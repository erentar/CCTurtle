local modemPer = peripheral.find("modem")
modemPer.closeAll() --close previously open channels
modemPer.open(0)
modemPer.open(1)

while true do
	local cases = {
		[87] = "forward", -- w
		[83] = "back",    -- s
		[65] = "turnLeft",    -- a
		[68] = "turnRight",   -- d
		[81] = "up",      -- q
		[90] = "down",    -- z
		[69] = "dig",    -- e
		[82] = "digUp",  -- r
		[70] = "digDown",-- f
		[71] = "exit"     -- g
	}
	local key = cases[({os.pullEvent("key")})[2]]
	modemPer.transmit(0,1,key)
	if key == "exit" then
		print("bye")
		break
	end
end

modemPer.closeAll() --close previously open channels
