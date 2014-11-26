main = {}
main.loader = require "loader"

-- Variables --
main.debugMode = true
main.font = love.graphics.getFont()
main.width = love.graphics.getWidth()
main.height = love.graphics.getHeight()

-- Callbacks --
function love.draw()
	main.loader.draw()
end

function love.focus(f)
	main.loader.focus(f)
end

function love.gamepadaxis(joystick,axis,value)
	main.loader.gamepadaxis(joystick, axis, value)
end

function love.gamepadpressed(joystick,button)
	main.loader.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick,button)
	main.loader.gamepadreleased(joystick, button)
end

function love.joystickadded(joystick)
	main.loader.joystickadded(joystick)
end

function love.joystickaxis(joystick,axis,value)
	main.loader.joystickaxis(joystick, axis, value)
end

function love.joystickhat(joystick,hat,direction)
	main.loader.joystickhat(joystick, hat, direction)
end

function love.joystickpressed(joystick,button)
	main.loader.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick,button)
	main.loader.joystickreleased(joystick, button)
end

function love.joystickremoved(joystick)
	main.loader.joystickremoved(joystick)
end

function love.keypressed(key,isrepeat)
	main.loader.keypressed(key, isrepeat)
end

function love.keyreleased(key)
	main.loader.keyreleased(key)
end

function love.load(arg)
	math.randomseed(os.time())
	main.loader.load(arg)
end

function love.mousefocus(f)
	main.loader.mousefocus(f)
end

function love.mousepressed(x,y,button)
	main.loader.mousepressed(x, y, button)
end

function love.mousereleased(x,y,button)
	main.loader.mousereleased(x, y, button)
end

function love.quit()
	main.loader.quit()
end

function love.resize(w,h)
	main.width = w
	main.height = h
	main.loader.resize(w, h)
end

function love.textinput(text)
	main.loader.textinput(text)
end

function love.threaderror(thread,errorstr)
	main.loader.threaderror(thread, errorstr)
end

function love.update(dt)
	main.loader.update(dt)
end

function love.visible(v)
	main.loader.visible(v)
end