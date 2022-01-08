" --------------- Terminal Configuration

let s:terminal = ''

function TerminalToggle()
	if s:terminal == '' 
		silent write

		let l:height = winheight(0) / 4

		execute ':belowright split'
		execute ':resize ' .. l:height
		execute ':edit'
		execute ':terminal'
		execute ':start'

		setlocal winfixheight
		setlocal nocursorline
		setlocal nonumber
		setlocal norelativenumber

		setlocal filetype=Terminal
		setlocal statusline=%!TerminalStatusLine()

		let s:terminal = bufname()
	else
		execute ':bwipeout! ' .. s:terminal

		let s:terminal = '' 
	endif
endfunction

function TerminalStatusLine()
	let l:mode = GetMode()
	
	if l:mode == 'Terminal'
		let l:mode = 'Insert'
	endif

	let l:name = 'Terminal'
	let l:terminal = 'prompt'

	let l:theme = GetTheme()

	let l:icon = ''

	let l:left = ''
	let l:right = ''

	let l:left = l:left .. '%#LineLeadCyan# ' .. l:name .. ' '
	let l:left = l:left .. '%#LineBaseCyan#' .. g:separator[0]
	let l:left = l:left .. ' ' .. l:mode ..  ' '
	let l:left = l:left .. '%#LineSep#' .. g:separator[0]
	let l:left = l:left .. '%#LineRest# ' .. l:terminal .. ' ' .. l:icon

	let l:right = l:right .. '%#LineRest# ' .. l:theme .. ' '
	let l:right = l:right .. '%#LineSep#' .. g:separator[1]
	let l:right = l:right .. '%#LineBaseCyan#' .. ' ' .. g:separator[1]
	let l:right = l:right .. '%#LineLeadCyan# ' .. ' '

	return l:left .. '%=' .. l:right
endfunction

" ----- Terminal Maps

tnoremap <Esc> <C-\><C-n>

" ----- Map Keys

nnoremap <silent> <space>t :call TerminalToggle() <CR>
