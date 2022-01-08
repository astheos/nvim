let s:i = '  ﰩ   療﨡  כּ '
                                
let g:coq_settings = {
	\"display.icons.aliases": {
		\"EnumMember": "Member",
		\"TypeParameter": "Parameter"
	\},
	\"display.icons.mappings": {
		\"Class": "",
		\"Color": "",
		\"Command": "",
		\"Constant": "π",
		\"Constructor": "",
		\"Enum": "",
		\"EnumMember": "",
		\"Event": "",
		\"Field": "",
		\"File": " File",
		\"Folder": " Folder",
		\"Function": "",
		\"Interface": "",
		\"Keyword": "",
		\"Method": "",
		\"Module": "",
		\"Operator": "•",
		\"Property": "",
		\"Reference": "",
		\"Snippet": "",
		\"Struct": "",
		\"Text": "Aa Text",
		\"TypeParameter": "",
		\"Unit": "",
		\"Value": "",
		\"Variable": "α"
	\}
\}

function ShowAllIconsMaBro()
	for l:index in range(64000, 128000)
		echo l:index .. '. ' .. nr2char(l:index)
	endfor
endfunction

function EnableCompletion()
	if &filetype == 'Startup'
		return
	endif

	if !exists('s:init')
		let s:init = v:true

		:COQnow --shut-up
	endif
endfunction

augroup CompletionStart
	autocmd!
	autocmd BufEnter * call EnableCompletion()
augroup end

"⌠b
"| f(x)dx = F(b) - F(a)
"⌡a

"⎛i j k⎞
"⎜a b c⎟
"⎝x y z⎠

"⎡⎤
"⎢⎥
"⎣⎦

"       ⎧-1, x < 0⎫
"f(x) = ⎨0,  x = 0⎬
"       ⎩1,  x > 0⎭

