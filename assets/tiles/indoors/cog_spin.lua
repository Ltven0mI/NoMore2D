cog_spin = {}
cog_spin.name = "cog_spin"
cog_spin.imageKey = "cog_spin"

cog_spin.tileSheet = {x=1,y=4}
cog_spin.speed = 10
cog_spin.playback = "loop"
cog_spin.collision = true

cog_spin.cc = true

-- Callbacks --
function cog_spin:interact()
	self.cc = not self.cc
	if self.cc then
		self.playback = "loop"
	else
		self.playback = "reverseloop"
	end
end

return cog_spin