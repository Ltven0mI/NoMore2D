local door_wood = {}
door_wood.name = "door_wood"
door_wood.imageKey = "door_wood"
door_wood.collision = true
door_wood.collider = {x=0,y=0,w=1,h=0.2}

door_wood.tileset = {x=1,y=3}
door_wood.playback = "reverseplay"
door_wood.speed = 10

door_wood.open = false

-- Callbacks --
function door_wood:interact()
	self.open = not self.open
	if self.open then
		self.collision = false
		self.playback = "play"
	else
		self.collision = true
		self.playback = "reverseplay"
	end
end

return door_wood