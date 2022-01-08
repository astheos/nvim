-------------- Shade Functions

require('interface')
require('general')

require('tools/colors')

function UpdateShadeColors()
	local color = eval['synIDattr'](eval['hlID']('Normal'), 'bg')

	local shade

	if theme[2] == 'light' then
		shade = 15
	elseif theme[2] == 'dark' then
		shade = 5
	end

	shade = ChangeBrightness(color, -shade)

	highlight('Normal',   {bg = color})
	highlight('NormalNC', {bg = shade})
end

function ToggleCursorLine(value)
	if value then
		if not ignore{'Startup', 'Terminal'} then
			setwindow('cursorline', true)
		end
	else
		setwindow('cursorline', false)
	end
end

augroup('CursorLine')
	autocmd()
	autocmd('BufEnter,WinEnter', '*', ':lua ToggleCursorLine(true)')
	autocmd('BufLeave,WinLeave', '*', ':lua ToggleCursorLine(false)')
augroup('end')
