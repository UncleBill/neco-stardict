let s:source = {
      \ 'name': 'stardict',
      \ 'kind': 'plugin',
      \ 'mark': '[stardict]',
      \ 'dict': '朗道英汉字典5.0',
      \ 'min_pattern_length' : 3,
      \ 'is_volatile': 1,
      \ }

function! s:source.initialize()
  call neocomplcache#set_completion_length('stardict', 4)
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_list(cur_keyword_str)
  let s:keyword = tolower(a:cur_keyword_str)
  if s:keyword !~ '^[[:alpha:]]\+$'
    return []
  endif
  if exists("g:neco_stardict_dictname")
      let self.dict = g:neocomplete_neco_stardict
  endif
  " TODO improve parser
  let lookup = split( system('sdcv -u ' . self.dict . ' ' . s:keyword . " -n"),
              \ "-->.*-->" . s:keyword )
  let list = len(lookup) > 1 ?
              \ split(lookup[1], "\n")[1:] : []
  let list = filter(list,
              \ 'v:val !~ "相关词组:" && len(v:val) >0')
  if neocomplcache#util#get_last_status()
    return []
  endif
  return list[0:10]
endfunction

function! neocomplcache#sources#stardict#define()
    if !executable("sdcv")
        echoerr "Require sdcv installed. read README.md for details"
        return {}
    endif
    return s:source
endfunction
