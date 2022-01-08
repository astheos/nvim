-------------- Ident Guides --------------

require('interface')
require('general')

require('tools/colors')

local files = {'help', 'Startup', 'Buffers', 'NvimTree', 'TelescopePrompt'}

function ToggleIndent(active)
	if active then
		if not ignore(files) then
			execute(':IndentBlanklineEnable')
		end
	else
		execute(':IndentBlanklineDisable')
	end
end

function UpdateIndentColors()
	local ground = eval['synIDattr'](eval['hlID']('Normal'), 'bg')

	local signal

	if theme[2] == 'light' then
		signal = -1
	elseif theme[2] == 'dark' then
		signal = 1
	end

	local actual = ChangeBrightness(ground, signal * 40)
	local others = ChangeBrightness(ground, signal * 10)

	highlight('IndentBlanklineChar', {bg = ground, fg = others})
	highlight('IndentBlanklineContextChar', {bg = ground, fg = actual})
end

require('indent_blankline').setup({
	show_current_context = true,
	context_patterns = {'class', 'function', 'method', 'statement', 'declaration', 'expression', 'block', 'if', 'for', 'while'},
	filetype_exclude = {'help', 'Startup', 'Buffers', 'NvimTree', 'TelescopePrompt'},
})

augroup('ToggleIndentBlankline')
	autocmd()
	autocmd('BufEnter,WinEnter', '*', 'lua ToggleIndent(true)')
	autocmd('BufLeave,WinLeave', '*', 'lua ToggleIndent(false)')
augroup('end')
