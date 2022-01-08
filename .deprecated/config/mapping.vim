" --------------- General Mapping ---------------

" ---------- Functions To Operations

function Out()
	let l:pos = [line('.'), col('.')]

	stopinsert

	call cursor(l:pos)
endfunction

function Copy(operation)
	let l:pos = [line('.'), col('.')]

	execute "normal " .. a:operation

	call cursor(l:pos)
endfunction
 
function Cut(operation)
	execute "normal " .. a:operation
endfunction

function Delete(operation)
	execute "normal " .. a:operation
endfunction

function Substitute(this, that)
	let l:pos = [line('.'), col('.')]
	
	normal v
	execute "normal i" .. a:this
	normal v

	normal `<
	let l:begin = [line('.'), col('.') - 1]
	
	normal `>
	let l:end = [line('.'), col('.') + 1]

	if l:begin != l:end
		call cursor(l:begin)
		execute "normal r" .. a:that[0]

		call cursor(l:end)
		execute "normal r" .. a:that[1]
	endif

	call cursor(l:pos)
endfunction

function AddBlank(position, type)
	let l:pos = [line('.'), col('.')]

	if a:position == "back"
		if a:type == "char"
			normal i 

			let l:pos[1] = l:pos[1] + 1
		elseif a:type == "line"
			normal O

			let l:pos[0] = l:pos[0] + 1
		endif
	elseif a:position == "fron"
		if a:type == "char"
			normal a 
		elseif a:type == "line"
			normal o
		endif
	endif

	stopinsert

	call cursor(l:pos)
endfunction

function MoveToBuffer(way)
	if a:way == "previous"
		bprevious
	elseif a:way == "next"
		bnext 
	elseif a:way == "first"
		bfirst
	elseif a:way == "last"
		blast	
	endif
endfunction

function ManipulateBuffer(action)
	if a:action == 'delete'
		bdelete
	elseif a:action == 'write'
		write
	elseif a:action == 'rename'
		return
	endif
endfunction

" ---------- Normal Mode Maps 

"nnoremap e :edit ~\appdata\local\nvim\init.vim <CR>
nnoremap <CR> gf <CR>

" Delete, Cut and Yank

nnoremap <silent>dw :call Delete("\"_diw") <CR>
nnoremap <silent>de :call Delete("\"_diW") <CR>
nnoremap <silent>df :call Delete("\"_d$")  <CR>
nnoremap <silent>db :call Delete("\"_d0")  <CR>
nnoremap <silent>dd :call Delete("V\"_d")  <CR>
nnoremap <silent>dp :call Delete("\"_dip") <CR>
nnoremap <silent>d( :call Delete("\"_di(") <CR>
nnoremap <silent>d[ :call Delete("\"_di[") <CR>
nnoremap <silent>d{ :call Delete("\"_di{") <CR>
nnoremap <silent>d< :call Delete("\"_di<") <CR>
nnoremap <silent>d" :call Delete("\"_di\"")<CR>
nnoremap <silent>d' :call Delete("\"_di\'")<CR>
nnoremap <silent>d) :call Delete("\"_da(") <CR>
nnoremap <silent>d] :call Delete("\"_da[") <CR>
nnoremap <silent>d} :call Delete("\"_da{") <CR>
nnoremap <silent>d> :call Delete("\"_da<") <CR>

nnoremap <silent>cw :call Cut("diw") <CR>
nnoremap <silent>ce :call Cut("diW") <CR>
nnoremap <silent>cf :call Cut("d$")  <CR>
nnoremap <silent>cb :call Cut("d0")  <CR>
nnoremap <silent>cc :call Cut("VyVd")<CR>
nnoremap <silent>cp :call Cut("dip") <CR>
nnoremap <silent>c( :call Cut("di(") <CR>
nnoremap <silent>c[ :call Cut("di[") <CR>
nnoremap <silent>c{ :call Cut("di{") <CR>
nnoremap <silent>c< :call Cut("di<") <CR>
nnoremap <silent>c" :call Cut("di\"")<CR>
nnoremap <silent>c' :call Cut("di\'")<CR>
nnoremap <silent>c) :call Cut("da(") <CR>
nnoremap <silent>c] :call Cut("da[") <CR>
nnoremap <silent>c} :call Cut("da{") <CR>
nnoremap <silent>c> :call Cut("da<") <CR>

nnoremap <silent>yw :call Copy("yiw") <CR>
nnoremap <silent>ye :call Copy("yiW") <CR>
nnoremap <silent>yf :call Copy("y$")  <CR>
nnoremap <silent>yb :call Copy("y0")  <CR>
nnoremap <silent>yy :call Copy("Vy")  <CR>
nnoremap <silent>yp :call Copy("yip") <CR>
nnoremap <silent>y( :call Copy("yi(") <CR>
nnoremap <silent>y[ :call Copy("yi[") <CR>
nnoremap <silent>y{ :call Copy("yi{") <CR>
nnoremap <silent>y< :call Copy("yi<") <CR>
nnoremap <silent>y" :call Copy("yi\"")<CR>
nnoremap <silent>y' :call Copy("yi\'")<CR>
nnoremap <silent>y) :call Copy("ya(") <CR>
nnoremap <silent>y] :call Copy("ya[") <CR>
nnoremap <silent>y} :call Copy("ya{") <CR>
nnoremap <silent>y> :call Copy("ya<") <CR>

" Substitute

" Subs "
nnoremap <silent>s([ :call Substitute("(", "[]")<CR>
nnoremap <silent>s({ :call Substitute("(", "{}")<CR>
nnoremap <silent>s(< :call Substitute("(", "<>")<CR>
nnoremap <silent>s(' :call Substitute("(", "\'\'")<CR>
nnoremap <silent>s(" :call Substitute("(", "\"\"")<CR>

" Subs "
nnoremap <silent>s[( :call Substitute("[", "()")<CR>
nnoremap <silent>s[{ :call Substitute("[", "{}")<CR>
nnoremap <silent>s[< :call Substitute("[", "<>")<CR>
nnoremap <silent>s[' :call Substitute("[", "\'\'")<CR>
nnoremap <silent>s[" :call Substitute("[", "\"\"")<CR>

" Subs "
nnoremap <silent>s{( :call Substitute("{", "()")<CR>
nnoremap <silent>s{[ :call Substitute("{", "[]")<CR>
nnoremap <silent>s{< :call Substitute("{", "<>")<CR>
nnoremap <silent>s{' :call Substitute("{", "\'\'")<CR>
nnoremap <silent>s{" :call Substitute("{", "\"\"")<CR>

" Subs <
nnoremap <silent>s<( :call Substitute("<", "()")<CR>
nnoremap <silent>s<[ :call Substitute("<", "[]")<CR>
nnoremap <silent>s<{ :call Substitute("<", "{}")<CR>
nnoremap <silent>s<' :call Substitute("<", "\'\'")<CR>
nnoremap <silent>s<" :call Substitute("<", "\"\"")<CR>

" Subs '
nnoremap <silent>s'( :call Substitute("\'", "()")<CR>
nnoremap <silent>s'[ :call Substitute("\'", "[]")<CR>
nnoremap <silent>s'{ :call Substitute("\'", "{}")<CR>
nnoremap <silent>s'< :call Substitute("\'", "<>")<CR>
nnoremap <silent>s'" :call Substitute("\'", "\"\"")<CR>

" Subs "
nnoremap <silent>s"( :call Substitute("\"", "()")<CR>
nnoremap <silent>s"[ :call Substitute("\"", "[]")<CR>
nnoremap <silent>s"{ :call Substitute("\"", "{}")<CR>
nnoremap <silent>s"< :call Substitute("\"", "<>")<CR>
nnoremap <silent>s"' :call Substitute("\"", "\'\'")<CR>

" Indent

nnoremap >p >ip
nnoremap <p <ip

" Add Blanks

nnoremap <silent><Space>h :call AddBlank("back", "char")<CR>
nnoremap <silent><Space>j :call AddBlank("fron", "line")<CR>
nnoremap <silent><Space>k :call AddBlank("back", "line")<CR>
nnoremap <silent><Space>l :call AddBlank("fron", "char")<CR>

" Change Window

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Change Buffer

nnoremap <silent><C-b>p :call MoveToBuffer("previous")<CR>
nnoremap <silent><C-b>n :call MoveToBuffer("next")    <CR>
nnoremap <silent><C-b>f :call MoveToBuffer("first")   <CR>
nnoremap <silent><C-b>l :call MoveToBuffer("last")    <CR>

nnoremap <silent><C-b>d :call ManipulateBuffer("delete")<CR>
nnoremap <silent><C-b>w :call ManipulateBuffer("write") <CR>
nnoremap <silent><C-b>r :call ManipulateBuffer("rename")<CR>

" ---------- Insert Mode Maps

inoremap <silent><ESC> <C-O>:call Out()<CR>

inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

" ---------- Command Mode Maps

"inoremap <C-h> <Left>
"inoremap <C-j> <Down>
"inoremap <C-k> <Up>
"inoremap <C-l> <Right>

" ---------- Visual Mode Maps

vnoremap d "_d
vnoremap c d

" ---------- Replace Mode Maps

"inoremap <silent><ESC> <C-O>:call ExitInsertion("replace")<CR>
