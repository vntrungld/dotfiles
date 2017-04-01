call plug#begin('~/.config/nvim/plugged')

Plug 'mileszs/ack.vim'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Yggdroot/indentLine'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'easymotion/vim-easymotion'
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
Plug 'editorconfig/editorconfig-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'yssl/QFEnter'
Plug 'ternjs/tern_for_vim'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-haml'
Plug 'digitaltoad/vim-pug'
Plug 'groenewege/vim-less'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/syntastic'
Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'valloric/youcompleteme', { 'do': './install.py --omnisharp-completer --tern-completer --clang-completer' }
Plug 'wakatime/vim-wakatime'

call plug#end()

" basic
filetype plugin indent on
syntax on
set lazyredraw

" theme and color
set t_Co=256
set background=dark
let g:gruvbox_invert_selection=0
colorscheme gruvbox
hi Normal ctermbg=none

" numbering, rulers and highlight
set relativenumber
set number
set laststatus=2
set nocursorline
set nocursorcolumn
highlight CursorColumn ctermbg=8
highlight ColorColumn ctermbg=7
highlight Visual ctermbg=255 ctermfg=16

" horizontal limit (ie. colored border, text width)
" TODO toggle textwidth
set colorcolumn=81 " make this 81, shouldn't hit it

" fix normal keys, and lock mouse
set backspace=indent,eol,start
set mouse=

" new window or pane should be appended to bottom right
set splitbelow
set splitright

" handy mapping
set pastetoggle=<leader>p
nnoremap ; :
vnoremap ; :
nnoremap <C-j> gj
nnoremap <C-k> gk
nnoremap <C-^> g^
nnoremap <C-$> g$
nnoremap <C-0> g0
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
nnoremap <M-u> <C-u>
nnoremap <M-d> <C-d>
nnoremap <BAR> :set cursorcolumn!<BAR>set cursorline!<CR>
noremap / /\v

if bufwinnr(1)
  " pane resize vertically = -
  " and horizontally + _
  map = 5<c-w>>
  map - 5<c-w><
  map + 5<c-w>+
  map _ 5<c-w>-
endif

" tab stops defaults and modeline
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set modeline
set modelines=5

" searching
set showcmd
set hlsearch
set modifiable
set smartcase
set ignorecase
map <space> :noh<cr>

" show hidden chars
set listchars=tab:>-,trail:.
set list

" text format
set wrap
set showmatch

" disable swap files
set nobackup
set nowritebackup
set noswapfile

" large file handle
let g:LargeFile = 10 * 1024 * 1024
augroup LargeFile
  autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END
function! LargeFile()
  set eventignore+=FileType " disable filetype related features
  noswapfile
  setlocal bufhidden=unload " save memory when other file is viewed
  setlocal buftype=nowrite
  setlocal undolevels=1
  autocmd VimEnter *  echo "Entering large-file-mode as file is larger than " . (g:LargeFile / 1024 / 1024) . "MB"
endfunction

" sudo switch with w!!
cmap w!! w !sudo tee % >/dev/null


" neovim
if has('nvim')
  " terminal
  tnoremap <Esc> <C-\><C-n>

  tnoremap <C-w>h <C-\><C-n><C-w>h
  tnoremap <C-w>j <C-\><C-n><C-w>j
  tnoremap <C-w>k <C-\><C-n><C-w>k
  tnoremap <C-w>l <C-\><C-n><C-w>l

  tnoremap <C-w>H <C-\><C-n><C-w>H
  tnoremap <C-w>J <C-\><C-n><C-w>J
  tnoremap <C-w>K <C-\><C-n><C-w>K
  tnoremap <C-w>L <C-\><C-n><C-w>L

  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
endif

" ====================================PLUGINS===================================

" NERDTREE
map <C-n> :NERDTreeToggle<CR>
" Binding to like CtrlP
let g:NERDTreeMapOpenSplit = '<C-x>'
let g:NERDTreeMapOpenVSplit = '<C-v>'
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

" ACK
" The Silver Searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column --ignore={*.jpg,*.png,*.jpeg,*.gif,*.css}'
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif
" Disable Ack mapping to use QFEnter
let g:ack_apply_qmappings = 0
let g:ack_apply_lmappings = 0
" QF Enter
" like CtrlP
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_topen_map = ['<C-t>']

nnoremap ? :Ack!<space>
noremap <C-s> :Ack! <cword><cr>

" INDENT LINE
let g:indentLine_color_term = 239
let g:indentLine_char = '│'

" AIRLINE
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_theme='gruvbox'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" SYNTASTIC
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'eslint_d'

let g:syntastic_sass_checkers = ['sass']

let g:syntastic_scss_checkers = ['sass']

let g:syntastic_pug_checkers = ['pug_lint']

" ULTISNIPS
let g:UltiSnipsExpandTrigger="<c-e>"

" TAGBAR
nmap <F8> :TagbarToggle<CR>
