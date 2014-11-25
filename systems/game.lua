game = {}
game.systemKey = "game"
game.runPriority = 6

-- Callbacks --
function game.load()
	object.new("player")
end

return game