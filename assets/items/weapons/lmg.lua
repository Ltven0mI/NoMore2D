local gun = {}
gun.name = "LMG"
gun.desc = "A Light Machine Gun"
gun.image = "lmg_nato"
gun.size = {w=3,h=3}
gun.itemType = "weapon"
gun.itemClass = "gun"

-- Variables --
gun.fireSpeed = 10

gun.attach = {}
gun.attach.mag = nil
gun.ammoType = {"nato_box","flame_box"}

-- Function --
function gun:updateMag()
	if self.attach and self.attach.mag then
		if self.attach.mag.roundType == "nato_box" then
			self.image = "lmg_nato"
		elseif self.attach.mag.roundType == "flame_box" then
			self.image = "lmg_flame"
		end
	end
end

return gun