
local js = require("js")
local window = js.global
local document = window.document
xml = {}
xml.maps = nil
xml.cats = nil
xml.passwords = nil
subItems = nil
local debug = false -- only first 1000 passwords for speed
-- To update data, open the data/xml files and paste the contents of
-- the xml between the [[ ]] brackets on the first/last line.
-- (Done this way because CERTAIN WEB LUA IMPLEMENTATIONS do not support
--  io.load to open files, but they do support require)
require("data/xmlMaps")
require("data/xmlFieldMixMap") -- passwords
require("data/xmlFieldMixCat")

require("data/subitems")

local passwords = {}
local categories = {}
local maps = {}
local mainItems = {}

local subItemMap = {}
local mainItemMap = {}
local mapToItem = {}

local function sleep(delay)
    local co = assert(coroutine.running(), "Should be run in a coroutine")

    window:setTimeout(function()
        assert(coroutine.resume(co))
    end, delay)

    coroutine.yield()
end
function message(text)
  local l = document:getElementById("status")
  print(text)
  l.innerHTML = text
  sleep(10)
end
function parsePasswordLine(line)
    --	<FieldMixMap No="0" l="5" g="900" p="5W5B" i="0" c="2" s="256"/>
    local data = {}
    data.level, data.gems, data.password,
    data.infoIndex, data.category, data.subitem = 
        line:match([[No=".*" l="(.*)" g="(.*)" p="(.*)" i="(.*)" c="(.*)" s="(.*)"]])
    if (data.level) then 
        for i,v in pairs(data) do data[i] = tonumber(v) or v end
        local subitem = subItems[data.subitem]
        local item = maps[data.infoIndex + 1]
        item = mapToItem[item]
        if (not subItemMap[subitem]) then subItemMap[subitem] = {} end
        if (not mainItemMap[item]) then mainItemMap[item] = {} end
        subItemMap[subitem][item] = data
        mainItemMap[item][subitem] = data
    end
end
local suffixes = {
    "Forest", "Grove", "Meadow", "Garden", "Trail", "Quarry", "Path",
    "Bluff", "Beach", "Ocean", "Shore", "Ruins", "Remnants",
    "Outer Sea", "Sea", -- ensure outer sea before sea =_=
    "Tower", "Locale", "Copse", "Cliff", "Site", "Ravine", "Domain",
}
local items_k = {}
function parseMapLine(line)
    line = line:match([[".*Text="(.*)".*]])
    if (line) then 
        line = line:gsub("%^00","")
        line = line:gsub("\r",""):gsub("\n","")
        if (line == "Magma Powder Ravin") then line = "Magma Powder Ravine" end
        maps[#maps + 1] = line
        local item = nil
        for _,v in pairs(suffixes) do
            item = line:match(string.format("(.*) %s$",v))
            if (item) then break end
        end
        if (not items_k[item]) then 
            items_k[item] = 1
            mainItems[#mainItems + 1] = item
        end
        mapToItem[line] = item
    end    
end
function parseCategoryLine(line)
    --	<FieldMixCat No="0" category="ITEM_CATEGORY_LIQUID"/>
    line = line:match([[".*Category="ITEM_CATEGORY_(.*)".*]])
    if (line) then 
        categories[#categories + 1] = line
    end
end
function process()
  coroutine.wrap(function()
    message("Processing categories..")
    local file = xml.cats
    for line in file:gmatch("[^\r\n]+") do
        parseCategoryLine(line)
    end
    message("Processing maps..")
    local file = xml.maps
    for line in file:gmatch("[^\r\n]+") do
        parseMapLine(line)
    end
    message("Processing passwords.. This will take a long time..")
    local file = xml.passwords
    local pws = 0
    for line in file:gmatch("[^\r\n]+") do
        pws = pws + 1
        parsePasswordLine(line)
        if (debug and pws > 1000) then break end
    end 
    message("Processing complete.")
    continueAfterProcessing()
  end)()
end
local selectedItems = {}
function purgeLists() 
  selectedItems = {}
  local mi = document:getElementById("mainItem")
  local si = document:getElementById("subItem")
  selectedItems[1] = mi.options[mi.selectedIndex].value
  selectedItems[2] = si.options[si.selectedIndex].value
  local select = document:getElementById("mainItem")
  local length = select.options.length
  for i=0,length do
    select:remove(0)
  end
end
function continueAfterProcessing()
  purgeLists()

end
process()


function assembleData(pw)
    local d = passwords[pw]
    local cat = categories[d.c + 1]:gsub("ITEM_CATEGORY_","")
    local map = maps[d.i + 1]
    local uwstring = ""
    return string.format("> %s < - Lv.%s %s [%sg], %s (s=%s)",d.p,d.l,map,d.g,cat,d.s,uwstring)
end
local item = nil


while (false) do 

    print("? Please specify an item name to search for:")
    io.write("> ")
    item = io.read("*l")

    if (not items_k[item]) then
        local item_matches = {}
        for i,v in pairs(mainItems) do
            if (v:lower():match(item:lower())) then item_matches[#item_matches+1] = v end
        end
        if (#item_matches > 0) then
            if (#item_matches == 1) then 
                item = item_matches[1]
            else
                local loop = true
                print("? Multiple results found. Please be more specific:")
                while (loop) do
                    print("["..table.concat(item_matches,", ").."]")
                    io.write("> ")
                    item = io.read("*l")
                    local f = false
                    for i,v in pairs(item_matches) do
                        if (v:lower():match(item:lower())) then item = v f = true end
                    end
                    if (not f) then print("? Invalid input.")
                    else loop = false end
                end
            end
        end
    end
    if (item) then 

        local results = {}
        local res_k = {}
        for pw,v in pairs(passwords) do
            if (maps[v.i + 1]:match("^"..item)) then 
                if (not results[v.l]) then 
                    results[v.l] = {} 
                    res_k[#res_k+1] = tonumber(v.l)
                end
                results[v.l][#results[v.l] + 1] = pw
            end
        end

        if (#res_k > 0) then 
            local input = tostring(res_k[1])
            if (#res_k > 1) then 
                table.sort(res_k)
                print("? Found passwords for "..item.." with levels "..table.concat(res_k,", "))
                local notok = true
                while (notok) do
                    print("? Please specify which level you would like to visit ("..table.concat(res_k,", ").."):")
                    io.write("> ")
                    input = io.read("*l")
                    if (not results[input]) then
                        print("? Invalid level.")
                    else
                        notok = false
                    end
                end
            end
            local reqBottle = 1
            local req255 = false
            for i,pw in pairs(results[input]) do
                print(assembleData(pw))
                local checked = false
                if (not checked) then 
                    local d = passwords[pw]
                    local lev = tonumber(d.l)
                    if (tonumber(d.i) > 255) then req255 = true
                    elseif (lev > 50) then reqBottle = 5
                    elseif (lev > 40) then reqBottle = 4
                    elseif (lev > 30) then reqBottle = 3
                    elseif (lev > 20) then reqBottle = 2
                    end
                end
            end
            if (req255) then 
                print("\n! These particular passwords can only be input with Travel Bottle #5.\n")
            elseif (reqBottle > 1) then
                print("\n! These particular passwords can only be input once you have at least "..reqBottle.." Travel Bottles.\n")
            end
        else
            print("? No results found.")
        end
    else
        print("? No item with that name found.")
    end
end