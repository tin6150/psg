" set nosmartindent
" set cindent
" filetype plugin indent on
" set cinkeys-=0#
" set indentkeys-=0#
" don't think below worked (some crazy auto intent from ubuntu18
" autocmd FileType * set cindent "some file types override it

" ======= 2018.0604 ===========
" ansible settings from rhel ansible training p61
" autocmd FileType yaml setlocal ai ts=2 sw=2 et
" autocmd FileType yaml setlocal noai ts=2 sw=2 et
" set compatible  " nah avoid this

" ======= 2018.0608 ===========
" the above stuff is worse on cueball for editing yaml
" just plain vanilla set noai worked out best
" the vis alias still works
" alias vis='\vim -c '\''set shiftwidth=2 tabstop=4 formatoptions-=cro list nu expandtab syntax-=on'\'''
"
set noai                
