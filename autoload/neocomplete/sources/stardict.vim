let s:source = {
      \ 'name': 'stardict',
      \ 'kind': 'plugin',
      \ 'mark': '[stardict]',
      \ 'dict': ' 朗道英汉字典5.0 ',
      \ 'min_pattern_length' : 3,
      \ 'is_volatile': 1,
      \ }

function! s:source.gather_candidates(context)
  let keyword = tolower(a:context.complete_str)
  if keyword !~ '^[[:alpha:]]\+$'
    return []
  endif
  " TODO improve parser
  let lookup = split( neocomplete#util#system('sdcv -u' . self.dict . keyword . " -n"),
              \ "-->.*-->" . keyword )
  let list = len(lookup) > 1 ?
              \ split(lookup[1], "\n")[1:] : []
  let list = filter(list,
              \ 'v:val !~ "相关词组:" && len(v:val) >0')
  if neocomplete#util#get_last_status()
    return []
  endif
  return list[0:10]
endfunction

function! neocomplete#sources#stardict#define()
    if !executable("sdcv")
        echoerr "Require sdcv installed. read README.md for details"
        return {}
    endif
    return s:source
endfunction
