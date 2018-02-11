"set tags=/home/fukang/svn_src/tmp/tags
"if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
"   set fileencodings=utf-8,latin1
"endif
"let &termencoding=&encoding
"let termencoding=gbk
"set fileencodings=gbk,utf-8,ucs-bom,cp936
set fileencodings=gbk
set tabstop=4
set sw=4
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

colorscheme molokai
set t_Co=256
set backspace=indent,eol,start
set history=50
set ruler
set showcmd
set nu
set tabstop=4
set incsearch
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set wildmenu
set mouse=a
set fileencodings=utf-8,gb18030,ucs-bom,chinese,gb2312
set termencoding=gb2312
set encoding=gb2312

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"


set bs=2
set nu
"ÉèÖÃTAB
set tabstop=4
set sw=4
set hlsearch
syntax enable
set cindent shiftwidth=4
set autoindent
set scrolloff=5

"½«cpp c h Îªºó×ºµÄÎÄ¼şµÄtab×ª»¯Îª¿Õ¸ñ
au FileType cpp set expandtab
au FileType c set expandtab

"ÕÛµş´úÂë
"set foldmethod=indent

"set hlsearch


let OmniCpp_SelectFirstItem=2
"set completeopt-=preview
map <C-c> :w<CR>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
map <F12> :w<CR>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ..<CR>
hi Pmenu		guifg=black	guibg=white	ctermfg=black	ctermbg=white
hi PmenuSel		guifg=white	guibg=blue	ctermfg=white	ctermbg=blue
"set tags+=/usr/include/tags
"set tags+=~/.vim/systags
set tags+=~/svn_root/lib2-64/tags
set matchtime=15
set showmatch

"ÓÀÔ¶ÏÔÊ¾vimµÄ×´Ì¬À¸
set laststatus=2
set statusline=%<%F\ [FORMAT=%{&ff}:%{&fenc!=''?&fenc:&enc}]\ %h%m%r%=%-14.(%l,%c%V%)\ %P

"set encoding=utf-8
"set ignorecase

"set for python
"autocmd FileType python setlocal et sta sw=4 sts=4
filetype on
filetype plugin indent on 
let g:pydiction_location="/home/luojinmei/software/pydiction-1.2/complete-dict"

" Configure the Tag List plugin
let Tlist_Auto_Open=0 " Let the tag list open automatically
let Tlist_Auto_Update=1 " Update the tag list automatically
let Tlist_Compact_Format=1 " Show small menu
let Tlist_Ctags_Cmd='ctags' " Location of ctags
let Tlist_Enable_Fold_Column=0 "do show folding tree
let Tlist_Process_File_Always=1 " Always process the source file
let Tlist_Show_One_File=1 " Only show the tag list of current file
let Tlist_Exist_OnlyWindow=1 " If you are the last, kill yourself
let Tlist_File_Fold_Auto_Close=0 " Fold closed other trees
let Tlist_Sort_Type="name" " Order by name
let Tlist_WinWidth=40 " Set the window 40 cols wide.
let Tlist_Close_On_Select=1 " Close the list when a item is selected

"set new file extension gr ast as c++ file.
au BufNewFile,BufRead *.gr set filetype=cpp
au BufNewFile,BufRead *.ast set filetype=cpp


"map <F9> :!pyf %
map <F10> :TlistToggle <CR>

set nobackup
set hlsearch
set number
set noswapfile
set autoindent
set tabstop=4
set shiftwidth=4
set laststatus=2
set history=200                                                                                                                                                                                                
set mouse-=a
