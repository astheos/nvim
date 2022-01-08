" --------------- Buffer Line ---------------

function ExtractName(path)
	let l:index = 0
	let l:split = 0

	while l:index <= len(a:path)
		if a:path[l:index] == '/'
			let l:split = l:index + 1
		endif

		let l:index = l:index + 1
	endwhile

	return a:path[l:split:]
endfunction

function ExtractIcon(path)
	let l:index = 0
	let l:split = 0

	while l:index <= len(a:path)
		if a:path[l:index] == '.'
			let l:split = l:index + 1
		endif

		let l:index = l:index + 1
	endwhile

	return GetFileIcon(a:path[l:split:])
endfunction

function GetListedBuffers()
	let l:buffers = []
	let l:numbers = []
	let l:icons   = []
	let l:current = 0

	for l:buffer in range(1, bufnr('$'))
		if buflisted(l:buffer)
			let l:numbers = l:numbers + [l:buffer]

			let l:buffers = l:buffers + [ExtractName(bufname(l:buffer))]
			let l:icons   = l:icons   + [ExtractIcon(bufname(l:buffer))]

			if l:buffer == bufnr()
				let l:current = len(l:buffers) - 1
			endif
		endif
	endfor
	
	return [l:numbers, l:buffers, l:icons, l:current]
endfunction

function GetBufferLineColor()
	if g:colors_name == 'gruvbox'
		return "White"
	elseif g:colors_name == 'sonokai'
		return "Red"
	elseif g:colors_name == 'nord'
		return "Cyan"
	elseif g:colors_name == 'rose-pine'
		return "Cyan"
	endif
endfunction

function BufferLine()
	let l:color = GetBufferLineColor()
	let l:listed = GetListedBuffers()

	let l:numbers = l:listed[0]
	let l:buffers = l:listed[1]
	let l:icons   = l:listed[2]
	let l:current = l:listed[3]

	let l:line = '%#LineLead' .. l:color .. '#'
	let l:line = l:line .. ' Buffers '
	let l:line = l:line .. '%#LineBase' .. l:color .. '#'
	let l:line = l:line .. '%#LineOther#'

	for l:index in range(0, len(l:buffers) - 1)
		let l:line = l:line .. '%#LineOther# ['
		let l:line = l:line .. '%#LineNumb#' .. l:numbers[l:index]
		let l:line = l:line .. '%#LineOther#] '

		if l:index == l:current
			let l:line = l:line .. '%#LineBase' .. l:color .. '#'
			let l:line = l:line .. l:buffers[l:index] .. ' '
			let l:line = l:line .. '%#LineOther#'
		else
			let l:line = l:line .. '%#LineOther#' .. l:buffers[l:index] .. ' '
		endif

		"Icons ----------------------------------------
		let l:line = l:line .. l:icons[l:index] .. ' '

		if l:index + 1 < len(l:buffers)
			let l:line = l:line .. '•'
		endif
	endfor

	let l:line = l:line .. '%#LineSep#'

	return l:line
endfunction

set showtabline=2

set tabline=%!BufferLine()
