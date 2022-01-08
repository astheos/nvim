let s:screen = ['                                __                 ',
			\	'   ___     ___    ___   __  __ /\_\    ___ ___     ',
			\	'  / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\   ',
			\	' /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ',
			\	' \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ',
			\	'  \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ',
			\	'                                                   ',
			\	' Actions                                           ',
			\	'                                                   ',
			\	' [•] New File or Folder                            ',
			\	' [•] File Manager                                  ',
			\	'                                                   ',
			\	' [•] Help                                          ',
			\	'                                                   ',
			\	' Files                                             ',
			\	'                                                   ',
			\	' [•] Settings                                      ',
			\	'                                                   ',
			\	' Folders                                           ',
			\	'                                                   ',
			\	' [•] Projects                                      ']

let s:width  = (winwidth(0)  - len(s:screen[0]))  / 2
let s:height = (winheight(0) - len(s:screen) - 1) / 2

let s:margin = ['', []]

let s:pos = [[s:height + 10, s:width + 3],
			\[s:height + 11, s:width + 3],
			\[s:height + 13, s:width + 3],
			\[s:height + 17, s:width + 3],
			\[s:height + 21, s:width + 3]]
 
let s:cur = 0

let g:initstartup = v:false

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
		call setline(s:pos[3][0], s:margin[0] .. ' [•] Settings ~\appdata\local\nvim\init.vim')
	else
		call setline(s:pos[3][0], s:margin[0] .. ' [•] Settings')
	endif

	if s:cur == 4
		call setline(s:pos[4][0], s:margin[0] .. ' [•] Projects c:\projetos\programação')
	else
		call setline(s:pos[4][0], s:margin[0] .. ' [•] Projects')
	endif

	setlocal 
	\	nomodifiable
	\	nomodified

	call cursor(s:pos[s:cur])
endfunction

function PerformAction()
	if s:cur == 0
		execute ':cd ~'
		execute ':Telescope file_browser'
	elseif s:cur == 1
		execute ':cd ~'
		execute ':Telescope find_files'
	elseif s:cur == 2
		execute ':bw'
		execute ':tab help'
	elseif s:cur == 3
		execute ':bw'
		execute ':edit ~\appdata\local\nvim\init.vim'
	elseif s:cur == 4
		execute ':cd ~\documents\projetos\programação'
		execute ':Telescope find_files'
	endif
endfunction

function EnabledPlugins(action)
	if a:action
		let g:indent_blankline_enabled = v:true
	else
		let g:indent_blankline_enabled = v:false
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

function Syntax()
	syntax keyword StartifyAction Actions Files Folders
	syntax keyword StartifyName   New File Folder Manager Settings Projects Help or
	syntax keyword StartifyPath   appdata local nvim init vim projetos programação c

	syntax match StartifyPoint  '•'

	syntax match StartifySymbol '\\'
	syntax match StartifySymbol '\/'
	syntax match StartifySymbol '\`'
	syntax match StartifySymbol '|'
	syntax match StartifySymbol '_'

	syntax match StartifyPath '\.'
	syntax match StartifyPath '\:'
	syntax match StartifyPath '\~'

	highlight default link StartifyAction Keyword
	highlight default link StartifyName   Function
	highlight default link StartifyPoint  Number
	highlight default link StartifySymbol Special
	highlight default link StartifyPath   Comment
endfunction

function Start()
	if argc() || line2byte('$') != -1 || &insertmode
		return
	endif

	enew

	file AVerySpecificNameToAvoidConfusions

	call EnabledPlugins(v:false)

	setlocal
	\	nobuflisted
	\	nocursorline
	\	nocursorcolumn
	\	nonumber
	\	norelativenumber
	\	nolist
	\	noswapfile
	
	set showtabline=0

	syntax enable
	
	call EvalScreen()
	call ShowScreen()
	call FillScreen()

	call cursor(s:pos[s:cur])

	setlocal
	\	nomodified
	\	nomodifiable
	
	call Syntax()

	let g:initstartup = v:true

	nnoremap <buffer><silent> <Left>  :call MoveCursor(v:false) <CR>
	nnoremap <buffer><silent> <Right> :call MoveCursor(v:true)  <CR>
	nnoremap <buffer><silent> <Up>    :call MoveCursor(v:false) <CR>
	nnoremap <buffer><silent> <Down>  :call MoveCursor(v:true)  <CR>
 
	nnoremap <silent><buffer> h :call MoveCursor(v:true)  <CR>
	nnoremap <silent><buffer> j :call MoveCursor(v:true)  <CR>
	nnoremap <silent><buffer> k :call MoveCursor(v:false) <CR>
	nnoremap <silent><buffer> l :call MoveCursor(v:false) <CR>
 
	nnoremap <silent><buffer> <Enter> :call PerformAction() <CR>
endfunction

function Finish()
	if bufwinnr('AVerySpecificNameToAvoidConfusions') == -1
		call EnabledPlugins(v:true)

		let g:initstartup = v:false

		set showtabline=2

		call UpdateThemeVariation()
		call UpdateTheme()
	endif
endfunction

augroup startify
	autocmd!
	autocmd VimEnter * call Start()
	autocmd BufEnter * call Finish()
augroup end
