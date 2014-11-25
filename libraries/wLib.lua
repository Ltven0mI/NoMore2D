wLib = {}

function printTable(table,params,ind,it,txt)
	if ind == nil then ind = 0 end
	if txt == nil then txt = "" end
	if params and params.name and it == nil then txt=txt..tostring(params.name).." = " end
	txt=txt.."{\n"
	for key, val in pairs(table) do
		for i=0, ind do txt=txt.."|   " end
		txt=txt..tostring(key).." = "
		if type(val) ~= "table" then
			txt=txt..tostring(val)..",\n"
		elseif type(val) == "table" then
			txt = printTable(val,params,ind+1,true,txt)
		end
	end
	if it ~= nil then for i=1, ind do txt=txt.."|   " end end
	txt=txt.."}\n"

	if it == nil and params and params.name and params.toFile == true then
		if not love.filesystem.isFile(params.name) then
			love.filesystem.newFile(params.name..".printTable", "a")
		end
		if love.filesystem.isFile(params.name..".printTable") then
			if params.force == true then
				love.filesystem.write(params.name..".printTable", txt)
			else
				love.filesystem.append(params.name..".printTable", txt)
			end
		end
	end
	if it == nil then io.write(txt) end
	return txt
end

-- Math Functions
function math.dist(ax, az, bx, bz) 
    return math.sqrt((bx - ax)*(bx - ax) + (bz - az)*(bz - az));
end

function math.round(number)
	if number-math.floor(number) >= 0.5 then return math.ceil(number) else return math.floor(number) end
end

function math.clamp(num,min,max)
	if num and min and max then
		if num < min then num = min end
		if num > max then num = max end
		return num
	else
		debug.log("[ERROR] Incorrect call to function 'math.clamp(num,min,max)'")
		return nil
	end
end

function math.lerp(n1,n2,t)
	if n1 and n2 and t then
		return n1 + (n2-n1)*t
	else
		debug.log("[ERROR] Incorrect call to function 'math.lerp(n1,n2,t)'")
	end
end

function math.norm(x,y)
	if x and y then
		local mag = math.sqrt((x*x)+(y*y))
		local xx, yy = math.abs(x/mag), math.abs(y/mag)
		if xx ~= xx then xx = 0 end
		if yy ~= yy then yy = 0 end
		return xx, yy
	else
		debug.log("[ERROR] Incorrect call to function 'math.norm(x,y)'")
	end
end

return wLib