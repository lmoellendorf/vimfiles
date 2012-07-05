" Vim indent file
" Language:    Octave
" Maintainer:  Lars Möllendorf <lars@moellendorf.eu>
" Created:     2010 Jul 29
" Last Change: 2010 Jul 29
" Only load this indent file when no other was loaded
if exists("b:did_indent")
    finish
endif
" flag the fact that we've loaded this script
let b:did_indent = 1
setlocal indentexpr=GetOctaveIndent(v:lnum)
setlocal indentkeys&
" Begin words
setlocal indentkeys+==for;,==function,==if,==switch,==try,==unwind_protect,==while
" Else words
setlocal indentkeys+==case,==catch,==else,==elseif,==otherwise,==unwind_protect_cleanup
" End words
setlocal indentkeys+==end,==endfor,==endfunction,==endif,==endswitch,==end_try_catch,==end_unwind_protect,==endwhile

if exists("*GetOctaveIndent")
    finish
endif


function! s:GetPrevNonCommentLineNum( line_num )

    " Skip lines starting with a comment
    "let SKIP_LINES = '^\s*\(\((\*\)\|\(\*\ \)\|\(\*)\)\|{\|}\)'
    " Todo: Check if this one works, and check if comments at the end of a line
    " are important to detect
    let SKIP_LINES = '^\s*\(\([%#]{\)\|\([%#]\)\|\(\[%#]}\)\)'

    let nline = a:line_num
    while nline > 0
        let nline = prevnonblank(nline-1)
        if getline(nline) !~? SKIP_LINES
            break
        endif
    endwhile

    return nline
endfunction


function! GetOctaveIndent( line_num )
    " Line 0 always goes at column 0
    if a:line_num == 0
        return 0
    endif

    let this_codeline = getline( a:line_num )

    " If in the middle of a three-part comment
    "	if this_codeline =~ '^\s*#'
    "		return indent( a:line_num )
    "	endif

    let prev_codeline_num = s:GetPrevNonCommentLineNum( a:line_num )
    let prev_codeline = getline( prev_codeline_num )
    let indnt = indent( prev_codeline_num )

    " Compiler directives should always go in column zero.
    if this_codeline =~ '^\s*{\(\$IFDEF\|\$ELSE\|\$ENDIF\)'
        return 0
    endif

    " These items have nothing before or after (not even a comment), and
    " go on column 0. Make sure that the ^\s* is followed by \( to make
    " ORs work properly, and not include the start of line (this must
    " always appear).
    " The bracketed expression with the underline is a routine
    " separator. This is one case where we do indent comment lines.
    "	if this_codeline =~ '^\s*\((\*\ _\+\ \*)\|\<\(const\|var\)\>\)$'
    "		return 0
    "	endif

    " These items may have text after them, and go on column 0 (in most
    " cases).
    if this_codeline =~ '^\s*function'
        return 0
    endif

    " BEGIN
    " If the begin does not come after "if", "for", or "else", then it
    " goes in column 0
    "	if this_codeline =~ '^\s*begin\>' && prev_codeline !~ '^\s*\<\(if\|for\|else\)\>'
        "		return 0
        "	endif

        " These keywords are indented once only.
        "	if this_codeline =~ '^\s*\<\(private\)\>'
        "		return &shiftwidth
        "	endif

        " If the PREVIOUS LINE contained these items, the current line is
        " always indented once.
        "	if prev_codeline =~ '^\s*\<\(type\|uses\)\>'
        "		return &shiftwidth
        "	endif

        " These keywords are indented once only. Possibly surrounded by
        " other chars.
        "	if this_codeline =~ '^.\+\<\(object\|record\)\>'
        "		return &shiftwidth
        "	endif

        " If the previous line was indenting...
        if prev_codeline =~ '^\s*\(for\|function\|if\|switch\|try\|unwind_protect\|while\|case\|catch\|else\|elseif\|otherwise\|unwind_protect_cleanup\)'
            " then indent.
            let indnt = indnt + &shiftwidth
            " BUT... if this is the start of a multistatement block then we
            " need to align the begin with the previous line.
            "		if this_codeline =~ '^\s*begin\>'
            "			return indnt - &shiftwidth
            "		endif

            " We also need to keep the indentation level constant if the
            " whole if-then statement was on one line.
            "		if prev_codeline =~ '\<then\>.\+'
            "			let indnt = indnt - &shiftwidth
            "		endif
        endif

        " PREVIOUS-LINE BEGIN
        " If the previous line was an indenting keyword then indent once...
        "if prev_codeline =~ '^\s*\<\(const\|var\|begin\|repeat\|private\)\>'
        " But only if this is another var in a list.
        "	if this_codeline !~ '^\s*var\>'
        "		return indnt + &shiftwidth
        "	endif
        "endif

        " PREVIOUS-LINE BEGIN
        " Indent code after a case statement begin
        "	if prev_codeline =~ '\:\ begin\>'
        "		return indnt + &shiftwidth
        "	endif

        " These words may have text before them on the line (hence the .*)
        " but are followed by nothing. Always indent once only.
        "	if prev_codeline =~ '^\(.*\|\s*\)\<\(object\|record\)\>$'
        "		return indnt + &shiftwidth
        "	endif

        " If we just closed a bracket that started on a previous line, then
        " unindent. But don't return yet -- we need to check for further
        " unindentation (for end/until/else)
        "	if prev_codeline =~ '^[^(]*[^*])'
        "		let indnt = indnt - &shiftwidth
        "	endif

        " At the end of a block, we have to unindent both the current line
        " (the "end" for instance) and the newly-created line.
        if this_codeline =~ '^\s*\(else\|end\|endfor\|endfunction\|endif\|endswitch\|end_try_catch\|end_unwind_protect\|endwhile\)'
            return indnt - &shiftwidth
        endif

        " If we have opened a bracket and it continues over one line,
        " then indent once.
        "
        " RE = an opening bracket followed by any amount of anything other
        " than a closing bracket and then the end-of-line.
        "
        " If we didn't include the end of line, this RE would match even
        " closed brackets, since it would match everything up to the closing
        " bracket.
        "
        " This test isn't clever enough to handle brackets inside strings or
        " comments.
        "	if prev_codeline =~ '([^*]\=[^)]*$'
        "		return indnt + &shiftwidth
        "	endif

        return indnt
    endfunction

