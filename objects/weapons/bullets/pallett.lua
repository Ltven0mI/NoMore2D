local bullet = {}
bullet.name = "pallet"

bullet.pos = {x=0,y=0}
bullet.vel = {x=0,y=0}
bullet.rot = 0
bullet.size = {w=10,h=10}
bullet.speed = 1200
bullet.life = 1
bullet.curLife = 0

-- Callbacks --
function bullet:update(dt)
	local velx, vely = math.sin(math.rad(self.rot))*self.speed, -math.cos(math.rad(self.rot))*self.speed
	self.pos.x = self.pos.x + (self.vel.x+velx)*dt
	self.pos.y = self.pos.y + (self.vel.y+vely)*dt
	self.curLife = self.curLife + dt
	if self.curLife >= self.life then object.destroyObject(self) end
end

function bullet:drawworld()
	ui.draw(image.getImage("pallett"), math.round(self.pos.x), math.round(self.pos.y), self.size.w, self.size.h, self.rot)
end

-- Functions --
function bullet:setVel(x,y)
	self.vel.x = x
	self.vel.y = y
end

return bullet