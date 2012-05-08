function! SyntaxName(l, c, ...) "{{{
    let trans = a:0 > 0 ? a:1 : 0
    return synIDattr(synID(a:l, a:c, trans), 'name')
endfunction "}}}

function! InComment() " {{{
    let syn = SyntaxName(line('.'), col('.') - 1, 1)
    if syn =~? 'comment'
        return 1
    else
        return 0
    endif
endfunction "}}}

function! EOL() "{{{
    if col('.') == col('$')
        return 1
    else
        return 0
    endif
endfunction "}}}

function! BlankLine() "{{{
    return getline('.') =~ '^\s*$'
endfunction "}}}

function! AlreadyEnded() "{{{
    return getline('.') =~ ':$'
endfunction "}}}

function! s:RewriteLine() "{{{
    echom 'es'
    let line = getline('.')
    let firstWord = substitute(line, '^\s*\(\w\+\).*$','\1','')
    echom 'line' line
    echom 'fword' firstWord
    let syn = SyntaxName(line('.'), col('.') - 1, 1)
    echom syn
    echo syn
    if AlreadyEnded() || !(EOL() || InComment())
        return ""
    elseif firstWord =~ '\(try\|finally\|with\|class\|def\|for\|if\|elif\|else\|while\)\>'
        if firstWord == 'def' && line !~ '(.*)'
            echom 'add brackets' line !~ '(.*)'
            return "():"
        else
            echom 'no brackets' line !~ '(.*)'
            return ":"
        endif
    elseif line =~ 'ifmain'
        call setline('.', 'if __name__ == "__main__":')
        call cursor(0, col('$'))
        return ""
    else
        return ""
    endif
endfunction " }}}

" {{{ Maps and abbreviations
inoremap <silent> <Plug>RewriteLine  <C-R>=<SID>RewriteLine()<CR>
imap <buffer> <CR> <Plug>RewriteLine
" }}}

echom 'python.vim loaded'
