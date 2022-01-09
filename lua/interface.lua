--------------- Aplication Interface To Lua ---------------

--------------- Basic Functions

eval    = vim.fn
call    = vim.call
execute = vim.cmd

--------------- Variable Functions

function var(name)
	return vim.v[name]
end

function varglobal(name, value)
	if value == nil then
		return vim.g[name]
	else
		vim.g[name] = value
	end
end

function varbuffer(name, value)
	if value == nil then
		return vim.bo[name]
	else
		vim.bo[name] = value
	end
end

function varwindow(name, value)
	if value == nil then
		return vim.wo[name]
	else
		vim.wo[name] = value
	end
end

--------------- Set Option Functions

function set(option, value)
	vim.opt[option] = value
end

function setoption(option, value)
	vim.o[option] = value
end

function setbuffer(option, value)
	vim.bo[option] = value
end

function setwindow(option, value)
	vim.wo[option] = value
end

function setglobal(option, value)
	vim.go[option] = value
end

function get(option)
	return vim.opt[option]._value
end

function getoption(option)
	return vim.o[option]
end

function getbuffer(option)
	return vim.bo[option]
end

function getwindow(option)
	return vim.wo[option]
end

function getglobal(option)
	return vim.go[option]
end

--------------- Mapping Functions

function nmap(keybinding, command)
	execute([[nmap ]] .. keybinding .. [[ ]] .. command)
end

function imap(keybinding, command)
	execute([[imap ]] .. keybinding .. [[ ]] .. command)
end

function vmap(keybinding, command)
	execute([[vmap ]] .. keybinding .. [[ ]] .. command)
end

function cmap(keybinding, command)
	execute([[cmap ]] .. keybinding .. [[ ]] .. command)
end

function tmap(keybinding, command)
	execute([[tmap ]] .. keybinding .. [[ ]] .. command)
end

function nnoremap(keybinding, command)
	execute([[nnoremap ]] .. keybinding .. [[ ]] .. command)
end

function inoremap(keybinding, command)
	execute([[inoremap ]] .. keybinding .. [[ ]] .. command)
end

function vnoremap(keybinding, command)
	execute([[vnoremap ]] .. keybinding .. [[ ]] .. command)
end

function cnoremap(keybinding, command)
	execute([[cnoremap ]] .. keybinding .. [[ ]] .. command)
end

function tnoremap(keybinding, command)
	execute([[tnoremap ]] .. keybinding .. [[ ]] .. command)
end

function nunmap(keybinding)
	execute([[nunmap ]] .. keybinding)
end

function iunmap(keybinding)
	execute([[iunmap ]] .. keybinding)
end

function vunmap(keybinding)
	execute([[vunmap ]] .. keybinding)
end

function cunmap(keybinding)
	execute([[cunmap ]] .. keybinding)
end

function tunmap(keybinding)
	execute([[tunmap ]] .. keybinding)
end

---------- Command Functions

function command(name, actions)
	execute('command! ' .. name .. ' ' .. actions)
end

---------- Autocommand Functions

function autocmd(event, pattern, command)
	if event == nil then
		execute('autocmd! ')
	else
		execute('autocmd ' .. event .. ' ' .. pattern .. ' ' .. command)
	end
end

function augroup(name)
	execute('augroup ' .. name)
end

---------- Highlight Functions

function highlight(name, colors)
	if colors.bg == nil then
		execute('highlight ' .. name .. ' guifg=' .. colors.fg)
	elseif colors.fg == nil then
		execute('highlight ' .. name .. ' guibg=' .. colors.bg)
	else
		execute('highlight ' .. name .. ' guibg=' .. colors.bg .. ' guifg=' .. colors.fg)
	end
end

---------- Other Functions

function colorscheme(scheme)
	execute('colorscheme ' .. scheme)
end

function cabbrev(original, new)
	execute('cabbrev ' .. original .. ' ' .. new)
end
