rednet.open("right")
id,message,protocol = rednet.receive()

function autodetect
	sides = {"front","back","left","right","top","bottom"}
	for i=1,6 do
	testside = sides[i]
		if peripheral.isPresent(testside)	--autodetect monitor
			return testside
		end
	end
end

monitor = autodetect()

--get argument(override monitor autodetect)
local tArgs = {...}
if #tArgs != 1 then
	monitor = tArgs[1]
end

m.peripheral.wrap(monitor)

while true do
	os.pullEvent("redstone")

	if message == "open" then
		redstone.setOutput("left",true)
		print("open")
		peripheral.call("top","clear")
		m.setCursorPos(1,1)
		peripheral.call("top","write","open")

	elseif message == "close" then
		redstone.setOutput("left",false)
		print("close")
		peripheral.call("top","clear")
		m.setCursorPos(1,1)
		peripheral.call("top","write","close")
	end
end