modemPer = peripheral.find("modem")
modemPer.closeAll() --close previously open channels
modemPer.open(0)

while true do
	eventType,peripheralSide,recieveChannel,replyChannel,message = os.pullEvent("modem_message")
	if message == "forward" then
		turtle.forward()
	elseif message == "back" then
		turtle.back()
	elseif message == "left" then
		turtle.turnLeft()
	elseif message == "right" then
		turtle.turnRight()
	elseif message == "up" then
		turtle.up()
	elseif message == "down" then
		turtle.down()
	elseif message == "mine" then
		turtle.dig()
	elseif message == "mineUp" then
		turtle.digUp()
	elseif message == "mineDown" then
		turtle.digDown()
	elseif message == "exit" then
		break
	end
end

modemPer.closeAll() --close previously open channels
