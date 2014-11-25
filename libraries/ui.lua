ui = {}

-- Variables --
ui.var = {}
ui.var.bgIdle = {r=255,g=255,b=255,a=255}
ui.var.bgActive = {r=255,g=255,b=255,a=255}
ui.var.bgHover = {r=255,g=255,b=255,a=255}
ui.var.fgIdle = {r=0,g=0,b=0,a=255}
ui.var.fgActive = {r=0,g=0,b=0,a=255}
ui.var.fgHover = {r=0,g=0,b=0,a=255}

ui.var.bgIdleAux = {r=255,g=255,b=255,a=255}
ui.var.bgActiveAux = {r=255,g=255,b=255,a=255}
ui.var.bgHoverAux = {r=255,g=255,b=255,a=255}
ui.var.fgIdleAux = {r=0,g=0,b=0,a=255}
ui.var.fgActiveAux = {r=0,g=0,b=0,a=255}
ui.var.fgHoverAux = {r=0,g=0,b=0,a=255}

ui.var.mode = "screen"
ui.var.style = "fill"
ui.var.lineWidth = 1

ui.pushpop = {}
ui.pushCount = 0

ui.groupCount = 0

ui.curDropMenu = nil

-- Functions --
function ui.mouseOver(x,y,w,h)
	if x and y and w and h then
		local mx, my
		if camera then mx, my = camera.getMouse() else mx, my = love.mouse.getPosition() end
		if mx>x and mx<x+w and my>y and my<y+h then return true else return false end
	else
		debug.log("[ERROR] Incorrect call to function 'ui.mouseOver(x,y,w,h)'")
	end
end

function ui.updateColor(cType,md,mo)
	if cType and type(cType) == "string" and md ~= nil and mo ~= nil then
		if cType == "fg" then
			if mo then if md then ui.setCurrentColor(ui.var.fgActive) else ui.setCurrentColor(ui.var.fgHover) end else ui.setCurrentColor(ui.var.fgIdle) end
		elseif cType == "bg" then
			if mo then if md then ui.setCurrentColor(ui.var.bgActive) else ui.setCurrentColor(ui.var.bgHover) end else ui.setCurrentColor(ui.var.bgIdle) end
		else
			debug.log("[WARNING] Argument 'cType' in call to function 'ui.updateColor(cType,md,mo)' must be 'fg' or 'bg'")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'ui.updateColor(cType,md,mo)'")
	end
end

function ui.setCurrentColor(color)
	if color and type(color) == "table" and color.r and color.g and color.b and color.a then
		love.graphics.setColor(color.r, color.g, color.b, color.a)
	else
		debug.log("[ERROR] Incorrect call to function 'ui.setCurrentColor(color)'")
	end
end

function ui.setColor(cType,cState,color,aux)
	if cType and type(cType) == "string" and cState and type(cState) == "string" and color and type(color) == "table" then
		if not aux then aux = false end
		if aux == false then
			if cType == "fg" then
				if cState == "idle" then
					ui.var.fgIdle = color
				elseif cState == "hover" then
					ui.var.fgHover = color
				elseif cState == "active" then
					ui.var.fgActive = color
				else
					debug.log("[WARNING] Argument 'cState' in call to function 'ui.setColor(cType,cState,color,aux)' must be 'idle' 'hover' or 'active'")
				end
			elseif cType == "bg" then
				if cState == "idle" then
					ui.var.bgIdle = color
				elseif cState == "hover" then
					ui.var.bgHover = color
				elseif cState == "active" then
					ui.var.bgActive = color
				else
					debug.log("[WARNING] Argument 'cState' in call to function 'ui.setColor(cType,cState,color,aux)' must be 'idle' 'hover' or 'active'")
				end
			else
				debug.log("[WARNING] Argument 'cType' in call to function 'ui.setColor(cType,cState,color,aux)' must be 'fg' or 'bg'")
			end
		else
			if cType == "fg" then
				if cState == "idle" then
					ui.var.fgIdleAux = color
				elseif cState == "hover" then
					ui.var.fgHoverAux = color
				elseif cState == "active" then
					ui.var.fgActiveAux = color
				else
					debug.log("[WARNING] Argument 'cState' in call to function 'ui.setColor(cType,cState,color,aux)' must be 'idle' 'hover' or 'active'")
				end
			elseif cType == "bg" then
				if cState == "idle" then
					ui.var.bgIdleAux = color
				elseif cState == "hover" then
					ui.var.bgHoverAux = color
				elseif cState == "active" then
					ui.var.bgActiveAux = color
				else
					debug.log("[WARNING] Argument 'cState' in call to function 'ui.setColor(cType,cState,color,aux)' must be 'idle' 'hover' or 'active'")
				end
			else
				debug.log("[WARNING] Argument 'cType' in call to function 'ui.setColor(cType,cState,color,aux)' must be 'fg' or 'bg'")
			end
		end
	else
		debug.log("[ERROR] Incorrect call to function 'ui.setColor(cType,cState,color,aux)'")
	end
end

function ui.setStyle(style)
	if style and type(style) == "string" then
		if style == "fill" or style == "line" or style == "outline" then
			ui.var.style = style
		else
			debug.log("[WARNING] Argument 'style' in call to function 'ui.setStyle(style)' must be 'fill' 'line' or 'outline'")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'ui.setStyle(style)'")
	end
end

function ui.setLineWidth(width)
	if width then
		ui.var.lineWidth = width
		love.graphics.setLineWidth(width)
	else
		debug.log("[ERROR] Incorrect call to function 'ui.setLineWidth(width)'")
	end
end

function ui.setMode(mode)
	if mode and type(mode) == "string" then
		if mode == "world" or mode == "screen" then
			ui.var.mode = mode
		else
			debug.log("[WARNING] Argument 'mode' in call to function 'ui.setMode(mode)' must be 'world' or 'screen'")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'ui.setMode(mode)'")
	end
end

function ui.push()
	ui.pushCount = ui.pushCount + 1
	ui.pushpop[ui.pushCount] = {}
	for key, val in pairs(ui.var) do
		if type(val) ~= "function" then
			ui.pushpop[ui.pushCount][key] = val
		end
	end
end

function ui.pop()
	for key, val in pairs(ui.pushpop[ui.pushCount]) do
		if type(val) ~= "function" then
			ui.var[key] = val
		end
	end
	ui.pushpop[ui.pushCount] = nil
	ui.pushCount = ui.pushCount - 1
end

function ui.beginGroup(x,y,w,h)
	if x and y and w and h then
		love.graphics.setScissor(x, y, w, h)
		ui.groupCount = ui.groupCount + 1
	else
		debug.log("[ERROR] Incorrect call to function 'ui.beginGroup(x,y,w,h)'")
	end
end

function ui.endGroup()
	if ui.groupCount > 0 then
		love.graphics.setScissor()
		ui.groupCount = ui.groupCount - 1
	else
		debug.log("[ERROR] Uneven 'ui.beginGroup(x,y,w,h)' to 'ui.endGroup()'")
	end
end

function ui.dropButton(text,style,btn)
	if ui.curDropMenu then
		local menu = ui.curDropMenu
		menu.count = menu.count + 1
		if menu.open then
			camera.push()
				camera.setMode(ui.var.mode)
				if not text then text = "" end
				if not style then style = menu.style end
				if not btn then btn = "l" end

				local x, y, w, h = menu.x+menu.w*0.05, menu.y+(menu.h+menu.h/10)*menu.count, menu.w*0.9, menu.h
				local od, md, mo = love.mouse.onDown(btn), love.mouse.isDown(btn), ui.mouseOver(x, y, w, h)
				local fw, fh = main.font:getWidth(text), main.font:getHeight(text)
				local lw = ui.var.lineWidth

				ui.updateColor("bg", md, mo)
				if style == "line" or style == "outline" then love.graphics.rectangle("line", x, y, w, h) end
				if style == "outline" then love.graphics.rectangle("fill", x+lw*1.5, y+lw*1.5, w-(lw*1.5)*2, h-(lw*1.5)*2) end
				if style == "fill" then love.graphics.rectangle("fill", x, y, w, h) end
				ui.updateColor("fg", md, mo)
				love.graphics.print(text, x+w/2-fw/2, y+h/2-fh/2)
			camera.pop()
			if mo and od then return true else return false end
		end
	else
		debug.log("[ERROR] 'ui.dropButton(text,style,btn)' must be called inside a 'ui.dropStart(x,y,w,h,act,text,style,btn)' and 'ui.dropEnd()'")
	end
end

function ui.dropStart(x,y,w,h,act,text,style,btn)
	if x and y and w and h and act ~= nil then
		if not ui.curDropMenu then
			camera.push()
				camera.setMode(ui.var.mode)
				if not btn then btn = "l" end
				if not style then style = ui.var.style end
				if not text then text = "" end

				local od, md, mo = love.mouse.onDown(btn), love.mouse.isDown(btn), ui.mouseOver(x, y, w, h)
				local fw, fh = main.font:getWidth(text), main.font:getHeight(text)
				local lw = ui.var.lineWidth

				if mo and od then act = not act end

				ui.updateColor("bg", md, mo)
				if style == "line" or style == "outline" then love.graphics.rectangle("line", x, y, w, h) end
				if style == "outline" then love.graphics.rectangle("fill", x+lw*1.5, y+lw*1.5, w-(lw*1.5)*2, h-(lw*1.5)*2) end
				if style == "fill" then love.graphics.rectangle("fill", x, y, w, h) end
				ui.updateColor("fg", md, mo)
				love.graphics.print(text, x+w/2-fw/2, y+h/2-fh/2)
			camera.pop()
			ui.curDropMenu = {open=act,count=0,style=style,x=x,y=y,w=w,h=h}
			return act
		else
			debug.log("[WARNING] Uneven 'ui.dropStart(x,y,w,h,act,text,style,btn)' to 'ui.dropEnd()'")
		end
	else
		debug.log("[ERROR] Incorrect call to function 'ui.dropStart(x,y,w,h,act,text,style,btn)'")
	end
end

function ui.dropEnd()
	if ui.curDropMenu then
		ui.curDropMenu = nil
	else
		debug.log("[WARNING] Uneven 'ui.dropStart(x,y,w,h,act,text,style,btn)' to 'ui.dropEnd()'")
	end
end

function ui.draw(drawable,x,y,w,h,r)
	if drawable and type(drawable) == "userdata" and x and y then
		
		camera.push()
			camera.setMode(ui.var.mode)
			local iw, ih = drawable:getWidth(), drawable:getHeight()
			if not w then w = iw end
			if not h then h = ih end
			if not r then r = 0 end
			ui.setCurrentColor({r=255,g=255,b=255,a=255})
			love.graphics.draw(drawable, x+w/2, y+h/2, math.rad(r), w/iw, h/ih, iw/2, ih/2)
		camera.pop()
	else
		debug.log("[ERROR] Incorrect call to function 'ui.draw(drawable,x,y,w,h,r)'")
	end
end

function ui.tickbox(x,y,w,h,act,style,btn)
	if x and y and w and h and act ~= nil then
		camera.push()
			camera.setMode(ui.var.mode)
			if not btn then btn = "l" end
			if not style then style = ui.var.style end
			local text
			if act then text = "O" else text = "X" end

			local od, md, mo = love.mouse.onDown(btn), love.mouse.isDown(btn), ui.mouseOver(x, y, w, h)
			local fw, fh = main.font:getWidth(text), main.font:getHeight(text)
			local lw = ui.var.lineWidth

			if mo and od then act = not act end

			ui.updateColor("bg", md, mo)
			if style == "line" or style == "outline" then love.graphics.rectangle("line", x, y, w, h) end
			if style == "outline" then love.graphics.rectangle("fill", x+lw*1.5, y+lw*1.5, w-(lw*1.5)*2, h-(lw*1.5)*2) end
			if style == "fill" then love.graphics.rectangle("fill", x, y, w, h) end
			ui.updateColor("fg", md, mo)
			love.graphics.print(text, x+w/2-fw/2, y+h/2-fh/2)
		camera.pop()
		return act
	else
		debug.log("[ERROR] Incorrect call to function 'ui.tickbox(x,y,w,h,act,style,btn)'")
		return nil
	end
end

function ui.imageButton(img,x,y,w,h,r,btn)
	if x and y and w and h and img and type(img) == "userdata" then
		camera.push()
			camera.setMode(ui.var.mode)
			local iw, ih = img:getWidth(), img:getHeight()
			if not w then w = iw end
			if not h then h = ih end
			if not r then r = 0 end
			if not btn then btn = "l" end

			local od, md, mo = love.mouse.onDown(btn), love.mouse.isDown(btn), ui.mouseOver(x, y, w, h)

			ui.updateColor("bg", md, mo)
			love.graphics.draw(img, x+w/2, y+h/2, math.rad(r), w/iw, h/ih, iw/2, ih/2)

			if mo and od then return true else return false end
		camera.pop()
	else
		debug.log("[ERROR] Incorrect call to function 'ui.imageButton(img,x,y,w,h,r,btn)'")
	end
end

function ui.button(x,y,w,h,text,style,btn)
	if x and y and w and h then
		camera.push()
			camera.setMode(ui.var.mode)
			if not btn then btn = "l" end
			if not style then style = ui.var.style end
			if not text then text = "" end

			local od, md, mo = love.mouse.onDown(btn), love.mouse.isDown(btn), ui.mouseOver(x, y, w, h)
			local fw, fh = main.font:getWidth(text), main.font:getHeight(text)
			local lw = ui.var.lineWidth

			ui.updateColor("bg", md, mo)
			if style == "line" or style == "outline" then love.graphics.rectangle("line", x, y, w, h) end
			if style == "outline" then love.graphics.rectangle("fill", x+lw*1.5, y+lw*1.5, w-(lw*1.5)*2, h-(lw*1.5)*2) end
			if style == "fill" then love.graphics.rectangle("fill", x, y, w, h) end
			ui.updateColor("fg", md, mo)
			love.graphics.print(text, x+w/2-fw/2, y+h/2-fh/2)
		camera.pop()
		if mo and od then return true else return false end
	else
		debug.log("[ERROR] Incorrect call to function 'ui.button(x,y,w,h,text,style,btn)'")
		return nil
	end
end

function ui.textbox(x,y,w,h,act,text,style,btn)
	if x and y and w and h and act ~= nil and text then
		camera.push()
			camera.setMode(ui.var.mode)
			if not btn then btn = "l" end
			if not style then style = ui.var.style end

			local od, md, mo = love.mouse.onDown(btn), love.mouse.isDown(btn), ui.mouseOver(x, y, w, h)
			local fw, fh = main.font:getWidth(text.."|"), main.font:getHeight(text.."|")
			local lw = ui.var.lineWidth

			if od and mo then act = true end
			if od and not mo then act = false end
			if act then text = text .. input.getCurrentText(); if input.onDown("backspace") then text = text:sub(1, #text-1) end end

			ui.updateColor("bg", md, mo)
			if style == "line" or style == "outline" then love.graphics.rectangle("line", x, y, w, h) end
			if style == "outline" then love.graphics.rectangle("fill", x+lw*1.5, y+lw*1.5, w-(lw*1.5)*2, h-(lw*1.5)*2) end
			if style == "fill" then love.graphics.rectangle("fill", x, y, w, h) end
			ui.updateColor("fg", md, mo)
			ui.beginGroup(x, y, w, h)
				love.graphics.print(text.."|", x+w/2-fw/2, y+h/2-fh/2)
			ui.endGroup()
		camera.pop()
		return act, text
	else
		debug.log("[ERROR] Incorrect call to function 'ui.textbox(x,y,w,h,act,text,style,btn)'")
		return nil
	end
end

function ui.slider(x,y,w,h,p,pm,typ,text,style,btn)
	if x and y and w and h and p and pm then
		camera.push()
			camera.setMode(ui.var.mode)
			if not style then style = ui.var.style end
			if not text then text = "" end
			if not typ then if w > h then typ = "h" else typ = "v" end end
			if not btn then btn = "l" end

			local md, mo = love.mouse.isDown(btn), ui.mouseOver(x, y, w, h)
			local mx, my = camera.getMouse()
			local fw, fh = main.font:getWidth(text), main.font:getHeight(text)
			local lw = ui.var.lineWidth
			local sX, sY = 1, 1

			if mo and md then if typ == "h" then p = pm*((mx-(x+lw/2))/(w-lw)) else p = pm*((my-(y+lw/2))/(h-lw)) end end
			p = math.clamp(p, 0, pm)

			if typ == "v" then sY = p/pm elseif typ == "h" then sX = p/pm end

			if style == "line" then 
				ui.setCurrentColor(ui.var.bgIdle)
				love.graphics.rectangle("line", x, y, w, h)
				ui.setCurrentColor(ui.var.bgIdleAux)
				love.graphics.rectangle("line", x+lw*1.5, y+lw*1.5, (w-(lw*1.5)*2)*sX, (h-(lw*1.5)*2)*sY)
			end
			if style == "outline" then
				ui.setCurrentColor(ui.var.bgIdle)
				love.graphics.rectangle("line", x, y, w, h)
				ui.setCurrentColor(ui.var.bgIdleAux)
				love.graphics.rectangle("fill", x+lw*1.5, y+lw*1.5, (w-(lw*1.5)*2)*sX, (h-(lw*1.5)*2)*sY)
			end
			if style == "fill" then
				ui.setCurrentColor(ui.var.bgIdle)
				love.graphics.rectangle("line", x, y, w, h)
				ui.setCurrentColor(ui.var.bgIdleAux)
				love.graphics.rectangle("fill", x+lw/2, y+lw/2, (w-lw)*sX, (h-lw)*sY)
			end
			ui.setCurrentColor(ui.var.fgIdle)
			love.graphics.print(text, x+w/2-fw/2, y+h/2-fh/2)
		camera.pop()
		return p
	else
		debug.log("[ERROR] Incorrect call to function 'ui.slider(x,y,w,h,p,pm,typ,text,style)'")
		return nil
	end
end

function ui.bar(x,y,w,h,p,pm,typ,text,style)
	if x and y and w and h and p and pm then
		camera.push()
			camera.setMode(ui.var.mode)
			if not style then style = ui.var.style end
			if not text then text = "" end
			if not typ then if w > h then typ = "h" else typ = "v" end end

			local fw, fh = main.font:getWidth(text), main.font:getHeight(text)
			local lw = ui.var.lineWidth
			local sX, sY = 1, 1

			p = math.clamp(p, 0, pm)

			if typ == "v" then sY = p/pm elseif typ == "h" then sX = p/pm end

			if style == "line" then 
				ui.setCurrentColor(ui.var.bgIdle)
				love.graphics.rectangle("line", x, y, w, h)
				ui.setCurrentColor(ui.var.bgIdleAux)
				love.graphics.rectangle("line", x+lw*1.5, y+lw*1.5, (w-(lw*1.5)*2)*sX, (h-(lw*1.5)*2)*sY)
			end
			if style == "outline" then
				ui.setCurrentColor(ui.var.bgIdle)
				love.graphics.rectangle("line", x, y, w, h)
				ui.setCurrentColor(ui.var.bgIdleAux)
				love.graphics.rectangle("fill", x+lw*1.5, y+lw*1.5, (w-(lw*1.5)*2)*sX, (h-(lw*1.5)*2)*sY)
			end
			if style == "fill" then
				ui.setCurrentColor(ui.var.bgIdle)
				love.graphics.rectangle("line", x, y, w, h)
				ui.setCurrentColor(ui.var.bgIdleAux)
				love.graphics.rectangle("fill", x+lw/2, y+lw/2, (w-lw)*sX, (h-lw)*sY)
			end
			ui.setCurrentColor(ui.var.fgIdle)
			love.graphics.print(text, x+w/2-fw/2, y+h/2-fh/2)
		camera.pop()
	else
		debug.log("[ERROR] Incorrect call to function 'ui.bar(x,y,w,h,p,pm,typ,text,style)'")
	end
end

return ui