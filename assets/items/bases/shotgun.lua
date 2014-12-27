local shotgun = {}
shotgun.name = "shotgun"
shotgun.desc = "Shotgun Template"
shotgun.image = ""
shotgun.size = {w=3,h=3}
shotgun.itemType = "weapon"
shotgun.itemClass = "self"

-- Variables --
shotgun.parent = nil
shotgun.acume = 0

shotgun.reloadTime = 1

shotgun.attach = {}
shotgun.shell = nil
shotgun.shells = 0
shotgun.maxShells = 5
shotgun.ammoType = {"slug","buckshot"}

-- Callbacks --
function shotgun:onAttack()
	if self.acume >= self.reloadTime and self.shells >= 1 then
		self.acume = 0
		self:shoot()
	end
end

function shotgun:update(dt)
	self.acume = self.acume + dt
end

-- Functions --
function shotgun:shoot()
	for i=1, self.shell.pallets do
		local holdBul = object.new(self.shell.object)
		if self.parent then holdBul.rot = self.parent.rot + math.random(-self.shell.spread, self.shell.spread) end
		if self.parent then holdBul.pos.x = self.parent.pos.x + self.parent.size/2 - holdBul.size.w/2 end
		if self.parent then holdBul.pos.y = self.parent.pos.y + self.parent.size/2 - holdBul.size.h/2 end
		if self.parent then holdBul.vel.x = self.parent.vel.x end
		if self.parent then holdBul.vel.y = self.parent.vel.y end
	end
	if self.shells then self.shells = self.shells - 1 end
end

return shotgun