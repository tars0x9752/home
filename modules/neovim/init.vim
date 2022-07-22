if exists('g:vscode')
else
  " --- plugins ---
  call plug#begin()
  Plug 'vim-airline/vim-airline'
  Plug 'ryanoasis/vim-devicons'
  Plug 'jiangmiao/auto-pairs'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'preservim/nerdtree'
  Plug 'cocopon/iceberg.vim'
  Plug 'sainnhe/sonokai'
  call plug#end()

  " --- visual ---
  colorscheme iceberg
  set background=dark
  set termguicolors " True Color対応
  set title " ターミナルのタブ名に現在編集中のファイル名を設定
  set number " 行番号を表示する
  set wrap " 行を折り返す
  set showmatch " 括弧入力時の対応する括弧を表示
  set list "不可視文字の可視化
  " set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲ " デフォルト不可視文字は美しくないのでUnicodeできれいに
  set matchtime=3 " 対応括弧のハイライト表示を3sにする

  " --- grep ---
  set ignorecase " 大文字小文字の区別なく検索する
  set smartcase " 検索文字列に大文字が含まれている場合は区別して検索する
  set wrapscan " 検索時に最後まで行ったら最初に戻る
  set hlsearch " 検索語をハイライト表示
  set incsearch " 検索文字列入力時に順次対象文字列にヒットさせる
  set inccommand=split " インタラクティブに変更

  " --- indent ---
  set smartindent " オートインデント
  set expandtab " softtabstop や shiftwidth で設定されている値分のスペースが挿入されたときに、挿入されたスペース数が tabstop に達してもタブに変換されない
  set tabstop=2 " スペースn個分で1つのタブとしてカウントするか
  set softtabstop=2 " <tab>を押したとき、n個のスペースを挿入
  set shiftwidth=2 " <Enter>や<<, >>などを押したとき、n個のスペースを挿入

  " --- auto complete ---
  set completeopt=noinsert,menuone,noselect
  set wildmode=list:longest " コマンドラインの補完
  set infercase " 補完時に大文字小文字を区別しない
  set wildmenu "コマンドの補完を有効に
  au FileType * setlocal formatoptions-=ro " 自動コメント挿入を回避

  " --- other ---
  set mouse=a
  set clipboard+=unnamedplus " クリップボードにコピーする
  set backspace=indent,eol,start " backspaceで様々な文字を消せるようにした
  set hidden
  set textwidth=0 "自動改行する文字数
  set encoding=utf-8 " 文字コード

  " --- keymap ---
  " jj as esc
  inoremap <silent> jj <Esc>

  " Find files using Telescope command-line sugar.
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
endif
