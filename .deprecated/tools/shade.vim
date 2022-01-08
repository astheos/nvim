" --------------- Shade Plugin Functions

function SyntaxShade()
	let l:color = synIDattr(hlID('Normal'), 'bg')

	let l:shade = ChangeBrightness(l:color, -20)

	execute 'highlight NormalNC guibg=' .. l:shade
endfunction

function ToggleCursorLine(value)
	if a:value
		if !(&filetype == 'Startup') && !(&filetype == 'Terminal')
			setlocal cursorline
		endif
	else
		setlocal nocursorline
	endif
endfunction

augroup CursorLine
    autocmd!
    autocmd WinEnter * call ToggleCursorLine(v:true)
    autocmd WinLeave * call ToggleCursorLine(v:false)
augroup end
