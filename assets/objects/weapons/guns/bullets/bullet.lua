bullet = {}
bullet.name = "bullet"

bullet.pos = {x=0,y=0}
bullet.vel = {x=0,y=0}
bullet.rot = 0
bullet.size = {w=15,h=20}
bullet.speed = 400
bullet.life = 4
bullet.curLife = 0

-- Callbacks --
function bullet:update(dt)
	self:setVel(math.sin(math.rad(self.rot))*self.speed, -math.cos(math.rad(self.rot))*self.speed)
	self.pos.x = self.pos.x + self.vel.x*dt
	self.pos.y = self.pos.y + self.vel.y*dt
	self.curLife = self.curLife + dt
	if self.curLife >= self.life then object.destroyObject(self) end
end

function bullet:draw()
	ui.push()
		ui.setMode("world")
		ui.draw(image.getImage("bullet_01"), math.round(self.pos.x), math.round(self.pos.y), self.size.w, self.size.h, self.rot)
	ui.pop()
end

-- Functions --
function bullet:setVel(x,y)
	self.vel.x = x
	self.vel.y = y
end

return bullet