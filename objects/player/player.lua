local player = {}

-- Variables --
player.tpos = {x=0,y=0}
player.pos = {x=0,y=0}
player.vel = {x=0,y=0}
player.size = 32
player.speed = 250
player.rot = 0
player.curRot = 0
player.facing = ""

player.editLayer = "floor"
player.editTile = 1
player.editTileCords = {x=1,y=1}

player.weapon = nil
player.inventory = nil

-- Callbacks --
function player:created()
	self.inventory = object.new("inventory", 10, 10)
end

function player:onDestroy()
	if self.inventory then object.destroyObject(self.inventory); self.inventory = nil end
end

function player:update(dt)
	self.vel.x, self.vel.y = 0, 0
	if love.keyboard.isDown("w") and not love.keyboard.isDown("s") then self.vel.y = -self.speed end
	if love.keyboard.isDown("s") and not love.keyboard.isDown("w") then self.vel.y = self.speed end
	if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then self.vel.x = -self.speed end
	if love.keyboard.isDown("d") and not love.keyboard.isDown("a") then self.vel.x = self.speed end

	local vx, vy = math.norm(self.vel.x, self.vel.y)
	self.vel.x, self.vel.y = vx*self.vel.x, vy*self.vel.y

	if self.vel.x > 0 then
		if self.vel.y > 0 then self.rot = 135 elseif self.vel.y < 0 then self.rot = 45 else self.rot = 90 end
	elseif self.vel.x < 0 then
		if self.vel.y > 0 then self.rot = 225 elseif self.vel.y < 0 then self.rot = 315 else self.rot = 270 end
	else
		if self.vel.y > 0 then self.rot = 180 elseif self.vel.y < 0 then self.rot = 0 end
	end

	local mx, my = camera.getMouse("world")
	if love.mouse.isDown("l") or love.mouse.isDown("r") or love.mouse.isDown("m") then self.rot = (math.atan2((my-(self.pos.y+self.size/2)), (mx-(self.pos.x+self.size/2)))*180/math.pi)+90 end
	if self.rot < 0 then self.rot = 270+(self.rot+90) end
	self.rot = (math.floor((self.rot+22.5)/45))*45

	if self.rot > -22.5 and self.rot < 22.5 then self.facing = "up" end
	if self.rot > 22.5 and self.rot < 67.5 then self.facing = "upright" end
	if self.rot > 67.5 and self.rot < 112.5 then self.facing = "right" end
	if self.rot > 112.5 and self.rot < 157.5 then self.facing = "downright" end
	if self.rot > 157.5 and self.rot < 202.5 then self.facing = "down" end
	if self.rot > 202.5 and self.rot < 247.5 then self.facing = "downleft" end
	if self.rot > 247.5 and self.rot < 292.5 then self.facing = "left" end
	if self.rot > 292.5 and self.rot < 337.5 then self.facing = "upleft" end

	local ts = tile.tileSize

	self.vel.x = self.vel.x*dt
	self.vel.y = self.vel.y*dt

	self.pos.x = self.pos.x + self.vel.x
	self.pos.y = self.pos.y + self.vel.y

	self.tpos.x = self.pos.x/ts
	self.tpos.y = self.pos.y/ts

	self:checkCollision()

	self.curRot = math.anglerp(self.curRot, self.rot, 0.1)

	camera.centerPos(math.round(self.pos.x+self.size/2), math.round(self.pos.y+self.size/2))

	if love.mouse.isDown(input.fire) then
		if self.weapon and self.weapon.attack then self.weapon:attack() end
	end
	if self.inventory and self.inventory.heldItem then
		if love.mouse.onDown("l") then
			local mx, my = camera.getMouse("world")
			if math.contains(self.pos.x, self.pos.y, self.size, self.size, mx, my, 1, 1) then
				self:equipItem(self.inventory.heldItem)
			end
		end
	end

	--[[local ts = tile.tileSize
	local x, y = camera.getMouse()
	local tx, ty = math.floor(x/ts)+1, math.floor(y/ts)+1
	if love.mouse.isDown("l") then
		local holdTile = world.setTile(tx, ty, self.editTile, self.editLayer)
		if holdTile and holdTile.tileset then
			holdTile.tileset.tx = self.editTileCords.x
			holdTile.tileset.ty = self.editTileCords.y
		end
	end
	if love.mouse.isDown("r") then
		world.setTile(tx, ty, "", self.editLayer)
	end]]
end

function player:drawworld()
	ui.draw(image.getImage("player_01"), math.round(self.pos.x), math.round(self.pos.y), self.size, self.size, self.curRot)
end

function player:keypressed(key)
	if key == input.interact then
		local tile = self:getTile(self.facing, "wall")
		local inTile = self:getTile("", "wall")
		if inTile and inTile.interact then
			inTile:interact()
		elseif tile and tile.interact then
			tile:interact()
		end
	end
	if key == input.inventory then
		if self.inventory ~= nil then self.inventory.open = not self.inventory.open end
	end
	if key == "f" then
		if self.editLayer == "floor" then
			self.editLayer = "wall"
		elseif self.editLayer == "wall" then
			self.editLayer = "roof"
		elseif self.editLayer == "roof" then
			self.editLayer = "floor"
		end
	end
	if key == "=" then
		self.editTile = self.editTile + 1
	end
	if key == "-" then
		self.editTile = self.editTile - 1
	end
	if key == "up" then
		self.editTileCords.y = self.editTileCords.y - 1
	end
	if key == "down" then
		self.editTileCords.y = self.editTileCords.y + 1
	end
	if key == "left" then
		self.editTileCords.x = self.editTileCords.x - 1
	end
	if key == "right" then
		self.editTileCords.x = self.editTileCords.x + 1
	end
	if key == "b" then
		world.saveMap("testsave")
	end
	if key == "n" then
		world.loadMap("testsave")
	end
end

-- Functions --
function player:equipItem(i)
	if i then
		if i.itemType == "weapon" then
			local holdItem = nil
			if self.weapon ~= nil then self.inventory:addItem(self.weapon.id) end
			self.weapon = i
			self.weapon.parent = self
			self.inventory.heldItem = nil
		end
		if i.itemType == "magazine" then
			local holdItem = nil
			if i.roundType == self.weapon.magType then
				if self.weapon.attach.mag ~= nil then self.inventory:addItem(self.weapon.attach.mag.id) end
				self.weapon.attach.mag = i
				self.inventory.heldItem = nil
			end
		end
	else
		debug.err("Incorrect call to function 'player:equipItem(i)'")
	end
end

function player:checkCollision()
	local map = world.map
	if map then
		if world.checkMap(map) then
			local w, h = map.size.w, map.size.h
			local ts = tile.tileSize
			local ptx, pty = math.floor((self.pos.x+self.size/2+ts)/ts), math.floor((self.pos.y+self.size/2+ts)/ts) --Player Tile Cords
			local sx, sy, ex, ey = math.clamp(ptx-2, 1, map.size.w), math.clamp(pty-2, 1, map.size.h), math.clamp(ptx+2, 1, map.size.w), math.clamp(pty+2, 1, map.size.h) --Start and End Cords

			for y=sy, ey do
				for x=sx, ex do
					if map.tiles.wall[y] and map.tiles.wall[y][x] then
						local holdTile = map.tiles.wall[y][x]
						if holdTile.collision then
							local col = holdTile.collider
							self.pos.x, self.pos.y, self.vel.x, self.vel.y = collision.boundingBox(self.pos.x, self.pos.y, self.size, self.size, self.vel.x, self.vel.y, (x-1)*ts+ts*col.x, (y-1)*ts+ts*col.y, ts*col.w, ts*col.h, 0, 0)
						end
					end
				end
			end
		end
	end
end

function player:getTile(side,layer)
	if side and layer then
		local holdTile = nil
		local ts = tile.tileSize
		if side == "up" then
			holdTile = world.getTile(self.pos.x+self.size/2, self.pos.y+self.size/2-ts, "wall")
		elseif side == "down" then
			holdTile = world.getTile(self.pos.x+self.size/2, self.pos.y+self.size/2+ts, "wall")
		elseif side == "left" then
			holdTile = world.getTile(self.pos.x+self.size/2-ts, self.pos.y+self.size/2, "wall")
		elseif side == "right" then
			holdTile = world.getTile(self.pos.x+self.size/2+ts, self.pos.y+self.size/2, "wall")
		elseif side == "" then
			holdTile = world.getTile(self.pos.x+self.size/2, self.pos.y+self.size/2, "wall")
		end
		return holdTile
	else
		debug.err("Incorrect call to function 'player:getTile(side,layer)'")
	end
end

return player