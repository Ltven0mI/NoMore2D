tile = {}
tile.systemKey = "tile"
tile.runPriority = 4

-- Variables --
tile.tileSize = 40
tile.tiles = {}
tile.tileCount = 0

-- Callbacks --
function tile.load()
	tile.getTiles("/assets/tiles")
end

-- Functions --
function tile.cloneTile(key)
	if key then
		if tile.tiles[key] then
			local holdTile = tile.tiles[key]
			local newTile = {}
			for key, val in pairs(holdTile) do
				newTile[key] = val
			end
			return newTile
		else
			debug.log("[WARNING] No tile with key '"..key.."'")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'tile.cloneTile(key)'")
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
								end
								holdTile.image = image.getImage(holdTile.imageKey)
								tile.tileCount = tile.tileCount + 1
								tiles[key] = holdTile
								tiles[tile.tileCount] = holdTile
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
		if not isrepeat then print(""); tile.tiles = tiles end
	else
		debug.log("[ERROR] Incorrect call to function 'tile.getTiles(dir,isrepeat,tiles)'")
	end
end

return tile