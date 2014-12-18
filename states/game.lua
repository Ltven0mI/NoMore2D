game = {}

-- Variables --
game.player = nil

-- Callbacks --
function game.stateOpen()
	world.genWorld(10,10)
	game.player = object.new("player")
end
function game.stateClose()
	world.clearMap()
	if game.player ~= nil then
		object.destroyObject(game.player)
		game.player = nil
	end
end

function game.draw()
	if main.debugMode then
		camera.push()
			camera.setMode("screen")
			love.graphics.print(love.timer.getFPS(), 0, 0)
		camera.pop()
	end
end

function game.keypressed(key)
	if key == "escape" then
		state.loadState("menu")
	end
end

return game