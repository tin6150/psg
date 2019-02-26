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
syntax on
set noai                
set modeline      
set modelines=1
" check with  :verbose set modeline?
" debian config turns it off :(


" ===== 2019.0222 =======
" really want to do tab settings per file type
" https://stackoverflow.com/questions/1562633/setting-vim-whitespace-preferences-by-filetype
" this hopefull really do what i want now!  
" modeline is NOT the way to go for collab, other may not like my settings!
filetype plugin on 
filetype plugin indent on 
autocmd Filetype html 		setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby 		setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 noexpandtab
autocmd Filetype txt 		setlocal ts=4 sw=4 noexpandtab nolist nonu
autocmd Filetype sh 		setlocal ts=4 sw=4 noexpandtab nolist nonu
autocmd Filetype rst 		setlocal ts=4 sw=4 noexpandtab nolist nonu



" ==== 2019.0202 =========
" kate and kdevelop in vi mode is my new fav editor, but there are still some quirkyness
" vi outside screen has better color for comment, even when TERM=xterm-256color
" so want some default that is kinda sane, even when still not optimal for python editing
" this is like default, when not matched to above file type
set shiftwidth=2 tabstop=4 formatoptions-=cro nolist nu noexpandtab syntax-=on 





" settings from https://github.com/geerlingguy/dotfiles/blob/master/.vimrc
set autoread            " watch for file changes
set number              " show line numbers
set showcmd             " show selection metadata
set showmode            " show INSERT, VISUAL, etc. mode
set showmatch           " show matching brackets
set autoindent smartindent  " auto/smart indent
set smarttab            " better backspace and tab functionality
set scrolloff=5         " show at least 5 lines above/below
filetype on             " enable filetype detection
filetype indent on      " enable filetype-specific indenting
filetype plugin on      " enable filetype-specific plugins
" colorscheme cobalt      " requires cobalt.vim to be in ~/.vim/colors

" column-width visual indication  , orig 81,999.  bleh, just disale it,
""let &colorcolumn=join(range(81,999),",")
""highlight ColorColumn ctermbg=235 guibg=#001D2F

" tabs and indenting
set autoindent          " auto indenting
set smartindent         " smart indenting
""set expandtab           " spaces instead of tabs
set noexpandtab           " i prefer tab damn it.  damn yaml.  damn python.  they should read up about whitepace programming lang!!
set tabstop=2           " 2 spaces for tabs
"set shiftwidth=2        " 2 spaces for indentation

" bells
set noerrorbells        " turn off audio bell
set visualbell          " but leave on a visual bell

" search
set hlsearch            " highlighted search results
set showmatch           " show matching bracket

" other
" set guioptions=aAace    " don't show scrollbar in MacVim
" call pathogen#infect()  " use pathogen

" clipboard
set clipboard=unnamed   " allow yy, etc. to interact with OS X clipboard

set background=dark     " comment will be more readable lighther color text

" shortcuts
map <F2> :NERDTreeToggle<CR>
