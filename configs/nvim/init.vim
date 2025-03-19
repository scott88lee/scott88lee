" ~/.config/nvim/init.vim
call plug#begin()
Plug 'github/copilot.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'
Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/gruvbox-material'
Plug 'preservim/nerdtree'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
call plug#end()

" Ctrl N for filetree
" Telescope settings \ff  \fg
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" UI settings
set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent
set wrap
set cursorline
set signcolumn=yes

" Split settings
set splitbelow
set splitright

" Search settings
set ignorecase
set smartcase

" Misc settings
set title

" Behavior settings
set mouse=a
set backspace=indent,eol,start

" Enable syntax highlighting
syntax on

" Colorscheme settings
set termguicolors
set background=dark
colorscheme gruvbox
" colorscheme gruvbox-material
" colorscheme tokyonight
" colorscheme sonokai
" colorscheme dracula
" colorscheme edge

" NERDTree Key mappings
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeShowHidden=1
" let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
" let NERDTreeMinimalUI=1 "hide the top menu bar in NERDTree
" let NERDTreeDirArrows=1 "show arrows for folders in NERDTree
" let NERDTreeWinSize=30 "set the size of the NERDTree window
" let NERDTreeChDirMode=2 "change root automatically when changing directories
" let NERDTreeAutoDeleteBuffer=1 "delete buffers when corresponding file is deleted in NERDTree
" let NERDTreeAutoCenter=1 "center the NERDTree window when opening a file
" let NERDTreeShowBookmarks=1 "show bookmarks in NERDTree
" let NERDTreeShowHidden=1 "show hidden files in NERDTree
" let NERDTreeShowLineNumbers=1 "show line numbers in NERDTree
" let NERDTreeMapOpenInTab='\t' "open files in tabs
" let NERDTreeMapPreview='\p' "preview files in NERDTree
" let NERDTreeMapToggle='\t' "toggle NERDTree
" let NERDTreeMapMenu='\m' "toggle NERDTree menu
" let NERDTreeMapHelp='?' "toggle NERDTree help menu
" let NERDTreeMapQuickLook='l' "quick look files in NERDTree
" let NERDTreeMapRevealInFinder='R' "reveal files in Finder
" let NERDTreeMapToggleBookmark='B' "toggle bookmarks in NERDTree
" let NERDTreeMapClearSelections='c' "clear selections in NERDTree
" let NERDTreeMapToggleShowHidden='H' "toggle hidden files in NERDTree
" let NERDTreeMapRefresh='R' "refresh NERDTree
" let NERDTreeMapToggleAutoDeleteBuffer='D' "toggle auto delete buffer
" let NERDTreeMapToggleAutoCenter='C' "toggle auto center
" let NERDTreeMapToggleCWD='c' "toggle CWD
" let NERDTreeMapToggleFocus='F' "toggle focus
" let NERDTreeMapToggleMouseMode='m' "toggle mouse mode
" let NERDTreeMapToggleNERDTreeFocus='F' "toggle NERDTree focus
" let NERDTreeMapToggleShowLineNumbers='N' "toggle line numbers
" let NERDTreeMapToggleShowBookmarks='B' "toggle bookmarks
" let NERDTreeMapToggleShowHidden='I' "toggle hidden files
" let NERDTreeMapToggleShowFiles='I' "toggle files
" let NERDTreeMapToggleShowFolders='I' "toggle folders
" let NERDTreeMapToggleShowLineNumbers='I' "toggle line numbers
