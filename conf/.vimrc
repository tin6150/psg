set nosmartindent
set cindent
filetype plugin indent on
set cinkeys-=0#
set indentkeys-=0#
" don't think below worked (some crazy auto intent from ubuntu18
" autocmd FileType * set cindent "some file types override it

" ======= 2018.0604 ===========
" ansible settings from rhel ansible training p61
autocmd FileType yaml setlocal ai ts=2 sw=2 et
