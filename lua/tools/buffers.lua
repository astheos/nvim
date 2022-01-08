-------------- Buffers Info --------------

require('interface')
require('general')

require('tools/icons')

local buffers = {}
local others  = {}

local numlen = {0, 0}
local buflen = {0, 0}

local width = 0
local height = 0

local value = -1

--local current

local function Info(path)
	local index = #path

	local name = 1
	local icon = 1

	while (index >= 1) do
		if path:sub(index, index) == '/' then
			name = index + 1
		end
		if path:sub(index, index) == '.' then
			icon = index + 1
		end

		if (name ~= 1) and (icon ~= 1) then
			break
		end

		index = index - 1
	end

	name = path:sub(name)
	icon = GetFileIcon(path:sub(icon))

	return {name, icon, path}
end

local function UpdateBuffers()
	buffers = {}
	others  = {}

	local number
	local buffer
	local icon
	local path

	for number = 1, eval['bufnr']('$') do
		if eval['bufexists'](number) == 1 then
			local infos = Info(eval['bufname'](number))

			buffer = infos[1]
			icon   = infos[2]
			path   = infos[3]

			if eval['buflisted'](number) == 1 then
				table.insert(buffers, {tostring(number), icon, buffer, path})

				if #tostring(number) > numlen[1] then
					numlen[1] = #tostring(number)
				end
				if #buffer > buflen[1] then
					buflen[1] = #buffer
				end

				if number == eval['bufnr']() then
					buffers['current'] = number
				end
			else
				table.insert(others,  {tostring(number), icon, buffer, path})

				if #tostring(number) > numlen[2] then
					numlen[2] = #tostring(number)
				end
				if #buffer > buflen[2] then
					buflen[2] = #buffer
				end

				if number == eval['bufnr']() then
					others['current'] = number
				end
			end
		end
	end

	height = #buffers + #others + 4
end

local function FormatBuffers()
	local number
	local buffer
	local icon
	local path

	local margin
	local line

	local pos = {2, #buffers + 4}

	if #buffers ~= 0 then
		eval['setline'](pos[1] - 1, '')
		eval['setline'](pos[1], 'Buffers:')
	end

	for index, data in ipairs(buffers) do
		icon = data[2]

		if icon == '' then
			icon = '   '
		else
			icon = '  ' .. icon
		end

		margin = string.rep(' ', numlen[1] - #data[1])

		if data[1] == tostring(buffers['current']) then
			number = '  ' .. margin .. '[' .. data[1] .. ']'
		else
			number = '   ' .. margin .. '[' .. data[1] .. ']'
		end

		margin = string.rep(' ', buflen[1] - #data[3])

		if data[1] == tostring(buffers['current']) then
			buffer = '  ' .. '"' .. data[3] .. '"' .. margin
		else
			buffer = '  ' .. ''  .. data[3] .. '  ' .. margin
		end

		path = '  -- ' .. data[4]

		line = number .. icon .. buffer .. path

		if #line > width then
			width = #line + 1
		end

		eval['setline'](index + pos[1], line)
	end

	if #others ~= 0 then
		eval['setline'](pos[2] - 1, '')
		eval['setline'](pos[2], 'Others:')
	end

	local last

	for index, data in ipairs(others) do
		icon = data[2]

		if icon == '' then
			icon = '  '
		else
			icon = '  ' .. icon
		end

		margin = string.rep(' ', numlen[2] - #data[1])

		if data[1] == tostring(others['current']) then
			number = '  ' .. margin .. '[' .. data[1] .. ']'
		else
			number = '   ' .. margin .. '[' .. data[1] .. ']'
		end

		margin = string.rep(' ', buflen[2] - #data[3])

		if data[1] == tostring(others['current']) then
			buffer = '  ' .. '"' .. data[3] .. '"' .. margin
		else
			buffer = '  ' .. ''  .. data[3] .. '  '  .. margin
		end

		path = '  -- ' .. data[4]

		line = number .. icon .. buffer .. path

		if #line > width then
			width = #line + 1
		end

		eval['setline'](index + pos[2], line)

		last = index + pos[2]
	end

	eval['setline'](last, '')
end

local function CreateBuffers()
	local _width = eval['winwidth'](0)

	if getbuffer('modified') == 1 then
		--if getbuffer('buftype') == "" or getbuffer('readonly') == 0 or
		execute('silent write')
	end

	UpdateBuffers()

	execute('belowright split')
	execute('enew')
	execute('file Buffers')

	setbuffer('swapfile', false)
	setbuffer('buflisted', false)

	setwindow('list', false)
	setwindow('cursorline', false)
	setwindow('cursorcolumn', false)
	setwindow('number', false)
	setwindow('relativenumber', false)

	setbuffer('filetype', 'Buffers')
	setbuffer('syntax', 'lua')

	value = eval['bufnr']()

	FormatBuffers()

	setbuffer('modified', false)
	setbuffer('modifiable', false)

	execute('resize ' .. height)

	if _width < width then
		execute('vertical resize ' .. width)
	end
end

function ToggleBuffersScreen()
	if eval['bufexists'](value) == 1 then
		execute('bwipeout! ' .. value)
	else
		CreateBuffers()
	end
end

nnoremap('<silent><a-b>', ':lua ToggleBuffersScreen()<cr>')
