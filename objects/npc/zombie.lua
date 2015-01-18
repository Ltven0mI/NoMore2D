local zombie = {}

-- Variables --
zombie.pos = {x=0,y=0}
zombie.vel = {x=0,y=0}
zombie.size = 32
zombie.speed = 150
zombie.rot = 180
zombie.curRot = 0
zombie.facing = ""
zombie.target = nil

zombie.weapon = nil
zombie.damage = 10

zombie.attackDist = 40
zombie.attackAcum = 0
zombie.attackSpeed = 1

zombie.health  = 100
zombie.maxHealth = 100

zombie.image = "zombie_01"

-- Callbacks --
function zombie:created(args)
	self.image = "zombie_0"..math.random(1,3)
	if args[2] and args[3] then
		self.pos.x = args[2]
		self.pos.y = args[3]
	end
end

function zombie:update(dt)
	if not self.target and state.currentState and state.currentState.player and state.currentState.player.health > 0 then self.target = self:checkTarget(state.currentState.player) end
	if self.target then
		local tx, ty, sx, sy = self.target.pos.x+self.target.size/2, self.target.pos.y+self.target.size/2, self.pos.x+self.size/2, self.pos.y+self.size/2
		local ang = (math.atan2(ty-sy, tx-sx))
		if math.dist(sx, sy, tx, ty) >= self.attackDist then
			self.vel.x, self.vel.y = math.cos(ang), math.sin(ang)

			local vx, vy = math.norm(self.vel.x, self.vel.y)
			self.vel.x, self.vel.y = vx*self.vel.x, vy*self.vel.y
			self.vel.x = self.vel.x*self.speed
			self.vel.y = self.vel.y*self.speed
		else
			if self.attackAcum >= self.attackSpeed then
				self:attack(self.target)
				self.attackAcum = 0
			end
		end
		self.rot = math.deg(ang)+90
		if self.target.health <= 0 then self.target = nil end
	end
	self.attackAcum = self.attackAcum + dt

	--[[if self.vel.x > 0 then
		if self.vel.y > 0 then self.rot = 135 elseif self.vel.y < 0 then self.rot = 45 else self.rot = 90 end
	elseif self.vel.x < 0 then
		if self.vel.y > 0 then self.rot = 225 elseif self.vel.y < 0 then self.rot = 315 else self.rot = 270 end
	else
		if self.vel.y > 0 then self.rot = 180 elseif self.vel.y < 0 then self.rot = 0 end
	end]]

	if self.rot < 0 then self.rot = 270+(self.rot+90) end

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

	if self.vel.x ~= 0 and self.vel.y ~= 0 then self:checkCollision() end

	self.curRot = math.anglerp(self.curRot, self.rot, 0.1)

	if self.health <= 0 then self:kill() end
end

function zombie:drawworld()
	ui.draw(image.getImage(self.image), math.round(self.pos.x), math.round(self.pos.y), self.size, self.size, self.rot)
end

-- Functions --

function zombie:attack(t)
	if t then
		if t.attackObject then t:attackObject(self.damage) end
	else
		debug.err("Incorrect call to function 'zombie:attack(t)'")
	end
end

function zombie:attackObject(dam)
	if dam then
		self.health = self.health - dam
	end
end

function zombie:kill()
	object.destroyObject(self)
end

function zombie:checkCollision()
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

function zombie:checkTarget(t)
	if t then
		if t.pos and t.size then
			local tx, ty, sx, sy = t.pos.x+t.size/2, t.pos.y+t.size/2, self.pos.x+self.size/2, self.pos.y+self.size/2
			local ang = math.deg(math.atan2(ty-sy, tx-sx))+90
			if ang-self.rot < 45 and ang-self.rot > -45 and not world.raycast(sx, sy, ang-90, math.dist(sx, sy, tx, ty), nil, true) then return t end
		end
	else
		debug.err("Incorrect call to function 'zombie:checkTarget(t)'")
	end
end

function zombie:getTile(side,layer)
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
		debug.err("Incorrect call to function 'zombie:getTile(side,layer)'")
	end
end

return zombie