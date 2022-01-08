--------------- Wild Menu --------------

require('interface')
require('general')

require('tools/colors')

function UpdateWilderColors()
	local background = {'', ''}
	local foreground = {'', ''}

	local signal

	if theme[2] == 'light' then
		signal = -1
	elseif theme[2] == 'dark' then
		signal = 1
	end

	background[1] = ChangeBrightness(base[1],  5 * signal)
	background[2] = ChangeBrightness(base[1], 20 * signal)

	foreground[1] = colors[16]
	foreground[2] = colors[15]

	highlight('WildDefault', {bg = background[1], fg = foreground[1]})
	highlight('WildSelected', {bg = background[2], fg = foreground[1]})
	highlight('WildAccent', {bg = background[1], fg = foreground[2]})
	highlight('WildSelectedAccent', {bg = background[2], fg = foreground[2]})
end

execute([[
	call wilder#setup({
	\	'modes': [':'],
	\	'next_key': '<tab>',
	\	'previous_key': '<s-tab>',
	\	'accept_key': '<down>',
	\	'reject_key': '<up>'
	\})
]])

execute([[
	call wilder#set_option('renderer', wilder#popupmenu_renderer(
	\	wilder#popupmenu_border_theme({
	\		'mode': 'float',
	\		'ellipsis': '...',
	\		'left': [
	\			' ', wilder#popupmenu_devicons(),
	\		],
	\		'right': [
	\			' ', wilder#popupmenu_scrollbar(),
	\		],
	\		'highlighter': wilder#basic_highlighter(),
	\		'highlights': {
	\			'border': 'Normal',
	\			'default': 'WildDefault',
	\			'selected': 'WildSelected',
	\			'accent': 'WildAccent',
	\			'selected_accent': 'WildSelectedAccent'
	\		},
	\		'border': 'rounded',
	\		'min_width': '20%',
	\		'max_width': '60%',
	\		'min_height': '0%',
	\		'max_height': '40%'
	\	})
	\))
]])
