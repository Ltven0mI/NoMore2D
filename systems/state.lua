state = {}
state.systemKey = "state"
state.runPriority = 18

-- Variables --
state.states = {}
state.currentState = nil
state.startState = "menu"

-- Callbacks --
function state.draw()
	if state.currentState.draw then state.currentState.draw() end
end

function state.errhand(msg)
	if state.currentState.errhand then state.currentState.errhand(msg) end
end

function state.focus(f)
	if state.currentState.focus then state.currentState.focus(f) end
end

function state.gamepadaxis(joystick,axis,value)
	if state.currentState.gamepadaxis then state.currentState.gamepadaxis(joystick,axis,value) end
end

function state.gamepadpressed(joystick,button)
	if state.currentState.gamepadpressed then state.currentState.gamepadpressed(joystick,button) end
end

function state.gamepadreleased(joystick,button)
	if state.currentState.gamepadreleased then state.gamepadreleased(joystick,button) end
end

function state.joystickadded(joystick)
	if state.currentState.joystickadded then state.currentState.joystickadded(joystick) end
end

function state.joystickaxis(joystick,axis,value)
	if state.currentState.joystickaxis then state.currentState.joystickaxis(joystick,axis,value) end
end

function state.joystickhat(joystick,hat,direction)
	if state.currentState.joystickhat then state.currentState.joystickhat(joystick,hat,direction) end
end

function state.joystickpressed(joystick,button)
	if state.currentState.joystickpressed then state.currentState.joystickpressed(joystick,button) end
end

function state.joystickreleased(joystick,button)
	if state.currentState.joystickreleased then state.currentState.joystickreleased(joystick,button) end
end

function state.joystickremoved(joystick)
	if state.currentState.joystickremoved then state.currentState.joystickremoved(joystick) end
end

function state.keypressed(key,isrepeat)
	if state.currentState.keypressed then state.currentState.keypressed(key,isrepeat) end
end

function state.keyreleased(key)
	if state.currentState.keyreleased then state.currentState.keyreleased(key) end
end

function state.load()
	state.getStates("/states")
	state.loadState(state.startState)

	if state.currentState.load then state.currentState.load() end
end

function state.mousefocus(f)
	if state.currentState.mousefocus then state.mousefocus(f) end
end

function state.mousepressed(x,y,button)
	if state.currentState.mousepressed then state.currentState.mousepressed(x,y,button) end
end

function state.mousereleased(x,y,button)
	if state.currentState.mousereleased then state.currentState.mousereleased(x,y,button) end
end

function state.quit()
	if state.currentState.quit then state.currentState.quit() end
end

function state.resize(w,h)
	if state.currentState.resize then state.currentState.resize(w,h) end
end

function state.textinput(text)
	if state.currentState.textinput then state.currentState.textinput(text) end
end

function state.threaderror(thread,errorstr)
	if state.currentState.threaderror then state.currentState.threaderror(thread,errorstr) end
end

function state.update(dt)
	if state.currentState.update then state.currentState.update(dt) end
end

function state.visible(v)
	if state.currentState.visible then state.currentState.visible(v) end
end

-- Funcitons --
function state.loadState(key)
	if key then
		if state.states[key] ~= nil then
			if state.currentState ~= nil then
				if state.currentState.stateClose then state.currentState.stateClose() end
				state.currentState = nil
				object.clearObjects()
			end
			state.currentState = state.states[key]
			if state.currentState.stateOpen then state.currentState.stateOpen() end
		else
			debug.log("[WARNING] No state with key '"..key.."'")
		end
	else
		debug.err("Incorrect call to function 'state.loadState(key)'")
	end
end

function state.getStates(dir,isrepeat)
	if dir then
		if isrepeat == nil then isrepeat = false end

		local files = love.filesystem.getDirectoryItems(dir)
		local lng = table.getn(files)
		for i=1, lng do
			local item = files[i]
			local key = string.gsub(item, ".lua", "")
			if key then
				if love.filesystem.isFile(dir.."/"..item) then
					local holdSta = require(dir.."/"..key)
					if holdSta and type(holdSta) == "table" then
						debug.log("[STATE] Adding state '"..key.."' from directory '"..dir.."'")
						state.states[key] = holdSta
					end
				elseif love.filesystem.isDirectory(dir.."/"..item) and item ~= "blacklist" then
					state.getStates(dir.."/"..item, true)
				end
			end
		end
		if not isrepeat then debug.log() end
	else
		debug.err("Incorrect call to function 'state.getStates(dir,isrepeat)'")
	end
end

return state