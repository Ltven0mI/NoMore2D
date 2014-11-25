input = {}
input.systemKey = "input"
input.runPriority = 100

-- Variables --
input.curText = ""
input.keys = {}

-- Callbacks --

function input.draw()
	input.curText = ""
	input.clearKeys()
end

function input.textinput(text)
	input.curText = input.curText .. text
end

function input.keypressed(key)
	if not input.keys[key] then input.keys[key] = {} end
	input.keys[key].onDown = true
	input.keys[key].isDown = true
end

function input.keyreleased(key)
	if not input.keys[key] then input.keys[key] = {} end
	input.keys[key].onUp = true
	input.keys[key].isDown = false
end

-- Functions --
function input.clearKeys()
	for key, val in pairs(input.keys) do
		val.onDown = false
		val.onUp = false
	end
end

function input.getCurrentText()
	if input.curText then return input.curText else return "" end
end

function input.isDown(key)
	if key and type(key) == "string" then
		if input.keys[key] then
			return input.keys[key].isDown
		else
			return false
		end
	else
		debug.log("[ERROR] Incorrect call to function 'input.isDown(key)'")
		return nil
	end
end

function input.onDown(key)
	if key and type(key) == "string" then
		if input.keys[key] then
			return input.keys[key].onDown
		else
			return false
		end
	else
		debug.log("[ERROR] Incorrect call to function 'input.onDown(key)'")
		return nil
	end
end

function input.onUp(key)
	if key and type(key) == "string" then
		if input.keys[key] then
			return input.keys[key].onUp
		else
			return false
		end
	else
		debug.log("[ERROR] Incorrect call to function 'input.onUp(key)'")
		return nil
	end
end

return input