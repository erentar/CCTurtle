rednet.open("left")
m = peripheral.wrap("top")

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
