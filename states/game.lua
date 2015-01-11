game = {}

-- Variables --
game.player = nil

-- Callbacks --
function game.stateOpen()
	world.loadMap("level_01")
	game.player = object.new("player")
	--object.new("light", 50, 50, 150)
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

	local mx, my = camera.getMouse("screen")
	--debug.log(math.raycast(camera.vWindow.w, camera.vWindow.h, mx, my, camera.vWindow.w, 0, 0, camera.vWindow.h))
end

function game.keypressed(key)
	if key == "escape" then
		state.loadState("menu")
	end
end

return game