" --------------- Lualine Configuration

let g:base = ['', '', '']

let g:colors = ['',
			\	'',
			\	'',
			\	'',
			\	'',
			\	'',
			\	'']

function UpdateColors()
	let g:colors[0] = g:terminal_color_0

	let l:color = 10

	while l:color <= 15
		execute 'let g:colors[' .. (l:color - 9) .. '] = g:terminal_color_' .. l:color

		let l:color = l:color + 1
	endwhile
	
	let g:base[0] = synIDattr(hlID("Normal"), "bg")
	
	let g:base[1] = ChangeBrightness(g:base[0],  10)
	let g:base[2] = ChangeBrightness(g:base[0], -10)
endfunction

function LimitValue(value, inferior, superior)
	if a:value < a:inferior
		return a:inferior
	endif

	if a:value > a:superior
		return a:superior
	endif

	return a:value
endfunction

function DecToHex(decimal)
	return printf('%x', a:decimal .. '')
endfunction

function HexToDec(hexadecimal)
	return str2nr(a:hexadecimal, 16) + 0
endfunction

function ChangeBrightness(color, increase)
	let l:red   = HexToDec(a:color[1:2]) + a:increase
	let l:green = HexToDec(a:color[3:4]) + a:increase
	let l:blue  = HexToDec(a:color[5:6]) + a:increase
		
	let l:red   = DecToHex(LimitValue(l:red,   0, 255))
	let l:green = DecToHex(LimitValue(l:green, 0, 255))
	let l:blue  = DecToHex(LimitValue(l:blue,  0, 255))
	
	if len(l:red) == 1
		let l:red = '0' .. l:red
	endif

	if len(l:green) == 1
		let l:green ='0' .. l:green
	endif

	if len(l:blue) == 1
		let l:blue = '0' .. l:blue
	endif
		
	return '#' .. l:red .. l:green .. l:blue
endfunction

function SetColors()
lua << EOF
colors = {
	bla = vim.g.colors[1],
	lim = vim.g.colors[2],
	yel = vim.g.colors[3],
	blu = vim.g.colors[4],
	fuc = vim.g.colors[5],
	aqu = vim.g.colors[6],
	whi = vim.g.colors[7],

	sil = vim.g.base[3],
	gra = vim.g.base[2],
}
EOF
endfunction

function SetTheme()
lua << EOF
scheme = {
	normal = {
		a = {bg = colors.lim, fg = colors.sil},
		b = {bg = colors.sil, fg = colors.lim},
		c = {bg = colors.gra, fg = colors.whi}
	},
	insert = {
		a = {bg = colors.yel, fg = colors.sil},
		b = {bg = colors.sil, fg = colors.yel},
		c = {bg = colors.gra, fg = colors.whi}
	},
	visual = {
		a = {bg = colors.blu, fg = colors.sil},
		b = {bg = colors.sil, fg = colors.blu},
		c = {bg = colors.gra, fg = colors.whi}
	},
	replace = {
		a =	{bg = colors.fuc, fg = colors.sil},
		b = {bg = colors.sil, fg = colors.fuc},
		c = {bg = colors.gra, fg = colors.whi}
	},
	command = {
		a =	{bg = colors.aqu, fg = colors.sil},
		b = {bg = colors.sil, fg = colors.aqu},
		c = {bg = colors.gra, fg = colors.whi}
	},
	inactive = {
		a = {bg = colors.whi, fg = colors.sil},
		b = {bg = colors.sil, fg = colors.whi},
		c = {bg = colors.gra, fg = colors.whi}
	}
}
EOF
endfunction

let g:namefile = ''

function SetFileName()
	let g:namefile = expand('%:t')

	if g:namefile == ''
		let g:namefile = 'empty'

		return
	endif

	let l:index = len(g:namefile) - 1

	while l:index >= 0
		if g:namefile[l:index] == '.'
			break
		endif

		let l:index = l:index - 1
	endwhile

	let g:namefile = g:namefile[: l:index - 1]
endfunction

augroup setnamefile
	autocmd!
	autocmd VimEnter,WinEnter,BufEnter,BufWinEnter * call SetFileName()
augroup end

function SetStatusLine()
lua << EOF
function nametheme()
	return vim.g.nametheme
end

function namebuffer()
	return vim.g.namefile
end

function inactive()
	return 'Inactive'
end
EOF

if g:nametheme[0:3] == 'Rose'
lua << EOF
require'lualine'.setup {
	options = {
		theme = 'auto',
		icons_enabled = false,
		component_separators = '•',
		section_separators = {left = '', right = ''},
		always_divide_middle = true
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branche', 'diff', namebuffer, 'filesize'},
		lualine_c = {'filetype'},
		lualine_x = {nametheme},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {'mode'},
		lualine_b = {namebuffer},
		lualine_c = {},
		lualine_x = {inactive},
		lualine_y = {'filetype'},
		lualine_z = {'location'}
	},
	tabline = {},
	extensions = {}
}
EOF
else
lua << EOF
require'lualine'.setup {
	options = {
		theme = scheme,
		icons_enabled = false,
		component_separators = '•',
		section_separators = {left = '', right = ''},
		always_divide_middle = true
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branche', 'diff', namebuffer, 'filesize'},
		lualine_c = {'filetype'},
		lualine_x = {nametheme},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {'mode'},
		lualine_b = {namebuffer},
		lualine_c = {},
		lualine_x = {inactive},
		lualine_y = {'filetype'},
		lualine_z = {'location'}
	},
	tabline = {},
	extensions = {}
}	
EOF
endif
endfunction

function StartifyLine()
lua << EOF
function welcome()
	return 'Welcome'
end
EOF

if g:nametheme[0:3] == 'Rose'
lua << EOF
require'lualine'.setup {
	options = {
		theme = 'auto',
		section_separators = {left = '', right = ''},
	},
	sections = {
		lualine_a = {welcome},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	inactive_sections = {
		lualine_a = {welcome},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	extensions = {}
}
EOF
else
lua << EOF
require'lualine'.setup {
	options = {
		theme = scheme,
		section_separators = {left = '', right = ''},
	},
	sections = {
		lualine_a = {welcome},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	inactive_sections = {
		lualine_a = {welcome},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	extensions = {}
}
EOF
endif
endfunction

function StatusLine()
	call UpdateColors()
	call SetColors()
	call SetTheme()

	if g:initstartup
		call StartifyLine()
	else
		call SetStatusLine()
	endif
endfunction
