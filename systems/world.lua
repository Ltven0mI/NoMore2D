world = {}
world.systemKey = "world"
world.runPriority = {15,17}

-- Variables --
world.map = {}
world.vignette = nil
world.lastUpdate = 0

-- Callbacks --
function world.load()
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
			local player = game.player
			local cs = camera.getScale()
			local sx, sy, ex, ey = math.floor(math.clamp(cx/ts+1, 1, w)), math.floor(math.clamp(cy/ts+1, 1, h)), math.floor((cx+main.width/cs)/(ts))+1, math.floor((cy+main.height/cs)/(ts))+1
			local holdTime = love.timer.getTime()
			local holdLast = world.lastUpdate

			for y=sy, ey do
				for x=sx, ex do
					-- Update Tiles
					local holdTile
					for i=1, 3 do
						if i == 1 then if map.tiles.floor[y] and map.tiles.floor[y][x] then holdTile = map.tiles.floor[y][x] end end
						if i == 2 then if map.tiles.wall[y] and map.tiles.wall[y][x] then holdTile = map.tiles.wall[y][x] end end
						if i == 3 then if map.tiles.roof[y] and map.tiles.roof[y][x] then holdTile = map.tiles.roof[y][x] end end
						if holdTile then
							if holdTile.ignore == nil then holdTile.ignore = {} end
							local ct = holdTile.ignore.curTime or 0
							local dtt
							local tileset = holdTile.tileset
							if tileset and tileset.x and tileset.y and (tileset.x > 1 or tileset.y > 1) and holdTile.speed and holdTile.playback then
								local setX, setY = tileset.x, tileset.y
								local pb = holdTile.playback or "loop"
								local time = 1/holdTile.speed
								local tx, ty
								if holdTile.ignore.lastU then dtt = holdLast - holdTile.ignore.lastU else dtt = 0 end
								if holdTile.ignore.lastPlayback == nil then holdTile.ignore.lastPlayback = pb end
								if pb ~= "stop" then
									if holdTile.ignore.lastPlayback ~= pb then
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
												ct = ct + sub; holdTile.ignore.curTime = holdTile.ignore.curTime + sub
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
												ct = ct - sub; holdTile.ignore.curTime = holdTile.ignore.curTime - sub
											end
										end
									end
									local hct = ct
									ty = math.ceil((math.floor(hct/time)+1)/setX)
									tx = (math.floor(hct/time)+1)-((ty-1)*setX)
									tileset.tx, tileset.ty = tx, ty
									if pb == "reverseplay" or pb == "reverseloop" then
										holdTile.ignore.curTime = ct - dtt
									else
										holdTile.ignore.curTime = ct + dtt
									end
								end
							end
							holdTile.ignore.lastU = holdLast
							holdTile.ignore.lastPlayback = holdTile.playback
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
			local cs = camera.getScale()
			local sx, sy, ex, ey = math.floor(math.clamp(cx/ts+1, 1, w)), math.floor(math.clamp(cy/ts+1, 1, h)), math.floor((cx+main.width/cs)/(ts))+1, math.floor((cy+main.height/cs)/(ts))+1

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
								if tileset and tileset.quads and tileset.quads and tileset.quads[tileset.ty] and tileset.quads[tileset.ty][tileset.tx] then drawQuad = tileset.quads[tileset.ty][tileset.tx] end
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
								if tileset and tileset.quads and tileset.quads and tileset.quads[tileset.ty] and tileset.quads[tileset.ty][tileset.tx] then drawQuad = tileset.quads[tileset.ty][tileset.tx] end
								if pri == world.runPriority[2] then
									if drawQuad then
										ui.draw({image.getImage(holdTile.imageKey), drawQuad}, (x-1)*ts, (y-1)*ts, ts*tileset.x, ts*tileset.y)
									else
										ui.draw(image.getImage(holdTile.imageKey), (x-1)*ts, (y-1)*ts, ts, ts)
									end
								end
							end
						end
						-- Draw Roof Tiles
						if map.tiles.roof[y] and map.tiles.roof[y][x] then
							local holdTile = map.tiles.roof[y][x]
							if holdTile.drawable then
								local drawQuad
								local tileset = holdTile.tileset
								if tileset and tileset.quads and tileset.quads and tileset.quads[tileset.ty] and tileset.quads[tileset.ty][tileset.tx] then drawQuad = tileset.quads[tileset.ty][tileset.tx] end
								if pri == world.runPriority[2] then
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
						if map.tiles.floor[y][x] and map.tiles.floor[y][x].tileset then 
							local checkTile = tile.getTile(map.tiles.floor[y][x].name)
							if checkTile and checkTile.tileset and checkTile.tileset.quads then map.tiles.floor[y][x].tileset.quads = checkTile.tileset.quads end
						end
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
						if map.tiles.wall[y][x] and map.tiles.wall[y][x].tileset then 
							local checkTile = tile.getTile(map.tiles.wall[y][x].name)
							if checkTile and checkTile.tileset and checkTile.tileset.quads then map.tiles.wall[y][x].tileset.quads = checkTile.tileset.quads end
						end
					end
					-- Load Roof Tiles
					if map.tiles.roof[y] and map.tiles.roof[y][x] then
						local holdTile = map.tiles.roof[y][x]
						if type(holdTile) == "number" then
							if holdTile ~= 0 then
								map.tiles.roof[y][x] = tile.cloneTile(holdTile)
							else
								map.tiles.roof[y][x] = nil
							end
						elseif type(holdTile) == "table" then
							map.tiles.roof[y][x] = tile.cloneTile(holdTile)
						end
						if map.tiles.roof[y][x] and map.tiles.roof[y][x].tileset then 
							local checkTile = tile.getTile(map.tiles.roof[y][x].name)
							if checkTile and checkTile.tileset and checkTile.tileset.quads then map.tiles.roof[y][x].tileset.quads = checkTile.tileset.quads end
						end
					end
				end
			end
			world.map = map
		end
	else
		debug.log("[ERROR] Incorrect call to function 'world.loadMap(key)'")
	end
end

function world.saveMap(key,map)
	if key then
		local holdMap = nil
		if map == nil then map = world.map end

		if map then
			if world.checkMap(map) then
				local w, h = map.size.w, map.size.h
				local ts = tile.tileSize
				local cx, cy = camera.getPos()

				holdMap = {}
				holdMap.size = {w=w,h=h}
				holdMap.tiles = {}
				holdMap.tiles.floor = {}
				holdMap.tiles.wall = {}
				holdMap.tiles.roof = {}

				for y=1, h do
					holdMap.tiles.floor[y] = {}
					holdMap.tiles.wall[y] = {}
					holdMap.tiles.roof[y] = {}
					for x=1, w do
						if map.tiles.floor[y] and map.tiles.floor[y][x] then
							local holdTile = map.tiles.floor[y][x]
							local holdCheckTile = tile.getTile(holdTile.id)
							if holdCheckTile and holdTile then
								if compareTables(holdTile, holdCheckTile, {"ignore", "quads"}) then
									holdMap.tiles.floor[y][x] = holdTile.id
								else
									holdMap.tiles.floor[y][x] = holdTile
								end
							end
						else
							holdMap.tiles.floor[y][x] = 0
						end
						if map.tiles.wall[y] and map.tiles.wall[y][x] then
							local holdTile = map.tiles.wall[y][x]
							local holdCheckTile = tile.getTile(holdTile.id)
							if holdCheckTile and holdTile then
								if compareTables(holdTile, holdCheckTile, {"ignore", "quads"}) then
									holdMap.tiles.wall[y][x] = holdTile.id
								else
									holdMap.tiles.wall[y][x] = holdTile
								end
							end
						else
							holdMap.tiles.wall[y][x] = 0
						end
						if map.tiles.roof[y] and map.tiles.roof[y][x] then
							local holdTile = map.tiles.roof[y][x]
							local holdCheckTile = tile.getTile(holdTile.id)
							if holdCheckTile and holdTile then
								if compareTables(holdTile, holdCheckTile, {"ignore", "quads"}) then
									holdMap.tiles.roof[y][x] = holdTile.id
								else
									holdMap.tiles.roof[y][x] = holdTile
								end
							end
						else
							holdMap.tiles.roof[y][x] = 0
						end
					end
				end
			end
		end

		local str = tableToString(holdMap, {"ignore", "quads"})
		if str then
			love.filesystem.write("/assets/maps/"..key..".lua", "return "..str)
		end
	else
		debug.log("[ERROR] Incorrect call to function 'world.saveMap(key,map)'")
	end
end

function world.genWorld(w,h)
	local map = {}
	map.size = {w=w,h=h}
	map.tiles = {}
	map.tiles.floor = {}
	map.tiles.wall = {}
	map.tiles.roof = {}
	for y=1, h do
		map.tiles.floor[y] = {}
		map.tiles.wall[y] = {}
		map.tiles.roof[y] = {}
		for x=1, w do
			map.tiles.floor[y][x] = 1
			map.tiles.wall[y][x] = 0--math.random(0,2)*(tile.tileCount-1)
			map.tiles.roof[y][x] = 0
		end
	end
	world.loadMap(map)
end

function world.clearMap()
	if world.map ~= nil then
		world.map = nil
	end
end

function world.checkMap(map)
	if map then
		if map.size and map.size.w and map.size.h and map.tiles and map.tiles.floor and map.tiles.wall and map.tiles.roof then return true else return false end
	else
		debug.log("[ERROR] Incorrect call to function 'world.checkMap(map)'")
	end
end

function world.getTile(x,y,l)
	if x and y then
		if l == nil then l = "floor" end
		local holdTile = nil
		local ts = tile.tileSize
		local map = world.map
		x, y = math.ceil(x/ts), math.ceil(y/ts)
		if map and x > 0 and x <= map.size.w and y > 0 and y <= map.size.h then
			if l == "floor" then
				if map.tiles.floor[y] and map.tiles.floor[y][x] then holdTile = map.tiles.floor[y][x] end
			elseif l == "wall" then
				if map.tiles.wall[y] and map.tiles.wall[y][x] then holdTile = map.tiles.wall[y][x] end
			elseif l == "roof" then
				if map.tiles.roof[y] and map.tiles.roof[y][x] then holdTile = map.tiles.roof[y][x] end
			end
		end
		return holdTile
	else
		debug.log("[ERROR] Incorrect call to function 'world.getTile(x,y,l)'")
	end
end

function world.setTile(x,y,key,l)
	if x and y and key then
		if l == nil then l = "floor" end
		if x > 0 and y > 0 and x <= world.map.size.w and y <= world.map.size.h then
			local holdTile = nil
			if key ~= "" then holdTile = tile.cloneTile(key) end
			if holdTile or key == "" then
				local map = world.map
				if map then
					if world.checkMap(map) and map.tiles then
						if l == "floor" then
							if map.tiles.floor[y] then
								map.tiles.floor[y][x] = holdTile
							end
						elseif l == "wall" then
							if map.tiles.wall[y] then
								map.tiles.wall[y][x] = holdTile
							end
						elseif l == "roof" then
							if map.tiles.roof[y] then
								map.tiles.roof[y][x] = holdTile
							end
						end
						return holdTile
					end
				end
			end
		else
			debug.log("[WARNING] Arguments 'x' and 'y' in call to function 'world.setTile(x,y,key,l)' are outside of the map bounds")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'world.setTile(x,y,key,l)'")
	end
end

return world