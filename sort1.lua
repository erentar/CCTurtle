local tArgs = { ... }
if #tArgs <1 then
    if turtle == nil then
        print("sort <chest side> <buffer side>")
        return
    else
        print("sort <chest side>")
        return
    end
end

local TESTING = false
if tArgs[1] == "test" then
    TESTING = true
end

if TESTING then
    chestList = {
        [3] = {
            count = 40,
            name = "minecraft:dirt"
        },
        [11] = {
            count = 1,
            name = "minecraft:chest"
        },
        [15] = {
            count = 1,
            name = "computercraft:monitor_advanced"
        },
        [27] = {
            count = 4,
            name = "minecraft:dirt"
        }
    }
else
    chestName = tArgs[1]
    chest = peripheral.wrap(chestName)

    -- only use buffer chest if not turtle
    if turtle == nil then
        buffer = peripheral.wrap(tArgs[2]) 
    end

    chestList = chest.list()
end

function tableLength(_table)
    -- return the number of items in a table
    -- #_table ignores named elements,
    -- and all items after an empty slot
    -- in a chest are named.
    local count = 0
    for _ in pairs(_table) do
        count = count + 1
    end
    return count
end

function tableSpan(_table)
    --- https://github.com/lunarmodules/lua-compat-5.3/issues/56#issuecomment-1119165168
    -- return the highest index
    -- i.e the last slot
    local max = 0
    for k in pairs(_table) do
        if type(k) == "number" and k > max then
            max = k
        end
    end
    return max
end

function dump(o)
--- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function lowestElement(_table)
    for i=0,tableSpan(_table) do
        if _table[i] ~= nil then
            return i
        end
    end
end

function contiguousSpaces(_table)
    -- find contiguous empty spaces
    local contiguousSpaces = {}
    -- format: contiguousSpaces{ {start,end} }
    local lastContiguousSpace = 0
    local contiguousSpacesLength = 0
    for i=1,tableSpan(chestList) do
        repeat -- have to encase this block in repeat until true in order to be able to use `continue`=do break end
            if chestList[i] == nil then
                contiguousSpacesLength = tableSpan(contiguousSpaces)
                if contiguousSpacesLength < 1 then -- if empty
                    contiguousSpaces[1] = {i,i}
                    do break end -- continue
                end

                local lastContiguousSpace = contiguousSpaces[contiguousSpacesLength]
                if i>=(lastContiguousSpace[2]+2) then
                    contiguousSpaces[contiguousSpacesLength+1] = {i,i}
                elseif i<=(lastContiguousSpace[2]+1) then
                    contiguousSpaces[contiguousSpacesLength][2] = i
                end
            end
        until true
    end
    return contiguousSpaces
end

function mv(from,to,_table)
    if TESTING then
        _table[to] = _table[from]
        _table[from] = nil
    else
        chest.pushItems(chestName,from,64,to)
    end
end

local currentContiguousSpaces = contiguousSpaces(chestList)
while next(currentContiguousSpaces) ~= nil do
    local oldKey = currentContiguousSpaces[1][1]
    for key=1,46 do
        if chestList[key] ~= nil then
            print(key)
            if chestList[1] == nil then
                mv(lowestElement(chestList),1,chestList)
                print(string.format("move %d to %d",key,1))
                goto continue
            end
            if oldKey+1 < key then
                mv(key,oldKey+1,chestList)
                print(string.format("move %d to %d",key,oldKey+1))
                -- oldKey = key
                goto continue
            end
            oldKey = key
        end
    end
    ::continue::
    chestList = chest.list()
    currentContiguousSpaces = contiguousSpaces(chestList)
    print("loop")
    -- print(dump(chestList))
    -- print(dump(currentContiguousSpaces))
end

local orderOfChars = {
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
    h = 8,
    i = 9,
    j = 10,
    k = 11,
    l = 12,
    m = 13,
    n = 14,
    o = 15,
    p = 16,
    q = 17,
    r = 18,
    s = 19,
    t = 20,
    u = 21,
    v = 22,
    w = 23,
    x = 24,
    y = 25,
    z = 26,
    _ = 27,
    [":"] = 28
}

function comesBeforeAlphabetical(a,b) -- says if a precedes b in alphabetical order
    local shorter
    if #a < #b then
        shorter = a
    else
        shorter = b
    end

    for i=1, #shorter do
        if a:sub(i,i) == b:sub(i,i) then
            do end
        elseif orderOfChars[a:sub(i,i)] < orderOfChars[b:sub(i,i)] then
            -- a is first
            return true
        elseif orderOfChars[a:sub(i,i)] > orderOfChars[b:sub(i,i)] then
            -- b is first
            return false
        end
    end
end

local chestSize = chest.size()
local swapsHaveBeenMade = true
while swapsHaveBeenMade do
    swapsHaveBeenMade = false
    for i=1,(tableLength(chestList)-1) do
        if ( chestList[i].name ~= chestList[i+1].name ) and ( not comesBeforeAlphabetical(chestList[i].name,chestList[i+1].name) ) then
            mv(i,chestSize,chestList)
            mv(i+1,i,chestList)
            mv(chestSize,i+1,chestList)
            swapsHaveBeenMade = true
        end
    end
    chestList = chest.list()
end