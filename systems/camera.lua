camera = {}
camera.systemKey = "camera"
camera.runPriority = 3

-- Variables --
camera.var = {}
camera.var.pos = {x=0,y=0}
camera.var.scale = 1
camera.var.rot = 0
camera.var.mode = "world"
camera.var.modeOffset = {x=0, y=0}
camera.var.scaleOffset = {x=0,y=0}

camera.pushpop = {}

camera.window = {w=0,h=0}
camera.pushCount = 0

-- Callbacks --
function camera.load(args)
	camera.window.w = main.w
	camera.window.h = main.h
end

function camera.draw()
	camera.updateSettings()
end

function camera.resize(w,h)
	camera.var.scale = (main.width+main.height)/1750
end

-- Function --
function camera.setPos(x,y)
	if x and y then
		camera.var.pos.x = math.round(x)
		camera.var.pos.y = math.round(y)
	else
		debug.log("[ERROR] Incorrect call to function 'camera.setPos(x,y)'")
	end
end

function camera.centerPos(x,y)
	if x and y then
		camera.var.pos.x = math.round(x-main.width/2/camera.var.scale)
		camera.var.pos.y = math.round(y-main.height/2/camera.var.scale)
		camera.var.scaleOffset.x = math.round((main.width/2/camera.var.scale)*(-camera.var.scale+1))
		camera.var.scaleOffset.y = math.round((main.height/2/camera.var.scale)*(-camera.var.scale+1))
	else
		debug.log("[ERROR] Incorrect call to function 'camera.center(x,y)'")
	end
end

function camera.getPos()
	return camera.var.pos.x, camera.var.pos.y
end

function camera.setRot(r)
	if r then
		camera.var.rot = math.round(r)
	else
		debug.log("Incorrect call to function 'camera.setRot(r)'")
	end
end

function camera.getRot()
	return camera.var.rot
end

function camera.getModeOffset()
	return camera.var.modeOffset
end

function camera.setMode(mode)
	if mode and type(mode) == "string" then
		if mode == "world" or mode == "screen" then
			camera.var.mode = mode
			camera.updateSettings()
		else
			debug.log("[WARNING] Argument 'mode' in call to function 'camera.setMode(mode)' must be 'world' or 'screen'")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'camera.setMode(mode)'")
	end
end

function camera.getMode()
	return camera.var.mode
end

function camera.getMouse()
	local mx, my = love.mouse.getPosition()
	if camera.var.mode == "world" then return mx+camera.var.pos.x+camera.var.scaleOffset.x, my+camera.var.pos.y+camera.var.scaleOffset.y elseif camera.var.mode == "screen" then return mx, my end
end

function camera.push()
	camera.pushCount = camera.pushCount + 1
	camera.pushpop[camera.pushCount] = {}
	for key, val in pairs(camera.var) do
		if type(val) ~= "function" then
			camera.pushpop[camera.pushCount][key] = val
		end
	end
end

function camera.pop()
	for key, val in pairs(camera.pushpop[camera.pushCount]) do
		if type(val) ~= "function" then
			camera.var[key] = val
		end
	end
	camera.pushpop[camera.pushCount] = nil
	camera.pushCount = camera.pushCount - 1

	camera.updateSettings()
end

function camera.updateSettings()
	love.graphics.origin()
	if camera.var.mode == "world" then
		local scale = camera.var.scale
		love.graphics.scale(scale)
		love.graphics.translate(-camera.var.pos.x, -camera.var.pos.y)
		camera.var.modeOffset.x, camera.var.modeOffset.y = -camera.var.pos.x, -camera.var.pos.y
	else
		love.graphics.translate(0, 0)
		camera.var.modeOffset.x, camera.var.modeOffset.y = 0, 0
	end
	love.graphics.rotate(math.rad(camera.var.rot))
end

return camera