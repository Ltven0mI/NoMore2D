local gun = {}
gun.name = "LMG"
gun.desc = "A Light Machine Gun"
gun.image = "lmg_empty"
gun.size = {w=3,h=3}
gun.itemType = "weapon"
gun.itemClass = "gun"

-- Variables --
gun.fireSpeed = 10

gun.attach = {}
gun.attach.mag = nil
gun.ammoType = {["nato_box"]="lmg_nato",["flame_box"]="lmg_flame",[""]="lmg_empty"}

return gun