debug = {}

-- Functions --
function debug.log(...)
	if main.debugMode == true then
		for k, v in pairs({...}) do io.write(v.." ") end
		io.write("\n")
	end
end

function debug.write(...)
	if main.debugMode == true then
		for k, v in pairs({...}) do io.write(v.." ") end
	end
end

function debug.start(key,msg)
	if key and type(key) == "string" then
		local t, err = timer.start(key)
		if t == true then if msg and type(msg) == "string" then debug.log(msg) end return true else debug.log(err); return nil end
	else
		return nil, "[ERROR] Incorrect call the 'debug.start(key)'"
	end
end

function debug.stop(key,msg,idf)
	if key and type(key) == "string" then
		local t, err = timer.stop(key)
		if t == true and msg and type(msg) == "string" and idf and type(idf) == "string" then msg = string.gsub(msg, idf, err) end
		if t == true then if msg and type(msg) == "string" then debug.log(msg) end return true else debug.log(err); return nil end
	else
		return nil, "[ERROR] Incorrect call the 'debug.start(key)'"
	end
end

return debug