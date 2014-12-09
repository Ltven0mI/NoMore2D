main = {}

require("loader")

-- Variables --
main.debugMode = true
main.colDebug = false
main.font = love.graphics.getFont()
main.width = love.graphics.getWidth()
main.height = love.graphics.getHeight()

-- Callbacks --
function love.draw()
	loader.draw()
end

function love.focus(f)
	loader.focus(f)
end

function love.gamepadaxis(joystick,axis,value)
	loader.gamepadaxis(joystick, axis, value)
end

function love.gamepadpressed(joystick,button)
	loader.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick,button)
	loader.gamepadreleased(joystick, button)
end

function love.joystickadded(joystick)
	loader.joystickadded(joystick)
end

function love.joystickaxis(joystick,axis,value)
	loader.joystickaxis(joystick, axis, value)
end

function love.joystickhat(joystick,hat,direction)
	loader.joystickhat(joystick, hat, direction)
end

function love.joystickpressed(joystick,button)
	loader.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick,button)
	loader.joystickreleased(joystick, button)
end

function love.joystickremoved(joystick)
	loader.joystickremoved(joystick)
end

function love.keypressed(key,isrepeat)
	loader.keypressed(key, isrepeat)
end

function love.keyreleased(key)
	loader.keyreleased(key)
end

function love.load(arg)
	math.randomseed(os.time())
	loader.load(arg)
end

function love.mousefocus(f)
	loader.mousefocus(f)
end

function love.mousepressed(x,y,button)
	loader.mousepressed(x, y, button)
end

function love.mousereleased(x,y,button)
	loader.mousereleased(x, y, button)
end

function love.quit()
	loader.quit()
end

function love.resize(w,h)
	main.width = w
	main.height = h
	loader.resize(w, h)
end

function love.textinput(text)
	loader.textinput(text)
end

function love.threaderror(thread,errorstr)
	loader.threaderror(thread, errorstr)
end

function love.update(dt)
	loader.update(dt)
	if collectgarbage("count")/1024 > 512 then collectgarbage("collect") end
end

function love.visible(v)
	loader.visible(v)
end