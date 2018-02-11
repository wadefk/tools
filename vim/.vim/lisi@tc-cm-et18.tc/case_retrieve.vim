" Vim c\c++ type plugin for fetching suite&case name and brief from btest code 
" Last Change: 2010 
" Maintainer: luozuozuo@baidu.com


let g:output_xml = 'atp.xml'
let g:last_suite_case_row = 1
"let g:xml_indent_unit = '  '

"function! <SID>Get_indent( level )
"	let i = 0
"	let temp = ""
"	while i < level
"		let temp = temp . g:xml_indent_unit
"		i += 1
"	endwhile
"	return temp
"endfunction

"xml 特殊字符转义
function! <SID>Xml_encode( string )
	let string = substitute(a:string, "&", "\\&amp;", "g")
	let string = substitute(string, "<", "\\&lt;", "g")
	let string = substitute(string, ">", "\\&gt;", "g")
	let string = substitute(string, "'", "\\&apos;", "g")
	let string = substitute(string, "\"", "\\&quot;", "g")
	return string
endfunction

function! <SID>In_comment()
	let row = line(".")
	let colomn = col(".")
	call cursor( row , colomn)
	let two_slash_row = search('//', 'bW')
	if two_slash_row == row 
		call cursor ( row, colomn)
		return 1
	endif

	call cursor ( row, colomn)
	let left_slash_asterisk_row = search ('/\*', 'bW')
	let left_slash_asterisk_col = col(".")

	if left_slash_asterisk_row > 0
		let right_asterisk_slash_row = searchpair('/\*','','\*/', 'W')
		let right_slash_asterisk_col = col(".")

		if right_asterisk_slash_row > row
			call cursor ( row, colomn)
			return 1
		elseif right_asterisk_slash_row == row && right_slash_asterisk_col > colomn
			call cursor ( row, colomn)
			return 1
		endif
	endif
	call cursor ( row, colomn)
	return 0
endfunction

function! <SID>Get_comment(key)
	let ori_row =  line(".")
	let ori_colomn = col(".")

	let value = ""
	let key_row = search( '\*\s\+@'.a:key, 'bW')
	if key_row > 0 && g:last_suite_case_row < key_row
		let line = getline(".")
		let temp = match(line, '@'.a:key)
		let temp = match(line, '\s', temp) 
		if temp > 0 
			let start = match(line, '\S', temp)
			if start > 0
				let value = strpart(line, start)
			endif
		endif
		if a:key == "brief"
			let row = line(".") + 1
			while 1
				let line = getline(row)	
				let temp = match( line, '\*\s\+[^@]')
				if temp < 0
					break
				else
					let more = strpart(line, 3)
					let value = value.'  '.more
					let row = row + 1
				endif
			endwhile
		endif
	endif
	call cursor(ori_row, ori_colomn)
	return value
endfunction


function! <SID>Get_describe()
	return <SID>Xml_encode( <SID>Get_comment('brief') )
endfunction

function! <SID>Get_begin_version()
	return <SID>Xml_encode( <SID>Get_comment('begin_version') )
endfunction

function! <SID>Get_case_name()
	let line = getline(".")
	let comma_pos = match(line, ',')
	let begin = match(line, '\k', comma_pos)
	let end = match(line, '\s\|)', begin)
	let case_name = strpart(line, begin, end - begin)
	return case_name
endfunction

function! <SID>Get_suite_name()
	let line = getline(".")
	let temp = match(line, 'class')
	let temp = match(line, '\s' , temp)
	let begin = match(line, '\k', temp)
	let end = match(line, '\s*:\s*public\s\+::testing::Test', begin)
	let suite_name = strpart(line, begin, end - begin)
	return suite_name
endfunction

function! <SID>Get_case( suite_name )
	let ori_row =  line(".")
	let ori_colomn = col(".")

	let case_regex = <SID>Get_case_regex(a:suite_name)

	while 1
		let case_row = search(case_regex, 'W')
		"echo "==="
		"echo case_regex
		"echo case_row
		"echo "==="
		if case_row <= 0
			break
		endif
		if <SID>In_comment() == 0
			let case_name = <SID>Get_case_name()
			let case_describe = <SID>Get_describe()
			let case_begin_version = <SID>Get_begin_version()
			call system('echo "            <case>" >> '.g:output_xml)
			call system('echo "                <name>'. case_name.'</name>" >> '.g:output_xml)
			call system('echo "                <describe>'. case_describe.'</describe>" >> '.g:output_xml)
			call system('echo "                <begin_version>'. case_begin_version.'</begin_version>" >> '.g:output_xml)
			call system('echo "            </case>" >> '.g:output_xml)
			let g:last_suite_case_row = line(".")
		endif
		call cursor(case_row , col('$'))
	endwhile
								
endfunction


function! <SID>Get_suite()
	let ori_row =  line(".")
	let ori_colomn = col(".")
	let suite_name = <SID>Get_suite_name()
	let suite_describe = <SID>Get_describe()

	call system('echo "    <suite>" >> '.g:output_xml)
	call system('echo "        <name>'. suite_name.'</name>" >> '.g:output_xml)
	call system('echo "        <describe>'. suite_describe.'</describe>" >> '.g:output_xml)
	let g:last_suite_case_row = line(".")
	call <SID>Get_case( suite_name)
	call system('echo "    </suite>" >> '.g:output_xml)
	call cursor(ori_row, ori_colomn)
	return suite_name
endfunction


function! <SID>Get_suite_regex()
	let suite_regex = 'class\s\+\k\+\s*:\s*public\s\+::testing::Test'
	return suite_regex
endfunction

function! <SID>Get_case_regex( suite_name )
	let case_regex = 'TEST_F\s*(\s*'.a:suite_name.'\s*,'
	return case_regex
endfunction


function! <SID>Main()
	"call system('rm -f '.g:output_xml)
	let filename = expand("%:p:t:r")
	call system('echo "<suite>" >> '.g:output_xml)
	call system('echo "    <name>'.filename.'</name>'.'" >> '.g:output_xml)
	call system('echo "    <describe>test code file</describe>'.'" >> '.g:output_xml)

	call cursor(1, 1)
	let suite_regex = <SID>Get_suite_regex()
	while 1
		let suite_row = search( suite_regex , 'cW') 
		if suite_row <= 0
			break
		endif
		if <SID>In_comment() == 0
			let suite_name = <SID>Get_suite()
		endif
		call cursor(suite_row, 1)
		call cursor(suite_row , col('$'))
	endwhile
	call system('echo "</suite>" >> '.g:output_xml)
endfunction

map <unique> \m :call <SID>Main()<CR>
