-------------- File Explorer Configuration --------------

require('interface')
require('general')

local function GetMode()
	local mode = eval['mode']()

	if mode == 'n' then
		mode = 'Normal'
	elseif mode == 'v' then
		mode = 'Visual'
	elseif mode == 'V' then
		mode = 'Visual'
	elseif mode == 'CTRL-V' then
		mode = 'Visual'
	elseif mode == 'i' then
		mode = 'Insert'
	elseif mode == 'r' then
		mode = 'Replace'
	elseif mode == 'R' then
		mode = 'Replace'
	elseif mode == 'c' then
		mode = 'Command'
	elseif mode == 't' then
		mode = 'Terminal'
	end

	return mode
end

function FileExplorerStatusLine(active)
	local name = 'Files'
	local file = ''
	local icon = ''
	local mode = ''
	
	if active then
		mode = ' ' .. GetMode() .. ' '
	end

	local left = ''
	local right = ''

	left = left .. '%#LineLeadCyan# ' .. name .. ' '
	left = left .. '%#LineBaseCyan#'  .. separator[1] .. mode
	left = left .. '%#LineSep#'       .. separator[1]
	left = left .. '%#LineRest# '

	right = right .. '%#LineSep#' .. separator[2]
	right = right .. '%#LineBaseCyan# ' .. icon .. ' '
	--right = right .. '%#LineBaseCyan#' .. separator[2]
	--right = right .. '%#LineLeadCyan# ' .. file .. ' '

	return left .. '%=' .. right
end

function ActiveFileExplorerStatusLine()
	execute('setlocal statusline=%!v:lua.FileExplorerStatusLine(v:true)')
end

function InactiveFileExplorerStatusLine()
	statusline = FileExplorerStatusLine(false)

	eval['setbufvar'](eval['bufnr'](), '&statusline', statusline)
end

function UpdateFileExplorerColors()
	local white = ChangeBrightness(colors[16],    0)
	local grey  = ChangeBrightness(colors[16],  -80)

	local marks = Opacity(colors[16], '#000000', 60)

	local root = colors[12]

	local current
	local variant

	if varglobal('colors_name') == 'gruvbox' then
		current = colors[11]
		variant = colors[15]
	elseif varglobal('colors_name') == 'sonokai' then
		current = colors[2]
		variant = colors[15]
	elseif varglobal('colors_name') == 'edge' then
		current = colors[3]
		variant = colors[7]
	elseif varglobal('colors_name') == 'nord' then
		current = colors[3]
		variant = colors[15]
	elseif varglobal('colors_name') == 'rose-pine' then
		current = colors[7]
		variant = colors[5]
	end

	highlight('NvimTreeSymlink', {fg = grey})
	highlight('NvimTreeFolderName', {fg = white})
	highlight('NvimTreeFolderIcon', {fg = white})
	highlight('NvimTreeRootFolder', {fg = root})
	highlight('NvimTreeEmptyFolderName', {fg = grey})
	highlight('NvimTreeOpenedFolderName', {fg = current})
	highlight('NvimTreeOpenedFile', {fg = current})
	highlight('NvimTreeExecFile', {fg = variant})
	highlight('NvimTreeSpecialFile', {fg = variant})
	highlight('NvimTreeImageFile', {fg = white})
	highlight('NvimTreeMarkdownFile', {fg = white})
	highlight('NvimTreeIndentMarker', {fg = marks})
end

function ResizeFileExplorer()
	local begin = eval['line']('w0')
	local ends = eval['line']('w$')

	local size = 0
	local length = 0

	for line = begin, ends do
		length = #eval['getline'](line)

		if size < length then
			size = length
		end
	end

	size = size + 2

	if size < 32 then
		size = 32
	end

	execute('vertical resize ' .. size)
end

function FileExplorerCursor()
	if getbuffer('filetype') == 'NvimTree' then
		execute([[
			setlocal cursorline

			highlight Cursor blend=100

			set guicursor+=n-v:Cursor/lCursor
		]])
	else
		execute([[
			highlight Cursor blend=0

			set guicursor-=n-v:Cursor/lCursor
		]])
	end
end

--    

local width = '30%'
local side = 'left'

local icons = {
	default = '',
	symlink = '',
	git = {
		unstaged = "×",
		staged = "+",
		unmerged = "",
		renamed = "=>",
		untracked = "*",
		deleted = "-",
		ignored = "•"
	},
	folder = {
		arrow_open = "",
		arrow_closed = "",
		default = "",
		open = "",
		empty = "",
		empty_open = "",
		symlink = "",
		symlink_open = "",
	}
}

varglobal('nvim_tree_width', width)
varglobal('nvim_tree_side',   side)
varglobal('nvim_tree_icons', icons)

local explorer = require'nvim-tree'

local action = require'nvim-tree.config'.nvim_tree_callback

local shortkeys = {
	{key = "<enter>", cb = action("edit")},
	{key = "<tab>",   cb = action("preview")},
	{key = "<bs>",    cb = action("close_node")},
	{key = "<",       cb = action("dir_up")},
	{key = ">",       cb = action("cd")},
	{key = "H",       cb = action("prev_sibling")},
	{key = "L",       cb = action("next_sibling")},
	{key = "J",       cb = action("first_sibling")},
	{key = "K",       cb = action("last_sibling")},
	{key = "a",       cb = action("create")},
	{key = "d",       cb = action("remove")},
	{key = "c",       cb = action("cut")},
	{key = "y",       cb = action("copy")},
	{key = "p",       cb = action("paste")},
	{key = "r",       cb = action("rename")},
	{key = "<c-n>",   cb = action("copy_name")},
	{key = "<c-p>",   cb = action("copy_path")},
	{key = "<c-a>",   cb = action("copy_absolute_path")},
	{key = "<c-v>",   cb = action("vsplit")},
	{key = "<c-h>",   cb = action("split")},
	{key = "<c-r>",   cb = action("refresh")},
	{key = "s",       cb = action("system_open")},
	{key = "m",       cb = action("toggle_help")},
}

explorer.setup {
	disable_netrw      = true,
	hijack_netrw       = true,
	open_on_setup      = false,
	ignore_ft_on_setup = {},
	update_to_buf_dir  = {
		enable = true,
		auto_open = true,
	},
	auto_close    = false,
	open_on_tab   = false,
	hijack_cursor = false,
	update_cwd    = false,
	diagnostics   = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		}
	},
	update_focused_file = {
		enable      = false,
		update_cwd  = false,
		ignore_list = {}
	},
	system_open = {
		cmd  = nil,
		args = {}
	},
	view = {
		width = 30,
		height = 30,
		side = 'left',
		auto_resize = false,
		mappings = {
			custom_only = true,
			list = shortkeys
		}
	},
	filters = {
		dotfiles = false,
		custom = {}
	}
}

nnoremap('<silent> <space>e', ':NvimTreeToggle <cr>')

augroup('FileExplorer')
	autocmd()
	-- autocmd BufCreate NvimTree call ConfigureFileExplorer()
	-- autocmd WinEnter  NvimTree call ConfigureFileExplorer()
	-- autocmd BufEnter *        call SetFileExplorerColors()
	autocmd('BufEnter', 'NvimTree', 'lua ActiveFileExplorerStatusLine()')
	autocmd('BufLeave', 'NvimTree', 'lua InactiveFileExplorerStatusLine()')
augroup('end')

augroup('ExplorerCursor')
	autocmd()
	autocmd('FileType',    '*', 'lua FileExplorerCursor()')
	autocmd('BufEnter',    '*', 'lua FileExplorerCursor()')
	autocmd('WinEnter',    '*', 'lua FileExplorerCursor()')
	autocmd('ColorScheme', '*', 'lua FileExplorerCursor()')
augroup('end')

augroup('ResizeExplorer')
	autocmd()
	autocmd('WinScrolled', 'NvimTree', 'lua ResizeFileExplorer()')
	autocmd('TextChanged', 'NvimTree', 'lua ResizeFileExplorer()')
augroup('end')
