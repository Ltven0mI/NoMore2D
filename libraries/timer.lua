timer = {}

-- Variables --
timer.timers = {}

-- Functions --
function timer.start(key)
	if key and type(key) == "string" then
		if not timer.timers[key] then
			timer.timers[key] = {s=timer.timeMili()}
			return true
		else
			return nil, "[WARNING] Timer allready exists with key '"..key.."'"
		end
	else
		debug.err("[ERROR] Incorrect call the 'timer.start(key)'")
		return nil
	end
end

function timer.stop(key)
	if key and type(key) == "string" then
		if timer.timers[key] then
			local t = timer.timeMili() - timer.timers[key].s
			timer.timers[key] = nil
			return true, t
		else
			return nil, "[WARNING] Timer does not exist with key '"..key.."'"
		end
	else
		debug.err("[ERROR] Incorrect call the 'timer.stop(key)'")
		return nil
	end
end

function timer.get(key)
	if key and type(key) == "string" then
		if timer.timers[key] then
			return timer.timeMili() - timer.timers[key].s
		else
			return nil, "[WARNING] Timer does not exist with key '"..key.."'"
		end
	else
		debug.err("[ERROR] Incorrect call the 'timer.get(key)'")
		return nil
	end
end

function timer.time()
	return love.timer.getTimer()
end

function timer.timeMili()
	return love.timer.getTime()*1000
end

return timer