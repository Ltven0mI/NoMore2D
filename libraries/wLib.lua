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

function compareTables(tab1,tab2,ignore)
	local same = true
	if ignore == nil then ignore = {} end
	for key, val in pairs(tab1) do
		local doIgnore = false
		for k, v in pairs(ignore) do
			if v == key then doIgnore = true; break end
		end
		if not doIgnore then
			if type(val) ~= "table" then
				if not (tab2[key] ~= nil and tab2[key] == val) then
					same = false
					break
				end
			else
				if tab2[key] then
					if not compareTables(val, tab2[key], ignore) then same = false; break end
				else
					same = false
					break
				end
			end
		end
	end

	for key, val in pairs(tab2) do
		local doIgnore = false
		for k, v in pairs(ignore) do
			if v == key then doIgnore = true; break end
		end
		if not doIgnore then
			if type(val) ~= "table" then
				if not (tab1[key] ~= nil and tab1[key] == val) then
					same = false
					break
				end
			else
				if tab1[key] then
					if not compareTables(val, tab1[key], ignore) then same = false; break end
				else
					same = false
					break
				end
			end
		end
	end
	return same
end

function tableToString(orig,ignore)
	local str = "{"
	if ignore == nil then ignore = {} end
	for key, val in pairs(orig) do
		local doIgnore = false
		for k, v in pairs(ignore) do
			if v == key then doIgnore = true; break end
		end
		if not doIgnore then
			if type(key) == "number" then key = "["..key.."]=" else key = key .. "=" end
			if str ~= "{" then str = str.."," end
			if type(val) ~= "table" then
				local varStr = tostring(val)
				if type(val) == "string" then varStr = "'"..val.."'" end
				str = str..key..varStr
			else
				str = str..key..tableToString(val, ignore)
			end
		end
	end
	str = str.."}"
	return str
end

function cloneTable(tab,ignore,newTab)
	if ignore == nil then ignore = {} end
	if newTab == nil then newTab = {} end

	for key, val in pairs(tab) do
		local doIgnore = false
		local vType = type(val)
		for i, str in pairs(ignore) do
			if vType == str then doIgnore = true; break end
		end
		if not doIgnore then
			if vType ~= "table" then newTab[key] = val else newTab[key] = cloneTable(val, ignore) end
		end
	end
	return newTab
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
		debug.err("Incorrect call to function 'math.clamp(num,min,max)'")
		return nil
	end
end

function math.lerp(n1,n2,t)
	if n1 and n2 and t then
		local dt = love.timer.getDelta()
		return n1 + ((n2-n1)*t)*(dt*100)
	else
		debug.err("Incorrect call to function 'math.lerp(n1,n2,t)'")
	end
end

function math.anglerp(n1,n2,t)
	if n1 and n2 and t then
		local ad, bd, cd = math.abs(n1-(360+n2)), math.abs(n2-(360+n1)), math.abs(n2-n1)
		if ad < bd and ad < cd then
			n1 = math.lerp(n1, n1+ad, t)
		elseif bd < ad and bd < cd then
			n1 = math.lerp(n1, n1-bd, t)
		else
			n1 = math.lerp(n1, n2, t)
		end
		if n1 > 360 then n1 = n1 - 360 end
		if n1 < 0 then n1 = n1 + 360 end
		return n1
	else
		debug.err("Incorrect call to function 'math.anglerp(n1,n2,t)'")
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
		debug.err("Incorrect call to function 'math.norm(x,y)'")
	end
end

function math.contains(x1,y1,w1,h1,x2,y2,w2,h2)
	if x1 and y1 and w1 and h1 and x2 and y2 and w2 and h2 then
		if (x2<x1 and x2+w2>x1 or x2<x1+w1 and x2+w2>x1+w1 or x2>=x1 and x2+w2<=x1+w1) then
			if ((y2<y1 and y2+h2>y1) or (y2<y1+h1 and y2+h2>y1+h1) or (y2>=y1 and y2+h2<=y1+h1)) then
				return true
			end
		end
		return false
	else
		debug.err("Incorrect call to function 'math.contains(x1,y1,w1,h1,x2,y2,w2,h2)'")
	end
end

function math.onSegment(px,py,qx,qy,rx,ry)
	if qx <= math.max(px, rx) and qx >= math.min(px, rx) and qy <= math.max(py, ry) and qy >= math.min(py, ry) then return true else return false end
end

function math.orientation(px,py,qx,qy,rx,ry)
	local val = (qy-py)*(rx-qx)-(qx-px)*(ry-qy)
    if val==0 then return 0 end
    if val>0 then return 1 else return 2 end
end

function math.intersect(px1,py1,qx1,qy1,px2,py2,qx2,qy2)
	local o1 = math.orientation(px1, py1, qx1, qy1, px2, py2);
	local o2 = math.orientation(px1, py1, qx1, qy1, qx2, qy2);
	local o3 = math.orientation(px2, py2, qx2, qy2, px1, py1);
	local o4 = math.orientation(px2, py2, qx2, qy2, qx1, qy1);
	
	if o1 ~= o2 and o3 ~= o4 then return true end
	
	if o1 == 0 and math.onSegment(px1, py1, px2, py2, qx1, qy1) then return true end
	
	if o2 == 0 and math.onSegment(px1, py1, qx2, qy2, qx1, qy1) then return true end
	
	if o3 == 0 and math.onSegment(px2, py2, px1, py1, qx2, qy2) then return true end
	
	if o4 == 0 and math.onSegment(px2, py2, qx1, qy1, qx2, qy2) then return true end
	
	return false
end

function math.raycast(px1,py1,qx1,qy1,px2,py2,qx2,qy2)
	local x1, y1, x2, y2 = px1, py1, qx1, qy1

	local w = x2 - x1
	local h = y2 - y1
	local dx1, dy1, dx2, dy2 = 0, 0, 0, 0
	if w<0 then dx1 = -1 elseif w>0 then dx1 = 1 end
	if h<0 then dy1 = -1 elseif h>0 then dy1 = 1 end
	if w<0 then dx2 = -1 elseif w>0 then dx2 = 1 end
	local longest = math.abs(w)
	local shortest = math.abs(h)
	if not (longest>shortest) then
		longest = math.abs(h)
		shortest = math.abs(w)
		if h<0 then dy2 = -1 elseif h>0 then dy2 = 1 end
		dx2 = 0            
	end
	local numerator = bit.rshift(longest, 1)

	for i=1, longest do
		if math.intersect(px1, py1, x1, y1, px2, py2, qx2, qy2) then
			return true, x1, y1
		end
		numerator = numerator + shortest
		if not (numerator<longest) then
			numerator = numerator - longest
			x1 = x1 + dx1
			y1 = y1 + dy1
		else
			x1 = x1 + dx2
			y1 = y1 + dy2
		end
	end
	return false
end

return wLib