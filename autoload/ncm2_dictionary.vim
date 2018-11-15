"=============================================================================
" FILE: ncm2_dictionary.vim
" AUTHOR:  yuki ycino <yuki.ycino@gmail.com>
" License: MIT license
"=============================================================================

if get(s:, 'loaded', 0)
  finish
endif
let s:loaded = 1

let s:cache = {}

function! ncm2_dictionary#on_complete(ctx)
  let l:startcol = a:ctx.startccol
  let l:base = strpart(a:ctx.typed, l:startcol)

  if !has_key(s:cache, &filetype)
    let l:matches = []
    let l:dictionaries = split(&dictionary, ',')

    for l:dictionary in l:dictionaries
      let l:matches = l:matches + readfile(l:dictionary)
    endfor

    map(l:matches, "{'word': v:val}")
    let s:cache[&filetype] = l:matches
  endif

  call ncm2#complete(a:ctx, l:startcol, s:cache[&filetype])
endfunction

function! ncm2_dictionary#init() abort
  call  ncm2#register_source({ 'name': 'dictionary',
  \ 'mark': 'dict',
  \ 'priority': 5,
  \ 'on_complete': 'ncm2_dictionary#on_complete',
  \ 'word_pattern': '[\w/]+',
  \ })
endfunction
