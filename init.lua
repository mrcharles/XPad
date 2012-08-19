--init.lua
local BASE = (...) .. '.'
assert(not BASE:match('%.init%.$'), "Invalid require path `"..(...).."' (drop the `.init').")

pad = require (BASE.."pad")

local xpad = {}
xpad.__index = xpad

--constants
local PAD_DISCONNECTED = 0
local PAD_CONNECTED = 1
local PAD_UNPLUGGED = 2
local PAD_ASSIGNED = 3
---------

local padstatus = 
{
	PAD_DISCONNECTED,
	PAD_DISCONNECTED,
	PAD_DISCONNECTED,
	PAD_DISCONNECTED,
}


local pads = 
{}

local buttonnames = {}
buttonnames["xbox gamepad"] = {
	"a",
	"b",
	"x",
	"y",
	"lt",
	"rt",
	"lb",
	"rb",
	"ls",
	"rs",
	"back",
	"start"
}

buttonnames["Controller (XBOX 360 For Windows)"] = {
	"a",
	"b",
	"x",
	"y",
	"lb",
	"rb",
	"back",
	"start",
	"ls",
	"rs",
}

local axisnames = {}
axisnames["xbox gamepad"] = {
	"leftx",
	"lefty",
	"rightx",
	"righty",
	"lefttrigger",
	"righttrigger"
}
axisnames["Controller (XBOX 360 For Windows)"] = {
	"leftx",
	"lefty",
	"brokentrigger",
	"righty",
	"rightx",
}


local input = nil

local pressedcallback = nil
local releasedcallback = nil

local function joystickpressed(index, button)

	if pressedcallback then
		pressedcallback(index, xpad:getAliasesForButton(pads[index]:getButtonName(button)))
	end
end

local function joystickreleased(index, button)

	if releasedcallback then
		releasedcallback(index, xpad:getAliasesForButton(pads[index]:getButtonName(button)))
	end
end

local function getpadmapping(padname)
	print(padname)
	local buttonids = {}
	for i=1,#buttonnames[padname] do
		buttonids[buttonnames[padname][i]] = i
	end

	local axisids = {}
	for i=1,#axisnames[padname] do
		axisids[axisnames[padname][i]] = i
	end

	return { buttonids = buttonids, axisids = axisids, buttonnames = buttonnames, axisnames = axisnames }
end

function xpad:init( _input )
	input = _input
	pad.input = _input

	-- pressedcallback = love.joystickpressed
	-- releasedcallback = love.joystickreleased
	-- love.joystickreleased = joystickreleased
	-- love.joystickpressed = joystickpressed

	--todo, load a translation table for non-xbox controllers.


end

function xpad:newplayer()
	assert(input)

	for i=1,4 do
		if padstatus[i] == PAD_DISCONNECTED and input.getNumJoysticks() >= i then 
			padstatus[i] = PAD_ASSIGNED
			local newpad = pad:new(i, getpadmapping(input.getName(i)), self.config)
			table.insert(pads, newpad)
			return newpad
		end
	end
end

function xpad:setButtonConfig(config)
	self.config = config

	--if we have pads, set the config
	for k,pad in pairs(pads) do
		pad:setAliases(config)
	end

end

function xpad:getAliasesForButton(name)
	local ret = {}
	for alias,button in pairs(self.config) do
		if button == name then
			table.insert(ret, alias)
		end
	end
	return unpack(ret)
end

function xpad:getpad(player)
	return pads[player]
end

function xpad:update()
	for i,pad in ipairs(pads) do
		pad:update()
	end
end

return xpad