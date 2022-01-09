-------------- Status Bar --------------

require('interface')
require('general')

require('tools/icons')

local active = true

function GetMode()
	local mode = eval['mode']()

	if mode == 'n' then
		mode = 'Normal'
	elseif mode == 'v' then
		mode = 'Visual'
	elseif mode == 'V' then
		mode = 'Visual'
	elseif mode == 'CTRL-V' then
		mode = 'Visual'
	elseif mode == 'i' then
		mode = 'Insert'
	elseif mode == 'r' then
		mode = 'Replace'
	elseif mode == 'R' then
		mode = 'Replace'
	elseif mode == 'c' then
		mode = 'Command'
	elseif mode == 't' then
		mode = 'Terminal'
	end

	return mode
end

function GetFileChanged() --    ○ ●
	local changed = ''

	if getoption('modified') then
		changed = "○" --"%#LineOther#○"
	else
		changed = "●" --"%#LineOther#●"
	end

	return changed
end

function GetFileName()
	local name = eval['expand']('%:t:r')

	if name == '' then
		return 'empty'
	end

	return name
end

function GetFileExtension()
	local extension = eval['expand']('%:e')

	if extension == '' then
		return 'null'
	end

	return extension
end

function GetFileProgress()
	local line  = eval['line']('.')
	local lines = eval['line']('$')

	return ' ' .. math.floor(100 * line / lines) .. '%%'

	--return '%p%%'
end

function GetCursorPosition()
	local lines   = eval['line']('.')
	local columns = eval['col']('.')

	return ' ' .. lines .. ':' .. columns

	--return '%l:%c'
end

function GetStatusLineColor(mode)
	local color = colors[0]

	local theme = varglobal('colors_name')

	if theme == nil then
		return "White"
	end

	if theme:sub(1, 4) == 'rose' then
		if mode == 'Normal' then
			return 'Cyan'
		elseif mode == 'Insert' then
			return 'Yellow'
		elseif mode == 'Visual' then
			return 'Green'
		elseif mode == 'Replace' then
			return 'Red'
		elseif mode == 'Command' then
			return 'Blue'
		elseif mode == 'Terminal' then
			return 'Cyan'
		end
	else
		if mode == 'Normal' then
			return 'Green'
		elseif mode == 'Insert' then
			return 'Yellow'
		elseif mode == 'Visual' then
			return 'Blue'
		elseif mode == 'Replace' then
			return 'Magenta'
		elseif mode == 'Command' then
			return 'Cyan'
		elseif mode == 'Terminal' then
			return 'Cyan'
		end
	end

	return color
end

-------------- Inactive Status Line

function InactiveStatusLine()
	local mode = 'Inactive'
	local name = GetFileName()
	local extension = GetFileExtension()
	local changed = GetFileChanged()

	local icon = GetFileIcon(extension)
	local file = GetFileType(extension)

	if icon == '' then
		icon = '●'
	end

	local len = eval['winwidth'](0)

	if len < (24 + #name + #file) then
		mode = mode:sub(1, 1)
	end

	local left = ''
	local right = ''

	left = left .. '%#LineLeadWhite# ' .. mode .. ' '
	left = left .. '%#LineBaseWhite#' .. separator[1]
	left = left .. ' ' .. name
	left = left .. ' ' .. changed
	left = left .. ' %#LineSep#' .. separator[1]
	left = left .. ' %#LineRest#'

	right = right .. '%#LineSep#' .. separator[2]
	right = right .. '%#LineBaseWhite#' ..  ' ' .. icon
	right = right .. ' ' .. separator[2]
	right = right .. '%#LineLeadWhite# ' .. file .. ' '

	return left .. '%=' .. right
end

-------------- Active Status Line

function ActiveStatusLine()
	local mode = GetMode()
	local name = GetFileName()
	local extension = GetFileExtension()
	local changed = GetFileChanged()
	local progress = GetFileProgress()
	local position = GetCursorPosition()

	local icon = GetFileIcon(extension)
	local color = GetStatusLineColor(mode)

	local limit  = eval['winwidth'](0)
	local length = 18

	length = length + #mode
	length = length + #name
	length = length + #extension
	length = length + #progress
	length = length + #position

	if limit < length then
		length = length - #mode + 1

		mode = mode:sub(1, 1)
	end

	if limit < length then
		progress = ''
	end

	local left = ''
	local right = ''

	left = left .. '%#LineLead' .. color .. '# ' .. mode .. ' '
	left = left .. '%#LineBase' .. color .. '#' .. separator[1]
	left = left .. ' ' .. name
	left = left .. ' ' .. changed
	left = left .. ' %#LineSep#' .. separator[1]
	left = left .. ' %#LineRest#' .. extension .. ' ' .. icon

	right = right .. '%#LineSep#' .. separator[2]
	right = right .. '%#LineBase' .. color .. '#' .. progress
	right = right .. ' ' .. separator[2]
	right = right .. '%#LineLead' .. color .. '#' .. position .. ' '

	return left .. '%=' .. right
end

function StatusLine(mode)
	if not ignore{'Startup', 'Search', 'NvimTree', 'Terminal'} then
		if mode == 'active' then
			execute([[setlocal statusline=%!v:lua.ActiveStatusLine()]])
		elseif mode == 'inactive' then
			eval['setbufvar'](eval['bufnr'](), '&statusline', InactiveStatusLine())
		end
	end
end

augroup('SetStatusLine')
	autocmd()
	autocmd('WinEnter,BufEnter', '*', [[lua StatusLine('active')]])
	autocmd('WinLeave,BufLeave', '*', [[lua StatusLine('inactive')]])
augroup('end')
