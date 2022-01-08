" --------------- Hold Cursor Line on Middle Functions ---------------

function HoldCursor(sense)
	let l:line  = winline()	
	let l:lines = winheight(0)

	let l:position = [line('.'), col('.')]

	if a:sense == "down"
		if (l:line < l:lines / 2) || (line('w$') == line('$'))
			normal! j
		else
			call cursor(line('w$'), l:position[1])

			normal! j

			call cursor(l:position[0] + 1, l:position[1])
		endif
	elseif a:sense == "up"
		if (l:line > l:lines / 2) || (line('w0') == 1)
			normal! k
		else
			call cursor(line('w0'), l:position[1])

			normal! k

			call cursor(l:position[0] - 1, l:position[1])
		endif
	endif
endfunction

let s:enable = v:false

function ToggleCursorHold()
	if s:enable
		nunmap j
		nunmap k
	else
		nnoremap <silent>j :call HoldCursor("down") <cr>
		nnoremap <silent>k :call HoldCursor("up")   <cr>
	endif

	let s:enable = !s:enable
endfunction
