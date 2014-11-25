player = {}

-- Callbacks --
function player:update(dt)
	self.vel.x, self.vel.y = 0, 0
	if love.keyboard.isDown("w") and not love.keyboard.isDown("s") then self.vel.y = -self.speed end
	if love.keyboard.isDown("s") and not love.keyboard.isDown("w") then self.vel.y = self.speed end
	if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then self.vel.x = -self.speed end
	if love.keyboard.isDown("d") and not love.keyboard.isDown("a") then self.vel.x = self.speed end

	local vx, vy = math.norm(self.vel.x, self.vel.y)
	self.vel.x, self.vel.y = vx*self.vel.x, vy*self.vel.y

	if self.vel.x > 0 then
		if self.vel.y > 0 then self.rot = 135 elseif self.vel.y < 0 then self.rot = 45 else self.rot = 90 end
	elseif self.vel.x < 0 then
		if self.vel.y > 0 then self.rot = 225 elseif self.vel.y < 0 then self.rot = 315 else self.rot = 270 end
	else
		if self.vel.y > 0 then self.rot = 180 elseif self.vel.y < 0 then self.rot = 0 end
	end

	local mx, my = camera.getMouse()
	if love.mouse.isDown("l") or love.mouse.isDown("r") or love.mouse.isDown("m") then self.rot = (math.atan2((my-(self.pos.y+self.size/2)), (mx-(self.pos.x+self.size/2)))*180/math.pi)+90 end
	if self.rot < 0 then self.rot = 270+(self.rot+90) end
	self.rot = (math.floor((self.rot+22.5)/45))*45

	self.pos.x = self.pos.x + self.vel.x*dt
	self.pos.y = self.pos.y + self.vel.y*dt

	camera.centerPos(self.pos.x+self.size/2, self.pos.y+self.size/2)
end

function player:draw()
	ui.push()
		ui.setMode("world")
		ui.draw(image.getImage("player_01"), math.round(self.pos.x), math.round(self.pos.y), self.size, self.size, self.rot)
		ui.draw(image.getImage("player_01"), 0, 0, self.size, self.size)
	ui.pop()
end

-- Functions --
function player:new()
	local obj = {}
	obj.pos = {x=0,y=0}
	obj.vel = {x=0,y=0}
	obj.size = 64
	obj.speed = 500
	obj.rot = 0
	return obj
end

return player