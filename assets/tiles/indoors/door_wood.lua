local tile = {}
tile.name = "door_wood"
tile.imageKey = "door_wood"
tile.collision = true
tile.collider = {x=0,y=0,w=1,h=0.2}

tile.tileset = {x=1,y=3}
tile.playback = "reverseplay"
tile.speed = 10

tile.open = false

-- Callbacks --
function tile:interact()
	self.open = not self.open
	if self.open then
		self.collision = false
		self.playback = "play"
	else
		self.collision = true
		self.playback = "reverseplay"
	end
end

return tile