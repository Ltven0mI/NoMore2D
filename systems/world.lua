world = {}
world.systemKey = "world"
world.runPriority = 6

-- Variables --
world.map = {}

-- Callbacks --
function world.load()
	world.loadMap("test")
end

function world.draw()
	if world.checkMap(world.map) then
		local map = world.map
		local w, h = map.size.w, map.size.h
		for y=1, h do
			for x=1, w do
				if map.tiles[y] and map.tiles[y][x] then
					local id = map.tiles[y][x]
					local ts = tiles.tileSize
					if id == 1 then love.graphics.rectangle("fill", (x-1)*ts, (y-1)*ts, ts, ts) end
				end
			end
		end
	end
end

-- Functions --
function world.loadMap(key)
	world.map = require("/maps/"..key)
end

function world.checkMap(map)
	if map then
		if map.size and map.size.w and map.size.h and map.tiles then return true else return false end
	else
		debug.log("[ERROR] Incorrect call to function 'world.checkMap(map)'")
	end
end

return world