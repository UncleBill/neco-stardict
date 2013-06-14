let s:source = {
      \ 'name': 'stardict',
      \ 'kind': 'plugin',
      \ 'mark': '[stardict]',
      \ 'dict': '朗道英汉字典5.0',
      \ 'min_pattern_length' : 3,
      \ 'matchers' : [],
      \ 'is_volatile': 1,
      \ }

function! s:source.gather_candidates(context)
  let s:keyword = tolower(a:context.complete_str)
  if s:keyword !~ '^[[:alpha:]]\+$'
    return []
  endif
  " TODO improve parser
  if exists("g:neco_stardict_dictname")
      let self.dict = g:neocomplete_neco_stardict
  endif
  let lookup = split( system('sdcv -u ' . self.dict . ' ' . s:keyword . " -n"),
              \ "-->.*-->" . s:keyword )
  let list = len(lookup) > 1 ?
              \ split(lookup[1], "\n")[1:] : []
  let list = filter(list,
              \ 'v:val !~ "相关词组:" && len(v:val) >0')
  return list
endfunction

function! neocomplete#sources#stardict#define()
    if !executable("sdcv")
        echoerr "Require sdcv installed. read README.md for more details"
        return {}
    endif
    return s:source
endfunction
