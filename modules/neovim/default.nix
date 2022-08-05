{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;

    coc = {
      enable = true;

      pluginConfig = ''
        nmap <silent> <space><space> :<C-u>CocList<cr>
        nmap <silent> <space>h :<C-u>call CocAction('doHover')<cr>
        nmap <silent> <space>d <Plug>(coc-definition)
        nmap <silent> <space>rf <Plug>(coc-references)
        nmap <silent> <space>rn <Plug>(coc-rename)
        nmap <silent> <space>f <Plug>(coc-format)

        let g:coc_user_config = {
          \"suggest.completionItemKindLabels": {
            \"class": "\uf0e8",
            \"color": "\ue22b",
            \"constant": "\uf8ff",
            \"default": "\uf29c",
            \"enum": "\uf435",
            \"enumMember": "\uf02b",
            \"event": "\ufacd",
            \"field": "\uf93d",
            \"file": "\uf471",
            \"folder": "\uf115",
            \"function": "\uf794",
            \"interface": "\ufa52",
            \"keyword": "\uf893",
            \"method": "\uf6a6",
            \"operator": "\uf915",
            \"property": "\ufab6",
            \"reference": "\uf87a",
            \"snippet": "\uf64d",
            \"struct": "\ufb44",
            \"text": "\ue612",
            \"typeParameter": "\uf278",
            \"unit": "\uf475",
            \"value": "\uf8a3",
            \"variable": "\uf71b"
          \}
        \}
      '';
    };

    plugins = with pkgs.vimPlugins; [
      vim-nix
      lualine-nvim
      vim-devicons
      # auto-pairs
      plenary-nvim
      telescope-nvim
      nerdtree
      iceberg-vim
      molokai
      neovim-ayu

      # coc
      coc-json
      coc-yaml
      coc-html
      coc-tsserver
      coc-eslint
      coc-pairs # or auto-pairs
      coc-prettier
      coc-lists
    ];

    extraConfig = ''
      " --- lualine ---
      lua << END
      require('lualine').setup {
        options = { theme  = 'ayu_mirage' },
      }
      END

      " --- visual ---
      colorscheme ayu-mirage
      set background=dark
      set termguicolors
      set title
      set number
      set wrap
      set showmatch
      set matchtime=3
      set list "不可視文字の可視化
      " set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲

      highlight Normal ctermbg=none guibg=NONE
      highlight NonText ctermbg=none guibg=NONE
      highlight LineNr ctermbg=none guibg=NONE
      highlight Folded ctermbg=none guibg=NONE
      highlight EndOfBuffer ctermbg=none guibg=NONE

      " --- grep ---
      set ignorecase
      set smartcase
      set wrapscan
      set hlsearch
      set incsearch
      set inccommand=split

      " --- indent ---
      set smartindent
      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2

      " --- auto complete ---
      set completeopt=noinsert,menuone,noselect
      set wildmode=list:longest
      set infercase
      set wildmenu
      au FileType * setlocal formatoptions-=ro

      " --- other ---
      set mouse=a
      set clipboard+=unnamedplus
      set backspace=indent,eol,start
      set hidden
      set textwidth=0
      set encoding=utf-8

      " --- keymap ---
      " jj as esc
      inoremap <silent> jj <Esc>

      " Find files using Telescope command-line sugar.
      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    '';
  };
}
