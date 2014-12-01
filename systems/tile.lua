tile = {}
tile.systemKey = "tile"
tile.runPriority = 4

-- Variables --
tile.tileSize = 40
tile.tiles = {}
tile.tileCount = 0

tile.unsortedTiles = {}

-- Callbacks --
function tile.load()
	tile.getTiles("/assets/tiles")
	tile.addTiles()
end

function tile.resize(w,h)
	tile.tileSize = math.floor(((w+h)/43.75)/2)*2
end

-- Functions --
function tile.cloneTile(key)
	if key then
		if type(key) == "number" or type(key) == "string" then
			if tile.tiles[key] then
				local holdTile = tile.tiles[key]
				local newTile = cloneTable(holdTile, {"function"})
				setmetatable(newTile, { __index = holdTile })
				return newTile
			else
				debug.log("[WARNING] No tile with key '"..key.."'")
			end
		elseif type(key) == "table" then
			local holdTile = key
			local newTile = cloneTable(holdTile, {"function"})
			setmetatable(newTile, { __index = holdTile })
			return newTile
		end
	else
		debug.log("[ERROR] Incorrect call to function 'tile.cloneTile(key)'")
	end
end

function tile.addTiles()
	tile.addTile("grass_01")
	tile.addTile("dirt_01")
	tile.addTile("check_bw")
	tile.addTile("tile_flat_w")
	tile.addTile("door_wood")
	tile.addTile("cog_spin")
end

function tile.addTile(key)
	if key then
		local holdTile = tile.unsortedTiles[key]
		if holdTile then
			tile.tileCount = tile.tileCount + 1
			tile.tiles[tile.tileCount] = holdTile
			tile.tiles[key] = holdTile
		else
			debug.log("[WARNING] No existing tile with the key '"..key.."'")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'tile.addTile(key)'")
	end
end

function tile.getTileSheet(t)
	if t then
		local sheet = t.tileSheet
		if sheet and type(sheet) == "table" and sheet.x and sheet.y and (sheet.x > 1 or sheet.y > 1) then
			local img = image.getImage(t.imageKey)
			local iw, ih = img:getWidth(), img:getHeight()
			local pw, ph = math.floor(iw/sheet.x), math.floor(ih/sheet.y)
			sheet.tiles = {}
			for y=1, sheet.y do
				sheet.tiles[y] = {}
				for x=1, sheet.x do
					sheet.tiles[y][x] = love.graphics.newQuad(pw*(x-1), ph*(y-1), pw, ph, iw, ih)
				end
			end
		end
	else
		debug.log("[ERROR] Incorrect call to function 'tile.getTileSheet(t)'")
	end
end

function tile.getTiles(dir,isrepeat,tiles)
	if dir then
		if isrepeat == nil then isrepeat = false end
		if not tiles then tiles = {} end

		local files = love.filesystem.getDirectoryItems(dir)
		local lng = table.getn(files)
		for i=1, lng do
			local item = string.lower(files[i])
			local key = item:gsub(".lua", "")
			if love.filesystem.isFile(dir.."/"..item) then
				if key ~= "" then
					local holdTile = require(dir.."/"..key)
					if holdTile and type(holdTile) == "table" then
						if not tiles[key] then
							if holdTile.name then
								if holdTile.imageKey == nil then holdTile.imageKey = "missing" end
								if holdTile.collision == nil then holdTile.collision = false end
								if holdTile.drawable == nil then holdTile.drawable = true end
								if holdTile.isFloor == nil then holdTile.isFloor = true end
								if holdTile.collider == nil or (holdTile.collider and (not holdTile.collider.x or not holdTile.collider.y or not holdTile.collider.w or not holdTile.collider.h)) then
									holdTile.collider = {x=0,y=0,w=1,h=1}
								else
									local col = holdTile.collider
									col.x = math.clamp(col.x, 0, 0.9)
									col.y = math.clamp(col.y, 0, 0.9)
									col.w = math.clamp(col.w, 0.1, 1-col.x)
									col.h = math.clamp(col.h, 0.1, 1-col.y)
								end
								tile.getTileSheet(holdTile)
								tiles[key] = holdTile
								debug.log("[TILE] Added tile '"..key.."' from directory '"..dir.."' with the keys '"..key.."' and '"..tile.tileCount.."'")
							else
								debug.log("[TILE] Tile with key '"..key.."' in directory '"..dir.."' does not have correct variables")
							end
						else
							debug.log("[TILE] Tile with key '"..key.."' allready exsists in directory '"..dir.."'")
						end
					end
				end
			elseif love.filesystem.isDirectory(dir.."/"..item) and item ~= "blacklist" then
				tile.getTiles(dir.."/"..item, true, tiles)
			end
		end
		if not isrepeat then print(""); tile.unsortedTiles = tiles end
	else
		debug.log("[ERROR] Incorrect call to function 'tile.getTiles(dir,isrepeat,tiles)'")
	end
end

return tile