local bullet = {}
bullet.name = "buckshot"

bullet.pos = {x=0,y=0}
bullet.vel = {x=0,y=0}
bullet.rot = 0
bullet.size = {w=15,h=60}
bullet.speed = 1200
bullet.life = 1
bullet.curLife = 0
bullet.damage = 30

bullet.doDestroy = false

-- Callbacks --
function bullet:update(dt)
	local velx, vely = math.sin(math.rad(self.rot))*self.speed, -math.cos(math.rad(self.rot))*self.speed
	local bool, hx, hy, obj = world.raycast(self.pos.x, self.pos.y, self.rot-90, math.clamp(self.speed*dt*3, 10, math.huge))
	if bool then
		self.doDestroy = true
		if obj then if obj.attackObject then obj:attackObject(self.damage) end end
	end
	self.pos.x = self.pos.x + (self.vel.x+velx)*dt
	self.pos.y = self.pos.y + (self.vel.y+vely)*dt
	self.curLife = self.curLife + dt
	if self.curLife >= self.life then object.destroyObject(self) end
end

function bullet:drawworld()
	ui.draw(image.getImage("bullet_02"), math.round(self.pos.x-self.size.w/2), math.round(self.pos.y-self.size.h/2), self.size.w, self.size.h, self.rot)
	if self.doDestroy then self:destroy() end
end

-- Functions --
function bullet:setVel(x,y)
	self.vel.x = x
	self.vel.y = y
end

function bullet:destroy()
	object.destroyObject(self)
end

return bullet