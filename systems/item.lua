item = {}
item.systemKey = "item"
item.runPriority = 6

-- Variables --
item.items = {}
item.unsortedItems = {}
item.itemCount = 0

-- Callbacks --
function item.load()
	item.getItems("/assets/items")
	item.addItems()
end

-- Functions --
function item.addItems()
	item.addItem("gun")
	debug.log("")
end

function item.addItem(key)
	if key then
		local holdItem = item.unsortedItems[key]
		if holdItem then
			item.itemCount = item.itemCount + 1
			holdItem.id = item.itemCount
			item.items[item.itemCount] = holdItem
			item.items[key] = holdItem
			debug.log("[ITEM] Added item '"..key.."' with the keys '"..key.."' and '"..item.itemCount.."'")
		else
			debug.log("[WARNING] No existing item with the key '"..key.."'")
		end
	else
		debug.err("Incorrect call to function 'item.addItem(key)'")
	end
end

function item.cloneItem(key)
	if key then
		if type(key) == "number" or type(key) == "string" then
			if item.items[key] then
				local holdItem = item.items[key]
				local newItem = cloneTable(holdItem, {"function"})
				setmetatable(newItem, { __index = holdItem })
				return newItem
			else
				debug.log("[WARNING] No item with key '"..key.."'")
			end
		elseif type(key) == "table" then
			local holdItem = key
			local newItem = cloneTable(holdItem, {"function"})
			setmetatable(newItem, { __index = holdItem })
			return newItem
		end
	else
		debug.err("Incorrect call to function 'item.cloneItem(key)'")
	end
end

function item.getItem(key)
	if key then
		if type(key) == "number" or type(key) == "string" then
			if item.items[key] then
				return item.items[key]
			else
				debug.log("[WARNING] No item with key '"..key.."'")
			end
		end
	else
		debug.err("Incorrect call to function 'item.getItem(key)'")
	end
end

function item.getItems(dir,isrepeat,items)
	if dir then
		if isrepeat == nil then isrepeat = false end
		if not items then items = {} end

		local files = love.filesystem.getDirectoryItems(dir)
		local lng = table.getn(files)
		for i=1, lng do
			local item = string.lower(files[i])
			local key = item:gsub(".lua", "")
			if love.filesystem.isFile(dir.."/"..item) then
				if key ~= "" then
					local holdItem = require(dir.."/"..key)
					if holdItem and type(holdItem) == "table" then
						if not items[key] then
							if holdItem.name then
								if holdItem.desc == nil then holdItem.desc = "No Description" end
								if holdItem.image == nil then holdItem.image = "missing" end
								if holdItem.object == nil then holdItem.object = "" end
								if holdItem.size == nil then
									holdItem.size = {w=1,h=1}
								else
									holdItem.size.w = math.clamp(holdItem.size.w, 1, math.huge)
									holdItem.size.h = math.clamp(holdItem.size.h, 1, math.huge)
								end
								if holdItem.ignore == nil then holdItem.ignore = {} end
								items[key] = holdItem
								debug.log("[ITEM] Added item '"..key.."' from directory '"..dir.."' to unsorted list")
							else
								debug.log("[ITEM] Item with key '"..key.."' in directory '"..dir.."' does not have correct variables")
							end
						else
							debug.log("[ITEM] Item with key '"..key.."' allready exsists in directory '"..dir.."'")
						end
					end
				end
			elseif love.filesystem.isDirectory(dir.."/"..item) and item ~= "blacklist" then
				item.getItems(dir.."/"..item, true, items)
			end
		end
		if not isrepeat then print(""); item.unsortedItems = items end
	else
		debug.err("Incorrect call to function 'item.getItems(dir,isrepeat,items)'")
	end
end

return item