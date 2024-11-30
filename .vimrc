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
Plug 'junegunn/seoul256.vim'
Plug 'tpope/vim-commentary'
Plug 'chr4/nginx.vim'
Plug 'itchyny/lightline.vim'
Plug 'smerrill/vcl-vim-plugin'
Plug 'kien/ctrlp.vim'
Plug 'pangloss/vim-javascript'
Plug 'ctrlpvim/ctrlp.vim'

" Plug 'editorconfig/editorconfig-vim'
" Plug 'beyondwords/vim-twig'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-haml'

if version >= 800
    Plug 'w0rp/ale'
endif

if has("win32unix")
    Plug 'tmux-plugins/vim-tmux'
endif

" Enable support for COBOL legacy code
let cobol_legacy_code=1

let git_version = system("git --version | cut -f 3 -d ' ' | sed -e 's/\\.//g'")
if git_version >= 1850
    Plug 'tpope/vim-fugitive'
endif

" Add plugins to &runtimepath
call plug#end()

set background=light
colorscheme seoul256
" transparent bg
hi Normal guibg=NONE ctermbg=NONE
set shortmess+=I
set cursorline
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

" JK motions: Line motions
" map <Leader>j <Plug>(easymotion-j)
" map <Leader>k <Plug>(easymotion-k)
set laststatus=2
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set t_ut=

" set mapleader
let mapleader = ','

noremap <Leader>n  :NERDTreeToggle<CR>
let NERDTreeChDirMode = 2
let NERDTreeShowHidden = 1

" autocomplete settings
:set completeopt=longest,menuone
:inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


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

"toggle paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
 
"relative numbers
function! Numbertoggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <c-x> :call Numbertoggle()<cr>
" exit insert mode
inoremap jk <esc> 

if version >= 800
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
endif

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"⭤":""}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
