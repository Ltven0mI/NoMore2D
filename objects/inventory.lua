local inventory = {}

-- Variables --
inventory.slots = {}
inventory.size = {w=0,h=0}

inventory.pos = {x=0,y=0}
inventory.slotSize = 30

inventory.image = ""
inventory.slotImage = "invslot"
inventory.padding = {left=0,right=0,top=0,bot=0}
inventory.mode = "screen"

inventory.open = false
inventory.heldItem = nil
inventory.parent = nil

-- Callbacks --
function inventory:created(args)
	if args[2] and args[3] then
		self:create(args[2], args[3])
	else
		self:create(1, 1)
	end
	if args[4] ~= nil and type(args[4]) == "table" then
		self.parent = args[4]
	end
	self:addItem("m4a1", 1)
	self:addItem("uzi", 1)
	self:addItem("ak47", 1)
	self:addItem("lmg", 1)
	self:addItem("mag_nato", 1)
	self:addItem("mag_uzi", 1)
	self:addItem("box_nato", 1)
	self:addItem("box_flame", 1)
	self:addItem("spas", 1)
	self:addItem("shells_buckshot", 1)
	self:addItem("shells_slug", 1)
end

function inventory:drawscreen()
	if self.open then
		local mx, my = camera.getMouse("screen")
		if self.image ~= nil and self.image ~= "" then
			local ix, iy, iw, ih = 0, 0, 0, 0
			ix = self.pos.x-self.padding.left-co.x
			iy = self.pos.y-self.padding.top-co.y
			iw = self.size.w*self.slotSize+self.padding.left+self.padding.right
			ih = self.size.h*self.slotSize+self.padding.top+self.padding.bot
			ui.draw(image.getImage(self.image), ix, iy, iw, ih)
		end
		local w, h = self.size.w, self.size.h
		for y=1, h do
			for x=1, w do
				if ui.imageButton(image.getImage(self.slotImage), self.pos.x+(x-1)*self.slotSize, self.pos.y+(y-1)*self.slotSize, self.slotSize, self.slotSize) then
					self:clickSlot(x, y)
				end
			end
		end
		for y=1, h do
			for x=1, w do
				local img = nil
				local holdItem = nil
				local holdSlot = nil
				if self.slots[y] and self.slots[y][x] and self.slots[y][x].item then holdSlot = self.slots[y][x]; holdItem = holdSlot.item; img = image.getImage(holdItem.image) end
				if img and holdSlot.orig then
					ui.draw(img, self.pos.x+(x-1)*self.slotSize, self.pos.y+(y-1)*self.slotSize, holdItem.size.w*self.slotSize, holdItem.size.h*self.slotSize)
				end
			end
		end
		if self.heldItem ~= nil then
			if self.heldItem.image then
				ui.draw(image.getImage(self.heldItem.image), mx-self.slotSize/2, my-self.slotSize/2, self.heldItem.size.w*self.slotSize, self.heldItem.size.h*self.slotSize)
			end
		end
	end
end

-- Functions --
function inventory:create(w,h)
	if w and h and w>0 and h>0 then
		local slots = {}
		local size = {w=w,h=h}
		for y=1, h do
			slots[y] = {}
			for x=1, w do
				slots[y][x] = {}
			end
		end
		self.slots = slots
		self.size = size
	else
		debug.err("Incorrect call to function 'inventory:create(w,h)'")
	end
end

function inventory:clickSlot(x,y)
	if x and y then
		if self.heldItem then
			self.heldItem = self:setItem(x, y, self.heldItem)
		else
			self.heldItem = self:removeItem(x, y)
		end
	else
		debug.error("Incorrect call to function 'inventory:clickSlot(x,y)'")
	end
end

function inventory:getItem(x,y)
	if x and y then
		if self.slots and self.slots[y] and self.slots[y][x] then
			return self.slots[y][x].item
		else
			debug.log("[WARNING] No slot at x:'"..x.."' y:'"..y.."'")
		end
	else
		debug.err("Incorrect call to function 'inventory:getItem(x,y)'")
	end
end

function inventory:addItem(arg,count)
	if arg then
		local holdItem = nil
		if type(arg) == "table" then holdItem = arg else holdItem = item.cloneItem(arg) end
		if count == nil then count = 1 end
		count = math.clamp(count, 1, math.huge)
		if holdItem then
			local addCount = 0
			for y=1, self.size.h do
				for x=1, self.size.w do
					local holdSlot = nil
					if self.slots and self.slots[y] and self.slots[y][x] then holdSlot = self.slots[y][x] end
					if holdSlot then
						if holdSlot.item == nil then
							if x+holdItem.size.w-1 <= self.size.w and y+holdItem.size.h-1 <= self.size.h then
								local fits = true
								for yy=0, holdItem.size.h-1 do
									for xx=0, holdItem.size.w-1 do
										local holdTempSlot = nil
										if self.slots and self.slots[y+yy] and self.slots[y+yy][x+xx] then holdTempSlot = self.slots[y+yy][x+xx] end
										if holdTempSlot and holdTempSlot.item ~= nil then fits = false; break end
									end
									if not fits then break end
								end
								if fits then
									self:setItem(x, y, holdItem)
									addCount = addCount + 1
									if addCount >= count then return end
								end
							end
						end
					end
				end
			end
		end
	else
		debug.err("Incorrect call to function 'inventory:addItem(arg,count)'")
	end
end

function inventory:removeItem(arg1,arg2)
	if arg1 then
		local holdItem = nil
		if arg2 then
			holdItem = self:getItem(arg1, arg2)
		else
			holdItem = arg1
		end
		if holdItem then
			local x, y, w1, h1 = holdItem.ignore.slot.x, holdItem.ignore.slot.y, holdItem.size.w, holdItem.size.h
			if x>=1 and y>=1 and x+w1-1<=self.size.w and y+h1-1<=self.size.h then
				for y1=y, y+h1-1 do
					for x1=x, x+w1-1 do
						local slot = nil
						if self.slots[y1] and self.slots[y1][x1] then slot = self.slots[y1][x1] end
						if slot then
							slot.item = nil
							slot.orig = true
						end
					end
				end
				return holdItem
			else
				debug.log("[WARNING] Tried to remove item outside of inventory")
			end
		end
		return nil
	else
		debug.err("Incorrect call to function 'inventory:removeItem(arg1,arg2)'")
	end
end

function inventory:setItem(x,y,arg)
	if x and y and arg then
		local holdItem
		if type(arg) == "table" then
			holdItem = arg
		else
			holdItem = item.getItem(arg)
		end
		if holdItem then
			local w1, h1 = holdItem.size.w, holdItem.size.h
			if x>=1 and y>=1 and x+w1-1<=self.size.w and y+h1-1<=self.size.h then
				local fits = true
				local itemCount = 0
				local items = {}
				for y1=y, y+h1-1 do
					for x1=x, x+w1-1 do
						local slot = nil
						if self.slots[y1] and self.slots[y1][x1] then slot = self.slots[y1][x1] end
						if slot then
							if slot.item ~= nil then
								local exists = false
								local itemString = tostring(slot.item)
								for k, v in pairs(items) do
									if tostring(v) == itemString then exists = true; break end
								end
								if not exists then
									itemCount = itemCount + 1
									items[itemCount] = slot.item
								end
							end
						end
					end
				end
				local removedItem = nil
				if itemCount == 1 then removedItem = self:removeItem(items[1]) end
				if itemCount <= 1 then
					local first = true
					local holdSlot = nil
					for y1=y, y+h1-1 do
						for x1=x, x+w1-1 do
							local slot = nil
							if self.slots[y1] and self.slots[y1][x1] then slot = self.slots[y1][x1] end
							if slot then
								if first == true then
									slot.item = item.cloneItem(holdItem)
									slot.item.ignore.slot = {x=x1,y=y1}
									slot.orig = true
									holdSlot = slot
									first = false
								else
									slot.item = holdSlot.item
									slot.orig = false
								end
							end
						end
					end
				end
				if removedItem ~= nil then return removedItem else if itemCount == 0 then return nil else return holdItem end end
			else
				debug.log("[WARNING] Tried to place item outside of inventory")
				return holdItem
			end
		else
			debug.log("[WARNING] No item with the key '"..key.."'")
		end
	else
		debug.err("Incorrect call to function 'inventory:setItem(x,y,arg)'")
	end
end

return inventory