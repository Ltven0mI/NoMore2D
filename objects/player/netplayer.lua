local netplayer = {}

-- Variables --
netplayer.pos = {x=0,y=0}
netplayer.curPos = {x=0,y=0}
netplayer.posLerpSpeed = 0.4

netplayer.rot = 0
netplayer.curRot = 0
netplayer.rotLerpSpeed = 0.1

netplayer.size = 32

-- Callbacks --
function netplayer:update(dt)
	self.curPos.x = math.lerp(self.curPos.x, self.pos.x, self.posLerpSpeed)
	self.curPos.y = math.lerp(self.curPos.y, self.pos.y, self.posLerpSpeed)
	self.curRot = math.anglerp(self.curRot, self.rot, self.rotLerpSpeed)
end

function netplayer:drawworld()
	local cs = camera.getScale()
	local cx, cy = camera.getPos()
	local cw, ch = main.width/cs, main.height/cs
	if math.contains(cx, cy, cw, ch, self.pos.x, self.pos.y, self.size, self.size) then
		local mode = ui.getMode()
		ui.setMode("world")
		ui.draw(image.getImage("player_01"), math.round(self.pos.x), math.round(self.pos.y), self.size, self.size, self.curRot)
		ui.setMode(mode)
	end
end

-- Functions --
function netplayer:setData(x,y,r)
	if not (x == nil and y == nil and r == nil) then
		if x ~= nil then self.pos.x = x end
		if y ~= nil then self.pos.y = y end
		if r ~= nil then self.rot = r end
	else
		debug.err("Incorrect call to function 'netplayer:setData(x,y,r)'")
	end
end

return netplayer