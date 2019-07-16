rednet.open("right")
id,message,protocol = rednet.receive()

sides = {"front","back","left","right","top","bottom"}

function autodetect
	for i=1,6 do
	testside = sides[i]
		if peripheral.isPresent(testside)	--autodetect monitor
			return testside
		end
	end
end

m.peripheral.wrap(autodetect())

--[[for i=1,6 do
	testside = sides[i]
	if peripheral.isPresent(testside)	--autodetect monitor
		--monitor = testside
		return 
	end
end
	m = peripheral.wrap(monitor)
--]]

while true do
	os.pullEvent("redstone")

	if message == "open" then
		redstone.setOutput("left",true)
		print("open")
		peripheral.call("top","clear")
		m.setCursorPos(1,1)
		peripheral.call("top","write","open")

	elseif message == "close" then
		print("close")
		redstone.setOutput("left",false)
		peripheral.call("top","clear")
		m.setCursorPos(1,1)
		peripheral.call("top","write","close")
	end
end
