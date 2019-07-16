rednet.open("left")

function autodetect
	sides = {"front","back","left","right","top","bottom"}
	for i=1,6 do
	testside = sides[i]
		if peripheral.isPresent(testside)	--autodetect monitor
			return testside
		end
	end
end

m.peripheral.wrap(autodetect())

--m = peripheral.wrap("top")

while true do
	os.pullEvent("redstone")
	if redstone.getInput("right") == true then
		rednet.broadcast("open","me")
		print("open")
		peripheral.call("top","clear")
		m.setCursorPos(1,1)
		peripheral.call("top","write","open")
	elseif redstone.getInput("right") == false then
		rednet.broadcast("close","me")
		print("close")
		peripheral.call("top","clear")
		m.setCursorPos(1,1)
		peripheral.call("top","write","close")
	end
end
