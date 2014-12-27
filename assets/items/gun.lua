local gun = {}
gun.name = "gun"
gun.desc = "Gun Template"
gun.image = "gun"
gun.size = {w=2,h=2}
gun.itemType = "weapon"
gun.itemClass = "self"

-- Variables --
gun.parent = nil
gun.acume = 0

gun.fireSpeed = 10

gun.attach = {}
gun.attach.mag = nil
gun.magType = "nato"

-- Callbacks --
function gun:attack()
	local dt = love.timer.getDelta()
	self.acume = self.acume + dt
	if self.acume >= 1/self.fireSpeed and self.attach and self.attach.mag and self.attach.mag.rounds >= 1 then
		self.acume = 0
		self:shoot()
	end
end

-- Functions --
function gun:setMag(arg)
	if arg then
		local holdMag = nil
		if type(arg) == "table" then
			holdMag = arg
		else
			holdMag = item.cloneItem(arg)
		end
		if holdMag and holdMag.roundType == self.magType then
			self.attach.mag = holdMag
		end
	end
end

function gun:shoot()
	local holdBul = object.new("bullet")
	if self.parent then holdBul.rot = self.parent.rot end
	if self.parent then holdBul.pos.x = self.parent.pos.x + self.parent.size/2 - holdBul.size.w/2 end
	if self.parent then holdBul.pos.y = self.parent.pos.y + self.parent.size/2 - holdBul.size.h/2 end
	if self.parent then holdBul.vel.x = self.parent.vel.x end
	if self.parent then holdBul.vel.y = self.parent.vel.y end
	if self.attach and self.attach.mag then self.attach.mag.rounds = self.attach.mag.rounds - 1 end
end

return gun