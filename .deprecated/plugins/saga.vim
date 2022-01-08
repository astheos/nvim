" --------------- Language Server Assistant ---------------

lua << EOF
local saga = require'lspsaga'

saga.init_lsp_saga {
	use_saga_diagnostic_sign = true,
	error_sign = '',
	warn_sign = '',
	hint_sign = '',
	infor_sign = '',
	dianostic_header_icon = '   ',
	code_action_icon = ' ',
	code_action_prompt = {
		enable = false,
		sign = true,
		sign_priority = 20,
		virtual_text = true,
	},
	finder_definition_icon = '  ',
	finder_reference_icon = '  ',
	max_preview_lines = 10, 
	finder_action_keys = {
		open = '<cr>',
		vsplit = 'v',
		split = 's',
		quit = '<esc>'
	},
	code_action_keys = {
		quit = 'q',
		exec = '<CR>'
	},
	rename_action_keys = {
		quit = '<C-c>',
		exec = '<CR>'  -- quit can be a table
	},
	definition_preview_icon = '  ',
	border_style = "round",
	rename_prompt_prefix = '➤'
}
EOF