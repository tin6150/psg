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


" ===== 2019.0222 =======
" really want to do tab settings per file type
" https://stackoverflow.com/questions/1562633/setting-vim-whitespace-preferences-by-filetype
filetype plugin on 
filetype plugin indent on 
autocmd Filetype html 		setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby 		setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 noexpandtab
autocmd Filetype txt 		setlocal ts=4 sw=4 noexpandtab nolist nonu
autocmd Filetype rst 		setlocal ts=4 sw=4 noexpandtab nolist nonu



" ==== 2019.0202 =========
" kate and kdevelop in vi mode is my new fav editor, but there are still some quirkyness
" vi outside screen has better color for comment, even when TERM=xterm-256color
" so want some default that is kinda sane, even when still not optimal for python editing
set shiftwidth=2 tabstop=4 formatoptions-=cro list nu noexpandtab syntax-=on 

