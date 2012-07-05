"if executable($GDB)
"	exec 'ConqueGdbExe ${GDB}'
"endif
"if filereadable("build/test/gdb/prepare-target.sh")
"	"TODO find way to set target
"	map öö :!build/test/gdb/prepare-target.sh test_pulserctl_target&<CR><CR>:ConqueGdb -x ./build/test/gdb/prepare-target.gdb<CR>
"endif

"ASTYLE
"The problem with mapping = is that astyle needs the whole file to understand
"the context - so just for later reference:
"au FileType c,cpp,java setlocal equalprg=astyle
"ma sets a mark, <`-a> jumps back to it
map <silent> <F2> ma<CR>:%!astyle<CR>`a:delm a<CR>zz
imap <silent> <F2> <ESC>ma:%!astyle<CR>`a:delm a<CR>zza

"Block comments
map <C-K> O/**<CR>/<ESC>O
imap <C-K> <ESC>O/**<CR>/<ESC>O

"CMake
if isdirectory("./build/")
	set makeprg=make\ -C\ ./build/
endif

" Command Make will call make and then cwindow which
" opens a 3 line error window if any errors are found.
" If no errors, it closes any open cwindow.
command! -nargs=* Make make <args> | cwindow 3
map <Leader>j :w<CR>:Make<CR>

" CSCOPE
if has("cscope")
	"use quickfix window to show cscope results
	"if has('quickfix')
    	"	set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
      	"endif
	"set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
	set cscopetag
	" commands ":tag" and CTRL-] as well as "vim -t" will always use |:cstag|
	" instead of the default :tag behavior.
	set cst
	" If 'csto' is set to zero, cscope database(s) are searched first, followed
	" by tag file(s) if cscope did not return any matches.
	set csto=0
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
	    cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    cs add $CSCOPE_DB
	endif
	set csverb
	nmap äs :cs find s <C-R>=expand("<cword>")<CR><CR>
	nmap äg :cs find g <C-R>=expand("<cword>")<CR><CR>
	nmap äc :cs find c <C-R>=expand("<cword>")<CR><CR>
	nmap ät :cs find t <C-R>=expand("<cword>")<CR><CR>
	nmap äe :cs find e <C-R>=expand("<cword>")<CR><CR>
	nmap äf :cs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap äi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap äd :cs find d <C-R>=expand("<cword>")<CR><CR>
	nmap äa :cs find a <C-R>=expand("<cword>")<CR><CR>

	" Using 'CTRL-spacebar' then a search type makes the vim window
	" split horizontally, with search result displayed in
	" the new window.

	nmap ääs :scs find s <C-R>=expand("<cword>")<CR><CR>
	nmap ääg :scs find g <C-R>=expand("<cword>")<CR><CR>
	nmap ääc :scs find c <C-R>=expand("<cword>")<CR><CR>
	nmap äät :scs find t <C-R>=expand("<cword>")<CR><CR>
	nmap ääe :scs find e <C-R>=expand("<cword>")<CR><CR>
	nmap ääf :scs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap ääi :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap ääd :scs find d <C-R>=expand("<cword>")<CR><CR>
	nmap ääa :scs find a <C-R>=expand("<cword>")<CR><CR>

	" Hitting CTRL-space *twice* before the search type does a vertical
	" split instead of a horizontal one

	nmap äääs :vert scs find s <C-R>=expand("<cword>")<CR><CR>
	nmap äääg :vert scs find g <C-R>=expand("<cword>")<CR><CR>
	nmap äääc :vert scs find c <C-R>=expand("<cword>")<CR><CR>
	nmap ääät :vert scs find t <C-R>=expand("<cword>")<CR><CR>
	nmap äääe :vert scs find e <C-R>=expand("<cword>")<CR><CR>
	nmap äääi :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap äääd :vert scs find d <C-R>=expand("<cword>")<CR><CR>
	nmap äääa :vert scs find a <C-R>=expand("<cword>")<CR><CR>

endif

"setlocal spell spelllang=en_us

"function! DelTagOfFile(file)
"  let fullpath = a:file
"  let cwd = getcwd()
"  let tagfilename = cwd . "/tags"
"  let f = substitute(fullpath, cwd . "/", "", "")
"  let f = escape(f, './')
"  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
"  let resp = system(cmd)
"endfunction
"
"function! UpdateTags()
"  let f = expand("%:p")
"  let cwd = getcwd()
"  let tagfilename = cwd . "/tags"
"  let cmd = 'ctags -a -f ' . tagfilename . ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
"  call DelTagOfFile(f)
"  let resp = system(cmd)
"endfunction
"autocmd BufWritePost *.cpp,*.h,*.c call UpdateTags()

