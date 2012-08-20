--pad.lua
local pad = {}
pad.__index = pad


function pad:new(index, mapping, aliases)
	local p = {}
	setmetatable(p, self)

	p.index = index

	p.currentstate = {}
	p.oldstate = {}

	p.mappings = mapping
	if aliases then
		p:setAliases(aliases)
	end

	self.input = pad.input or love.joystick

	return p
end

local function padGetButtonName(self, id)
	if type(id) == "number" then
		return self.mappings.buttonnames[id]
	else
		if self.aliases and self.aliases[id] then
			return self.aliases[id]
		end
		return id
	end
end

local function padGetAxisID(self, name)
	return self.mappings.axisids[ padGetButtonName(self, name) ]
end

local function padGetButtonID(self, name)
	return self.mappings.buttonids[ padGetButtonName(self, name) ]
end

function pad:setAliases(aliases)
	self.aliases = aliases
end

function pad:getAxis(name)
	assert(self.input)
	local id = padGetAxisID( self, padGetButtonName(self, name) )

	if id == nil then
		return 0
	end
	
	return self.input.getAxis(self.index, id)
end


function pad:pressed(name)
	local id = padGetButtonID(self,name)

	if id == nil then
		return false
	end

	return self.currentstate[id] == true
end

function pad:justPressed(name)
	local id = padGetButtonID(self,name)

	if id == nil then
		return false
	end

	return self.currentstate[id] and not self.oldstate[id]
end

function pad:justReleased(name)
	local id = padGetButtonID(self,name)

	if id == nil then
		return false
	end

	return self.oldstate[id] and not self.currentstate[id]
end

function pad:setRumble(pct)
	assert(self.input)
	if self.input.setRumble then
		self.input.setRumble(self.index, pct)
	end
end

function pad:setVibrate(pct)
	assert(self.input)
	if self.input.setVibrate then
		self.input.setVibrate(self.index, pct)
	end
end

function pad:getName()
	assert(self.input)
	return self.input.getName(self.index)
end

function pad:getDPad()
	assert(self.input)
	return self.input.getHat(self.index, 1)
end

function pad:update()
	assert(self.input)
	local input = self.input
	local oldstate = self.oldstate
	local currentstate = self.currentstate
	local index = self.index
	for i=1, input.getNumButtons(self.index) do
		oldstate[i] = currentstate[i]
		currentstate[i] = input.isDown(index, i)
	end
end


return pad