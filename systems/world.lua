world = {}
world.systemKey = "world"
world.runPriority = {6,8}

-- Variables --
world.map = {}
world.vignette = nil
world.lastUpdate = 0

-- Callbacks --
function world.load()
	world.genWorld(300,300)
	--world.loadMap("level_01")

	world.vignette = image.getImage("vignette")
	world.vignette:setFilter("linear")

	world.vignetteShader = love.graphics.newShader [[
		vec4 effect ( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
			return vec4(0.0,0.0,0.0,-Texel(texture, texture_coords).r+0.99);
		}
	]]
end

function world.update(dt)
	local map = world.map
	if map then
		if world.checkMap(map) then
			local w, h = map.size.w, map.size.h
			local ts = tile.tileSize
			local cx, cy = camera.getPos()
			local sx, sy, ex, ey = math.floor(math.clamp(cx/ts+1, 1, w)), math.floor(math.clamp(cy/ts+1, 1, h)), math.floor(math.clamp((cx+main.width)/ts+1, 1, w)), math.floor(math.clamp((cy+main.height)/ts+1, 1, h))
			local holdTime = love.timer.getTime()
			local holdLast = world.lastUpdate

			for y=sy, ey do
				for x=sx, ex do
					-- Update Tiles
					local holdTile
					for i=1, 2 do
						if i == 1 then if map.tiles.floor[y] and map.tiles.floor[y][x] then holdTile = map.tiles.floor[y][x] end end
						if i == 2 then if map.tiles.wall[y] and map.tiles.wall[y][x] then holdTile = map.tiles.wall[y][x] end end
						if holdTile then
							local ct = holdTile.curTime or 0
							local dtt
							local tileset = holdTile.tileset
							if tileset and tileset.x and tileset.y and (tileset.x > 1 or tileset.y > 1) and holdTile.speed and holdTile.playback then
								local setX, setY = tileset.x, tileset.y
								local pb = holdTile.playback or "loop"
								local time = 1/holdTile.speed
								local tx, ty
								if holdTile.lastU then dtt = holdLast - holdTile.lastU else dtt = 0 end
								if holdTile.lastPlayback == nil then holdTile.lastPlayback = pb end
								if pb ~= "stop" then
									if holdTile.lastPlayback ~= pb then
										if pb == "start" then ct = 0 end
										if pb == "reversestart" then ct = (setX*setY-1)*time end
									end
									if pb == "reverseplay" or pb == "reversestart" or pb == "reverseloop" then
										if ct < 0 then
											if pb == "reverseplay" or pb == "reversestart" then
												holdTile.playback = "stop"
												ct = 0
											end
											while ct < 0 do
												local sub = (setX*setY)*time
												ct = ct + sub; holdTile.curTime = holdTile.curTime + sub
											end
										end
									else
										if ct > (setX*setY)*time then
											if pb == "play" or pb == "start" then
												holdTile.playback = "stop"
												ct = (setX*setY-1)*time
											end
											while ct > (setX*setY)*time do
												local sub = (setX*setY)*time
												ct = ct - sub; holdTile.curTime = holdTile.curTime - sub
											end
										end
									end
									local hct = ct
									ty = math.ceil((math.floor(hct/time)+1)/setX)
									tx = (math.floor(hct/time)+1)-((ty-1)*setX)
									tileset.tx, tileset.ty = tx, ty
									if pb == "reverseplay" or pb == "reverseloop" then
										holdTile.curTime = ct - dtt
									else
										holdTile.curTime = ct + dtt
									end
								end
							end
							holdTile.lastU = holdLast
							holdTile.lastPlayback = holdTile.playback
						end
					end
				end
			end
		end
	end
	world.lastUpdate = love.timer.getTime()
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

			ui.push()
				ui.setMode("world")
				for y=sy, ey do
					for x=sx, ex do
						-- Draw Floor Tiles
						if map.tiles.floor[y] and map.tiles.floor[y][x] then
							local holdTile = map.tiles.floor[y][x]
							if holdTile.drawable then
								local drawQuad
								local tileset = holdTile.tileset
								if tileset and tileset.tiles and tileset.tiles and tileset.tiles[tileset.ty] and tileset.tiles[tileset.ty][tileset.tx] then drawQuad = tileset.tiles[tileset.ty][tileset.tx] end
								if pri == world.runPriority[1] then
									if drawQuad then
										ui.draw({image.getImage(holdTile.imageKey), drawQuad}, (x-1)*ts, (y-1)*ts, ts*tileset.x, ts*tileset.y)
									else
										ui.draw(image.getImage(holdTile.imageKey), (x-1)*ts, (y-1)*ts, ts, ts)
									end
								end
							end
						end
						-- Draw Wall Tiles
						if map.tiles.wall[y] and map.tiles.wall[y][x] then
							local holdTile = map.tiles.wall[y][x]
							if holdTile.drawable then
								local drawQuad
								local tileset = holdTile.tileset
								if tileset and tileset.tiles and tileset.tiles and tileset.tiles[tileset.ty] and tileset.tiles[tileset.ty][tileset.tx] then drawQuad = tileset.tiles[tileset.ty][tileset.tx] end
								if pri == world.runPriority[1] then
									if drawQuad then
										ui.draw({image.getImage(holdTile.imageKey), drawQuad}, (x-1)*ts, (y-1)*ts, ts*tileset.x, ts*tileset.y)
									else
										ui.draw(image.getImage(holdTile.imageKey), (x-1)*ts, (y-1)*ts, ts, ts)
									end
								end
							end
						end
					end
				end
			ui.pop()
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
			map.tiles.floor[y][x] = math.random(1,2)
			map.tiles.wall[y][x] = math.random(0,2)*tile.tileCount
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