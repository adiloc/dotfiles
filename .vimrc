set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'Jorengarenar/COBOl.vim'
Plug 'tpope/vim-sensible'
Plug 'elzr/vim-json'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'chr4/nginx.vim'
Plug 'itchyny/lightline.vim'
Plug 'smerrill/vcl-vim-plugin'
Plug 'kien/ctrlp.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vimwiki/vimwiki'
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'

if version >= 800
    Plug 'w0rp/ale'
endif

if has("win32unix")
    Plug 'tmux-plugins/vim-tmux'
endif

let git_version = system("git --version | cut -f 3 -d ' ' | sed -e 's/\\.//g'")
if git_version >= 1850
    Plug 'tpope/vim-fugitive'
endif

call plug#end()

" Enable syntax highlighting
syntax on
filetype plugin on
filetype indent on

" Set the color scheme and style
let g:onedark_style = 'darker'
colorscheme onedark
highlight Normal guibg=#141414 ctermbg=NONE
highlight CursorLine guibg=#202020 ctermbg=NONE

" Enable support for COBOL legacy code
let cobol_legacy_code=1

" Enable true colors
set termguicolors

set cursorline
set shortmess+=I
set t_Co=256
set number
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a
set ttymouse=xterm2
set clipboard+=unnamed
set smartcase
set showmatch
set history=1000
set showmode
set hls is
set laststatus=2
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set t_ut=

" Set mapleader
let mapleader = ','

noremap <Leader>n  :NERDTreeToggle<CR>
let NERDTreeChDirMode = 2
let NERDTreeShowHidden = 1

noremap <Leader>md :InstantMarkdownPreview<CR>

" Autocomplete settings
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" VimWiki configuration
let g:vimwiki_list = [{'path': '~/.vimwiki/',
                       \ 'syntax': 'markdown',
                       \ 'ext': '.md'}]

" Uncomment to override defaults:
"let g:instant_markdown_slow = 1
"let g:vimwiki_autowriteall = 1
let g:instant_markdown_autostart = 0
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
"let g:instant_markdown_mathjax = 1
"let g:instant_markdown_mermaid = 1
"let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"let g:instant_markdown_autoscroll = 0
"let g:instant_markdown_port = 8888
"let g:instant_markdown_python = 1
let g:instant_markdown_theme = 'dark'


" Search files inside vim  
let g:ctrlp_cache_dir = $HOME.'/.tmp/ctrlp'
let g:ctrlp_cmd = 'CtrlPCurWD'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|log\|node_modules\|tmp$',
      \ 'file': '\.exe$\|\.so$\|\.dat$|\moc$|\.cpp_parameters|\.o$|\.cpp.o$'
      \ }
let g:ctrlp_max_height = 30

" Copy selected text to clipboard
vnoremap <Leader>y :w !xclip -selection clipboard<CR><CR>

" Paste from clipboard
nnoremap <Leader>p :r !xclip -selection clipboard -o<CR>

" Toggle paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
 
" Relative numbers
function! Numbertoggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <c-x> :call Numbertoggle()<cr>
" Exit insert mode
inoremap jk <esc> 

if version >= 800
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
endif

" Allow saving of files as sudo when I forgot to start vim using sudo.
command! Ww w !sudo tee % >/dev/null

" Ensure Persistent Undo
set undofile
set undodir=~/.vim/undo

augroup mutt
      autocmd!
        autocmd BufRead,BufNewFile muttrc*,*.muttrc set filetype=muttrc
          autocmd FileType muttrc source ~/.vim/syntax/neomuttrc.vim
augroup END

