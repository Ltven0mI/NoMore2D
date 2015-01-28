world = {}
world.systemKey = "world"
world.runPriority = {15, 17}

-- Variables --
world.map = nil

-- Callbacks --
function world.load()
	--world.getMap()
end

function world.drawworld()
	if world.map then
		if loader.curPri == world.runPriority[1] then
			for y=1, world.map.size do
				for x=1, world.map.size do
					if world.map.tiles[y][x] ~= 0 then
						local ts = tile.tileSize
						love.graphics.setColor(255, 255, 255, 255)
						ui.draw(image.getImage("grass_01"), x*ts, y*ts, ts, ts)
					end
				end
			end
		end

		if loader.curPri == world.runPriority[2] then
			for y=1, world.map.size do
				for x=1, world.map.size do
					if world.map.object[y][x] ~= 0 then
						local ts = tile.tileSize
						love.graphics.setColor(255, 255, 255, 255)
						ui.draw(image.getImage("pallett"), x*ts, y*ts, ts, ts)
					end
				end
			end
		end
	end
end

-- Functions --
function world.getMap()
	world.map = {size=10}
	world.getMapTiles()
	world.getMapObjects()
end

function world.getMapObjects()
	world.map.object = {}
	for y=1, world.map.size do
		world.map.object[y] = {}
		for x=1, world.map.size do
			world.map.object[y][x] = math.random(0,1)
		end
	end
end

function world.getMapTiles()
	world.map.tiles = {}
	for y=1, world.map.size do
		world.map.tiles[y] = {}
		for x=1, world.map.size do
			world.map.tiles[y][x] = 1
		end
	end
end

function world.clearMap()
	world.map = nil
end

function world.checkMap()

end

return world