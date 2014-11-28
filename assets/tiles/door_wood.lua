door_wood = {}
door_wood.name = "door_wood"
door_wood.imageKey = "door_shut"
door_wood.collision = true
door_wood.collider = {x=0,y=0,w=1,h=0.2}
door_wood.isFloor = false

door_wood.open = false

-- Callbacks --
function door_wood:interact()
	self.open = not self.open
	if self.open then
		self.imageKey = "door_open"
		self.collision = false
	else
		self.imageKey = "door_shut"
		self.collision = true
	end
end

return door_wood