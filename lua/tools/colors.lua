--------------- Color Functions ---------------

require("interface")
require("general")

function UpdateColors()
	for color = 1, 16 do
		colors[color] = varglobal('terminal_color_' .. tostring(color - 1))
	end

	base[1] = eval['synIDattr'](eval['hlID']("Normal"), "bg")

	local signal = 1

	if theme[2] == 'dark' then
		signal = 1
	elseif theme[2] == 'light' then
		signal = -1
	end

	if theme[1] == 'rose' then
		base[2] = ChangeBrightness(base[1], signal * 10)
		base[3] = ChangeBrightness(base[1], signal * 25)
		base[4] = ChangeBrightness(base[3], signal * 100)
		base[5] = ChangeBrightness(base[1], signal * 180)
	else
		base[2] = ChangeBrightness(base[1],  signal * 10)
		base[3] = ChangeBrightness(base[1], -signal * 10)
		base[4] = ChangeBrightness(base[3],  signal * 100)
		base[5] = ChangeBrightness(base[1],  signal * 180)
	end

	varglobal('terminal_color_8', base[2])
end

function UpdateHighlights()
	highlight('LineLeadBlack',   {bg = colors[1],  fg = base[3]})
	highlight('LineLeadRed',     {bg = colors[10], fg = base[3]})
	highlight('LineLeadGreen',   {bg = colors[11], fg = base[3]})
	highlight('LineLeadYellow',  {bg = colors[12], fg = base[3]})
	highlight('LineLeadBlue',    {bg = colors[13], fg = base[3]})
	highlight('LineLeadMagenta', {bg = colors[14], fg = base[3]})
	highlight('LineLeadCyan',    {bg = colors[15], fg = base[3]})
	highlight('LineLeadWhite',   {bg = colors[16], fg = base[3]})

	highlight('LineBaseBlack',   {bg = base[3], fg = colors[1]})
	highlight('LineBaseRed',     {bg = base[3], fg = colors[10]})
	highlight('LineBaseGreen',   {bg = base[3], fg = colors[11]})
	highlight('LineBaseYellow',  {bg = base[3], fg = colors[12]})
	highlight('LineBaseBlue',    {bg = base[3], fg = colors[13]})
	highlight('LineBaseMagenta', {bg = base[3], fg = colors[14]})
	highlight('LineBaseCyan',    {bg = base[3], fg = colors[15]})
	highlight('LineBaseWhite',   {bg = base[3], fg = colors[16]})

	highlight('LineSep',   {bg = base[2], fg = base[3]})
	highlight('LineSup',   {bg = base[3], fg = base[2]})
	highlight('LineRest',  {bg = base[2], fg = colors[16]})
	highlight('LineNumb',  {bg = base[2], fg = base[5]})
	highlight('LineOther', {bg = base[3], fg = base[4]})
end

function LimitValue(value, inferior, superior)
	if value < inferior then return inferior end
	if value > superior then return superior end

	return value
end

function DecToHex(decimal)
	return string.format('%x', decimal)
end

function HexToDec(hexadecimal)
	return tonumber('0x' .. hexadecimal)
end

function LinearMapping(origin, destination, point)
	point = LimitValue(point, 0, 100)

	return origin + point * (destination - origin) / 100
end

function ColorHexToDec(color)
	local red   = HexToDec(color:sub(2, 3))
	local green = HexToDec(color:sub(4, 5))
	local blue  = HexToDec(color:sub(6, 7))

	return {red, green, blue}
end

function ColorDecToHex(color)
	local red   = DecToHex(color[1])
	local green = DecToHex(color[2])
	local blue  = DecToHex(color[3])

	if #red == 1 then
		red = '0' .. red
	end

	if #green == 1 then
		green = '0' .. green
	end

	if #blue == 1 then
		blue = '0' .. blue
	end

	return '#' .. red .. green .. blue
end

function ChangeBrightness(color, increase)
	local red   = HexToDec(color:sub(2, 3)) + increase
	local green = HexToDec(color:sub(4, 5)) + increase
	local blue  = HexToDec(color:sub(6, 7)) + increase

	red   = DecToHex(LimitValue(red,   0, 255))
	green = DecToHex(LimitValue(green, 0, 255))
	blue  = DecToHex(LimitValue(blue,  0, 255))

	if #red == 1 then
		red = '0' .. red
	end

	if #green == 1 then
		green = '0' .. green
	end

	if #blue == 1 then
		blue = '0' .. blue
	end

	return '#' .. red .. green .. blue
end

function Opacity(base, other, opacity)
	base  = ColorHexToDec(base)
	other = ColorHexToDec(other)

	local color = {0, 0, 0}

	for index = 1, 3 do
		color[index] = LinearMapping(base[index], other[index], opacity)
	end

	return ColorDecToHex(color)
end
