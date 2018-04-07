let g:python3_host_prog = expand('/Users/Mnb0130/anaconda3/bin/python3')
let g:python_host_prog=$PYENV_ROOT.'/versions/neovim-2/bin/python2.7'
:let java_highlight_all=1
:let java_highlight_debug=1
:let java_allow_cpp_keywords=1
:let java_highlight_functions=1


" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

" ENV
let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

" Load rc file
function! s:load(file) abort
    let s:path = expand('$CONFIG/nvim/rc/' . a:file . '.vim')

    if filereadable(s:path)
        execute 'source' fnameescape(s:path)
    endif
endfunction

call s:load('plugins')

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/Mnb0130/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/Mnb0130/.cache/dein')
  call dein#begin('/Users/Mnb0130/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/Mnb0130/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})


  " dein.toml, dein_layz.tomlファイルのディレクトリをセット
  let s:toml_dir = expand('~/.config/nvim')
  " 起動時に読み込むプラグイン群
  call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})
  " 遅延読み込みしたいプラグイン群
  call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})

  " You can specify revision/branch/tag.
  call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable


" その他インストールしていないものはこちらに入れる
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

" <C-c> で実行を強制終了させる
" quickrun.vim が実行していない場合には <C-c> を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
" vimprocで非同期実行
" 成功時にバッファ、失敗時にQuickFixで表示
" 結果表示のサイズ調整など
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'runner'    : 'vimproc',
      \ 'runner/vimproc/updatetime' : 60,
      \ 'outputter' : 'error',
      \ 'outputter/error/success' : 'buffer',
      \ 'outputter/error/error'   : 'quickfix',
      \ 'outputter/buffer/split'  : ':rightbelow 8sp',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }
" q でquickfixを閉じれるようにする。
au FileType qf nnoremap <silent><buffer>q :quit<CR>
" 実行時に前回の表示内容をクローズ&保存してから実行
let g:quickrun_no_default_key_mappings = 1
nmap <Leader>r :cclose<CR>:write<CR>:QuickRun -mode n<CR>
nnoremap \r :write<CR>:QuickRun -mode n<CR>
xnoremap \r :<C-U>write<CR>gv:QuickRun -mode v<CR>



" Denite用プレフィックス
nmap [denite] <Nop>
map <C-j> [denite]
" プロジェクト内のファイル検索
nmap <silent> [denite]<C-P> :<C-u>Denite file_rec -highlight-mode-insert=Search<CR>
" バッファに展開中のファイル検索
nmap <silent> [denite]<C-B> :<C-u>Denite buffer -highlight-mode-insert=Search<CR>
" ファイル内の関数/クラス等の検索
nmap <silent> [denite]<C-O> :<C-u>Denite outline -highlight-mode-insert=Search<CR>
" dotfiles配下をカレントにしてfile_rec起動
nmap <silent> [denite]<C-V> :<C-u>call denite#start([{'name': 'file_rec', 'args': ['~/.dotfiles']}]) -highlight-mode-insert=Search=Search<CR>

" 上下移動を<C-N>, <C-P>
call denite#custom#map('normal', '<C-N>', '<denite:move_to_next_line>')
call denite#custom#map('normal', '<C-P>', '<denite:move_to_previous_line>')
call denite#custom#map('insert', '<C-N>', '<denite:move_to_next_line>')
call denite#custom#map('insert', '<C-P>', '<denite:move_to_previous_line>')
" 入力履歴移動を<C-J>, <C-K>
call denite#custom#map('insert', '<C-J>', '<denite:assign_next_text>')
call denite#custom#map('insert', '<C-K>', '<denite:assign_previous_text>')
" 横割りオープンを`<C-S>`
call denite#custom#map('insert', '<C-S>', '<denite:do_action:split>')
" 縦割りオープンを`<C-I>`
call denite#custom#map('insert', '<C-I>', '<denite:do_action:vsplit>')
" タブオープンを`<C-O>`
call denite#custom#map('insert', '<C-O>', '<denite:do_action:tabopen>')
" file_rec検索時にfuzzymatchを有効にし、検索対象から指定のファイルを除外
call denite#custom#source(
    \ 'file_rec', 'matchers', ['matcher_fuzzy', 'matcher_project_files', 'matcher_ignore_globs'])
" 検索対象外のファイル指定
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

" NERDTree
autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>

" Theme
colorscheme onedark
let g:airline_theme='oceanicnext'
"set t_Co=256
"set termguicolors
"set background=dark


" パワーラインでかっこよく
"let g:airline_powerline_fonts = 1
" カラーテーマ指定してかっこよく
"let g:airline_theme = 'badwolf'
" タブバーをかっこよく
let g:airline#extensions#tabline#enabled = 1
" 選択行列の表示をカスタム(デフォルトだと長くて横幅を圧迫するので最小限に)
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
" virtulenvを認識しているか確認用に、現在activateされているvirtualenvを表示(vim-virtualenvの拡張)
let g:airline#extensions#virtualenv#enabled = 1
" gitのHEADから変更した行の+-を非表示(vim-gitgutterの拡張)
let g:airline#extensions#hunks#enabled = 0
" Lintツールによるエラー、警告を表示(ALEの拡張)
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'

" Leader
" LeaderをSpaceキーにする
let mapleader = "\<Space>"
" <Space>wを押してファイルを保存する（:w<Enter>よりずっと速い）
nnoremap <Leader>w :w<CR>
" <Space>pと<Space>yでシステムのクリップボードにコピー＆ペーストする
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P



" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" シンタックスハイライト
syntax enable
" Y を、行末までのヤンクにする
nnoremap Y y$
" displayオプション
set display=lastline
" 補完メニューの高さ
set pumheight=10
" 括弧を入力した時に、対応する括弧に一瞬カーソル飛ぶ
set showmatch
set matchtime=1
" インクリメント、デクリメントへのマッピング
nnoremap + <C-a>
nnoremap - <C-x>
" 不可視文字を表示
set clipboard+=unnamed
set clipboard=unnamed
" 括弧補完
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap < <><LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap [ []<LEFT>





" 見た目系
" タイトルを表示
set title
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
"set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=4


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
