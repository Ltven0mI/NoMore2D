player = {}

-- Variables --
player.pos = {x=0,y=0}
player.vel = {x=0,y=0}
player.size = 32
player.speed = 250
player.rot = 0
player.curRot = 0
player.facing = ""

-- Callbacks --
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

	local mx, my = camera.getMouse()
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

	self.vel.x = self.vel.x*dt
	self.vel.y = self.vel.y*dt

	self.pos.x = self.pos.x + self.vel.x
	self.pos.y = self.pos.y + self.vel.y

	self:checkCollision()

	self.curRot = math.anglerp(self.curRot, self.rot, 0.1)

	camera.centerPos(self.pos.x+self.size/2, self.pos.y+self.size/2)
end

function player:draw()
	ui.push()
		ui.setMode("world")
		ui.draw(image.getImage("player_01"), math.round(self.pos.x), math.round(self.pos.y), self.size, self.size, self.curRot)
	ui.pop()
end

function player:keypressed(key)
	if key == input.interact then
		local tile = self:getTile(self.facing)
		if tile then
			if tile.interact then tile:interact() end
		end
	end
end

-- Functions --
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
					if map.tiles[y] and map.tiles[y][x] then
						local holdTile = map.tiles[y][x]
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

function player:getTile(side)
	if side then
		local holdTile = nil
		local ts = tile.tileSize
		if side == "up" then
			holdTile = world.getTile(self.pos.x+self.size/2, self.pos.y+self.size/2-ts)
		elseif side == "down" then
			holdTile = world.getTile(self.pos.x+self.size/2, self.pos.y+self.size/2+ts)
		elseif side == "left" then
			holdTile = world.getTile(self.pos.x+self.size/2-ts, self.pos.y+self.size/2)
		elseif side == "right" then
			holdTile = world.getTile(self.pos.x+self.size/2+ts, self.pos.y+self.size/2)
		end
		return holdTile
	else
		debug.log("[ERROR] Incorrect call to function 'player:getTile(side)'")
	end
end

return player