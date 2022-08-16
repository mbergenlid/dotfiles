source ~/.vim/basic

set rubydll=/usr/local/opt/ruby/lib/libruby.dylib

call plug#begin()

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'wincent/command-t', { 'do': 'cd ruby/command-t && ruby extconf.rb && make' }
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim'
Plug 'google/vim-jsonnet'
Plug 'godlygeek/tabular'
Plug 'vim-syntastic/syntastic'
Plug 'majutsushi/tagbar'
Plug 'hashivim/vim-terraform'
call plug#end()

nmap <c-p> :CommandT
set list listchars=tab:»·,trail:·
set number
set ruler

let g:jsonnet_fmt_options = '--indent 4 --string-style d --comment-style s'
colorscheme desert

let g:rustfmt_autosave = 1

nnoremap <C-b> :YcmCompleter GoTo<CR>
let g:ycm_autoclose_preview_window_after_completion = 1

let g:terraform_fmt_on_save=1

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
