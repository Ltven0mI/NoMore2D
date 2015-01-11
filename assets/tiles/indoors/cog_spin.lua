local tile = {}
tile.name = "cog_spin"
tile.imageKey = "cog_spin"

tile.tileset = {x=1,y=4}
tile.speed = 10
tile.playback = "loop"
tile.collision = true

tile.cc = true

-- Callbacks --
function tile:interact()
	self.cc = not self.cc
	if self.cc then
		self.playback = "loop"
	else
		self.playback = "reverseloop"
	end
end

return tile