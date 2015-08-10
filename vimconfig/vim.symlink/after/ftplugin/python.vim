augroup python_lang
    autocmd!
    " Before writing the buffer, remove white spaces.
    autocmd BufWritePre <buffer> :call RemoveWhite()
augroup END
