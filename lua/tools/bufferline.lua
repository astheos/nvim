-------------- Buffer Line ---------------

require('interface')
require('general')

require('tools/icons')

local begin = 1
local ends = 100

local truncated = false

function MoveBufferLine(sense)
	if sense then
		if (begin + 1 <= ends) and truncated then
			begin = begin + 1
		end
	else
		if begin > 1 then
			begin = begin - 1
		end
	end

	print(vim.inspect({begin, ends, truncated}))

	execute('set tabline=%!v:lua.BufferLine()')
end

function ExtractName(path)
	local index = #path
	local split = 0

	while (index >= 1) do
		if path:sub(index, index) == '/' then
			split = index + 1

			break
		end

		index = index - 1
	end

	local name = path:sub(split)

	if name == '' then
		return 'empty'
	end

	return name
end

function ExtractIcon(path)
	local index = #path
	local split = 0

	while (index >= 1) do
		if path:sub(index, index) == '.' then
			split = index + 1

			break
		end

		index = index - 1
	end

	return GetFileIcon(path:sub(split))
end

function ListedBuffers()
	local buffers = {}
	local numbers = {}
	local icons   = {}
	local current = 1

	for buffer = 1, eval['bufnr']('$') do
		if eval['buflisted'](buffer) == 1 then
			table.insert(numbers, tostring(buffer))

			table.insert(buffers, ExtractName(eval['bufname'](buffer)))
			table.insert(icons,   ExtractIcon(eval['bufname'](buffer)))

			if buffer == eval['bufnr']() then
				current = #buffers
			end
		end
	end

	return {numbers, buffers, icons, current}
end

function BufferLineColor()
	local theme = varglobal('colors_name')

	if theme == 'gruvbox' then
		return "White"
	elseif theme == 'sonokai' then
		return "Red"
	elseif theme == 'nord' then
		return "Cyan"
	elseif theme == 'rose-pine' then
		return "Cyan"
	end
end

function RestComponent(_length)
	local sep   = '%#LineSep#'
	local sup   = '%#LineSup#'
	local other = '%#LineOther#'

	local length = 0

	local rest = ''

	if style[1] == 'blank' then
		rest = rest .. ''
	elseif style[1] == 'round' then
		rest = rest .. ' ' .. separator[2]

		length = length + 2
	else
		rest = rest .. sup .. separator[1]

		length = length + 1
	end

	rest = rest .. other .. ' ... '

	length = length + 5

	if style[1] == 'blank' then
		rest = rest .. sep ..  ' '
	else
		rest = rest .. sep .. separator[1]
	end

	length = length + 1

	_length[1] = _length[1] + length

	return rest
end

function HeadComponent(listed, color, _length)
	local lead = '%#LineLead' .. color .. '#'
	local base = '%#LineBase' .. color .. '#'

	local sep   = '%#LineSep#'
	local other = '%#LineOther#'

	local numbers = listed[1]
	local buffers = listed[2]
	local icons   = listed[3]
	local current = listed[4]

	local length = 0

	local head = ''
	local file = ''

	local title = ' Buffers '

	head = lead .. title .. base .. separator[1]

	length = #title + 1

	if #numbers ~= 0 then
		file = file .. other .. ' ' .. numbers[current]

		length = length + #numbers[current] + 1
	end

	if #buffers ~= 0 then
		file = file .. base .. ' ' .. buffers[current] .. ' '

		length = length + #buffers[current] + 2
	else
		local name

		if get('filetype') == 'TelescopePrompt' then
			name = ' telescope '
		elseif get('filetype') == 'NvimTree' then
			name = ' tree '
		elseif get('filetype') == 'help' then
			name = ' help '
		else
			name = ' [empty] '
		end

		file = file .. base .. name

		length = length + #name
	end

	if (#icons ~= 0) and (icons[current] ~= '') then
		file = file .. other .. icons[current] .. ' '

		length = length + 2
	end

	file = file .. other

	if style[1] == 'blank' then
		file = file .. sep .. ' '
	else
		file = file .. sep .. separator[1]
	end

	length = length + 1

	_length[1] = _length[1] + length

	return head .. file
end

function BodyComponent(listed, limit, _length)
	local sep   = '%#LineSep#'
	local sup   = '%#LineSup#'
	local other = '%#LineOther#'

	local numbers = listed[1]
	local buffers = listed[2]
	local icons   = listed[3]
	local current = listed[4]

	local length = 0

	local rest = RestComponent(_length)

	local body = ''
	local file = ''

	ends = #buffers

	if begin ~= 1 then
		rest = RestComponent(_length)

		body = body .. rest
	end

	for index = begin, ends do
		file = ''
		length = 0

		if index ~= current then
			if style[1] == 'blank' then
				file = file .. ''
			elseif style[1] == 'round' then
				file = file .. ' ' .. separator[2]

				length = length + 2
			else
				file = file .. sup .. separator[1]

				length = length + 1
			end

			file = file .. other .. ' ' .. numbers[index] .. ' '

			length = length + #numbers[current] + 2

			file = file .. buffers[index] .. ' '

			length = length + #buffers[index] + 1

			if icons[index] ~= '' then
				file = file .. icons[index] .. ' '

				length = length + 2
			end

			if style[1] == 'blank' then
				file = file .. sep .. ' '
			else
				file = file .. sep .. separator[1]
			end

			length = length + 1

			file = file .. sep

			_length[1] = _length[1] + length

			if _length[1] >= limit then
				body = body .. rest

				truncated = true

				break
			end

			truncated = false

			body = body .. file
		end
	end

	return body
end

function BufferLine()
	local color  = BufferLineColor()
	local listed = ListedBuffers()

	local length = {0}

	local limit  = get("columns")

	local head = HeadComponent(listed, color, length)
	local body = BodyComponent(listed, limit, length)

	return head .. body
end

nnoremap('<silent><a-.>', ':lua MoveBufferLine(true)<cr>')
nnoremap('<silent><a-,>', ':lua MoveBufferLine(false)<cr>')

set('showtabline', 2)

execute('set tabline=%!v:lua.BufferLine()')
