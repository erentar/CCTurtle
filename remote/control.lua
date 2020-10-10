--replace modemPer with modemPeripheral when done

modemPer = peripheral.find("modem")
modemPer.closeAll() --close previously open channels
modemPer.open(0)
modemPer.open(1)

while true do
	cases = {
		[87] = "forward", -- w
		[83] = "back",    -- s
		[65] = "left",    -- a
		[68] = "right",   -- d
		[81] = "up",      -- q
		[90] = "down",    -- z
		[69] = "mine",    -- e
		[82] = "mineUp",  -- r
		[70] = "mineDown",-- f
		[71] = "exit"     -- g
	}
	key = cases[({os.pullEvent("key")})[2]]
	modemPer.transmit(0,1,key)
	if key == "exit" then
		print("bye")
		break
	end
end
	--modemPer.transmit(0,1,"fucks")

modemPer.closeAll() --close previously open channels
