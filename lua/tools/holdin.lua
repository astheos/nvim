--------------- Hold Cursor Line on Middle Functions ---------------

require('interface')

function HoldCursor(sense)
	local line  = eval['winline']()
	local lines = eval['winheight'](0)

	local position = {eval['line']('.'), eval['col']('.')}

	if sense == "down" then
		if (line < (lines / 2)) or (eval['line']('w$') == eval['line']('$')) then
			execute('normal! j')
		else
			call('cursor', {eval['line']('w$'), position[2]})

			execute('normal! j')

			call('cursor', {position[1] + 1, position[2]})
		end
	elseif sense == "up" then
		if (line > (lines / 2)) or (eval['line']('w0') == 1) then
			execute('normal! k')
		else
			call('cursor', {eval['line']('w0'), position[2]})

			execute('normal! k')

			call('cursor', {position[1] - 1, position[2]})
		end
	end
end

local enable = false

function ToogleCursorHold()
	if enable then
		nunmap('j')
		nunmap('k')
	else
		nnoremap('<silent>j', [[:call HoldCursor("down") <cr>]])
		nnoremap('<silent>k', [[:call HoldCursor("up")   <cr>]])
	end

	enable = not enable
end
