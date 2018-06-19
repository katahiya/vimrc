let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/.vim/dein/repos/github.com/Shougo/dein.vim'


if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

"Colorscheme
syntax on
colorscheme molokai
set t_Co=256

set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題を解決


" setting
set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
"
set number
set cursorline
" set cursorcolumn
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest
nnoremap j gj
nnoremap k gk


"set list listchars=tab:
set expandtab
set tabstop=2
set shiftwidth=2" "

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"tab
set tabstop=4
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

"backspace
set backspace=indent,eol,start

"rubocop
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']

if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

"------------------------------------
" neocomplete.vim
"------------------------------------
if !has('nvim') && has('lua')
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3

  let g:neocomplete#enable_camel_case_completion = 1    "| camle caseを有効化。大文字を区切りとしたワイルドカードのように振る舞う
  let g:neocomplete#enable_underbar_completion = 1      "| _(アンダーバー)区切りの補完を有効化
  let g:neocomplete#source#syntax#min_syntax_length = 3 "| シンタックスをキャッシュするときの最小文字長を3に
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*' "| neocomplcacheを自動的にロックするバッファ名のパターン
  " Define dictionary. -------------------------------------------
  let g:neocomplete#source#dictionary#dictionaries = {
    \ 'default'    : '',
    \ 'java'       : $HOME.'/.vim/dict/java.dict',
    \ }
  " Define keyword. -----------------------------------------------
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " 補完を選択しpopupを閉じる
  inoremap <expr><C-y> neocomplete#close_popup()
  " 補完をキャンセルしpopupを閉じる
  inoremap <expr><C-e> neocomplete#cancel_popup()
  " TABで補完できるようにする
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " undo
  inoremap <expr><C-g> neocomplete#undo_completion()
  " 補完候補の共通部分までを補完する
  inoremap <expr><C-l> neocomplete#complete_common_string()
  " C-kを押すと行末まで削除
  inoremap <C-k> <C-o>D
  " C-nでneocomplcache補完
  inoremap <expr><C-n> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
  " C-pでkeyword補完
  inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplete#undo_completion()
  inoremap <expr><C-l>     neocomplete#complete_common_string()

  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  " バックスペースで補完のポップアップを閉じる
  inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"
  " 補完候補が表示されている場合は確定。そうでない場合は改行
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    " Enable heavy omni completion.
  if !exists('g:neocomplete#source#omni#input_patterns')
    let g:neocomplete#source#omni#input_patterns = {}
  endif
  let g:neocomplete#source#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  let g:neocomplete#source#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'

  let g:neocomplete#source#omni#input_patterns.python = '\h\w*\|[^. \t]\.\w*'

  " Enable omni completion.
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  "for RSense
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif

  let g:neocomplete#sources#dictionary#dictionaries = {
  \  'ruby': $HOME . '/dicts/ruby.dict',
  \}

  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  let g:rsenseHome = expand("~/.rbenv/shims/rsense")
  let g:rsenseUseOmniFunc = 1
endif

let file_name = expand('%')

"split
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H

"------------------------------------
" NERDTree
"------------------------------------
let g:NERDTreeShowBookmarks=1
autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py',     'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('md',     'blue',    'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml',    'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('config', 'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('conf',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('json',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('html',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('styl',   'cyan',    'none', 'cyan',    '#151515')
call NERDTreeHighlightFile('css',    'cyan',    'none', 'cyan',    '#151515')
call NERDTreeHighlightFile('rb',     'Red',     'none', 'red',     '#151515')
call NERDTreeHighlightFile('js',     'Red',     'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php',    'Magenta', 'none', '#ff00ff', '#151515')
"------------------------------------
"------------------------------------

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Unite
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> <C-u><C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> <C-u><C-m> :<C-u>Unite file_mru buffer<CR>
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')

"vim filer
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>
nnoremap <silent><C-e> :VimFiler<CR>

"jedi-vim
autocmd FileType python setlocal completeopt-=preview

"paste
set clipboard=unnamed,autoselect
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

   inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

let mapleader = "\<Space>"

nnoremap <Leader>l $
nnoremap <Leader>h ^
noremap <Leader>l $
vnoremap <Leader>h ^
nmap <Leader>s <Plug>(easymotion-s2)
vmap <Leader>s <Plug>(easymotion-s2)
