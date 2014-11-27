weather = {}
weather.systemKey = "weather"
weather.runPriority = 5

-- Variables --
weather.speed = 100

weather.day = 0
weather.hour = 0
weather.minute = 0
weather.second = 0

-- Callbacks --
function weather.update(dt)
	weather.second = weather.second + dt*weather.speed
	if weather.second >= 60 then weather.minute = weather.minute+math.floor(weather.second/60); weather.second = weather.second-math.floor(weather.second/60)*60 end
	if weather.minute >= 60 then weather.hour = weather.hour+math.floor(weather.minute/60); weather.minute = weather.minute-math.floor(weather.minute/60)*60 end
	if weather.hour >= 24 then weather.day = weather.day+math.floor(weather.hour/24); weather.hour = weather.hour-math.floor(weather.hour/24)*24 end
	--debug.log(weather.second, weather.minute, weather.hour, weather.day)
end

return weather