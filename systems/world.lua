world = {}
world.systemKey = "world"
world.runPriority = {6,8}

-- Variables --
world.map = {}
world.vignette = nil

-- Callbacks --
function world.load()
	world.genWorld(300,300)

	world.vignette = image.getImage("vignette")
	world.vignette:setFilter("linear")

	world.vignetteShader = love.graphics.newShader [[
		vec4 effect ( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
			return vec4(0.0,0.0,0.0,-Texel(texture, texture_coords).r+0.99);
		}
	]]
end

function world.draw()
	local pri = loader.getPriority()
	local map = world.map
	if map then
		if world.checkMap(map) then
			local w, h = map.size.w, map.size.h
			local ts = tile.tileSize
			local cx, cy = camera.getPos()
			local sx, sy, ex, ey = math.floor(math.clamp(cx/ts+1, 1, w)), math.floor(math.clamp(cy/ts+1, 1, h)), math.floor(math.clamp((cx+main.width)/ts+1, 1, w)), math.floor(math.clamp((cy+main.height)/ts+1, 1, h))

			for y=sy, ey do
				for x=sx, ex do
					-- Draw Floor Tiles
					if map.tiles.floor[y] and map.tiles.floor[y][x] then
						local holdTile = map.tiles.floor[y][x]
						if holdTile.drawable then
							if pri == world.runPriority[1] then
								ui.push()
									ui.setMode("world")
									ui.draw(image.getImage(holdTile.imageKey), (x-1)*ts, (y-1)*ts, ts, ts)
								ui.pop()
							end
						end
					end
					-- Draw Wall Tiles
					if map.tiles.wall[y] and map.tiles.wall[y][x] then
						local holdTile = map.tiles.wall[y][x]
						if holdTile.drawable then
							if pri == world.runPriority[2] then
								ui.push()
									ui.setMode("world")
									ui.draw(image.getImage(holdTile.imageKey), (x-1)*ts, (y-1)*ts, ts, ts)
									if main.colDebug == true then
										local col = holdTile.collider
										if holdTile.collision then love.graphics.setColor(255,0,50,100) else love.graphics.setColor(0,0,255,100) end
										love.graphics.rectangle("fill", (x-1)*ts+ts*col.x, (y-1)*ts+ts*col.y, ts*col.w, ts*col.h)
									end
								ui.pop()
							end
						end
					end
				end
			end
			if pri == world.runPriority[2] then
				ui.push()
					ui.setMode("screen")
					love.graphics.setShader(world.vignetteShader)
						ui.draw(image.getImage("vignette"),0,0,main.width,main.height)
					love.graphics.setShader()
				ui.pop()
			end
		end
	end
end

-- Functions --
function world.loadMap(key)
	if key then
		local map = nil
		if type(key) == "string" then
			map = require("/assets/maps/"..key)
		elseif type(key) == "table" then
			map = key
		end

		if world.checkMap(map) then
			local w, h = map.size.w, map.size.h
			for y=1, h do
				for x=1, w do
					-- Load Floor Tiles
					if map.tiles.floor[y] and map.tiles.floor[y][x] then
						local holdTile = map.tiles.floor[y][x]
						if type(holdTile) == "number" then
							if holdTile ~= 0 then
								map.tiles.floor[y][x] = tile.cloneTile(holdTile)
							else
								map.tiles.floor[y][x] = nil
							end
						elseif type(holdTile) == "table" then
							map.tiles.floor[y][x] = tile.cloneTile(holdTile)
						end
						if map.tiles.floor[y][x] then map.tiles.floor[y][x].isFloor = true end
					end
					-- Load Wall Tiles
					if map.tiles.wall[y] and map.tiles.wall[y][x] then
						local holdTile = map.tiles.wall[y][x]
						if type(holdTile) == "number" then
							if holdTile ~= 0 then
								map.tiles.wall[y][x] = tile.cloneTile(holdTile)
							else
								map.tiles.wall[y][x] = nil
							end
						elseif type(holdTile) == "table" then
							map.tiles.wall[y][x] = tile.cloneTile(holdTile)
						end
						if map.tiles.wall[y][x] then map.tiles.wall[y][x].isFloor = false end
					end
				end
			end
			world.map = map
		end
	else
		debug.log("[ERROR] Incorrect call to function 'world.loadMap(key)'")
	end
end

function world.genWorld(w,h)
	local map = {}
	map.size = {w=w,h=h}
	map.tiles = {}
	map.tiles.floor = {}
	map.tiles.wall = {}
	for y=1, h do
		map.tiles.floor[y] = {}
		map.tiles.wall[y] = {}
		for x=1, w do
			map.tiles.floor[y][x] = math.random(0,tile.tileCount)
			map.tiles.wall[y][x] = math.random(0,tile.tileCount)
		end
	end
	world.loadMap(map)
end

function world.checkMap(map)
	if map then
		if map.size and map.size.w and map.size.h and map.tiles and map.tiles.floor and map.tiles.wall then return true else return false end
	else
		debug.log("[ERROR] Incorrect call to function 'world.checkMap(map)'")
	end
end

function world.getTile(x,y,f)
	if x and y then
		if f == nil then f = false end
		local holdTile = nil
		local ts = tile.tileSize
		local map = world.map
		x, y = math.ceil(x/ts), math.ceil(y/ts)
		if map and x > 0 and x <= map.size.w and y > 0 and y <= map.size.h then
			if f then
				if map.tiles.floor[y] and map.tiles.floor[y][x] then holdTile = map.tiles.floor[y][x] end
			else
				if map.tiles.wall[y] and map.tiles.wall[y][x] then holdTile = map.tiles.wall[y][x] end
			end
		end
		return holdTile
	else
		debug.log("[ERROR] Incorrect call to function 'world.getTile(x,y,f)'")
	end
end

return world