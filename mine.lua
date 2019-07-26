--[[
this file is going to be for mining out entire tunnels/mineshafts, in 64*64/4*L/R format
]]--
--[[
2 large chests are behind the starting position of the turtle.
--]]
--[[
==TODO=={
* torch and fuel source definition
		}
]]--
--</headers>

function autodetect
	sides = {"front","back","left","right","top","bottom"}
	local i
	for	i=1,6 do
		testside = sides[i]
		if peripheral.isPresent(testside)
			return testside
		end
	end
end

length = tonumber(arg[1])

./tunnel_erentar length --mine main shaft

function sidexcavate
	for i=1,(length/4) do
		-- first branch to left --
		turtle.turnLeft()		--
		turtle.turnLeft()		--
		turtle.forward()		--
		turtle.forward()		--
		turtle.turnLeft			--
		./tunnel_erentar 64		--
		-- 		  </> 			--
	end						}
end

sidexcavate()
turtle.turnLeft()
turtle.forward()
turtle.turnRight() --turtle is now at the middle of the last tunnel
turtle.forward()
turtle.forward()
turtle.forward()
sidexcavate()
