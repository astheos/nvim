" -------------- File Explorer Configuration --------------

function FileExplorerStatusLine(...)
	let l:separator = ['', '']

	let l:name = 'Files'
	let l:progress = GetFileProgress()
	let l:line = line('.')
	
	if a:0 == 0
		let l:mode = ' ' .. GetMode() .. ' '
	else
		let l:mode = ''
	endif

	let l:left = ''
	let l:right = ''

	let l:left = l:left .. '%#LineLeadCyan# ' .. l:name .. ' '
	let l:left = l:left .. '%#LineBaseCyan#'  .. l:separator[0] .. l:mode
	let l:left = l:left .. '%#LineSep#'       .. l:separator[0]
	let l:left = l:left .. '%#LineRest# '

	let l:right = l:right .. '%#LineSep#'       .. l:separator[1]
	let l:right = l:right .. '%#LineBaseCyan#'  .. ' ' .. l:progress .. ' '
	let l:right = l:right .. '%#LineBaseCyan#'  .. l:separator[1]
	let l:right = l:right .. '%#LineLeadCyan# ' .. l:line .. ' '

	let l:right = '%#LineSep#' .. l:separator[1]
	let l:right = l:right .. '%#LineBaseCyan#' .. l:separator[1]
	let l:right = l:right .. '%#LineLeadCyan# '

	return l:left .. '%=' .. l:right
endfunction

function ActiveFileExplorerStatusLine()
	setlocal statusline=%!FileExplorerStatusLine()
endfunction

function InactiveFileExplorerStatusLine()
	let l:statusline = FileExplorerStatusLine('inactive')

	call setbufvar(bufnr(), '&statusline', l:statusline)
endfunction

function UpdateFileExplorerColors()
	let l:white = ChangeBrightness(g:colors[15],    0)
	let l:grey  = ChangeBrightness(g:colors[15],  -80)

	let l:marks = Opacity(g:colors[15], '#000000', 60)

	let l:root = g:colors[11]

	if g:nametheme[0:6] == 'Gruvbox'
		let l:current = g:colors[10]
		let l:variant = g:colors[14]
	elseif g:nametheme[0:6] == 'Sonokai'
		let l:current = g:colors[1]
		let l:variant = g:colors[14]
	elseif g:nametheme[0:3] == 'Edge'
		let l:current = g:colors[2]
		let l:variant = g:colors[6]
	elseif g:nametheme[0:3] == 'Nord'
		let l:current = g:colors[2]
		let l:variant = g:colors[14]
	elseif g:nametheme[0:3] == 'Rose'
		let l:current = g:colors[6]
		let l:variant = g:colors[4]
	endif

	execute 'highlight NvimTreeSymlink          guifg=' .. l:grey
	execute 'highlight NvimTreeFolderName       guifg=' .. l:white
	execute 'highlight NvimTreeFolderIcon       guifg=' .. l:white
	execute 'highlight NvimTreeRootFolder       guifg=' .. l:root
	execute 'highlight NvimTreeEmptyFolderName  guifg=' .. l:grey
	execute 'highlight NvimTreeOpenedFolderName guifg=' .. l:current
	execute 'highlight NvimTreeOpenedFile       guifg=' .. l:current
	execute 'highlight NvimTreeExecFile         guifg=' .. l:variant
	execute 'highlight NvimTreeSpecialFile      guifg=' .. l:variant
	execute 'highlight NvimTreeImageFile        guifg=' .. l:white
	execute 'highlight NvimTreeMarkdownFile     guifg=' .. l:white
	execute 'highlight NvimTreeIndentMarker     guifg=' .. l:marks
endfunction 
 
function ResizeFileExplorer()
	let l:lines = range(line('w0'), line('w$'))

	let l:size = 0

	for l:line in l:lines
		let l:length = len(getline(l:line))

		if l:size < l:length
			let l:size = l:length
		endif
	endfor

	let l:size = l:size + 2

	if l:size < 32
		let l:size = 32
	endif

	execute 'vertical resize' .. l:size
endfunction

function FileExplorerCursor()
	if &filetype == 'NvimTree'
		setlocal cursorline

		highlight Cursor blend=100

		set guicursor+=n-v:Cursor/lCursor
	else
		highlight Cursor blend=0

		set guicursor-=n-v:Cursor/lCursor
	endif
endfunction


"   

let g:nvim_tree_width = '30%'
let g:nvim_tree_side = 'left'

let g:nvim_tree_icons = {
	\'default': '',
	\'symlink': '',
	\'git': {
		\'unstaged': "×",
		\'staged': "+",
		\'unmerged': "",
		\'renamed': "=>",
		\'untracked': "*",
		\'deleted': "-",
		\'ignored': "•"
	\},
	\'folder': {
		\'arrow_open': "",
		\'arrow_closed': "",
		\'default': "",
		\'open': "",
		\'empty': "",
		\'empty_open': "",
		\'symlink': "",
		\'symlink_open': "",
	\}
\}

lua << EOF
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
EOF

nnoremap <silent> <space>e :NvimTreeToggle <CR>

augroup FileExplorer
	autocmd!
	"autocmd BufCreate NvimTree call ConfigureFileExplorer()
	"autocmd WinEnter  NvimTree call ConfigureFileExplorer()
	"autocmd BufEnter *        call SetFileExplorerColors()
	autocmd BufEnter NvimTree call ActiveFileExplorerStatusLine()
	autocmd BufLeave NvimTree call InactiveFileExplorerStatusLine()
augroup end

augroup ExplorerCursor
	autocmd!
	autocmd FileType    * call FileExplorerCursor()
	autocmd BufEnter    * call FileExplorerCursor()
	autocmd WinEnter    * call FileExplorerCursor()
	autocmd ColorScheme * call FileExplorerCursor()
augroup end

augroup ResizeExplorer
	autocmd!
	autocmd WinScrolled NvimTree call ResizeFileExplorer()
	autocmd TextChanged NvimTree call ResizeFileExplorer()
augroup end
