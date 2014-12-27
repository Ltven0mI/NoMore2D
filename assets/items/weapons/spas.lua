local shotgun = {}
shotgun.name = "Spas"
shotgun.desc = "A Shotgun"
shotgun.image = "spas_metal"
shotgun.size = {w=3,h=3}
shotgun.itemType = "weapon"
shotgun.itemClass = "shotgun"

-- Variables --
shotgun.reloadTime = 1

shotgun.attach = {}
shotgun.shell = nil
shotgun.shells = 0
shotgun.maxShells = 6
shotgun.ammoType = {"buckshot","slug"}

return shotgun