
local js = require("js")
local window = js.global
local document = window.document

xml = {}
xml.maps = nil
xml.cats = nil
xml.passwords = nil
subItems = nil
local debug = true -- only first 1000 passwords for speed
local debugCount = 10000 
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

local itemMap = {}
local mapToItem = {}
local item_k = {}
local _item_k = {}
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
        if (not itemMap[subitem]) then itemMap[subitem] = {} end
        if (not itemMap[item]) then itemMap[item] = {} end
        if (not itemMap[subitem][item]) then itemMap[subitem][item] = {} end
        if (not itemMap[item][subitem]) then itemMap[item][subitem] = {} end
        local a = itemMap[subitem][item]
        a[#a + 1] = data
        local b = itemMap[item][subitem]
        b[#b + 1] = data
        if (not _item_k[item]) then _item_k[item] = 1 item_k[#item_k + 1] = item end
        if (not _item_k[subitem]) then _item_k[subitem] = 1 item_k[#item_k + 1] = subitem end
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
    line = line:match([[".*category="ITEM_CATEGORY_(.*)".*]])
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
    for i,v in pairs(xml) do print(i) end
    message("Processing passwords.. This will take a long time..")
    local file = xml.passwords
    local pws = 0
    for line in file:gmatch("[^\r\n]+") do
        pws = pws + 1
        parsePasswordLine(line)
        if (debug and pws > debugCount) then break end
    end 
    table.sort(item_k)
    message("Processing complete.")
    continueAfterProcessing()
  end)()
end
local selectedItems = {}
-- both if none specified
function purgeList(list) 
    selectedItems = {}
    if (not list) then list = {"mainItem", "subItem"} 
    else list = { list } end
    for i,v in pairs(list) do
        local select = document:getElementById(v)
        if (select.selectedIndex > -1) then 
            selectedItems[i] = select.options[select.selectedIndex].value
        end
        local length = select.options.length
        for i=0,length do
            select:remove(0)
        end
    end
end

function populateMainList()
    local mainList = document:getElementById("mainItem")
    local option = document:createElement("option")
    option.text = "{Main Item}"
    option.value = ""
    mainList:add(option)    
    for _,i in pairs(item_k) do
        local option = document:createElement("option")
        option.text = i
        option.value = i
        mainList:add(option)
    end
    mainList.onchange = populateSubList
end
function populateSubList()
    purgeList("subItem")
    local mainList = document:getElementById("mainItem")
    local subList = document:getElementById("subItem")
    local selected = mainList.options[mainList.selectedIndex].value
    if (selected and not (selected == "")) then 
        local option = document:createElement("option")
        option.text = "{Sub Item}"
        option.value = ""
        subList:add(option)         
        local sortsub = {}
        local _sortsub = {}
        for i,v in pairs(itemMap[selected]) do 
            if (not _sortsub[i]) then _sortsub[i] = 1 sortsub[#sortsub + 1] = i end
        end
        table.sort(sortsub)
        for _,i in pairs(sortsub) do
            local option = document:createElement("option")
            option.text = i
            option.value = i
            subList:add(option)
        end
    end
    subList.onchange = getPasswords
end

function getPasswords()
    local mainList = document:getElementById("mainItem")
    local subList = document:getElementById("subItem")
    local selectedM = mainList.options[mainList.selectedIndex].value
    local selectedS = subList.options[subList.selectedIndex].value
    if (selectedM and selectedS and not (selectedM == "") and not (selectedS == "")) then
        local divText = ""..selectedM.." x "..selectedS.."<br>"
        local pwfield = document:getElementById("passwords")
        for i,dataset in pairs(itemMap[selectedM][selectedS]) do
            divText = divText..assembleData(dataset).."<br>"
        end
        pwfield.innerHTML = divText
    end
end

function continueAfterProcessing()
    purgeList()

    populateMainList()
end


process()

function assembleData(dataset)
    --    data.level, data.gems, data.password, data.infoIndex, data.category, data.subitem
    local d = dataset
    local cat = categories[tonumber(d.category + 1)]
    local map = maps[d.infoIndex + 1]
    local uwstring = ""
    print(dataset)
    return string.format("> %s < - Lv.%s %s [%sg], %s (s=%s)",d.password,d.level,map,d.gems,cat,d.subitem,uwstring)
end
local item = nil
