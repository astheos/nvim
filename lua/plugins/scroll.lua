-------------- Scroll Configuration --------------

require('neoscroll').setup({
	hide_cursor = true,
    stop_eof = true,
    use_local_scrolloff = false,
    respect_scrolloff = false,
    cursor_scrolls_alone = true
})

local maps = {}
-- Syntax: t[keys] = {function, {function arguments}}
maps['J'] = {'scroll', { '8', 'true', '100'}}
maps['K'] = {'scroll', {'-8', 'true', '100'}}
maps['H'] = {'scroll', { '8', 'false', '100'}}
maps['L'] = {'scroll', {'-8', 'false', '100'}}

require('neoscroll.config').set_mappings(maps)
