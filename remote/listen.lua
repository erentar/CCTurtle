local modemPer = peripheral.find("modem")
modemPer.closeAll() --close previously open channels
modemPer.open(0)

while true do
	eventType,peripheralSide,recieveChannel,replyChannel,message = os.pullEvent("modem_message")
	local fnc = turtle[message]
	if fnc then
		fnc()
	elseif message == "exit" then
		break
	end
end

modemPer.closeAll() --close previously open channels
