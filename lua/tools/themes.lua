-------------- Theme Configuration --------------

require('interface')
require('general')

local path = eval['stdpath']('data') .. '/memory.txt'

local memory = io.lines(path)

local ground = memory(1)
local scheme = memory(2)
local variat = memory(3)

local function cap(str)
	return str:sub(1, 1):upper() .. str:sub(2)
end

function ColorScheme(_ground, _scheme, _variat)
	if _ground == 'dark' then
		set('background', 'dark')

		if _scheme == 'gruvbox' then
			varglobal('gruvbox_contrast_dark', _variat)

			colorscheme('gruvbox')
		elseif _scheme == 'sonokai' then
			varglobal('sonokai_style', 'andromeda')

			colorscheme('sonokai')
		elseif _scheme == 'nord' then
			varglobal('nord_borders', true)

			require('nord').set()
		elseif _scheme == 'rose' then
			varglobal('rose_pine_variant', _variat)

			colorscheme('rose-pine')
		end
	elseif _ground == 'light' then
		set('background', 'light')

		if _scheme == 'gruvbox' then
			varglobal('gruvbox_contrast_light', _variat)

			colorscheme('gruvbox')
		elseif _scheme == 'rose' then
			varglobal('rose_pine_variant', 'dawn')

			colorscheme('rose-pine')
		end
	end

	ground = _ground
	scheme = _scheme
	variat = _variat

	memory = io.open(path, 'r+')

	memory:write(ground, "\n")
	memory:write(scheme, "\n")
	memory:write(variat, "\n")

	memory:close(memory)

	theme = {_scheme, _ground}
end

function InitTheme()
	ColorScheme(ground, scheme, variat)

	execute(':lua UpdateColors()')
	execute(':lua UpdateHighlights()')
	execute(':lua UpdateCursorColors()')
	execute(':lua UpdateShadeColors()')
	execute(':lua UpdateWilderColors()')
	execute(':lua UpdateIndentColors()')
	execute(':lua UpdateFileExplorerColors()')
end

function ChangeTheme(_ground, _scheme, _variat)
	ColorScheme(_ground, _scheme, _variat)

	execute(':lua UpdateColors()')
	execute(':lua UpdateHighlights()')
	execute(':lua UpdateCursorColors()')
	execute(':lua UpdateShadeColors()')
	execute(':lua UpdateWilderColors()')
	execute(':lua UpdateIndentColors()')
	execute(':lua UpdateFileExplorerColors()')

	ShowScheme()
end

function ShowScheme()
	if variat == 'None' then
		print(cap(ground) .. ' Theme: ' .. cap(scheme))
	else
		print(cap(ground) .. ' Theme: ' .. cap(scheme) .. ' [' .. cap(variat) .. ']')
	end
end
