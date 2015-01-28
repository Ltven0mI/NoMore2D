game = {}

-- Variables --
game.player = nil

-- Callbacks --
function game.stateOpen()
	world.getMap()
	game.player = object.new("player")
end
function game.stateClose()
	world.clearMap()
	if game.player ~= nil then
		object.destroyObject(game.player)
		game.player = nil
	end
end

function game.drawscreen()
	if main.debugMode then
		love.graphics.print(love.timer.getFPS(), 0, 0)
	end
end

function game.keypressed(key)
	if key == "escape" then
		state.loadState("menu")
	end
end

return game