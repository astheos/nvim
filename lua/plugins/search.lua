-------------- Search Box Configuration --------------

require('interface')
require('general')

require('tools/icons')

local mode
local name
local extension
local changed

local icon
local file

local function SetFileName()
	name = eval['expand']('%:t:r')

	if name == '' then
		name = 'empty'
	end
end

local function SetFileExtension()
	extension = eval['expand']('%:e')

	if extension == '' then
		extension = 'null'
	end
end

local function SetFileChanged()
	changed = ''

	if getoption('modified') then
		changed = "○" --"%#LineOther#○"
	else
		changed = "●" --"%#LineOther#●"
	end
end

function Search(sense, state)
	if state == 'normal' then
		if sense == '/' then
			sense = false
			state = false
		elseif sense == '?' then
			sense = true
			state = false
		end
	elseif state == 'visual' then
		if sense == '/' then
			sense = false
			state = true
		elseif sense == '?' then
			sense = true
			state = true
		end
	end

	mode = 'Search'

	SetFileName()
	SetFileExtension()
	SetFileChanged()

	icon = GetFileIcon(extension)
	file = GetFileType(extension)

	search = {eval['bufnr'](), SearchStatusLine()}

	require('searchbox').match_all({
		reverse = sense,
		exact = false,
		visual_mode = state,
		title = ' Search ',
		prompt = '  '
	})

	eval['setbufvar'](search[1], '&statusline', search[2])
end

function Replace(state)
	if state then
		state = false
	else
		state = true
	end

	mode = 'Replace'

	SetFileName()
	SetFileExtension()
	SetFileChanged()

	icon = GetFileIcon(extension)
	file = GetFileType(extension)

	search = {eval['bufnr'](), SearchStatusLine()}

	require('searchbox').replace({
		reverse = false,
		exact = false,
		visual_mode = state,
		confirm = 'native',
		title = ' Replace ',
		prompt = '  '
	})

	eval['setbufvar'](search[1], '&statusline', search[2])
end

function SearchStatusLine()
	if icon == '' then
		icon = '●'
	end

	local len = eval['winwidth'](0)

	if len < (24 + #name + #file) then
		mode = mode:sub(1, 1)
	end

	local left = ''
	local right = ''

	left = left .. '%#LineLeadMagenta# ' .. mode .. ' '
	left = left .. '%#LineBaseMagenta#' .. separator[1]
	left = left .. ' ' .. name
	left = left .. ' ' .. changed
	left = left .. ' %#LineSep#' .. separator[1]
	left = left .. ' %#LineRest#'

	right = right .. '%#LineSep#' .. separator[2]
	right = right .. '%#LineBaseMagenta#' ..  ' ' .. icon
	right = right .. ' ' .. separator[2]
	right = right .. '%#LineLeadMagenta# ' .. file .. ' '

	return left .. '%=' .. right
end

require('searchbox').setup({
	popup = {
		relative = 'win',
		position = {
			row = '95%',
			col = 1,
		},
		size = 30,
		border = {
			style = 'rounded',
			highlight = 'Normal',
			text = {
				top = ' Search ',
				top_align = 'left',
			},
		},
		win_options = {
			winhighlight = 'Normal:Normal',
		},
		buf_options = {
			filetype = 'Search'
		}
	}
})

nnoremap('<silent>sc', ':SearchBoxClear<cr>')

nnoremap('<silent>/', ':lua Search("/", "normal")<cr>')
nnoremap('<silent>?', ':lua Search("?", "normal")<cr>')
vnoremap('<silent>/', ':lua Search("/", "visual")<cr>')
vnoremap('<silent>?', ':lua Search("?", "visual")<cr>')

nnoremap('<silent>sr', ':lua Replace("normal")<cr>')
vnoremap('<silent>sr', ':lua Replace("visual")<cr>')
