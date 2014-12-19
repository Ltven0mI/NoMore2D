mouseInput = {}
mouseInput.systemKey = "mouseInput"
mouseInput.runPriority = 1

-- Variables --
mouseInput.buttons = {}

-- Callbacks --
function mouseInput.load(args)
	mouseInput.addButtons()
end

function mouseInput.update(dt)
	for key, val in pairs(mouseInput.buttons) do
		val.cur = love.mouse.isDown(key)
		val.onDown = false
		val.onUp = false
		if val.last ~= val.cur then if val.cur == false then val.onUp = true else val.onDown = true end end
		val.last = val.cur
	end
end

-- Functions --
function mouseInput.addButtons()
	mouseInput.addButton("l")
	mouseInput.addButton("m")
	mouseInput.addButton("r")
	mouseInput.addButton("x1")
	mouseInput.addButton("x2")
end

function mouseInput.addButton(btn)
	if btn and type(btn) == "string" then
		mouseInput.buttons[btn] = {cur=false,last=false,onDown=false,onUp=false}
	end
end

function love.mouse.onDown(btn)
	if btn and type(btn) == "string" then
		if mouseInput.buttons[btn] ~= nil then
			return mouseInput.buttons[btn].onDown
		else
			debug.log("[WARNING] Argument 'btn' in call to function 'love.mouse.onDown(btn)' must be 'l' 'm' 'r' 'x1' or 'x2'")
		end
	else
		debug.err("Incorrect call to function 'love.mouse.onDown(btn)'")
		return nil
	end
end

function love.mouse.onUp(btn)
	if btn and type(btn) == "string" then
		if mouseInput.buttons[btn] ~= nil then
			return mouseInput.buttons[btn].onUp
		else
			debug.log("[WARNING] Argument 'btn' in call to function 'love.mouse.onUp(btn)' must be 'l' 'm' 'r' 'x1' or 'x2'")
		end
	else
		debug.err("Incorrect call to function 'love.mouse.onUp(btn)'")
		return nil
	end
end

return mouseInput