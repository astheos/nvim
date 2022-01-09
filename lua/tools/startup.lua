-------------- Startup Screen --------------

require('interface')

-- Variables

local screen = {
	[[                                __                 ]],
 	[[   ___     ___    ___   __  __ /\_\    ___ ___     ]],
 	[[  / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\   ]],
 	[[ /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ]],
 	[[ \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ]],
 	[[  \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ]],
 	[[                                                   ]],
 	[[ Actions                                      Maps ]],
 	[[                                                   ]],
 	[[ [•]  New Archives                          <c-n> ]],
 	[[ [•]  Old Archives                          <c-o> ]],
 	[[                                                   ]],
 	[[ [•]  File Manager                          <c-f> ]],
 	[[                                                   ]],
 	[[ Files                                             ]],
 	[[                                                   ]],
 	[[ [•]  Settings                              <c-s> ]],
 	[[                                                   ]],
 	[[ Folders                                           ]],
 	[[                                                   ]],
 	[[ [•]  Projects                              <c-p> ]]
}

local width  = math.floor((eval['winwidth'](0)  - #screen[1])  / 2)
local height = math.floor((eval['winheight'](0) - #screen - 1) / 2)

local margin = string.rep(' ', width)

local pos = {{height + 10, width + 3},
			 {height + 11, width + 3},
			 {height + 13, width + 3},
			 {height + 17, width + 3},
			 {height + 21, width + 3}}

local cur = 1

function MoveCursor(sense)
	if sense then
		cur = cur + 1

		if cur > #pos then cur = 1 end
	else
		cur = cur - 1

		if cur < 1 then cur = #pos end
	end

	execute([[
		setlocal
		\	modifiable
		\	modified
	]])

	if cur == 4 then
		eval['setline'](pos[4][1], margin .. ' [•]  Settings ~/.config/nvim/init.lua      <c-s>')
	else
		eval['setline'](pos[4][1], margin .. ' [•]  Settings                              <c-s>')
	end

	if cur == 5 then
		eval['setline'](pos[5][1], margin .. ' [•]  Projects ~/projetos/programação       <c-p>')
	else
		eval['setline'](pos[5][1], margin .. ' [•]  Projects                              <c-p>')
	end

	execute([[
		setlocal
		\	nomodifiable
		\	nomodified
	]])

	eval['cursor'](pos[cur])
end

function PerformAction(action)
	if action == -1 then
		if cur == 1 then
			execute(':cd ~')
			execute(':Telescope file_browser')
		elseif cur == 2 then
			execute(':Telescope oldfiles')
		elseif cur == 3 then
			execute(':cd ~')
			execute(':Telescope find_files')
		elseif cur == 4 then
			execute(':bw')
			execute(':cd ~/.config/nvim')
			execute(':edit init.lua')
		elseif cur == 5 then
			execute(':cd ~/projetos/programação')
			execute(':Telescope find_files')
		end
	else
		if cur == 1 then
			execute(':cd ~')
			execute(':Telescope file_browser')
		elseif cur == 2 then
			execute(':Telescope oldfiles')
		elseif cur == 3 then
			execute(':cd ~')
			execute(':Telescope find_files')
		elseif cur == 4 then
			execute(':bw')
			execute(':cd ~/.config/nvim')
			execute(':edit init.lua')
		elseif cur == 5 then
			execute(':cd ~/projetos/programação')
			execute(':Telescope find_files')
		end
	end
end

function UpdateScreen()
	width  = math.floor((eval['winwidth'](0)  - #screen[1])  / 2)
	height = math.floor((eval['winheight'](0) - #screen - 1) / 2)

	margin = string.rep(' ', width)

	pos = {{height + 10, width + 3},
		   {height + 11, width + 3},
		   {height + 13, width + 3},
		   {height + 17, width + 3},
		   {height + 21, width + 3}}

	ShowScreen()

	eval['cursor']({1, 1})

	execute('redraw')

	eval['cursor'](pos[cur])
end

function ShowScreen()
	local lines = eval['winheight'](0)

	execute([[
		setlocal
		\	modifiable
		\	modified
	]])

	for line = 1, lines do
		if (line > height) and (line <= #screen + height) then
			eval['setline'](line, margin .. screen[line - height])
		else
			eval['setline'](line, '')
		end
	end

	execute([[
		setlocal
		\	nomodifiable
		\	nomodified
	]])
end

function Start()
	if eval['argc']() ~= 0 or get('insertmode') then
		execute('lua InitTheme()')

		return
	end

	execute('enew')

	execute('file Startup')

	execute([[
		setlocal
		\	nobuflisted
		\	nocursorline
		\	nocursorcolumn
		\	nonumber
		\	norelativenumber
		\	nolist
		\	noswapfile

		setlocal filetype=Startup
	]])

	--setlocal statusline=%!StartupStatusLine()

	set('showtabline', 0)

	execute('syntax enable')

	setbuffer('syntax', 'startup')

	UpdateScreen()

	execute([[
		setlocal
		\	nomodifiable
		\	nomodified
	]])

	execute('lua InitTheme()')

	nnoremap('<buffer><silent> <Left>',  ':lua MoveCursor(false) <CR>')
	nnoremap('<buffer><silent> <Right>', ':lua MoveCursor(true)  <CR>')
	nnoremap('<buffer><silent> <Up>',    ':lua MoveCursor(false) <CR>')
	nnoremap('<buffer><silent> <Down>',  ':lua MoveCursor(true)  <CR>')

	nnoremap('<silent><buffer> h', ':lua MoveCursor(true)  <CR>')
	nnoremap('<silent><buffer> j', ':lua MoveCursor(true)  <CR>')
	nnoremap('<silent><buffer> k', ':lua MoveCursor(false) <CR>')
	nnoremap('<silent><buffer> l', ':lua MoveCursor(false) <CR>')

	nnoremap('<silent><buffer> <Enter>', ':lua PerformAction(-1) <CR>')

	nnoremap('<silent><buffer><c-n>', ':lua PerformAction(0) <CR>')
	nnoremap('<silent><buffer><c-o>', ':lua PerformAction(1) <CR>')
	nnoremap('<silent><buffer><c-f>', ':lua PerformAction(2) <CR>')
	nnoremap('<silent><buffer><c-s>', ':lua PerformAction(3) <CR>')
	nnoremap('<silent><buffer><c-p>', ':lua PerformAction(4) <CR>')
end

augroup('Startup')
	autocmd()
	autocmd('VimEnter', '*', 'lua Start()')
	autocmd('BufEnter', 'Startup', 'set showtabline=0')
	autocmd('BufLeave', 'Startup', 'set showtabline=2')

	autocmd('VimResized', 'Startup', 'lua UpdateScreen()')
augroup('end')
