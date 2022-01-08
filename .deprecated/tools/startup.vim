let s:screen = ['                                __                 ',
			\	'   ___     ___    ___   __  __ /\_\    ___ ___     ',
			\	'  / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\   ',
			\	' /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ',
			\	' \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ',
			\	'  \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ',
			\	'                                                   ',
			\	' Actions                                      Maps ',
			\	'                                                   ',
			\	' [•]  New Archives                          <c-n> ',
			\	' [•]  Old Archives                          <c-o> ',
			\	'                                                   ',
			\	' [•]  File Manager                          <c-f> ',
			\	'                                                   ',
			\	' Files                                             ',
			\	'                                                   ',
			\	' [•]  Settings                              <c-s> ',
			\	'                                                   ',
			\	' Folders                                           ',
			\	'                                                   ',
			\	' [•]  Projects                              <c-p> ']

let s:width  = (winwidth(0)  - len(s:screen[0]))  / 2
let s:height = (winheight(0) - len(s:screen) - 1) / 2

let s:margin = ['', []]

let s:pos = [[s:height + 10, s:width + 3],
			\[s:height + 11, s:width + 3],
			\[s:height + 13, s:width + 3],
			\[s:height + 17, s:width + 3],
			\[s:height + 21, s:width + 3]]
 
let s:cur = 0

function MoveCursor(sense)
	if a:sense
		let s:cur = s:cur + 1
		
		if s:cur == len(s:pos)
			let s:cur = 0
		endif
	else
		let s:cur = s:cur - 1
		
		if s:cur == -1
			let s:cur = len(s:pos) - 1
		endif
	endif

	setlocal
	\	modifiable
	\	modified

	if s:cur == 3
		call setline(s:pos[3][0], s:margin[0] .. ' [•]  Settings ~/.config/nvim/init.vim      <c-s>')
	else
		call setline(s:pos[3][0], s:margin[0] .. ' [•]  Settings                              <c-s>')
	endif

	if s:cur == 4
		call setline(s:pos[4][0], s:margin[0] .. ' [•]  Projects ~/projetos/programação       <c-p>')
	else
		call setline(s:pos[4][0], s:margin[0] .. ' [•]  Projects                              <c-p>')
	endif

	setlocal 
	\	nomodifiable
	\	nomodified

	call cursor(s:pos[s:cur])
endfunction

function PerformAction(cur)
	if a:cur == -1
		if s:cur == 0
			execute ':cd ~'
			execute ':Telescope file_browser'
		elseif s:cur == 1
			execute ':Telescope oldfiles'
		elseif s:cur == 2
			execute ':cd ~'
			execute ':Telescope find_files'
		elseif s:cur == 3
			execute ':bw'
			execute ':cd ~/.config/nvim'
			execute ':edit init.vim'
		elseif s:cur == 4
			execute ':cd ~/projetos/programação'
			execute ':Telescope find_files'
		endif
	else
		if a:cur == 0
			execute ':cd ~'
			execute ':Telescope file_browser'
		elseif a:cur == 1
			execute ':Telescope oldfiles'
		elseif a:cur == 2
			execute ':cd ~'
			execute ':Telescope find_files'
		elseif a:cur == 3
			execute ':bw'
			execute ':cd ~/.config/nvim'
			execute ':edit init.vim'
		elseif a:cur == 4
			execute ':cd ~/projetos/programação'
			execute ':Telescope find_files'
		endif
	endif
endfunction

function FillScreen()
	let l:rest = []
	let l:count = 0

	let l:lim = winwidth(0) - len(s:screen)

	while l:count < l:lim
		let l:rest = l:rest + ['']
		let l:count = l:count + 1
	endwhile

	call append(len(s:screen), l:rest)
endfunction

function EvalScreen()
	let l:count = 0

	while l:count < s:width
		let s:margin[0] = s:margin[0] .. ' '
		let l:count = l:count + 1
	endwhile

	let l:count = 0

	while l:count < s:height
		let s:margin[1] = s:margin[1] + ['']
		let l:count = l:count + 1
	endwhile

	let l:index = 0

	while l:index < len(s:screen)
		let s:screen[l:index] = s:margin[0] .. s:screen[l:index]
		let l:index = l:index + 1
	endwhile

	let s:screen = s:margin[1] + s:screen
endfunction

function ShowScreen()
	call append(0, s:screen)
endfunction

function StartupStatusLine()
	let l:line = '%#LineLeadCyan# Welcome '
	let l:line = l:line .. '%#LineBaseCyan#'
	let l:line = l:line .. g:separator[0]
	let l:line = l:line .. '%#LineSep#'
	let l:line = l:line .. g:separator[0]
	let l:line = l:line .. '%#LineRest#'

	return l:line
endfunction

function StartupSyntax()
	syntax keyword StartupAction Actions Files Folders Maps
	syntax keyword StartupName   New File Manager Settings Projects Help Archives Old Quit
	syntax keyword StartupPath   nvim init vim projetos programação config
	syntax keyword StartupMaps   c n o f s p

	syntax match StartupPoint   '•'

	syntax match StartupSymbol  '\\'
	syntax match StartupSymbol  '\/'
	syntax match StartupSymbol  '\`'
	syntax match StartupSymbol  '|'
	syntax match StartupSymbol  '_'

	syntax match StartupPath    '\.'
	syntax match StartupPath    '\:'
	syntax match StartupPath    '\~'

	highlight default link StartupAction Keyword
	highlight default link StartupName   Function
	highlight default link StartupPoint  Number
	highlight default link StartupSymbol Special
	highlight default link StartupPath   Comment
	highlight default link StartupMaps   Type
endfunction

function Start()
	if argc() || line2byte('$') != -1 || &insertmode
		call UpTheme()

		return
	endif

	enew

	file Startup

	setlocal
	\	nobuflisted
	\	nocursorline
	\	nocursorcolumn
	\	nonumber
	\	norelativenumber
	\	nolist
	\	noswapfile

	setlocal filetype=Startup

	setlocal statusline=%!StartupStatusLine()

	set showtabline=0

	syntax enable

	call EvalScreen()
	call ShowScreen()
	call FillScreen()

	call cursor(s:pos[s:cur])

	setlocal
	\	nomodified
	\	nomodifiable
	
	call StartupSyntax()
	call UpTheme()

	nnoremap <buffer><silent> <Left>  :call MoveCursor(v:false) <CR>
	nnoremap <buffer><silent> <Right> :call MoveCursor(v:true)  <CR>
	nnoremap <buffer><silent> <Up>    :call MoveCursor(v:false) <CR>
	nnoremap <buffer><silent> <Down>  :call MoveCursor(v:true)  <CR>
 
	nnoremap <silent><buffer> h :call MoveCursor(v:true)  <CR>
	nnoremap <silent><buffer> j :call MoveCursor(v:true)  <CR>
	nnoremap <silent><buffer> k :call MoveCursor(v:false) <CR>
	nnoremap <silent><buffer> l :call MoveCursor(v:false) <CR>
 
	nnoremap <silent><buffer> <Enter> :call PerformAction(-1) <CR>

	nnoremap <silent><buffer><c-n> :call PerformAction(0) <CR>
	nnoremap <silent><buffer><c-o> :call PerformAction(1) <CR>
	nnoremap <silent><buffer><c-f> :call PerformAction(2) <CR>
	nnoremap <silent><buffer><c-s> :call PerformAction(3) <CR>
	nnoremap <silent><buffer><c-p> :call PerformAction(4) <CR>
endfunction

augroup startup
	autocmd!
	autocmd VimEnter * call Start()
	autocmd BufEnter Startup set showtabline=0
	autocmd BufLeave Startup set showtabline=2
augroup end
