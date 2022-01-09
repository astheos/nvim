--------------- General Mappings ---------------

require('interface')

--------------- Functions To Operations

function Out()
	local pos = {eval['line']('.'), eval['col']('.')}

	execute('stopinsert')

	call('cursor', pos)
end

function Copy(what, where)
	local pos = {eval['line']('.'), eval['col']('.')}

	if what == "'" or what == '"' then
		execute('normal! v')
		execute('normal! 2i' .. what:sub(1, 1))
		execute('normal! v')
	else
		execute('normal! v')
		execute('normal! a' .. what:sub(1, 1))
		execute('normal! v')
	end

	execute('normal! `<')
	local begin = {eval['line']('.'), eval['col']('.')}

	execute('normal! `>')
	local ends = {eval['line']('.'), eval['col']('.')}

	if (begin[1] <= pos[1]) and (pos[1] <= ends[1]) then
		if begin[1] ~= ends[1] then
			if where == "in" then
				execute([[normal! yi]] .. what:sub(1, 1))
			else
				execute([[normal! ya]] .. what:sub(1, 1))
			end
		else
			if (begin[2] ~= ends[2]) then
				if (begin[2] <= pos[2]) and (pos[2] <= ends[2]) then
					if where == "in" then
						execute([[normal! yi]] .. what:sub(1, 1))
					else
						execute([[normal! ya]] .. what:sub(1, 1))
					end
				end
			end
		end
	end

	call('cursor', pos)
end

function Cut(what, where)
	local pos = {eval['line']('.'), eval['col']('.')}

	if what == "'" or what == '"' then
		execute('normal! v')
		execute('normal! 2i' .. what:sub(1, 1))
		execute('normal! v')
	else
		execute('normal! v')
		execute('normal! a' .. what:sub(1, 1))
		execute('normal! v')
	end

	execute('normal! `<')
	local begin = {eval['line']('.'), eval['col']('.')}

	execute('normal! `>')
	local ends = {eval['line']('.'), eval['col']('.')}

	call('cursor', pos)

	if (begin[1] <= pos[1]) and (pos[1] <= ends[1]) then
		if begin[1] ~= ends[1] then
			if where == "in" then
				execute([[normal! di]] .. what:sub(1, 1))
			else
				execute([[normal! da]] .. what:sub(1, 1))
			end
		else
			if (begin[2] ~= ends[2]) then
				if (begin[2] <= pos[2]) and (pos[2] <= ends[2]) then
					if where == "in" then
						execute([[normal! di]] .. what:sub(1, 1))
					else
						execute([[normal! da]] .. what:sub(1, 1))
					end
				end
			end
		end
	end
end

function Delete(what, where)
	local pos = {eval['line']('.'), eval['col']('.')}

	if what == "'" or what == '"' then
		execute('normal! v')
		execute('normal! 2i' .. what:sub(1, 1))
		execute('normal! v')
	else
		execute('normal! v')
		execute('normal! a' .. what:sub(1, 1))
		execute('normal! v')
	end

	execute('normal! `<')
	local begin = {eval['line']('.'), eval['col']('.')}

	execute('normal! `>')
	local ends = {eval['line']('.'), eval['col']('.')}

	call('cursor', pos)

	if (begin[1] <= pos[1]) and (pos[1] <= ends[1]) then
		if begin[1] ~= ends[1] then
			if where == "in" then
				execute([[normal! "_di]] .. what:sub(1, 1))
			else
				execute([[normal! "_da]] .. what:sub(1, 1))
			end
		else
			if (begin[2] ~= ends[2]) then
				if (begin[2] <= pos[2]) and (pos[2] <= ends[2]) then
					if where == "in" then
						execute([[normal! "_di]] .. what:sub(1, 1))
					else
						execute([[normal! "_da]] .. what:sub(1, 1))
					end
				end
			end
		end
	end
end

function Put(what, where)
	if where == "word" then
		execute('normal! lbe')
		execute('normal! a ')
		execute('normal! r' .. what:sub(2, 2))
		execute('normal! b')
		execute('normal! i ')
		execute('normal! r' .. what:sub(1, 1))
	elseif where == "expr" then
		execute('normal! lBE')
		execute('normal! a ')
		execute('normal! r' .. what:sub(2, 2))
		execute('normal! B')
		execute('normal! i ')
		execute('normal! r' .. what:sub(1, 1))
	elseif where == "line" then
		execute('normal! $')
		execute('normal! a ')
		execute('normal! r' .. what:sub(2, 2))
		execute('normal! ^')
		execute('normal! i ')
		execute('normal! r' .. what:sub(1, 1))
	elseif where == "phag" then
		execute('normal! $')
		execute('normal! a ')
		execute('normal! r' .. what:sub(2, 2))
		execute('normal! 0')
		execute('normal! i ')
		execute('normal! r' .. what:sub(1, 1))
	end
end

function Take(what)
	local pos = {eval['line']('.'), eval['col']('.')}

	if what == "'" or what == '"' then
		execute('normal! v')
		execute('normal! 2i' .. what:sub(1, 1))
		execute('normal! v')
	else
		execute('normal! v')
		execute('normal! a' .. what:sub(1, 1))
		execute('normal! v')
	end

	execute('normal! `<')
	local begin = {eval['line']('.'), eval['col']('.')}

	execute('normal! `>')
	local ends = {eval['line']('.'), eval['col']('.')}

	if (begin[1] <= pos[1]) and (pos[1] <= ends[1]) then
		if begin[1] ~= ends[1] then
			call('cursor', ends)
			execute([[normal! v"_d]])

			call('cursor', begin)
			execute([[normal! v"_d]])

			call('cursor', {pos[1], pos[2] - 1})
		else
			if (begin[2] ~= ends[2]) then
				if (begin[2] <= pos[2]) and (pos[2] <= ends[2]) then
					call('cursor', ends)
					execute([[normal! v"_d]])

					call('cursor', begin)
					execute([[normal! v"_d]])

					call('cursor', {pos[1], pos[2] - 1})
				else
					call('cursor', pos)
				end
			else
				call('cursor', pos)
			end
		end
	else
		call('cursor', pos)
	end
end

function Substitute(this, that)
	local pos = {eval['line']('.'), eval['col']('.')}

	if this == "'" or this == '"' then
		execute('normal! v')
		execute('normal! 2i' .. this)
		execute('normal! v')
	else
		execute('normal! v')
		execute('normal! a' .. this)
		execute('normal! v')
	end


	execute('normal! `<')
	local begin = {eval['line']('.'), eval['col']('.')}

	execute('normal! `>')
	local ends = {eval['line']('.'), eval['col']('.')}

	if (begin[1] <= pos[1]) and (pos[1] <= ends[1]) then
		if begin[1] ~= ends[1] then
			call('cursor', begin)
			execute('normal! r' .. that:sub(1, 1))

			call('cursor', ends)
			execute('normal! r' .. that:sub(2, 2))
		else
			if (begin[2] ~= ends[2]) then
				if (begin[2] <= pos[2]) and (pos[2] <= ends[2]) then
					call('cursor', begin)
					execute('normal! r' .. that:sub(1, 1))

					call('cursor', ends)
					execute('normal! r' .. that:sub(2, 2))
				end
			end
		end
	end

	call('cursor', pos)
end

function AddBlank(position)
	local pos

	if position == "left" then
		pos = {eval['line']('.'), eval['col']('.') + 1}

		execute('normal! i ')
	elseif position == "right" then
		pos = {eval['line']('.'), eval['col']('.')}

		execute('normal! a ')
	elseif position == "top" then
		pos = {eval['line']('.') + 1, eval['col']('.')}

		execute('normal! O')
		execute('normal dbl')
		execute('normal dfl')
	elseif position == "bottom" then
		pos = {eval['line']('.'), eval['col']('.')}

		execute('normal! o')
		execute('normal dbl')
		execute('normal dfl')
	end

	call('cursor', pos)
end

function MoveToBuffer(buffer)
	if buffer == 'previous' then
		execute('bprevious')
	elseif buffer == 'next' then
		execute('bnext')
	elseif buffer == 'first' then
		execute('bfirst')
	elseif buffer == 'last' then
		execute('blast')
	end
end

function SetResizeAmount(amount)
	nnoremap([[<silent>+]], [[:resize +]] .. amount .. [[<cr>]])
	nnoremap([[<silent>_]], [[:resize -]] .. amount .. [[<cr>]])
	nnoremap([[<silent>=]], [[:vertical :resize +]] .. amount .. [[<cr>]])
	nnoremap([[<silent>-]], [[:vertical :resize -]] .. amount .. [[<cr>]])
end

function Goto(where, how)
	if where == 'file' then
		local file = ''

		if get('filetype') == 'lua' then
			execute([[normal! y']])

			file = file .. eval['stdpath']('config') .. '/lua/'
			file = file .. eval['getreg']('"')
			file = file .. '.lua'

			if eval['filereadable'](file) == 1 then
				if how == 'current' then
					execute('edit ' .. file)
				elseif how == 'vertical' then
					execute('vsplit ' .. file)
				elseif how == 'horizontal' then
					execute('split ' .. file)
				end
			else
				if how == 'current' then
					execute('normal gfsc')
				elseif how == 'vertical' then
					execute('normal gfsv')
				elseif how == 'horizontal' then
					execute('normal gfsh')
				end
			end
		end
	end
end

---------- Normal Mode Maps

-- Go To

nnoremap([[<silent>gfsc]], [[gf]])
nnoremap([[<silent>gfsv]], [[<c-w>f]])
nnoremap([[<silent>gfsh]], [[<c-w><c-f>]])

nnoremap([[<silent>gfc]], [[:lua Goto("file", "current")   <cr>]])
nnoremap([[<silent>gfv]], [[:lua Goto("file", "vertical")  <cr>]])
nnoremap([[<silent>gfh]], [[:lua Goto("file", "horizontal")<cr>]])

-- Delete, Cut and Yank

nnoremap([[<silent>dw]], [["_diw]])
nnoremap([[<silent>de]], [["_diW]])
nnoremap([[<silent>dd]], [[V"_d]])
nnoremap([[<silent>dp]], [["_dap]])
nnoremap([[<silent>dfw]], [["_de]])
nnoremap([[<silent>dfe]], [["_dE]])
nnoremap([[<silent>dfl]], [["_d$]])
nnoremap([[<silent>dbw]], [["_db]])
nnoremap([[<silent>dbe]], [["_dB]])
nnoremap([[<silent>dbl]], [["_d0]])
-- Delete Surrounds
nnoremap([[<silent>d(]], [[:lua Delete("()", "in")<cr>]])
nnoremap([[<silent>d[]], [[:lua Delete("[]", "in")<cr>]])
nnoremap([[<silent>d{]], [[:lua Delete("{}", "in")<cr>]])
nnoremap([[<silent>d<]], [[:lua Delete("<>", "in")<cr>]])
nnoremap([[<silent>d"]], [[:lua Delete('""', "in")<cr>]])
nnoremap([[<silent>d']], [[:lua Delete("''", "in")<cr>]])
nnoremap([[<silent>D(]], [[:lua Delete("()", "on")<cr>]])
nnoremap([[<silent>D[]], [[:lua Delete("[]", "on")<cr>]])
nnoremap([[<silent>D{]], [[:lua Delete("{}", "on")<cr>]])
nnoremap([[<silent>D<]], [[:lua Delete("<>", "on")<cr>]])
nnoremap([[<silent>D"]], [[:lua Delete('""', "on")<cr>]])
nnoremap([[<silent>D']], [[:lua Delete("''", "on")<cr>]])

nnoremap([[<silent>cw]], [[diw]])
nnoremap([[<silent>ce]], [[diW]])
nnoremap([[<silent>cc]], [[VyVd]])
nnoremap([[<silent>cp]], [[dap]])
nnoremap([[<silent>cfw]], [[de]])
nnoremap([[<silent>cfe]], [[dE]])
nnoremap([[<silent>cfl]], [[d$]])
nnoremap([[<silent>cbw]], [[db]])
nnoremap([[<silent>cbe]], [[dB]])
nnoremap([[<silent>cbl]], [[d0]])
-- Cut Surrounds
nnoremap([[<silent>c(]], [[:lua Cut("()", "in")<cr>]])
nnoremap([[<silent>c[]], [[:lua Cut("[]", "in")<cr>]])
nnoremap([[<silent>c{]], [[:lua Cut("{}", "in")<cr>]])
nnoremap([[<silent>c<]], [[:lua Cut("<>", "in")<cr>]])
nnoremap([[<silent>c"]], [[:lua Cut('""', "in")<cr>]])
nnoremap([[<silent>c']], [[:lua Cut("''", "in")<cr>]])
nnoremap([[<silent>C(]], [[:lua Cut("()", "on")<cr>]])
nnoremap([[<silent>C[]], [[:lua Cut("[]", "on")<cr>]])
nnoremap([[<silent>C{]], [[:lua Cut("{}", "on")<cr>]])
nnoremap([[<silent>C<]], [[:lua Cut("<>", "on")<cr>]])
nnoremap([[<silent>C"]], [[:lua Cut('""', "on")<cr>]])
nnoremap([[<silent>C']], [[:lua Cut("''", "on")<cr>]])

nnoremap([[<silent>yw]], [[mayiw`a]])
nnoremap([[<silent>ye]], [[mayiW`a]])
nnoremap([[<silent>yy]], [[maVy`a]])
nnoremap([[<silent>yp]], [[mayap`a]])
nnoremap([[<silent>yfw]], [[maye`a]])
nnoremap([[<silent>yfe]], [[mayE`a]])
nnoremap([[<silent>yfl]], [[may$`a]])
nnoremap([[<silent>ybw]], [[mayb`a]])
nnoremap([[<silent>ybe]], [[mayB`a]])
nnoremap([[<silent>ybl]], [[may0`a]])
-- Copy Surrounds
nnoremap([[<silent>y(]], [[:lua Copy("()", "in")<cr>]])
nnoremap([[<silent>y[]], [[:lua Copy("[]", "in")<cr>]])
nnoremap([[<silent>y{]], [[:lua Copy("{}", "in")<cr>]])
nnoremap([[<silent>y<]], [[:lua Copy("<>", "in")<cr>]])
nnoremap([[<silent>y"]], [[:lua Copy('""', "in")<cr>]])
nnoremap([[<silent>y']], [[:lua Copy("''", "in")<cr>]])
nnoremap([[<silent>Y(]], [[:lua Copy("()", "on")<cr>]])
nnoremap([[<silent>Y[]], [[:lua Copy("[]", "on")<cr>]])
nnoremap([[<silent>Y{]], [[:lua Copy("{}", "on")<cr>]])
nnoremap([[<silent>Y<]], [[:lua Copy("<>", "on")<cr>]])
nnoremap([[<silent>Y"]], [[:lua Copy('""', "on")<cr>]])
nnoremap([[<silent>Y']], [[:lua Copy("''", "on")<cr>]])

--  Put/Take

nnoremap([[<silent>tw(]], [[:lua Put("()", "word")<cr>]])
nnoremap([[<silent>tw[]], [[:lua Put("[]", "word")<cr>]])
nnoremap([[<silent>tw{]], [[:lua Put("{}", "word")<cr>]])
nnoremap([[<silent>tw<]], [[:lua Put("<>", "word")<cr>]])
nnoremap([[<silent>tw"]], [[:lua Put('""', "word")<cr>]])
nnoremap([[<silent>tw']], [[:lua Put("''", "word")<cr>]])

nnoremap([[<silent>te(]], [[:lua Put("()", "expr")<cr>]])
nnoremap([[<silent>te[]], [[:lua Put("[]", "expr")<cr>]])
nnoremap([[<silent>te{]], [[:lua Put("{}", "expr")<cr>]])
nnoremap([[<silent>te<]], [[:lua Put("<>", "expr")<cr>]])
nnoremap([[<silent>te"]], [[:lua Put('""', "expr")<cr>]])
nnoremap([[<silent>te']], [[:lua Put("''", "expr")<cr>]])

nnoremap([[<silent>tl(]], [[:lua Put("()", "line")<cr>]])
nnoremap([[<silent>tl[]], [[:lua Put("[]", "line")<cr>]])
nnoremap([[<silent>tl{]], [[:lua Put("{}", "line")<cr>]])
nnoremap([[<silent>tl<]], [[:lua Put("<>", "line")<cr>]])
nnoremap([[<silent>tl"]], [[:lua Put('""', "line")<cr>]])
nnoremap([[<silent>tl']], [[:lua Put("''", "line")<cr>]])

nnoremap([[<silent>tp(]], [[:lua Put("()", "phag")<cr>]])
nnoremap([[<silent>tp[]], [[:lua Put("[]", "phag")<cr>]])
nnoremap([[<silent>tp{]], [[:lua Put("{}", "phag")<cr>]])
nnoremap([[<silent>tp<]], [[:lua Put("<>", "phag")<cr>]])
nnoremap([[<silent>tp"]], [[:lua Put('""', "phag")<cr>]])
nnoremap([[<silent>tp']], [[:lua Put("''", "phag")<cr>]])

nnoremap([[<silent>t(]], [[:lua Take("(")<cr>]])
nnoremap([[<silent>t[]], [[:lua Take("[")<cr>]])
nnoremap([[<silent>t{]], [[:lua Take("{")<cr>]])
nnoremap([[<silent>t<]], [[:lua Take("<")<cr>]])
nnoremap([[<silent>t"]], [[:lua Take('"')<cr>]])
nnoremap([[<silent>t']], [[:lua Take("'")<cr>]])

-- Substitute

-- Subs "
nnoremap([[<silent>s([]], [[:lua Substitute("(", "[]")<cr>]])
nnoremap([[<silent>s({]], [[:lua Substitute("(", "{}")<cr>]])
nnoremap([[<silent>s(<]], [[:lua Substitute("(", "<>")<cr>]])
nnoremap([[<silent>s(']], [[:lua Substitute("(", "\'\'")<cr>]])
nnoremap([[<silent>s("]], [[:lua Substitute("(", "\"\"")<cr>]])

-- Subs "
nnoremap([[<silent>s[(]], [[:lua Substitute("[", "()")<cr>]])
nnoremap([[<silent>s[{]], [[:lua Substitute("[", "{}")<cr>]])
nnoremap([[<silent>s[<]], [[:lua Substitute("[", "<>")<cr>]])
nnoremap([[<silent>s[']], [[:lua Substitute("[", "\'\'")<cr>]])
nnoremap([[<silent>s["]], [[:lua Substitute("[", "\"\"")<cr>]])

-- Subs "
nnoremap([[<silent>s{(]], [[:lua Substitute("{", "()")<cr>]])
nnoremap([[<silent>s{[]], [[:lua Substitute("{", "[]")<cr>]])
nnoremap([[<silent>s{<]], [[:lua Substitute("{", "<>")<cr>]])
nnoremap([[<silent>s{']], [[:lua Substitute("{", "\'\'")<cr>]])
nnoremap([[<silent>s{"]], [[:lua Substitute("{", "\"\"")<cr>]])

-- Subs <
nnoremap([[<silent>s<(]], [[:lua Substitute("<", "()")<cr>]])
nnoremap([[<silent>s<[]], [[:lua Substitute("<", "[]")<cr>]])
nnoremap([[<silent>s<{]], [[:lua Substitute("<", "{}")<cr>]])
nnoremap([[<silent>s<']], [[:lua Substitute("<", "\'\'")<cr>]])
nnoremap([[<silent>s<"]], [[:lua Substitute("<", "\"\"")<cr>]])

-- Subs '
nnoremap([[<silent>s'(]], [[:lua Substitute("\'", "()")<cr>]])
nnoremap([[<silent>s'[]], [[:lua Substitute("\'", "[]")<cr>]])
nnoremap([[<silent>s'{]], [[:lua Substitute("\'", "{}")<cr>]])
nnoremap([[<silent>s'<]], [[:lua Substitute("\'", "<>")<cr>]])
nnoremap([[<silent>s'"]], [[:lua Substitute("\'", "\"\"")<cr>]])

-- Subs "
nnoremap([[<silent>s"(]], [[:lua Substitute("\"", "()")<cr>]])
nnoremap([[<silent>s"[]], [[:lua Substitute("\"", "[]")<cr>]])
nnoremap([[<silent>s"{]], [[:lua Substitute("\"", "{}")<cr>]])
nnoremap([[<silent>s"<]], [[:lua Substitute("\"", "<>")<cr>]])
nnoremap([[<silent>s"']], [[:lua Substitute("\"", "\'\'")<cr>]])

-- Indent

nnoremap([[>p]], [[>ip]])
nnoremap([[<p]], [[<ip]])

-- Add Blanks

nnoremap([[<silent><space>h]], [[:lua AddBlank("left")  <cr>]])
nnoremap([[<silent><space>l]], [[:lua AddBlank("right") <cr>]])
nnoremap([[<silent><space>k]], [[:lua AddBlank("top")   <cr>]])
nnoremap([[<silent><space>j]], [[:lua AddBlank("bottom")<cr>]])

-- Window

nnoremap([[<a-h>]], [[<c-w>h]])
nnoremap([[<a-j>]], [[<c-w>j]])
nnoremap([[<a-k>]], [[<c-w>k]])
nnoremap([[<a-l>]], [[<c-w>l]])

nnoremap([[<silent>=]], [[:vertical :resize +1<cr>]])
nnoremap([[<silent>-]], [[:vertical :resize -1<cr>]])
nnoremap([[<silent>+]], [[:resize +1<cr>]])
nnoremap([[<silent>_]], [[:resize -1<cr>]])

-- Change Buffer

nnoremap([[<silent><a-p>]], [[:lua MoveToBuffer("previous")<cr>]])
nnoremap([[<silent><a-n>]], [[:lua MoveToBuffer("next")    <cr>]])
nnoremap([[<silent><a-f>]], [[:lua MoveToBuffer("first")   <cr>]])
nnoremap([[<silent><a-s>]], [[:lua MoveToBuffer("last")    <cr>]])

nnoremap([[<silent><c-b>d]], [[:lua ManipulateBuffer("delete")<cr>]])
nnoremap([[<silent><c-b>w]], [[:lua ManipulateBuffer("write") <cr>]])
nnoremap([[<silent><c-b>r]], [[:lua ManipulateBuffer("rename")<cr>]])

---------- Insert Mode Maps

inoremap([[<a-h>]], [[<Left>]])
inoremap([[<a-j>]], [[<Down>]])
inoremap([[<a-k>]], [[<Up>]])
inoremap([[<a-l>]], [[<Right>]])

---------- Command Mode Maps

cnoremap([[<a-h>]], [[<Left>]])
cnoremap([[<a-j>]], [[<Down>]])
cnoremap([[<a-k>]], [[<Up>]])
cnoremap([[<a-l>]], [[<Right>]])

---------- Visual Mode Maps

vnoremap([[d]], [["_d]])
vnoremap([[c]], [[d]])
