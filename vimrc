let mapleader = "ü"
let g:ConqueGdb_Leader = 'ö'

set nocp
filetype plugin on

filetype indent on
" Display line numbers on the left
set number
"Activate octave filetype detection for files ending with .m
let filetype_m = 'octave'
" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent
set smartindent

set showmatch
set grepprg=grep\ -nH\ $*
" Use visual bell instead of beeping when doing something wrong
set visualbell
set maxmempattern=20000

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Enable syntax highlighting
syntax on

" One of the most important options to activate. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files will keep you safe if your computer crashes.
set hidden

" Better command-line completion
set wildmenu
set wildmode=list:longest

" Show partial commands in the last line of the screen
set showcmd

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" nice colors
colorscheme elflord
set cursorline
highlight CursorLine   cterm=NONE ctermbg=Black ctermfg=NONE
highlight CursorLineNR ctermbg=Black ctermfg=darkyellow

"Sets default exclude pattern for DirDiff
let g:DirDiffExcludes ="CVS,*.class,*.exe,.*.swp,.git*"

" Press Space to turn off highlighting and clear any message already
" displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Turn on omnicompletion
set ofu=syntaxcomplete#Complete

" Delete trailing white spaces in the given files
autocmd BufWritePre * :%s/\s\+$//e

" mark right margin
set colorcolumn=80

" source project specific .vimrc files
if filereadable("Session.vim")
    source Session.vim
endif

" Width of the Tagbar window in characters.
let g:tagbar_width = 30

" open and close Tagbar by simply pressing the <F9> key
nnoremap <silent> <F9> :TagbarToggle<CR>

" enable spell checker
":autocmd FileType mail :nmap <F7> :w<CR>:!aspell -e -c %<CR>:e<CR>
:nmap <F7> :w<CR>:!aspell --lang=de_DE -e -c %<CR>:e<CR>

" enable spell checker
":autocmd FileType mail :nmap <F8> :w<CR>:!aspell -e -c %<CR>:e<CR>
:nmap <F8> :w<CR>:!aspell --lang=en_US -e -c %<CR>:e<CR>

" vim-latex plugin
filetype plugin on
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" Compatible with ranger 1.4.2 through 1.7.*
"
" Add ranger as a file chooser in vim
"
" If you add this code to the .vimrc, ranger can be started using the command
" ":RangerChooser" or the keybinding "<leader>r".  Once you select one or more
" files, press enter and ranger will quit again and vim will open the selected
" files.
function! RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    if has("gui_running")
        exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
    endif
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar RangerChooser call RangeChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>

augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END

let vim_markdown_preview_use_xdg_open=1
let vim_markdown_preview_github=1
