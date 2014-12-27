local gun = {}
gun.name = "AK47"
gun.desc = "A Assault Rifle"
gun.image = "ak47_wood"
gun.size = {w=3,h=3}
gun.itemType = "weapon"
gun.itemClass = "gun"

-- Variables --
gun.fireSpeed = 10

gun.attach = {}
gun.attach.mag = nil
gun.ammoType = "nato"

return gun