
local js = require("js")
local window = js.global
local document = window.document

xml = {}
xml.maps = nil
xml.cats = nil
xml.passwords = nil
xml.mapinfo = nil
xml.enemies = nil 
xml.enemyNames = nil
xml.enemyData = nil

subItems = nil
local debug = false -- only first 1000 passwords for speed
local debugCount = 10000 
-- To update data, open the data/xml files and paste the contents of
-- the xml between the [[ ]] brackets on the first/last line.
-- (Done this way because CERTAIN WEB LUA IMPLEMENTATIONS do not support
--  io.load to open files, but they do support require)
require("data/xmlMaps")
require("data/xmlFieldMixMap") -- passwords
require("data/xmlFieldMixCat")
require("data/xmlFieldMixMapInfo")
require("data/xmlFieldMixEnemy")
require("data/xmlEnemyNames")
require("data/xmlEnemyData")
require("data/subitems")

local passwords = {}
local categories = {}
local maps = {}
local mainItems = {}

local itemMap = {}
local mapToItem = {}
local item_k = {}
local _item_k = {}
local mapEnemies = {}
local enemies = {}
local enemyNames = {}
local enemyTags = {}
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
function parsePasswordLine(number,level,gems,password,info,category,subitem)
    --	<FieldMixMap No="0" l="5" g="900" p="5W5B" i="0" c="2" s="256"/>
    local data = {}
    data.level, data.gems, data.password,
    data.infoIndex, data.category, data.subitem = 
    level, gems, password, info, category, tonumber(subitem)
    if (data.level) then 
        data.infoIndex = tonumber(data.infoIndex)
        data.category = tonumber(data.category)
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
    "Outer Sea", 
    "Tower", "Locale", "Copse", "Cliff", "Site", "Ravine", "Domain",
}
 -- for some unholy reason suffixes get added backwards
 -- sea needs to be after outer sea to handle "X Outer Sea" properly
suffixes[#suffixes + 1] = "Sea"
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
            item = line:match("(.*) "..v.."$")
            if (item) then break end
        end
        if (not items_k[item]) then 
            items_k[item] = 1
            mainItems[#mainItems + 1] = item
        end
        mapToItem[line] = item
    end    
end
function parseMapInfoLine(line)
    nme,boss = line:match([[enemy="FIELD_MIX_ENEMY_(%d*)".* boss="FIELD_MIX_ENEMY_(%d*)"]])
    if (nme and boss) then
        mapEnemies[#mapEnemies + 1] = { enemies[nme], enemies[boss] }
    end
end
function parseEnemyLine(line)
    --<FieldMixEnemy No="11" enemySymbolTag="ENEMY_SYMBOL_FLDMIX_SYMBOL_PUNI_01" encountGroupTag="ENCOUNT_GROUP_FLD_MIX_ENC_ID_001"/>
    id,enemy = line:match([[No="(%d*)".* enemySymbolTag="ENEMY_SYMBOL_FLDMIX_SYMBOL_(.-)"]])
    if (id and enemy) then
        enemies[id] = enemyTags[enemy]
    end
end
function parseCategoryLine(line)
    --	<FieldMixCat No="0" category="ITEM_CATEGORY_LIQUID"/>
    line = line:match([[".*category="ITEM_CATEGORY_(.*)".*]])
    if (line) then 
        categories[#categories + 1] = line
    end
end
function parseEnemyNameLine(line)
    -- <str String_No="19791873" Text="Blue Puni"/>
    name = line:match([[.*Text="(.-)".*]])
    if (name) then 
        enemyNames[#enemyNames + 1] = name 
    end
end
function parseEnemyDataLine(line)
    --[[<enemy_data name_id="STR_MONSTER_NAME_000" library_rank_00="1" 
    library_rank_01="1" library_rank_02="1" library_rank_03="1" 
    monster_tag="MONSTER_PUNI_00" --]]
    id,tag = line:match([[.*name_id="STR_MONSTER_NAME_(.-)".*monster_tag="MONSTER_(.-)".*]])
    if (id and tag) then 
        enemyTags[tag] = enemyNames[tonumber(id + 1)]
    end
end
function process()
  coroutine.wrap(function()
    message("Processing categories..")
    local file = xml.cats
    for line in file:gmatch("[^\r\n]+") do
        parseCategoryLine(line)
    end
    message("Processing enemies..")
    local file = xml.enemyNames for line in file:gmatch("[^\r\n]+") do parseEnemyNameLine(line) end
    local file = xml.enemyData for line in file:gmatch("[^\r\n]+") do parseEnemyDataLine(line) end
    local file = xml.enemies for line in file:gmatch("[^\r\n]+") do parseEnemyLine(line) end
    message("Processing map info..")
    local file = xml.mapinfo
    for line in file:gmatch("[^\r\n]+") do
        parseMapInfoLine(line)
    end
    message("Processing maps..")
    local file = xml.maps
    for line in file:gmatch("[^\r\n]+") do
        parseMapLine(line)
    end
    message("Processing passwords (~4MB).. This will take a long time..")
    local file = xml.passwords
    local pws = 0

    --for line in file:gmatch("[^\r\n]+") do
--<FieldMixMap No="56324" l="70" g="39600" p="0TI4" i="270" c="4" s="442"/>
for number,level,gems,password,info,category,subitem in
file:gmatch([[<FieldMixMap No="(.-)" l="(.-)" g="(.-)" p="(.-)" i="(.-)" c="(.-)" s="(.-)"/>]]) do
        pws = pws + 1
        parsePasswordLine(number,level,gems,password,info,category,subitem)
        --parsePasswordLine(line)
        if ((pws % 10000) == 0) then message("Processing passwords - "..pws.."/56000+ (~4MB).. This will take a long time..") end
        if (debug and pws > debugCount) then break end
    end 
    table.sort(item_k)
    message("Processing complete. Data is 4MB+ so recommended to leave this page open to avoid redownloads.")
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
        local divText = "<u>"..selectedM.." + "..selectedS.."</u><br>"
        if (selectedM == selectedS) then divText = "<u>"..selectedM.." Only</u><br>" end
        local pwfield = document:getElementById("passwords")
        local pws = {}
        for i,dataset in pairs(itemMap[selectedM][selectedS]) do
            if (not pws[dataset.password]) then 
                pws[dataset.password] = 1
                divText = divText..assembleData(dataset).."<br>"
            end
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
    text = string.format("> <b>%s</b> < - Lv.%s %s [%sg], %s (s=%s)",d.password,d.level,map,d.gems,cat,d.subitem,uwstring)
    local enem = mapEnemies[d.infoIndex + 1]
    if (enem) then 
        local uenem = {}
        local thisenemy = {}
        for i,v in pairs(enem) do if (not uenem[v]) then uenem[v] = 1 thisenemy[#thisenemy + 1] = v end end
        text = text.."<br>&nbsp;&nbsp;&nbsp;&nbsp;Estimated Enemies: "..table.concat(thisenemy,", ") 
    end
    local req255 = (dataset.infoIndex > 255)
    if (req255) then 
        text = text.."<br>&nbsp;&nbsp;&nbsp;&nbsp;! Only accessible with Travel Bottle #5."
    else        
        local reqBottle = 1
        local lev = tonumber(dataset.level)
        if (lev > 50) then reqBottle = 5
        elseif (lev > 40) then reqBottle = 4
        elseif (lev > 30) then reqBottle = 3
        elseif (lev > 20) then reqBottle = 2
        end
        if (reqBottle > 1) then 
            if (reqBottle < 5) then reqBottle = tostring(reqBottle).."+" end
            text = text.."<br>&nbsp;&nbsp;&nbsp;&nbsp;! Only accessible with "..reqBottle.." Travel Bottles."
        end
    end
    text = text.."<br>"
    return text
end
local item = nil
