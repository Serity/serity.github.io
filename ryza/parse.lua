--frontload all the processing/connecting/etc
-- use w/ cmd line "lua parse.lua > data\stored_data.lua" to write to file
-- =_= may get stored as unicode => re-encode as ANSI..
xml = {}
xml.maps = nil
xml.cats = nil
xml.passwords = nil
xml.mapinfo = nil
xml.enemies = nil 
xml.enemyNames = nil
xml.enemyData = nil

local xmlData = {}
local Data = {} -- final stuff
subItems = nil

require("data/xmlMaps")
require("data/xmlFieldMixMap") -- passwords
require("data/xmlFieldMixCat")
require("data/xmlFieldMixMapInfo")
require("data/xmlFieldMixEnemy")
require("data/xmlEnemyNames")
require("data/xmlEnemyData")
require("data/subitems")

function parse(type,line)
    local vals = {}
    for k,v in line:gmatch('([^< ]-)="(.-)"') do
        vals[k] = v
    end
    xmlData[type][#xmlData[type] + 1] = vals
end

for type,v in pairs(xml) do
    xmlData[type] = {}
    for line in v:gmatch("\t(.-)[\r\n]+") do
        parse(type,line)
    end
end



--boss="FIELD_MIX_ENEMY_182"
function parseEnemies()
    Data._Enemies = {}
    Data.EnemyNames = {}
    --<enemy_data name_id="STR_MONSTER_NAME_004" library_rank_00="2" 
    --library_rank_01="2" library_rank_02="2" library_rank_03="1"
    -- monster_tag="MONSTER_PUNI_04" chara_tag="CHARA_PUNI_04"
    local reverseMap = {}
    -- record index=enemy_real_name in EnemyNames
    for ix,v in pairs(xmlData.enemyData) do
        Data.EnemyNames[ix] = xmlData.enemyNames[ix].Text
        reverseMap[v.monster_tag] = ix
    end
    -- get fieldEnemy=>realNameIndex
    for _,v in pairs(xmlData.enemies) do 
        local id = v.No
        local symbol = v.enemySymbolTag:gsub("ENEMY_SYMBOL_FLDMIX_SYMBOL_","MONSTER_")
        symbol = reverseMap[symbol]
        if (symbol) then Data._Enemies[id] = symbol end
    end
    io.write([[Data.EnemyNames = {"]])
    local t = ""
    for ix,v in pairs(Data.EnemyNames) do 
        if (#v > 0) then 
            t = t..v..[[","]]
        end
    end
    t = t:sub(1,-3)
    io.write(t)
    print([[}]])
end
function parseMapInfo()
    print("")
    io.write([[Data.MapInfo = {]])
    for ix,data in pairs(xmlData.mapinfo) do
        local mapName = xmlData.maps[ix].Text:gsub("%^00","")
        if (mapName == "Magma Powder Ravin") then mapName = "Magma Powder Ravine" end
        if (mapName == "Myrietes Fish Outer Sea") then mapName = "Myria Fish Outer Sea" end
        local enemy = Data._Enemies[data.enemy:gsub("FIELD_MIX_ENEMY_","")]
        local boss = Data._Enemies[data.boss:gsub("FIELD_MIX_ENEMY_","")]
        io.write(string.format([[{"%s","%s","%s"},]],enemy, boss, mapName))
    end
    print([[}]])
end
function parsePasswords()
    print("")
    io.write([[Data.Passwords = {]])
    for _,data in pairs(xmlData.passwords) do
        io.write(string.format([[{"%s",%s,%s,"%s","%s"},]],data.p, data.l, data.g, data.i + 1, data.s))
    end
    print([[}]])
end
function parseSubitems()
    print("")
    io.write([[Data.Subitems = {]])
    for ix,item in pairs(subItems) do
        io.write(string.format([[{"%s","%s"},]],ix,item))
    end
    print([[}]])
end

parseEnemies()
parseMapInfo()
parseSubitems()
parsePasswords()
