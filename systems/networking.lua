-- system setup --
networking = {}
networking.systemKey = "networking"
networking.runPriority = 99

networking.status = "disconnected"
networking.connected = false
networking.ip = "localhost"
networking.port = 641337
networking.clientID = 0

networking.socket = require("socket")
networking.udp = networking.socket.udp()
networking.udp:settimeout(0)

-- love callbacks --
function networking.load()
	--networking:connect()
end

function networking.update(dt)
	local data, msg = networking.udp:receive()
	if data then
		local decoded = {}
		for word in data:gmatch("%S+") do table.insert(decoded,word) end
		local data_type = decoded[1]
		if data_type == "request" then
			networking.request(decoded)
		elseif data_type == "push" then
			networking.push(decoded)
		elseif data_type == "response" then
			networking.response(decoded)
		else
			debug.log("[NETWORKING] Received unknown request type from server!")
		end
	end
end

function networking.draw()
	camera.push()
	camera.setMode("screen")
	love.graphics.print(networking.status.." | "..networking.clientID, 0, 14)
	camera.pop()
end

function networking.keypressed(key)
	if key == "v" then
		networking:connect()
	end
end

function networking.quit()
	networking:disconnect()
end

-- networking callbacks --
function networking.request(data)
	
end

function networking.push(data)
	
end

function networking.response(data)
	if data[2] == "connected" then
		networking.status = "connected"
		networking.clientID = data[3]
	end
end

-- networking functions --
function networking:connect(ip,port)
	if self.status == "connected" then
		networking:disconnect()
	end
	if self.status == "disconnected" then
		self.ip = ip or self.ip
		self.port = port or self.port
		self.udp:setpeername(self.ip, self.port)
		self.status = "connecting"
		self.udp:send("request connect")
	end
end

function networking:disconnect()
	self.udp:send("request disconnect "..networking.clientID)
	self.status = "disconnected"
end

return networking