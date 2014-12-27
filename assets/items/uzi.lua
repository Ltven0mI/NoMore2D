local gun = {}
gun.name = "Uzi"
gun.desc = "A Sub Machine Gun"
gun.image = "uzi_wood"
gun.size = {w=2,h=2}
gun.itemType = "weapon"
gun.itemClass = "gun"

-- Variables --
gun.fireSpeed = 10

gun.attach = {}
gun.attach.mag = nil
gun.magType = "uzi"

return gun