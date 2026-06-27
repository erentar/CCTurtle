--++ definitions
local alphabet = {
    a = 11,
    b = 12,
    c = 13,
    d = 14,
    e = 15,
    f = 16,
    g = 17,
    h = 18,
    i = 19,
    j = 20,
    k = 21,
    l = 22,
    m = 23,
    n = 24,
    o = 25,
    p = 26,
    q = 27,
    r = 28,
    s = 29,
    t = 30,
    u = 31,
    v = 32,
    w = 33,
    x = 34,
    y = 35,
    z = 36,
    _ = 37,
    [":"] = 38
}

local function characterOrder(char1,char2) -- returns true if char1 comes before char2 on the alphabet
    return alphabet[char1] < alphabet[char2]
end

local function stringOrder(str1, str2) -- returns true if str1 comes before str2 on the dictionary
    local shorter
    if #str1 < #str2 then
        shorter = str1
    else
        shorter = str2
    end
    for i=1,#shorter do
        local char1 = str1:sub(i,i)
        local char2 = str2:sub(i,i)
        if char1 ~= char2 then
            return characterOrder(char1,char2)
        end
    end
    -- if not returned yet, all characters are equal, however strings may differ in length
    if shorter == str1 then
        return true
    else
        return false
    end
end

local function move(inventoryName,from,to)
    inventory.pushItems(inventoryName,from,9999,to)
end

local function swap(inventoryName,a,b)
    parallel.waitForAll(
        function() move(inventoryName,a,chestSize) end,
        function() move(inventoryName,b,a) end,
        function() move(inventoryName,chestSize,b) end
    )
end

---- definitions

local startTime = os.epoch("utc")

local chests = { peripheral.find("inventory") } -- what the fuck is this
for _, chest1 in pairs(chests) do
    local chest = chest1
    local chestList = chest.list()
    chestSize = chest.size()
    local chestName = peripheral.getName(chest)

    local emptySlots = {}
    for i=1,chestSize do
        if chestList[i] == nil then
            table.insert(emptySlots,i)
            break
        end
    end

    if #emptySlots == 0 then
        error("chest needs one empty slot")
    end

    local lastEmptySlot = emptySlots[#emptySlots]
    if lastEmptySlot ~= chestSize then -- last slot is not empty
        move(chestName,chestSize,emptySlots[1])
    end

    local sorted = false
    while sorted == false do
        sorted = true
        for i=2,chestSize do
            if chestList[i] == nil then
                goto continue
            end
            -- here on not nil

            if chestList[i-1] == nil then
                sorted = false
                parallel.waitForAll(
                    function() move(chestName,i,i-1) end,
                    function() chestList = chest.list() end
                )
                i = i-1
            end

            if (chestList[i-1] == nil) then
                goto continue
            end

            if not stringOrder(chestList[i-1]["name"],chestList[i]["name"]) then
                parallel.waitForAll(
                    function() swap(chest,i-1,i) end,
                    function() chestList = chest.list() end
                )
                sorted = false
            elseif chestList[i-1]["name"] == chestList[i]["name"] then
                parallel.waitForAll(
                    function() move(chestName,i,i-1) end,
                    function() chestList = chest.list() end
                )
                sorted = false
            end
            ::continue::
        end
    end
end

local endTime = os.epoch("utc")
timing = endTime - startTime
print(timing)
