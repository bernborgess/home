syntax on
set ts=4 sw=4 mouse=a nu ai si
set cursorline
set expandtab
set nobackup
set incsearch
set ignorecase
set smartcase

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

autocmd BufNewFile *.cpp 0r ~/.templ.cpp | 17 | startinsert!

" Change cursor shape
" Note: This should be set after `set termguicolors` or `set t_Co=256`.
if &term =~ 'xterm' || &term == 'win32'
  " Use DECSCUSR escape sequences
  let &t_SI = "\e[5 q"    " blink bar
  let &t_SR = "\e[3 q"    " blink underline
  let &t_EI = "\e[1 q"    " blink block
  let &t_ti .= "\e[1 q"   " blink block
  let &t_te .= "\e[0 q"   " default (depends on terminal, normally blink block)
endif

" How to install vim plugins
" $ mkdir -p ~/.vim/pack/vendor/start

" $ git clone --depth 1 \
"   https://github.com/preservim/nerdtree.git \
"   ~/.vim/pack/vendor/nerdtree

" If you don't want a plugin to load automatically
" every time you launch Vim, you can create an opt
" directory within your ~/.vim/pack/vendor directory:

" $ mkdir ~/.vim/pack/vendor/opt

" Any plugins installed into opt are available to Vim,
" but they're not loaded into memory until you add them
" to a session with the packadd command.

" For example, to load an imaginary plugin called foo:
" :packadd foo

" Officially, Vim recommends that each plugin project
" gets its own directory within ~/.vim/pack. For example,
" if you were to install the NERDTree plugin and the
" imaginary foo plugin, you would create this structure:

" $ mkdir -p ~/vim/pack/foo/start/
" $ git clone --depth 1 \
"   https://github.com/foo/foo.git \
"   ~/.vim/pack/foo/start/foo


" Nerdtree red
" nnoremap <C-b> :NERDTreeToggle<CR>

" Conquer of Completion
" set encoding=utf-8
" set nobackup
" set nowritebackup
" set updatetime=300
" set signcolumn=yes
" inoremap <silent><expr> <TAB>
"     \ coc#pum#visible() ? coc#pum#next(1) :
"    \ CheckBackspace() ? "\<Tab>" :
"    \ coc#refresh()
" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"     \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"



" Using Haskell in Vim
nnoremap <Leader>q :tabp<CR>
nnoremap <Leader>r :tabn<CR>
nnoremap <Leader>t :vert term<CR>
nnoremap <Leader>b :NERDTreeToggle<CR>

" Tabs
nnoremap <Leader><TAB> :tabnext<CR>

" Escape from terminal 
tnoremap <C-C> <C-\><C-n>
tnoremap <ESC> <C-\><C-n>




