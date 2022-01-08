-------------- Highlight Number and Line Cursor --------------

require('interface')
require('general')

require('tools/colors')

function UpdateCursorColors()
	local color = eval['synIDattr'](eval['hlID']('Normal'), 'bg')

	local signal

	if theme[2] == 'light' then
		signal = -1
	elseif theme[2] == 'dark' then
		signal = 1
	end

	color = ChangeBrightness(color, signal * 20)

	highlight('CursorLine', {bg = color})
	highlight('CursorLineNr', {fg = colors[16]})

	execute('highlight! link Visual CursorLine')

	execute('redraw')
end
