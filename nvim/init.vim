" Gökhan Karabulut <gokhanettin@gmail.com>

if !has('nvim')
    set nocompatible     " Be iMproved
endif

" Install Plugins {{{
let s:vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(s:vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:loading_plugins = "yes"
  autocmd VimEnter * PlugInstall
endif

call plug#begin(expand('~/.config/nvim/plugged'))

Plug 'ctrlpvim/ctrlp.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'itchyny/lightline.vim'
Plug 'tomasr/molokai'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'Raimondi/delimitMate'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'Rip-Rip/clang_complete', {'do': 'make install'}

call plug#end()
" }}}

" Basic Setup {{{
    " Set saner defaults for vim
    if !has('nvim')
        filetype plugin indent on  " Load plugin and indent for a specific file
        set ttyfast                " Indicate fast terminal connection
        set ttymouse=xterm2        " Mouse handling type
        set ttyscroll=3            " Max number of lines to scroll the screen
        set laststatus=2                " Always show status line
        set encoding=utf-8              " Set default encoding to UTF-8
        set autoread                    " Reload files changed outside vim
        set autoindent                  " Match indent of previous line on new lines
        set backspace=indent,eol,start  " Allow backspace in insert mode
        set incsearch                   " Shows the match while typing
        set hlsearch                    " Highlight found text
        set mouse=a                     " Enables mouse in all modes
        set wildmenu                    " Completion with menu
    endif

    " Common basic setup for both vim and neovim
    set number      " Show line numbers
    set nobackup    " No backup before overwriting a file
    set noswapfile  " No *.swp files
    set noshowmode  " Let lightline/airline handle the mode display
    set guicursor=a:blinkon0 " Disable cursor blinking
    set splitright " Opens vertical split right of current window
    set splitbelow " Opens horizontal split below current window
    set shortmess=a " Use short messages when interacting with user
    set foldlevelstart=0 " Folds are closed by default
    set wildmode=longest,list,full " Tab presses cycle through these modes
    set wildignore=*.o,*.obj,*~ " Stuff to ignore when tab completing
    set listchars=tab:→\ ,eol:¬ " Change default display of tab and CR chars in list mode
    set noerrorbells visualbell t_vb= "No bell noise on errors
    autocmd GUIEnter * set visualbell t_vb= "No visual noise errors
    set lazyredraw " Eliminate redundant redraws
    set cmdheight=2 " Avoid many cases of having to press <Enter> to continue

    set history=1000 " Store lots of cmdline history
    set undolevels=1000 " Use many undo levels

    set hidden " Buffers can exist in the background
    set scrolloff=10 " Keep some lines visible for vertical margins
    set sidescrolloff=5 " Keep some columns visible for horizontal margins
    set virtualedit=block " Useful for selecting a rectangle

    set ignorecase " Case insesitive search
    set smartcase " Case sensitive search when an upper case typed
    set wrapscan " Wrap again after the last match

    set tabstop=4 " Number of spaces a tab counts for
    set shiftwidth=4 " Spaces for autoindents
    set softtabstop=4 " Tab spaces to be inserted when hit
    set shiftround " Makes indenting a multiple of shiftwidth
    set expandtab " Turn a tab into spaces
    set copyindent " Copy the previous indentation on autoindenting

    set textwidth=80 " Enforce line length
    set colorcolumn=+1 " Highlight the limit of textwidth
    set wrap " Wrap long text in display

    " Copy/Paste/Cut
    if has('clipboard')
        if has('unix')
            set clipboard=unnamed,unnamedplus
        else
            set clipboard=unnamed
        endif
    endif

    if has('gui_running')
        set guioptions=c  " Console dialogs instead of popups for simple choices
        set mousehide     " Hides mouse cursor while typing
        if has('gui_gtk')
            let &guifont = 'DejaVu Sans Mono for Powerline 11'
        endif
    else
        set t_Co=256
    endif
" }}}

" Plugin Configurations {{{

    " ctrlp.vim {{{
    if isdirectory(expand('~/.config/nvim/plugged/ctrlp.vim'))
        let g:ctrlp_map = '<c-p>'
        let g:ctrlp_cmd = 'CtrlPMixed'

        " 1-) Nearest repo (r)
        " 2-) Directory of the current file (c)
        let g:ctrlp_working_path_mode = 'rc'
        " Check if we have a fast search tool, if we don't, then use `find`.
        if executable('ag')
            " https://news.ycombinator.com/item?id=5245578
            let s:fallback = 'ag --nogroup --nobreak --noheading --nocolor -g "" %s'

            " ag should be fast enough, we don't need caching
            let g:ctrlp_use_caching = 0
        elseif executable('ack-grep')
            let s:fallback = 'ack-grep %s --nocolor -f'
        elseif executable('ack')
            let s:fallback = 'ack %s --nocolor -f'
        else
            let s:fallback = 'find %s -type f'
        endif

        " Use a search tool of a version control system if exists, they are
        " supposed to be faster than even `ag`, otherwise use our fallback as
        " the user command
        let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . ' .
                \     '--cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': s:fallback
        \ }
    endif
    " }}}

    " lightline.vim {{{
    if isdirectory(expand('~/.config/nvim/plugged/lightline.vim'))
        let g:lightline = {
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'fugitive', 'filename' ] ]
            \ },
            \ 'component_function': {
            \   'fugitive': 'LightlineFugitive',
            \   'readonly': 'LightlineReadonly',
            \   'modified': 'LightlineModified',
            \   'filename': 'LightlineFilename'
            \ },
            \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
            \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
            \ }

        function! LightlineModified()
            if &filetype == "help"
                return ""
            elseif &modified
                return "+"
            elseif &modifiable
                return ""
            else
                return ""
            endif
        endfunction

        function! LightlineReadonly()
            if &filetype == "help"
                return ""
            elseif &readonly
                return "\ue0a2"
            else
                return ""
            endif
        endfunction

        function! LightlineFugitive()
            if exists("*fugitive#head")
                let branch = fugitive#head()
                return branch !=# '' ? "\ue0a0 ".branch : ''
            endif
            return ''
        endfunction

        function! LightlineFilename()
            return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
                \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
                \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
        endfunction
    endif
    " }}}

    " molokali {{{
    if isdirectory(expand('~/.config/nvim/plugged/molokai'))
        set background=dark
        if !exists('s:loading_plugins')
            colorscheme molokai
        endif
    endif
    " }}}

    " ultisnips {{{
    if isdirectory(expand('~/.config/nvim/plugged/ultisnips'))
        " Trigger configuration.
        let g:UltiSnipsExpandTrigger="<Tab>"
        let g:UltiSnipsJumpForwardTrigger="<Tab>"
        let g:UltiSnipsJumpBackwardTrigger="<C-b>"

        " Register the author
        let g:snips_author = 'Gökhan Karabulut <gokhanettin@gmail.com>'

        " Custom snippet folder, :UltiSnipsEdit will open the files in this directory.
        let g:UltiSnipsSnippetsDir = '~/.config/nvim/mysnippets'

        " :UltiSnipsEdit will split our window.
        let g:UltiSnipsEditSplit="vertical"
    endif
    " }}}

    " deoplete.vim {{{
    if has('nvim') && has('python3')
        let g:deoplete#enable_at_startup = 1
    endif
    " }}}

    " deoplete-jedi {{{
    if has('nvim') && has('python3')
        let g:python_host_prog = '/usr/bin/python2'
        let g:python3_host_prog = '/usr/bin/python3'
        " let g:deoplete#sources#jedi#show_docstring = 1
    endif
    " }}}

    " clang_complete {{{
    if has('nvim') && has('python3')
        let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang-3.8.so.1'
    endif
    " }}}

" }}}

" Mappings {{{
    " Space is the <leader>
    let mapleader=" "
    " Dash is the <localleader>
    let maplocalleader=','

    " Quickly edit/reload the vimrc file
    nnoremap <silent> <leader>ev :vs $MYVIMRC<CR>
    nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

    " Temporarily get out of search highlight
    nnoremap <silent> <CR> :nohlsearch<CR><CR>

    " Move cursor by display lines when wrapping
    noremap <Up> gk
    noremap <Down> gj
    noremap j gj
    noremap k gk

    " Easy navigation with splits
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l

    " Easy navigation with buffers
    nnoremap <silent> <C-x><Right> :bn<CR>
    nnoremap <silent> <C-x><Left>  :bp<CR>
    " tnoremap <silent> <C-x><Right> :bn<CR>
    " tnoremap <silent> <C-x><Left>  :bp<CR>

    " Easy navigation with tabs
    nnoremap <silent> <C-Right> :tabn<CR>
    nnoremap <silent> <C-Left>  :tabp<CR>

    " Terminal escape
    tnoremap <Esc> <C-\><C-n>
" }}}

" vim: set sw=4 ts=4 sts=4 et tw=80 foldlevel=0 foldmethod=marker:
