" Basic Config
syntax on
set ts=4 sw=4 mouse=a nu ai si cursorline expandtab nobackup incsearch ignorecase smartcase

" Blinking Cursor
if &term =~ 'xterm' || &term == 'win32'
  let &t_SI = "\e[5 q" | let &t_SR = "\e[3 q" | let &t_EI = "\e[1 q" | let &t_ti .= "\e[1 q" | let &t_te .= "\e[0 q"
endif

" Wayland clipboard support while not (https://github.com/vim/vim/issues/5157)
xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p

" Maratona Hash
function Hash(l)
        return system("sed '/^#/d' | cpp -dD -P -fpreprocessed | tr -d '[:space:]' | md5sum", a:l)
endfunction
function PrintHash() range
        for i in range(a:firstline, a:lastline)
                let k = i
                let l = getline(i)
                for j in range(len(l))
                        if l[j] == '}'
                                call cursor(i, j+1)
                                let k = searchpair('{', '', '}', 'b')
                        endif
                endfor
                echo Hash(join("\n", getline(k, i)))[0:2] l
                call cursor(i, len(l))
        endfor
endfunction
vmap <C-H> :call PrintHash()<CR>

" Automatic C++ Template
autocmd BufNewFile *.cpp 0r ~/.templ.cpp | 17 | startinsert!

