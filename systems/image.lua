image = {}
image.systemKey = "image"
image.runPriority = 2

-- Variables --
image.images = {}
image.imageCount = 0

image.imageTypes = {"jpg", "png", "bmp", "tga"}

-- Callbacks --
function image.load()
	image.getImages("/images")
end

-- Functions --
function image.getImages(dir,isrepeat,images)
	if dir then
		if isrepeat == nil then isrepeat = false end
		if not images then images = {} end

		local files = love.filesystem.getDirectoryItems(dir)
		local lng = table.getn(files)
		for i=1, lng do
			local item = string.lower(files[i])
			local key = ""
			for extKey, val in pairs(image.imageTypes) do
				if item:gsub("."..val, "") ~= item then key = item:gsub("."..val, ""); break end
			end
			if love.filesystem.isFile(dir.."/"..item) then
				if key ~= "" then
					local holdImg = love.graphics.newImage(dir.."/"..item)
					if holdImg and type(holdImg) == "userdata" then
						image.imageCount = image.imageCount + 1
						if not images[key] then
							holdImg:setFilter("nearest")
							images[key] = holdImg
							debug.log("[IMAGE] Added image '"..key.."' from directory '"..dir.."'")
						else
							debug.log("[IMAGE] Image with key '"..key.."' allready exsists in directory '"..dir.."'")
						end
					end
				end
			elseif love.filesystem.isDirectory(dir.."/"..item) and item ~= "blacklist" then
				image.getImages(dir.."/"..item, true, images)
			end
		end
		if not isrepeat then print(""); image.images = images end
	else
		debug.log("[ERROR] Incorrect call to function 'image.getImages(dir,isrepeat,images)'")
	end
end

function image.getImage(key)
	if key then
		if image.images[key] then
			return image.images[key]
		else
			debug.log("[WARNING] No image with the key '"..key.."'")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'image.getImage(key)'")
	end
end

return image