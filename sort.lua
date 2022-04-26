local tArgs = { ... }
local chest = peripheral.wrap(tArgs[1])
local buffer = peripheral.wrap(tArgs[2])

local chestList = chest.list()
local chestSpan = 0 -- this variable keeps track of what slot the last item in the chest is, useful when removing spaces


-- remove empty space
local sorted = false
while not sorted do

    chestList = chest.list()

    chestSpan = 0
    for slot,item in pairs(chestList) do
        if slot > chestSpan then chestSpan = slot end
    end

    sorted = true
    for slot = 2,chestSpan do
        if chestList[slot-1] == nil then
            sorted = false
            chest.pushItems(peripheral.getName(chest), slot, 999, slot-1)
        end
    end
end

-- sort
function swapItems(a,b)
    parallel.waitForAll(
        function() chest.pushItems(peripheral.getName(buffer),a,999,1) end,
        function() chest.pushItems(peripheral.getName(buffer),b,999,2) end,
        function() chest.pullItems(peripheral.getName(buffer),2,999,a) end,
        function() chest.pullItems(peripheral.getName(buffer),1,999,b) end
    )
end

function comesBeforeAlphabetical(a,b) -- says if a precedes b in alphabetical order
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

sorted = 0
local itemsHaveBeenSwapped = true
while itemsHaveBeenSwapped do
    chestList = chest.list()
    itemsHaveBeenSwapped = false
    for slot=2,chestSpan do
        if comesBeforeAlphabetical(chestList[slot].name,chestList[slot-1].name) then
            itemsHaveBeenSwapped = true
            swapItems(slot,slot-1)
        end
    end
end
