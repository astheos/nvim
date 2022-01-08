---------------- General Purpose Functions ----------------

require('interface')

--------------- Variables

-- Theme
theme = {'', ''}

-- Colors
base = {0, 0, 0, 0, 0}

colors = {
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
}

-- Components
style = {"slant", "slant"}

separators = {
	arrow = {'', ''},
	round = {'', ''},
	slant = {'◣', '◢'},
	blank = {'', ''}
}

separator = separators[style[1]]

divisors = {
	arrow = {'', ''},
	round = {'', ''},
	slant = {'', ''},
	blank = {'', ''},
	point = '•'
}

divisor = divisors[style[2]]

-- Search
search = {0, ''}

-- Functions

function ignore(files)
	for index, file in pairs(files) do
		if file == get('filetype') then
			return true
		end
	end

	return false
end
