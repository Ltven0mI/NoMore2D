game = {}
game.systemKey = "game"
game.runPriority = 6

-- Variables --
game.player = nil

-- Callbacks --
function game.load()
	game.player = object.new("player")
end

return game