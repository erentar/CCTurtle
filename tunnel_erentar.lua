--[[insert this into code, not in the appropriate place
	--gps, get the orientation, get the current coord on axis, an then return to that
		start = gps.getCurrentCoord(orientationaxis)
		orientation = --check if you can get orientation from gps framework, if not ill have to log the movement and judge from that


	--return to start pos
		--go up in order not to hit torches
			--turn back
			turtle.turnLeft()
			turtle.turnLeft()
			turtle.up()
		--get current coords and find the distance needed
		dist = mutlakdeğer(start) - mutlakdeğer(gps.getCurrentCoord(orientationaxis)) --neyse işte, hem negaitf hem pozitifte çalışsın

		turtle.forward(dist)
		print("Returned to pos")"]]


		--##ARGUMENTS##--
local tArgs = { ... }
if #tArgs ~= 1 then
	print( "Usage: tunnel <length>" )
	return
end

local length = tonumber( tArgs[1] )
if length < 1 then
	print( "Tunnel length must be positive" )
	return
end

local depth = 0
local collected = 0



		--##DIGGING##--
--not dig if nothing's in front
local function tryDig(n)
	while turtle.detect() do
		if turtle.dig() then
			--collect()
			sleep(0.2)
		else
			return false
		end
	end
	return true
end

--not dig up if nothing's up
local function tryDigUp()
	while turtle.detectUp() do
		if turtle.digUp() then
			--collect()
			sleep(0.2)
		else
			return false
		end
	end
	return true
end
-- not dig down
local function tryDigDown()
	while turtle.detectDown() do
		if turtle.digDown() then
			--collect()
			sleep(0.2)
		else
			return false
		end
	end
	return true
end

--checkfuel level
local function refuel()
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" or fuelLevel > 0 then
		return
	end

--try refueling with every item until you hit a fuel item
	local function tryRefuel()
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
				turtle.select(n)
				if turtle.refuel(1) then
					turtle.select(1)
					return true
				end
			end
		end
		turtle.select(1)
		return false
	end

	if not tryRefuel() then
		print( "Add more fuel to continue." )
		while not tryRefuel() do
			os.pullEvent( "turtle_inventory" )
		end
		print( "Resuming Tunnel." )
	end
end
--try to go up, if not dig up
local function tryUp()
	refuel()
	while not turtle.up() do
		if turtle.detectUp() then
			if not tryDigUp() then
				return false
			end
		elseif turtle.attackUp() then
			--collect()
		else
			sleep( 0.5 )
		end
	end
	return true0
end

local function tryDown()
	refuel()
	while not turtle.down() do
		if turtle.detectDown() then
			if not tryDigDown() then
				return false
			end
		elseif turtle.attackDown() then
			--collect()
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryForward()
	refuel()
	while not turtle.forward() do
		if turtle.detect() then
			if not tryDig() then
				return false
			end
		elseif turtle.attack() then
			--collect()
		else
			sleep( 0.5 )
		end
	end
	return true
end

print( "Tunnelling..." )

for n=1,length do
	turtle.select(2) -- added later -- selects cobblestone in slot 2
	turtle.placeDown()
	--turtle.placeUp() -- <- added later, if anything this will cause problems
	tryDigUp()
	turtle.turnLeft()
	tryDig()
	tryUp()
	tryDig()
	turtle.placeUp() -- moving the one above here, becasue problems
	turtle.turnRight()
	turtle.turnRight()
	tryDig()
	tryDown()
	tryDig()
	turtle.turnLeft()
	print(n)

	--place torch every 10 blocks
if math.fmod(n, 15) == 0 then
		if turtle.getItemCount(1) > 2 then
		--rotate turtle 180*
		turtle.turnLeft()
		turtle.turnLeft()
		--select slot 1(where torch is placed) -- TORCH
		turtle.select(1)
		turtle.place()
		--rotate it back
		turtle.turnLeft()
		turtle.turnLeft()
		end
end

	if n<length then
		tryDig()
		if not tryForward() then
			print( "Aborting Tunnel." )
			break
		end
	else
		print( "Tunnel complete." )
		--return to start
		turtle.turnLeft()
		tryDig()
		turtle.forward()
		turtle.turnLeft()
		for i=1,(length+15) do
		tryDig()
		turtle.forward()
		end
	end
end

