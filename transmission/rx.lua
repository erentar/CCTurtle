rednet.open("right")
id,message,protocol = rednet.receive()
m = peripheral.wrap("top")
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
