-------------- Terminal Configuration --------------

require('interface')
require('general')

local terminal = ''

function TerminalToggle()
	if terminal == '' then
		if getbuffer('modified') == 1 then
			--if getbuffer('buftype') == "" or getbuffer('readonly') == 0 or
			execute('silent write')
		end

		local height = math.floor(eval['winheight'](0) / 4)

		execute('belowright split')
		execute('resize ' .. height)
		execute('edit')
		execute('terminal')
		execute('start')

		setwindow('winfixheight', true)
		setwindow('cursorline', false)
		setwindow('number', false)
		setwindow('relativenumber', false)

		setbuffer('filetype', 'Terminal')

		execute([[
			setlocal statusline=%!v:lua.TerminalStatusLine()
		]])

		terminal = eval['bufname']()
	else
		execute('bwipeout! ' .. terminal)

		terminal = ''
	end
end

function TerminalStatusLine()
	local mode = 'mode'
	local name = 'Terminal'
	local icon = ''
	local shell = 'zsh'

	local left = ''
	local right = ''

	left = left .. '%#LineLeadCyan# ' .. name .. ' '
	left = left .. '%#LineBaseCyan#' .. separator[1]
	left = left .. ' ' .. mode ..  ' '
	left = left .. '%#LineSep#' .. separator[1]

	right = right .. '%#LineSep#' .. separator[2]
	right = right .. '%#LineBaseCyan#' .. ' ' .. icon .. ' '
	right = right .. '%#LineBaseCyan#' .. separator[2]
	right = right .. '%#LineLeadCyan#' .. ' ' .. shell .. ' '

	return left .. '%=' .. right
end

----- Terminal Maps

tnoremap('<Esc>', [[<C-\><C-n>]])

----- Map Keys

nnoremap('<silent> <space>t', ':lua TerminalToggle()<cr>')
