grass_flat = {}
grass_flat.name = "grass_flat"
grass_flat.imageKey = "grass_flat"
grass_flat.collision = true

-- Functions --
function grass_flat:interact()
	self.collision = not self.collision
end

return grass_flat