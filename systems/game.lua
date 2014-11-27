game = {}
game.systemKey = "game"
game.runPriority = 9

-- Variables --
game.player = nil

-- Callbacks --
function game.load()
	game.player = object.new("player")
end

function game.draw()
	if main.debugMode then
		camera.push()
			camera.setMode("screen")
			love.graphics.print(love.timer.getFPS(), 0, 0)
		camera.pop()
	end
end

return game