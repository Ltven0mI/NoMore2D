world = {}
world.systemKey = "world"
world.runPriority = 6

-- Variables --
world.map = {}
world.rd = 100 --RenderDistance

-- Callbacks --
function world.load()
	world.loadMap("level_01")

	world.rdShader = love.graphics.newShader [[
		vec4 effect ( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
			return vec4(0.0,0.0,0.0,-Texel(texture, texture_coords).r+0.99);
		}
	]]
end

function world.draw()
	if world.checkMap(world.map) then
		local map = world.map
		local w, h = map.size.w, map.size.h
		local ts = tile.tileSize
		local cx, cy = camera.getPos()
		for y=1, h do
			for x=1, w do
				if map.tiles[y] and map.tiles[y][x] then
					local holdTile = map.tiles[y][x]
					if holdTile.image and holdTile.drawable then
						ui.push()
							ui.setMode("world")
							ui.draw(holdTile.image, (x-1)*ts, (y-1)*ts, ts, ts)
						ui.pop()
					end
				end
			end
		end
		ui.push()
			ui.setMode("screen")
			love.graphics.setShader(world.rdShader)
				ui.draw(image.getImage("rendisteffect"),0,0,main.width,main.height)
			love.graphics.setShader()
		ui.pop()
	end
end

-- Functions --
function world.loadMap(key)
	local map = require("/assets/maps/"..key)
	if world.checkMap(map) then
		local w, h = map.size.w, map.size.h
		for y=1, h do
			for x=1, w do
				if map.tiles[y] and map.tiles[y][x] then
					local holdTile = map.tiles[y][x]
					if type(holdTile) == "number" then
						map.tiles[y][x] = tile.cloneTile(holdTile)
					end
				end
			end
		end
		world.map = map
	end
end

function world.checkMap(map)
	if map then
		if map.size and map.size.w and map.size.h and map.tiles then return true else return false end
	else
		debug.log("[ERROR] Incorrect call to function 'world.checkMap(map)'")
	end
end

return world