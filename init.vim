set nocompatible            " disable compatibility to old-time vi
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set signcolumn=yes          " 
set showmatch               " show the matching brackets
set ttyfast                 " Speed up scrolling in Vim
set spell                   " enable spell check may need to download language package

set completeopt=menuone,noinsert,noselect

augroup numbertobble
    autocmd! BufEnter,FocusGained,InsertLeave   * set relativenumber
    autocmd! BufLeave,FocusLost,InsertEnter     * set norelativenumber
augroup END

set noswapfile            " disable creating swap file
set backupdir=~/.cache/vim " Directory to store backup files.
let g:NERDTreeWinPos = "right"

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'dracula/vim'
Plug 'ryanoasis/vim-devicons'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'dense-analysis/ale'
Plug 'neovim/nvim-lspconfig'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'neomake/neomake'
Plug 'kshenoy/vim-signature'

" Rust stuff
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'ycm-core/YouCompleteMe'
Plug 'cespare/vim-toml'

Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'

" C++
Plug 'deoplete-plugins/deoplete-clang'

" install cool looking bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'

" Optional dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Python stuff
Plug 'zchee/deoplete-jedi'

" Debugging (needs plenary from above as well)
Plug 'mfussenegger/nvim-dap'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" YCM
let g:ycm_extra_conf_globlist = ['~/.vim/plugged/YouCompleteMe/third_party/ycmd/*','!~/*']
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
let g:ycm_clangd_args = ['-std=c++20']

" YouCompleteMe and UltiSnips compatibility.
let g:ycm_use_ultisnips_completer = 1
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
" Rust config
" As-you-type autocomplete
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1
let g:ale_sign_error = '👹'
let g:ale_sign_warning = '☢️'
let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }
" let g:ale_sign_warning =
let g:ycm_clangd_binary_path = "/usr/bin/clang"
let g:ycm_seed_identifiers_with_syntax = 1
set completeopt=menu

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"
let g:LanguageClient_serverCommands = {
\ 'rust': ['rust-analyzer'],
\ }

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

" Apply AutoFix to problem to the current line.
nmap <leader>qf <Plug>(lcn-code-action)

" Setup Completion
" YCM KEYBINDINGS
function! YcmStuff() 
    nnoremap ;;    :YcmCompleter GoToDefinition<cr>
    nnoremap <F5>  :YcmRestartServer<cr>
    nnoremap <F1>  :YcmCompleter FixIt<cr>
    nnoremap K     :YcmCompleter GetDoc<cr>
    nnoremap ''    :YcmCompleter GetType<cr>
    nnoremap <F6>  :YcmForceCompileAndDiagnostics<CR>
endfunction

function! Rusty()
    nnoremap <C-e> :terminal cargo run<cr>
    nnoremap <C-t> :terminal cargo test<cr>
    nnoremap <C-T> :terminal cargo test -- --show-output<cr>
    inoremap <C-e> <esc>:terminal cargo run<cr>
endfunction 

augroup rust
    autocmd!
    autocmd FileType rust call Rusty()
	autocmd FileType rust call YcmStuff()
augroup end


" Set exit from terminal mode to Esc
:tnoremap <Esc> <C-\><C-n>


" Expand snippets from UltiSnips with tab
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-tab>"
let g:UltiSnipsSnippetDirectories = ['UltiSnips']

" Python Code Checker with pylint
let g:neomake_python_enable_makers = ['pylint']
call neomake#configure#automake('nrwi', 500)

" Set airline theme
let g:airline_theme='tomorrow'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled=0

" Note: You must define the dictionary first before setting values.
" Also, it's a good idea to check whether it exists as to avoid 
" accidentally overwriting its contents.

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

" If you only see boxes here it may be because your system doesn't have
" the correct fonts. Try it in vim first and if that fails see the help 
" pages for vim-airline :help airline-troubleshooting

set termguicolors
colorscheme gruvbox
