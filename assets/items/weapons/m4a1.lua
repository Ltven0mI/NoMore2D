local gun = {}
gun.name = "m4a1"
gun.desc = "A Assault Rifle"
gun.image = "m4a1_metal_empty"
gun.size = {w=3,h=3}
gun.itemType = "weapon"
gun.itemClass = "gun"

-- Variables --
gun.fireSpeed = 13

gun.attach = {}
gun.attach.mag = nil
gun.ammoType = {["nato"]="m4a1_metal_nato",[""]="m4a1_metal_empty"}

return gun