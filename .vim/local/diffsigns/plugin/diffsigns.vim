" Disable syntax highlighting for diffs - using autoload/diffsigns instead
let g:diffsigns_disablehighlight = 1

" Use the diffsigns function to calculate diffs (which as a side-effect sets
" sign column)
set diffexpr=diffsigns#run()
