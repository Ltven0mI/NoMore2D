gun = {}
gun.name = "gun"

gun.fireSpeed = 10
gun.acume = 0

gun.parent = nil

-- Callbacks --
function gun:attack()
	local dt = love.timer.getDelta()
	self.acume = self.acume + dt
	if self.acume >= 1/self.fireSpeed then
		self.acume = self.acume - 1/self.fireSpeed
		self:shoot()
	end
end

-- Functions --
function gun:shoot()
	local holdBul = object.new("bullet")
	if self.parent then holdBul.rot = self.parent.rot end
	if self.parent then holdBul.pos.x = self.parent.pos.x + self.parent.size/2 - holdBul.size.w/2 end
	if self.parent then holdBul.pos.y = self.parent.pos.y + self.parent.size/2 - holdBul.size.h/2 end
end

return gun