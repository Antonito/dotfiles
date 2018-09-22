"----------------------------------------------
" OS specific settings
"----------------------------------------------

if has("unix")
  let s:uname = system("echo -n \"$(uname -s)\"")
  if s:uname == "Darwin"
    " Do Mac stuff here
    let g:python_host_prog = '/usr/bin/local/python2'
    let g:python3_host_prog = '/usr/bin/local/python3'
  elseif s:uname == "Linux"
    " Do Linux stuff here
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
  endif
endif