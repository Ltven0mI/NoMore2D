-- System Settings --
object = {}
object.systemKey = "object"
object.runPriority = 7

-- Variables --
object.objects = {}
object.createdObjects = {}
object.objCount = 0

-- Callbacks --
function object.draw()
	for uid, obj in pairs(object.createdObjects) do
		if obj.draw then obj:draw() end
	end
end

function object.errhand(msg)
	for uid, obj in pairs(object.createdObjects) do
		if obj.errhand then obj:errhand(msg) end
	end
end

function object.focus(f)
	for uid, obj in pairs(object.createdObjects) do
		if obj.focus then obj:focus(f) end
	end
end

function object.gamepadaxis(joystick,axis,value)
	for uid, obj in pairs(object.createdObjects) do
		if obj.gamepadaxis then obj:gamepadaxis(joystick, axis, value) end
	end
end

function object.gamepadpressed(joystick,button)
	for uid, obj in pairs(object.createdObjects) do
		if obj.gamepadpressed then obj:gamepadpressed(joystick, button) end
	end
end

function object.gamepadreleased(joystick,button)
	for uid, obj in pairs(object.createdObjects) do
		if obj.gamepadreleased then obj:gamepadreleased(joystick, button) end
	end
end

function object.joystickadded(joystick)
	for uid, obj in pairs(object.createdObjects) do
		if obj.joystickadded then obj:joystickadded(joystick) end
	end
end

function object.joystickaxis(joystick,axis,value)
	for uid, obj in pairs(object.createdObjects) do
		if obj.joystickaxis then obj:joystickaxis(joystick, axis, value) end
	end
end

function object.joystickhat(joystick,hat,direction)
	for uid, obj in pairs(object.createdObjects) do
		if obj.joystickhat then obj:joystickhat(joystick,hat,direction) end
	end
end

function object.joystickpressed(joystick,button)
	for uid, obj in pairs(object.createdObjects) do
		if obj.joystickpressed then obj:joystickpressed(joystick, button) end
	end
end

function object.joystickreleased(joystick,button)
	for uid, obj in pairs(object.createdObjects) do
		if obj.joystickreleased then obj:joystickreleased(joystick, button) end
	end
end

function object.joystickremoved(joystick)
	for uid, obj in pairs(object.createdObjects) do
		if obj.joystickremoved then obj:joystickremoved(joystick) end
	end
end

function object.keypressed(key,isrepeat)
	for uid, obj in pairs(object.createdObjects) do
		if obj.keypressed then obj:keypressed(key, isrepeat) end
	end
end

function object.keyreleased(key)
	for uid, obj in pairs(object.createdObjects) do
		if obj.keyreleased then obj:keyreleased(key) end
	end
end

function object.load(arg)
	object.getObjects("/objects")

	for uid, obj in pairs(object.createdObjects) do
		if obj.load then obj:load(arg) end
	end
end

function object.mousefocus(f)
	for uid, obj in pairs(object.createdObjects) do
		if obj.mousefocus then obj:mousefocus(f) end
	end
end

function object.mousepressed(x,y,button)
	for uid, obj in pairs(object.createdObjects) do
		if obj.mousepressed then obj:mousepressed(x, y, button) end
	end
end

function object.mousereleased(x,y,button)
	for uid, obj in pairs(object.createdObjects) do
		if obj.mousereleased then obj:mousereleased(x, y, button) end
	end
end

function object.quit()
	for uid, obj in pairs(object.createdObjects) do
		if obj.quit then obj:quit() end
	end
end

function object.resize(w,h)
	for uid, obj in pairs(object.createdObjects) do
		if obj.resize then obj:resize(w, h) end
	end
end

function object.textinput(text)
	for uid, obj in pairs(object.createdObjects) do
		if obj.textinput then obj:textinput(text) end
	end
end

function object.threaderror(thread,errorstr)
	for uid, obj in pairs(object.createdObjects) do
		if obj.threaderror then obj:threaderror(thread, errorstr) end
	end
end

function object.update(dt)
	for uid, obj in pairs(object.createdObjects) do
		if obj.update then obj:update(dt) end
	end
end

function object.visible(v)
	for uid, obj in pairs(object.createdObjects) do
		if obj.visible then obj:visible(v) end
	end
end

-- Functions --
function object.new(...)
	local args = {...}
	local objType = args[1]
	if objType then
		local holdType = object.objects[objType]
		if holdType then
			local holdObject = cloneTable(holdType, {"function"})
			local uid = object.createUID()
			holdObject.uid = uid
			object.createdObjects[uid] = holdObject
			setmetatable(holdObject, { __index = holdType })
			if holdObject.created then holdObject:created(args) end
			return object.createdObjects[uid]
		end
	else
		debug.log("[ERROR] Incorrect call to function 'object.new(...)'")
	end
end

function object.getObjects(dir,isrepeat)
	if dir then
		if isrepeat == nil then isrepeat = false end

		local files = love.filesystem.getDirectoryItems(dir)
		local lng = table.getn(files)
		for i=1, lng do
			local item = files[i]
			local key = string.gsub(item, ".lua", "")
			if key then
				if love.filesystem.isFile(dir.."/"..item) then
					local holdObj = require(dir.."/"..key)
					if holdObj and type(holdObj) == "table" then
						debug.log("[OBJECT] Adding object '"..key.."' from directory '"..dir.."'")
						object.objects[key] = holdObj
					end
				elseif love.filesystem.isDirectory(dir.."/"..item) and item ~= "blacklist" then
					object.getObjects(dir.."/"..item, true)
				end
			end
		end
	else
		debug.log("[ERROR] Incorrect call to function 'object.getObjects(dir,isrepeat)'")
	end
end

function object.createUID()
	object.objCount = object.objCount + 1
	return object.objCount
end

function object.getObject(uid)
	if uid then
		if object.createdObjects[uid] then
			return object.createdObjects[uid]
		else
			return nil
		end
	else
		debug.log("[ERROR] Incorrect call to function 'object.getObject(uid)'")
	end
end

function object.destroyObject(arg)
	if arg then
		if type(arg) == "number" then
			if object.createdObjects[arg] then
				object.createdObjects[arg] = nil
			end
		elseif type(arg) == "table" then
			if arg.uid then
				if object.createdObjects[arg.uid] then
					object.createdObjects[arg.uid] = nil
				end
			end
		end
	else
		debug.log("[ERROR] Incorrect call to function 'object.destroyObject(arg)'")
	end
end

return object