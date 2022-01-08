" -------------- Highlight Number and Line Cursor

function UpdateCursorColors()
	let l:color = synIDattr(hlID("Normal"), "bg")
	let l:color = Opacity(l:color, '#ffffff', 10)

	execute 'highlight CursorLine guibg=' .. l:color
	execute 'highlight CursorLineNr guifg=' .. g:colors[15]

	highlight! link Visual CursorLine

	redraw
endfunction
