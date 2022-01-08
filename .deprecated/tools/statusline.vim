" --------------- Status Bar ---------------

let g:separator = ['', '']
let g:divisor = '•'

let g:active = v:true

function GetFileSize()
	let l:size = getfsize(bufname())

	if l:size < 0
		return '0 [b]'
	endif

	let l:units = ['b', 'kb', 'mb', 'gb', 'tb']

	let l:unit = 0

	while l:size >= 1024
		let l:size = l:size / 1024.0
		
		let l:unit = l:unit + 1
	endwhile

	return float2nr(l:size) .. ' [' .. l:units[l:unit] .. ']'
endfunction

function GetMode()
	let l:mode = mode()

	if l:mode == 'n'
		let l:mode = 'Normal'
	elseif l:mode == 'v'
		let l:mode = 'Visual'
	elseif l:mode == 'V'
		let l:mode = 'Visual'
	elseif l:mode == 'i'
		let l:mode = 'Insert'
	elseif l:mode == 'r'
		let l:mode = 'Replace'
	elseif l:mode == 'R'
		let l:mode = 'Replace'
	elseif l:mode == 'c'
		let l:mode = 'Command'
	elseif l:mode == 't'
		let l:mode = 'Terminal'
	endif

	return l:mode
endfunction

function GetFileChanged(color)
	let l:changed = ''

	if g:active
		let l:base = "%#LineBase" .. a:color .. "#"
	else
		let l:base = "%#LineBaseWhite#"
	endif

	let l:chan = "%#LineOther#"

	"  

	if &modified
		let l:changed = l:changed .. l:chan .. "["
		let l:changed = l:changed .. l:base .. "*"
		let l:changed = l:changed .. l:chan .. "]"
		let l:changed = l:changed .. l:base
	else
		let l:changed = l:changed .. l:chan .. "["
		let l:changed = l:changed .. l:base .. "•"
		let l:changed = l:changed .. l:chan .. "]"
		let l:changed = l:changed .. l:base
	endif

	return l:changed
endfunction

function GetFileName()
	let l:name = expand('%:t:r')

	if l:name == ''
		return 'empty'
	endif

	return l:name
endfunction

function GetFileExtension()
	let l:extension = expand('%:e')

	if l:extension == ''
		return 'null'
	endif

	return l:extension
endfunction

function GetTheme()
	return g:nametheme
endfunction

function GetFileProgress()
	return '%3p%%'
endfunction

function GetCursorPosition()
	return '%l:%c'
endfunction

function GetStatusLineColor(mode)
	let l:color = g:colors[0]

	if g:nametheme[0:3] == 'Rose'
		if a:mode == 'Normal'
			return 'Cyan'
		elseif a:mode == 'Insert'
			return 'Yellow'
		elseif a:mode == 'Visual'
			return 'Green'
		elseif a:mode == 'Replace'
			return 'Red'
		elseif a:mode == 'Command'
			return 'Blue'
		elseif a:mode == 'Terminal'
			return 'Cyan'
		endif
	else
		if a:mode == 'Normal'
			return 'Green'
		elseif a:mode == 'Insert'
			return 'Yellow'
		elseif a:mode == 'Visual'
			return 'Blue'
		elseif a:mode == 'Replace'
			return 'Magenta'
		elseif a:mode == 'Command'
			return 'Cyan'
		elseif a:mode == 'Terminal'
			return 'Cyan'
		endif
	endif
	
	return l:color
endfunction

" -------------- Inactive Buffer Status Line

function InactiveStatusLine()
	let l:name = GetFileName()
	let l:extension = GetFileExtension()
	let l:size = GetFileSize()
	let l:progress = GetFileProgress()
	let l:position = GetCursorPosition()

	let l:changed = GetFileChanged("White")
	let l:icon = GetFileIcon(l:extension)

	let l:left = ''
	let l:right = ''

	let l:left = l:left .. '%#LineLeadWhite# Inactive '
	let l:left = l:left .. '%#LineBaseWhite#' .. g:separator[0]
	let l:left = l:left .. ' ' .. l:changed
	let l:left = l:left .. ' ' .. l:name
	let l:left = l:left .. ' ' .. g:divisor
	let l:left = l:left .. ' ' .. l:size .. ' '
	let l:left = l:left .. '%#LineSep#' .. g:separator[0]
	let l:left = l:left .. '%#LineRest# ' .. l:extension .. ' ' .. l:icon

	let l:right = l:right .. '%#LineSep#' .. g:separator[1]
	let l:right = l:right .. '%#LineBaseWhite#' .. ' ' .. l:progress .. ' '  .. g:separator[1]
	let l:right = l:right .. '%#LineLeadWhite# ' .. l:position .. ' '

	return l:left .. '%=' .. l:right
endfunction	

" -------------- Active Buffer Status Line

function StatusLine()
	let l:mode = GetMode()
	let l:name = GetFileName()
	let l:extension = GetFileExtension()
	let l:size = GetFileSize()
	let l:theme = GetTheme()
	let l:progress = GetFileProgress()
	let l:position = GetCursorPosition()

	let l:icon = GetFileIcon(l:extension)
	let l:color = GetStatusLineColor(l:mode)
	let l:changed = GetFileChanged(l:color)

	"call SetStatusLineColors()

	let l:left = ''
	let l:right = ''

	let l:left = l:left .. '%#LineLead' .. l:color .. '# ' .. l:mode .. ' '
	let l:left = l:left .. '%#LineBase' .. l:color .. '#' .. g:separator[0]
	let l:left = l:left .. ' ' .. l:changed
	let l:left = l:left .. ' ' .. l:name
	let l:left = l:left .. ' ' .. g:divisor
	let l:left = l:left .. ' ' .. l:size .. ' '
	let l:left = l:left .. '%#LineSep#' .. g:separator[0]
	let l:left = l:left .. '%#LineRest# ' .. l:extension .. ' ' .. l:icon

	let l:right = l:right .. '%#LineRest# ' .. l:theme .. ' '
	let l:right = l:right .. '%#LineSep#' .. g:separator[1]
	let l:right = l:right .. '%#LineBase' .. l:color .. '#' .. ' ' .. l:progress .. ' '  .. g:separator[1]
	let l:right = l:right .. '%#LineLead' .. l:color .. '# ' .. l:position .. ' '

	return l:left .. '%=' .. l:right
endfunction

function SetActiveBufferStatusLine()
	let l:ignored = ['Startup', 'NvimTree', 'Terminal']

	let l:default = v:true

	for l:file in l:ignored
		if &filetype == l:file
			let l:default = v:false
			
			break
		endif
	endfor

	if l:default
		let g:active = v:true

		setlocal statusline=%!StatusLine()
	endif
endfunction

function SetInactiveBufferStatusLine()
	let l:ignored = ['Startup', 'NvimTree', 'Terminal']

	let l:default = v:true

	for l:file in l:ignored
		if &filetype == l:file
			let l:default = v:false
			
			break
		endif
	endfor

	if l:default
		let g:active = v:false

		call setbufvar(bufnr(), '&statusline', InactiveStatusLine())
	endif
endfunction

augroup SetStatusLine
	autocmd!
	autocmd WinEnter,BufEnter * call SetActiveBufferStatusLine()
	autocmd WinLeave,BufLeave * call SetInactiveBufferStatusLine()
augroup end
