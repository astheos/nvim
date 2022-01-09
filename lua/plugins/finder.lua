--------------- Telescope Configuration ---------------

require('interface')

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

function TelescopeAction(action)
	if action == "files" then
		execute('cd')
		execute(':Telescope find_files')
	elseif action == "browser" then
		execute(':Telescope file_browser')
	elseif action == "grep" then
		execute(':Telescope live_grep')
	elseif action == "buffers" then
		execute(':Telescope buffers')
	elseif action == "tags" then
		execute(':Telescope help_tags')
	elseif action == "current" then
		execute(':Telescope current_buffer_fuzzy_find')
	end

	print('Directory: ' .. eval['getcwd']())
end

--------------- Map Keys

nnoremap('ff', [[:lua TelescopeAction("files")   <CR>]])
nnoremap('fm', [[:lua TelescopeAction("browser") <CR>]])
nnoremap('fg', [[:lua TelescopeAction("grep")    <CR>]])
nnoremap('fb', [[:lua TelescopeAction("buffers") <CR>]])
nnoremap('fh', [[:lua TelescopeAction("tags")    <CR>]])
nnoremap('fw', [[:lua TelescopeAction("current") <CR>]])
