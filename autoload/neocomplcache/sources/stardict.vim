let s:source = {
      \ 'name': 'stardict',
      \ 'kind': 'plugin',
      \ 'mark': '[stardict]',
      \ 'max_candidates': 10,
      \ }
let dict = " 懒虫简明英汉词典 "

function! s:source.initialize()
  call neocomplcache#set_completion_length('stardict', 2)
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_list(cur_keyword_str)
  if a:cur_keyword_str !~ '^[[:alpha:]]\+$'
    return []
  endif
  let keyword = a:cur_keyword_str
  let result = split( neocomplcache#util#system('sdcv -u' . dict . keyword . " -n"),
              \ "-->.*-->" . keyword )
  "echo result
  let list = len(result) > 1 ?
              \ split(result[1], "\n")[1:] : []
  if neocomplcache#util#get_last_status()
    return []
  endif
  return list[0:10]
endfunction

function! neocomplcache#sources#stardict#define()
  return s:source
endfunction
