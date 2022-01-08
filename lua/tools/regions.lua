-------------- Syntax To File Regions --------------

require('interface')

function EnableSyntaxRegion(filetype, begin, ends, highlight)
	local file = eval['toupper'](filetype)

	local group = 'textGroup' .. file

	if eval['exists']('b:current_syntax') == 1 then
		execute([[
			let s:current_syntax = b:current_syntax

			unlet b:current_syntax
		]])
	end

	execute('syntax include @' .. group .. ' syntax/' .. filetype .. '.vim')

	execute([[
		try
			syntax include @]] .. group .. [[ after/syntax/]] .. filetype .. [[.vim
		catch
		endtry
	]])

	if eval['exists']('s:current_syntax') == 1 then
		execute('let s:current_syntax = b:current_syntax')
	else
		execute('unlet b:current_syntax')
	end

	local syntax = ''

	syntax = syntax .. 'syntax region textSnip' .. file .. ' '
	syntax = syntax .. 'matchgroup=' .. highlight .. ' '
	syntax = syntax .. 'keepend start="' .. begin .. '" end="' .. ends .. '" '
	syntax = syntax .. 'contains=@' .. group

	execute(syntax)
end
