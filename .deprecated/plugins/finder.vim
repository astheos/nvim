" --------------- Telescope Configuration ---------------

lua << EOF
require('telescope').setup({
	defaults = {
		prompt_prefix = "  ",
		selection_caret = " "
	},
	pickers = {
		find_files = {
			hidden = true
		},
		file_browser = {
			hidden = true
		},
		live_greps = {
			hidden = true
		}
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	}
})

require('telescope').load_extension('fzf')
EOF

function TelescopeAction(action)
	if a:action == "files"
		cd
		execute ':Telescope find_files'
	elseif a:action == "browser"
		execute ':Telescope file_browser'
	elseif a:action == "grep"
		execute ':Telescope live_grep'
	elseif a:action == "buffers"
		execute ':Telescope buffers'
	elseif a:action == "tags"
		execute ':Telescope help_tags'
	elseif a:action == "current"
		execute ':Telescope current_buffer_fuzzy_find'
	endif

	echo 'Directory: ' .. getcwd()
endfunction

" --------------- Map Keys

noremap ff :call TelescopeAction("files")   <CR>
noremap fm :call TelescopeAction("browser") <CR>
noremap fg :call TelescopeAction("grep")    <CR>
noremap fb :call TelescopeAction("buffers") <CR>
noremap fh :call TelescopeAction("tags")    <CR>
noremap fw :call TelescopeAction("current") <CR>
