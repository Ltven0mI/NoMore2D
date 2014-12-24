local inventory = {}

-- Variables --
inventory.slots = {}
inventory.size = {w=0,h=0}

inventory.pos = {x=0,y=0}
inventory.slotSize = 30

inventory.image = ""
inventory.padding = {left=0,right=0,top=0,bot=0}

inventory.open = false
inventory.heldItem = nil

-- Callbacks --
function inventory:created(args)
	if args[2] and args[3] then
		self:create(args[2], args[3])
	else
		self:create(1, 1)
	end
	self:setSlot(1, 1, 1)
	self.pos.x = main.width/2-self.size.w*self.slotSize/2
	self.pos.y = main.height/2-self.size.h*self.slotSize/2
end

function inventory:resize(w,h)
	self.pos.x = w/2-self.size.w*self.slotSize/2
	self.pos.y = h/2-self.size.h*self.slotSize/2
end

function inventory:draw()
	if self.open then
		local mode = ui.getMode()
		ui.setMode("world")
		local mx, my = camera.getMouse()
		if self.image ~= nil and self.image ~= "" then
			local ix, iy, iw, ih = 0, 0, 0, 0
			local co = camera.getModeOffset()
			ix = self.pos.x-self.padding.left-co.x
			iy = self.pos.y-self.padding.top-co.y
			iw = self.size.w*self.slotSize+self.padding.left+self.padding.right
			ih = self.size.h*self.slotSize+self.padding.top+self.padding.bot
			ui.draw(image.getImage(self.image), ix, iy, iw, ih)
		end
		local w, h = self.size.w, self.size.h
		for y=1, h do
			for x=1, w do
				local co = camera.getModeOffset()
				if ui.button(self.pos.x+(x*self.slotSize)-co.x, self.pos.y+(y*self.slotSize)-co.y, self.slotSize, self.slotSize) then
					self:clickSlot(x, y)
				end
			end
		end
		for y=1, h do
			for x=1, w do
				local co = camera.getModeOffset()
				local img = nil
				local holdItem = nil
				local holdSlot = nil
				if self.slots[y] and self.slots[y][x] and self.slots[y][x].item then holdSlot = self.slots[y][x]; holdItem = holdSlot.item; img = image.getImage(holdItem.image) end
				if img and holdSlot.orig then
					ui.draw(img, self.pos.x+(x*self.slotSize)-co.x, self.pos.y+(y*self.slotSize)-co.y, holdItem.size.w*self.slotSize, holdItem.size.h*self.slotSize)
				end
			end
		end
		ui.setMode(mode)
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
			self.heldItem = self:setSlot(x, y, self.heldItem)
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

function inventory:setSlot(x,y,key)
	if x and y and key then
		local holdItem
		if type(key) == "table" then
			holdItem = key
		else
			holdItem = item.getItem(key)
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
				if removedItem ~= nil then debug.log("REMOVED ITEM"); return removedItem else if itemCount == 0 then debug.log("No Return"); return nil else debug.log("HoldItem"); return holdItem end end
			else
				debug.log("[WARNING] Tried to place item outside of inventory")
				return holdItem
			end
		else
			debug.log("[WARNING] No item with the key '"..key.."'")
		end
	else
		debug.err("Incorrect call to function 'inventory:setSlot(x,y,key)'")
	end
end

return inventory