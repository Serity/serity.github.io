local js = require("js")
local window = js.global
local document = window.document

Data = {}
Data.Passwords = nil
Data.EnemyNames = nil
Data.MapInfo = nil
Data.Subitems = nil
-- enemy name
Data.EnemyNames = {"Blue Puni","Green Puni","Red Puni","Black Puni","Silver Puni","Gold Puni","Big Puni","Shining Puni","Giant Weasel","Bluefin","Silky Fur","Night Hunter","Ruined Corrupter","Hide Stalker","Mother Weasel","Savage Assassin","Flower Pixie","Illuminated Sylph","Flower Gardener","Eternal Guardian","Blazing Maiden","Hallowed Spirit","Elder Fairy","Mirage Master","Lunaria Angel","Stone Golem","Rock Puppet","Jewel Guard","Metal Golem","Meteorite Doll","Earth Master","Colossus Golem","Eternal Sculpture","Boulder Soldier","Living Armor","Ghost Armor","Honor Guard Armor","Gladiator","Legendary Warrior","Immortal Knight","Heavy Warrior Armor","Noble Paladin","Great Guardian","Stinger","Sharpened Scissors","Pile Bunker","Parching Demon","Dark Scout","Spine Rat","Ogre Head","Shadow Vanguard","Thrust Hedge","Shadow Eater","Mini Wyvern","Zephyr Feather","Evil Orchis","Mach Hawk","Watcher","Draconic Lord","Mega Wyvern","King of Storms","Cloud Liner","Hide Shark","Megamouth","Grand Tusk","Sandstorm Tyrant","Dark General","Cluster Beetle","Shadow Commander","Horn Demon","Old Castle Dragon","Dragon Lord","Great Wind Element","Great Dark Element","Great Fire Element","Great Ice Element","Great Lightning Element","Ravaging Queen","Queen of Shadows","Ravaging Queen","Queen of Shadows"}

-- enemy_index, boss_index, map_name (item name extrapolated from this)
Data.MapInfo = {{"1","2","Nameless Grass Forest"},{"2","9","Fresh Berry Forest"},{"9","17","Rainbow Grape Forest"},{"17","10","Blue Clover Forest"},{"10","18","Cotton Grass Forest"},{"18","11","Tough Log Forest"},{"11","19","Silver Uni Forest"},{"19","12","Maple Leaf Forest"},{"12","20","Mushroom Colony Forest"},{"20","20","Fossil Tree Forest"},{"1","2","Health Flower Grove"},{"2","9","Uni Grove"},{"9","17","Eicheloa Grove"},{"17","10","Restraint Silk Grove"},{"10","18","Spirit Flower Grove"},{"18","11","Poison Grass Grove"},{"11","19","Sweet Leaf Grove"},{"19","12","Silver Beehive Grove"},{"12","20","Blessed Pure Flower Grove"},{"20","20","Ancient Branch Grove"},{"1","2","Northern Wind Flower Meadow"},{"2","9","Wasser Wheat Meadow"},{"9","17","Eiche Meadow"},{"17","10","Oil Tree Fruit Meadow"},{"10","18","Lantern Grass Meadow"},{"18","11","Palma Fruit Meadow"},{"11","19","Bubble Grass Meadow"},{"19","12","Jupitonion Meadow"},{"12","20","Memorial Mist Flower Meadow"},{"20","20","Arbor Ivy Meadow"},{"1","2","Sunny Honey Flower Garden"},{"2","9","Fodder Garden"},{"9","17","Beehive Garden"},{"17","10","Tough Vine Garden"},{"10","18","Spirit Feather Garden"},{"18","11","Mossy Driftwood Garden"},{"11","19","Dream Mushroom Garden"},{"19","12","Serenity Flower Garden"},{"12","20","Serene Moon Flower Garden"},{"20","20","Underworld Rotwood Garden"},{"3","4","Small Crystal Trail"},{"4","17","Lightning Ore Trail"},{"17","26","Nectar Rock Trail"},{"26","18","Flame Black Sand Trail"},{"18","27","Snake Slough Trail"},{"27","19","Ancient Pillar Trail"},{"19","28","Shell Pearl Trail"},{"28","20","Beast Fossil Trail"},{"20","29","Cave Coral Trail"},{"29","29","Riverstone Trail"},{"3","4","Crimson Ore Quarry"},{"4","17","Dried Lumber Quarry"},{"17","26","Large Feather Quarry"},{"26","18","Koberinite Quarry"},{"18","27","Magma Powder Quarry"},{"27","19","Magnemalmoa Quarry"},{"19","28","Old Knight Emblem Quarry"},{"28","20","Dragon Meat Quarry"},{"20","29","Earth Fish Fang Quarry"},{"29","29","Mordinite Quarry"},{"3","4","Aqua Ore Path"},{"4","17","Rusted Sword Path"},{"17","26","Large Bone Path"},{"26","18","Mystery Gemstone Path"},{"18","27","Waterside Moss Stone Path"},{"27","19","Beast Shell Path"},{"19","28","Amber Fragment Path"},{"28","20","Stalactite Fragment Path"},{"20","29","Coral Stone Path"},{"29","29","Blue Flame Riverstone Path"},{"3","4","Sandstone Bluff"},{"4","17","Amatite Ore Bluff"},{"17","26","Eroded Stone Bluff"},{"26","18","Animal Hide Bluff"},{"18","27","Pentanite Bluff"},{"27","19","Beast Scales Bluff"},{"19","28","Cometstone Bluff"},{"28","20","Atonement Stinger Bluff"},{"20","29","Dragon Wing Bluff"},{"29","29","Ethereal Stone Bluff"},{"17","54","Clean Water Sea"},{"54","63","Sardine Sea"},{"63","18","Taun Sea"},{"18","55","Exofish Sea"},{"55","64","Green Puniball Sea"},{"64","19","Beast Fin Sea"},{"19","56","Selior Sea"},{"56","65","Xisor Sea"},{"65","20","Maple Bark Sea"},{"20","20","Black Puniball Sea"},{"17","54","Goat's Milk Beach"},{"54","63","Wild Potato Beach"},{"63","18","Blue Puniball Beach"},{"18","55","Crab Beach"},{"55","64","Unknown Egg Beach"},{"64","19","Roteswasser Tonic Beach"},{"19","56","Fertile Soil Beach"},{"56","65","Crimson Grass Beach"},{"65","20","Foamy Water Beach"},{"20","20","Fresh Meat Beach"},{"17","54","Scrap Paper Ocean"},{"54","63","Pretty Shell Ocean"},{"63","18","Beast Meat Ocean"},{"18","55","Plant Essence Ocean"},{"55","64","Natural Oil Ocean"},{"64","19","Spikey Ocean"},{"19","56","Palma Bark Ocean"},{"56","65","Medicine Moss Ocean"},{"65","20","Jade Water Ocean"},{"20","20","Mutant Taun Ocean"},{"17","54","Kurken Fruit Shore"},{"54","63","Purumuru Shore"},{"63","18","Flammable Bark Shore"},{"18","55","Bitter Root Shore"},{"55","64","Tall Taun Shore"},{"64","19","Red Puniball Shore"},{"19","56","Sapling Branch Shore"},{"56","65","Honey Tree Branch Shore"},{"65","20","Smoky Charcoal Shore"},{"20","20","Sawe Fish Shore"},{"5","6","Seven Stars Ruins"},{"6","17","Kumine Fruit Ruins"},{"17","35","Kumine Poison Ruins"},{"35","18","Emerald Glass Ruins"},{"18","36","Giant Beetle Ruins"},{"36","19","Fragrant Honey Tree Ruins"},{"19","37","Lunatic Poison Lance Ruins"},{"37","20","Resentful Scream Ruins"},{"20","38","Rotwood Miasma Ruins"},{"38","38","Lapis Papillion Ruins"},{"5","6","Soft Sand Remnants"},{"6","17","Fairystone Fragment Remnants"},{"17","35","Burning Sand Remnants"},{"35","18","Polluted Humus Remnants"},{"18","36","Bomb Dragoon Remnants"},{"36","19","Rotten Tree Bark Remnants"},{"19","37","Spear Worm Remnants"},{"37","20","Underworld Core Remnants"},{"20","38","Old Magic Tome Remnants"},{"38","38","Holy Tree Leaf Remnants"},{"5","6","Honey Ant Tower"},{"6","17","Ashen Sand Tower"},{"17","35","Rose Bee Tower"},{"35","18","Mushroom Powder Tower"},{"5","36","Sky Bubble Tower"},{"6","19","Dark Crystal Fragment Tower"},{"17","37","Gold Beehive Tower"},{"35","20","Amber Fly Tower"},{"5","38","Forest Sage Tower"},{"6","38","Mythical Hide Tower"},{"5","6","Wing Plant Locale"},{"6","17","Beast Venom Pouch Locale"},{"17","35","Lantern Fly Locale"},{"35","18","Magic Tome Piece Locale"},{"18","36","Crispy Mushroom Locale"},{"36","19","Nectar Fruit Locale"},{"19","37","Nightglow Flower Locale"},{"37","20","Spring Princess Locale"},{"20","38","Medium Medicine Locale"},{"38","38","Esplante Locale"},{"2","9","Lucky Clover Copse"},{"17","10","Holy Arbor Branch Copse"},{"10","18","Wasser Wheat Copse"},{"19","12","Cotton Grass Copse"},{"12","20","Bubble Grass Copse"},{"20","20","Memorial Mist Flower Copse"},{"2","9","Palma Copse"},{"17","10","Gold Uni Copse"},{"11","19","Rainbow Grape Copse"},{"12","12","Lantern Grass Copse"},{"12","20","Maple Leaf Copse"},{"20","20","Fossil Tree Copse"},{"2","9","Rosen Leaf Copse"},{"17","10","Nameless Grass Copse"},{"11","19","Eiche Copse"},{"19","12","Tough Log Copse"},{"12","20","Jupitonion Copse"},{"20","20","Arbor Ivy Copse"},{"2","9","Delphi Rose Copse"},{"17","10","Northern Wind Flower Copse"},{"11","19","Oil Tree Fruit Copse"},{"12","20","Palma Fruit Copse"},{"12","20","Mushroom Colony Copse"},{"20","20","Dunkelheit Copse"},{"4","17","Amber Crystal Cliff"},{"26","18","Rainbow Gemstone Cliff"},{"19","28","Aqua Ore Cliff"},{"20","29","Flame Black Sand Cliff"},{"20","29","Beast Shell Cliff"},{"29","29","Cave Coral Cliff"},{"17","26","Degenesis Stone Cliff"},{"27","19","Goldinite Cliff"},{"19","28","Lightning Ore Cliff"},{"28","20","Unknown Gemstone Cliff"},{"20","29","Shell Pearl Cliff"},{"29","29","Coral Stone Cliff"},{"4","17","Marbled Stone Cliff"},{"26","18","Septrin Cliff"},{"19","28","Nectar Rock Cliff"},{"28","20","Waterside Moss Stone Cliff"},{"20","29","Beast Fossil Cliff"},{"29","29","Riverstone Cliff"},{"17","26","Holy Arbor Crystal Cliff"},{"27","19","Small Crystal Cliff"},{"19","28","Large Bone Cliff"},{"28","20","Ancient Pillar Cliff"},{"20","29","Stalactite Fragment Cliff"},{"29","29","Blue Flame Riverstone Cliff"},{"63","18","Silver Puniball Outer Sea"},{"64","19","Myria Fish Outer Sea"},{"19","56","Sardine Outer Sea"},{"56","65","Plant Essence Outer Sea"},{"65","20","Selior Outer Sea"},{"20","20","Maple Bark Outer Sea"},{"63","18","Mace Fish Outer Sea"},{"64","19","Underworld Master Outer Sea"},{"19","56","Pretty Shell Outer Sea"},{"56","65","Natural Oil Outer Sea"},{"65","20","Palma Bark Outer Sea"},{"20","20","Jade Water Outer Sea"},{"63","18","Triplet Taun Outer Sea"},{"64","19","Lake Master Outer Sea"},{"19","56","Taun Outer Sea"},{"56","65","Beast Fin Outer Sea"},{"65","20","Xisor Outer Sea"},{"20","20","Black Puniball Outer Sea"},{"63","18","Ether Aqua Outer Sea"},{"64","19","Clean Water Outer Sea"},{"19","56","Exofish Outer Sea"},{"56","65","Spikey Outer Sea"},{"65","20","Medicine Moss Outer Sea"},{"20","20","Mutant Taun Outer Sea"},{"17","35","Palma Charcoal Site"},{"36","19","Baby Wyrm Site"},{"19","37","Trihorn Site"},{"37","20","Kumine Poison Site"},{"20","38","Dark Crystal Fragment Site"},{"38","38","Rotwood Miasma Site"},{"17","35","Beast Spirit Armor Site"},{"36","19","Holy Stone Fragment Site"},{"19","37","Seven Stars Site"},{"37","20","Emerald Glass Site"},{"20","38","Lunatic Poison Lance Site"},{"38","38","Forest Sage Site"},{"17","35","Death's Grief Site"},{"6","19","Dragon Egg Site"},{"17","37","Honey Ant Site"},{"35","20","Giant Beetle Site"},{"5","38","Gold Beehive Site"},{"6","38","Lapis Papillion Site"},{"17","35","Golden Crown Site"},{"36","19","Gold Puniball Site"},{"20","38","Ashen Sand Site"},{"37","20","Sky Bubble Site"},{"20","38","Amber Fly Site"},{"38","38","Mythical Hide Site"},{"44","45","Gold Uni Ravine"},{"45","46","Golden Crown Ravine"},{"46","47","Gold Beehive Ravine"},{"47","48","Magma Powder Ravine"},{"48","49","Delphi Rose Ravine"},{"49","50","Rotwood Miasma Ravine"},{"50","51","Underworld Master Ravine"},{"51","67","Rainbow Gemstone Ravine"},{"67","68","Septrin Domain"},{"68","68","Polluted Humus Domain"},{"48","49","Rosen Leaf Domain"},{"49","50","Jade Water Domain"},{"50","51","Ethereal Stone Domain"},{"51","67","Atonement Stinger Domain"},{"67","68","Palma Charcoal Domain"},{"68","68","Death's Grief Domain"},}


-- subitem_id, subitem_name
Data.Subitems = {{"405","Burnt Ash"},{"305","Mace Fish"},{"287","Memorial Mist Flower"},{"409","Mushroom Powder"},{"420","Fresh Berry"},{"320","Lightning Ore"},{"309","Small Crystal"},{"436","Fertile Soil"},{"336","Restraint Silk"},{"443","Dragon Meat"},{"387","Giant Beetle"},{"343","Fodder"},{"337","Tough Vine"},{"295","Rotwood Miasma"},{"396","Large Feather"},{"399","Snake Slough"},{"299","Exofish"},{"294","Sky Bubble"},{"362","Old Magic Tome"},{"434","Bitter Root"},{"334","Emerald Glass"},{"278","Magma Powder"},{"318","Crimson Ore"},{"262","Dream Mushroom"},{"431","Palma"},{"315","Amber Crystal"},{"415","Flammable Bark"},{"319","Aqua Ore"},{"384","Honey Ant"},{"310","Unknown Gemstone"},{"290","Spring Princess"},{"390","Amber Fly"},{"296","Sardine"},{"433","Taun"},{"333","Burning Sand"},{"285","Serenity Flower"},{"407","Beast Venom Pouch"},{"307","Underworld Master"},{"289","Nightglow Flower"},{"389","Spear Worm"},{"304","Sawe Fish"},{"284","Bubble Flower"},{"328","Degenesis Stone"},{"321","Amatite Ore"},{"425","Eiche"},{"325","Cometstone"},{"340","Arbor Ivy"},{"329","Goldinite"},{"429","Fragrant Honey Tree"},{"440","Mutant Taun"},{"416","Natural Oil"},{"316","Holy Arbor Crystal"},{"323","Pentanite"},{"423","Palma Fruit"},{"346","Sweet Leaf"},{"391","Lapis Papillion"},{"291","Esplante"},{"414","Scrap Paper"},{"314","Marbled Stone"},{"382","Ethereal Stone"},{"282","Spirit Flower"},{"411","Lunatic Poison Lance"},{"298","Purumuru"},{"339","Spirit Feather"},{"335","Polluted Humus"},{"293","Wing Plant"},{"330","Septrin"},{"257","Silver Uni"},{"348","Ancient Branch"},{"326","Mordinite"},{"426","Tough Log"},{"313","Amber Fragment"},{"413","Death's Grief"},{"381","Blue Flame Riverstone"},{"327","Beast Spirit Armor"},{"281","Sunny Honey Flower"},{"301","Spikey"},{"401","Beast Fossil"},{"272","Red Puniball"},{"308","Lake Master"},{"383","Seven Stars"},{"283","Lantern Flower"},{"338","Cotton Grass"},{"438","Crimson Grass"},{"303","Xisor"},{"403","Atonement Spear"},{"360","Dark Crystal Fragment"},{"260","Dunkelheit"},{"366","Goat's Milk"},{"371","Ether Aqua"},{"259","Forest Sage"},{"322","Koberinite"},{"355","Unknown Egg"},{"271","Green Puniball"},{"422","Oil Tree Fruit"},{"354","Beast Meat"},{"359","Magic Tome Piece"},{"444","Dragon Wing"},{"373","Nectar Rock"},{"273","Black Puniball"},{"368","Roteswasser Tonic"},{"445","Dragon Egg"},{"442","Triplet Taun"},{"441","Medium Medicine"},{"306","Myria Fish"},{"406","Kumine Fruit"},{"439","Medicine Moss"},{"437","Sapling Branch"},{"356","Beast Fin"},{"256","Uni"},{"435","Tall Taun"},{"332","Ashen Sand"},{"361","Underworld Core"},{"430","Underworld Rotwood"},{"345","Poison Grass"},{"261","Eicheloa"},{"412","Resentful Scream"},{"428","Fossil Tree"},{"427","Mossy Driftwood"},{"292","Delphi Rose"},{"268","Silver Beehive"},{"392","Heavy Wyrm"},{"421","Rainbow Grape"},{"344","Blue Clover"},{"349","Lucky Clover"},{"419","Palma Charcoal"},{"363","Holy Tree Leaf"},{"418","Smoky Charcoal"},{"400","Beast Scales"},{"300","Crab"},{"358","Fairystone Fragment"},{"267","Beehive"},{"417","Palma Bark"},{"263","Jupitonion"},{"410","Rotten Tree Bark"},{"380","Riverstone"},{"408","Kumine Poison"},{"286","Blessed Pure Flower"},{"404","Mythical Hide"},{"402","Earth Fish Fang"},{"280","Northern Wind Flower"},{"398","Animal Hide"},{"397","Large Bone"},{"395","Honey Tree Branch"},{"317","Rainbow Gemstone"},{"351","Stinky Trash"},{"379","Coral Stone"},{"279","Health Flower"},{"275","Gold Puniball"},{"375","Waterside Moss Stone"},{"394","Maple Bark"},{"393","Trihorn"},{"388","Bomb Dragoon"},{"258","Gold Uni"},{"386","Lantern Fly"},{"385","Rose Bee"},{"374","Eroded Stone"},{"274","Silver Puniball"},{"378","Stalactite Fragment"},{"353","Kurken Fruit"},{"377","Cave Coral"},{"297","Pretty Shell"},{"352","Wild Potato"},{"372","Sandstone"},{"367","Plant Essence"},{"277","Flame Black Sand"},{"370","Jade Water"},{"302","Selior"},{"266","Golden Crown"},{"357","Fresh Meat"},{"376","Ancient Pillar"},{"276","Dried Lumber"},{"350","Rosen Leaf"},{"270","Puniball"},{"347","Maple Leaf"},{"342","Wasser Wheat"},{"341","Nameless Grass"},{"269","Gold Beehive"},{"432","Holy Arbor Branch"},{"331","Soft Sand"},{"365","Clean Water"},{"265","Crispy Mushroom"},{"312","Shell Pearl"},{"311","Magnemalmoa"},{"324","Beast Shell"},{"424","Nectar Fruit"},{"369","Foamy Water"},{"288","Serene Moon Flower"},{"264","Mushroom Colony"},{"364","Holy Stone Fragment"},}

-- password, level, info_index, subitem_id

local function sleep(delay)
    local co = assert(coroutine.running(), "Should be run in a coroutine")

    window:setTimeout(function()
        assert(coroutine.resume(co))
    end, delay)

    coroutine.yield()
end
function message(text)
  local l = document:getElementById("status")
  --print(text)
  l.innerHTML = text
  sleep(100)
end
coroutine.wrap(function()
local suffixes = {
    "Forest", "Grove", "Meadow", "Garden", "Trail", "Quarry", "Path",
    "Bluff", "Beach", "Ocean", "Shore", "Ruins", "Remnants",
    "Outer Sea", 
    "Tower", "Locale", "Copse", "Cliff", "Site", "Ravine", "Domain",
}
 -- for some unholy reason suffixes get added backwards
 -- sea needs to be after outer sea to handle "X Outer Sea" properly
suffixes[#suffixes + 1] = "Sea"
function parseMapName(mapName)
        for _,v in pairs(suffixes) do
            mapName = mapName:match("(.*) "..v.."$") or mapName
        end
        return mapName
end
-- convert subitems tables to ID=Name
-- use mitm table to prevent over
message("Processing subitems...")
for i,v in pairs(Data.Subitems) do
    if (not Data._Subitems) then Data._Subitems = {} end
    Data._Subitems[v[1]] = v[2]
end
Data.Subitems = {}
for i,v in pairs(Data._Subitems) do Data.Subitems[i] = v end
Data._Subitems = nil
message("Processing map info...")
-- convert mapinfo array-tables to kvp
for i,v in pairs(Data.MapInfo) do
    local mi_data = {
        Enemy = Data.EnemyNames[tonumber(v[1])],
        Boss = Data.EnemyNames[tonumber(v[2])],
        MapName = v[3],
        Item = parseMapName(v[3]),
    }
    Data.MapInfo[i] = mi_data
end
message("Processing passwords...")
-- convert password array-tables to kvp
local _passwords = {}
for i,v in pairs(Data.Passwords) do
    local Info = Data.MapInfo[tonumber(v[4])]
    local pw_data = {
        Password = v[1], 
        Level = v[2], 
        Gems = v[3], 
        Items = { Info.Item, Data.Subitems[v[5]] },
        Enemies = { Info.Enemy, Info.Boss },
        MapName = { Info.MapName },
        Bottle5Only = (tonumber(v[4]) > 256),
    }
    _passwords[pw_data.Password] = pw_data
end
Data.Passwords = _passwords
_passwords = nil
message("Processing lists...")
-- put items and enemies into sortable lists for dropdowns
local _items_keys = {}
local _items_keys_c = {}
for i,v in pairs(Data.MapInfo) do
    if (not _items_keys_c[v.Item]) then 
        _items_keys[#_items_keys + 1] = v.Item
        _items_keys_c[v.Item] = true
    end
end
for i,v in pairs(Data.Subitems) do
    if (not _items_keys_c[v]) then 
        _items_keys[#_items_keys + 1] = v
        _items_keys_c[v] = true
    end
end
table.sort(_items_keys)
_items_keys_c = nil

local _sortableEnemies = {}
local _enemies_c = {}
for i,v in pairs(Data.MapInfo) do
    for j,k in pairs({v.Enemy, v.Boss}) do
        if (k and not _enemies_c[k]) then _enemies_c[k] = 1 _sortableEnemies[#_sortableEnemies + 1] = k end
    end
end
table.sort(_sortableEnemies)
_enemies_c = nil
function populateItemList()
    local ItemList = document:getElementById("mainItem")   
    for _,i in pairs(_items_keys) do
        local option = document:createElement("option")
        option.text = i
        option.value = i
        ItemList:add(option)
    end
    ItemList.onchange = getPasswordsMI
end
function populateEnemyList()
    local EnemyList = document:getElementById("enemyChoice")   
    for _,i in pairs(_sortableEnemies) do
        local option = document:createElement("option")
        option.text = i
        option.value = i
        EnemyList:add(option)
    end
    EnemyList.onchange = getPasswordsEC
end
function findPasswordsItem(item)
    local passwords = {}
    for pw,data in pairs(Data.Passwords) do
        if (not passwords[data.Level]) then 
            for _,i in pairs(data.Items) do 
                if (i == item) then passwords[data.Level] = pw break end
            end
        end
    end
    return passwords
end
function findPasswordsEnemy(enemy)
    local passwords = {}
    for pw,data in pairs(Data.Passwords) do
        if (not passwords[data.Level]) then 
            for _,i in pairs(data.Enemies) do 
                if (i == enemy) then passwords[data.Level] = pw break end
            end
        end
    end
    return passwords
end
function randomPasswords() 
    coroutine.wrap(function()
        message("Generating random passwords...")
        local passwords = {}
        local _pk = {}
        local __pk = {}
        for pw,data in pairs(Data.Passwords) do
            if ((data.Level % 5) == 0 or data.Level == 98) then
                if (not passwords[data.Level]) then passwords[data.Level] = {} end
                passwords[data.Level][#passwords[data.Level] + 1] = pw
                if (not __pk[data.Level]) then __pk[data.Level] = 1 _pk[#_pk + 1] = data.Level end
            end
        end
        __pk = nil
        table.sort(_pk)
        local finalPWs = {}
        for i,v in pairs(_pk) do
            local options = passwords[v]
            finalPWs[#finalPWs + 1] = options[math.random(1,#options)]
            options = nil
        end
        passwords = nil
        _pk = nil
        local divText = "<u>Password Roulette!</u><br>Lv21+ requires 2+ Bottles, 31+ 3+, 41+ 4+, 51+ 5+. Red are fifth bottle only.<br>"
        local pwfield = document:getElementById("passwords")        
        for _,pw in pairs(finalPWs) do
            local pwData = Data.Passwords[pw]
            local lv = pwData.Level
            if (lv < 10) then lv = "0"..tostring(lv) end
            if (pwData.Bottle5Only) then divText = divText..[[<font color="#dd2700">]] end
            divText = divText.. string.format([[> <b>%s</b> < Lv.%s - ??? ($%s)]], pw, lv, pwData.Gems)
            if (pwData.Bottle5Only) then divText = divText..[[</font>]] end
            divText = divText.."<br>"
        end
        finalPWs = nil
        pwfield.innerHTML = divText
        message("Loading complete. Data is 1.5MB+ so recommended to leave this page open to avoid redownloads. (Probably shouldn't reload either, not very memory friendly..)")
    end)()
end
function getPasswordsMI() getPasswords("mainItem") end
function getPasswordsEC() getPasswords("enemyChoice") end
function getPasswords(list)
    coroutine.wrap(function()
        local mainList = document:getElementById(list)
        local selectedM = mainList.options[mainList.selectedIndex].value
        if (selectedM and not (selectedM == "")) then
            message("Loading passwords...")
            local divText = "<u>"..selectedM.."</u><br>Lv21+ requires 2+ Bottles, 31+ 3+, 41+ 4+, 51+ 5+. Red are fifth bottle only.<br>"
            local pwfield = document:getElementById("passwords")
            local pws = nil
            if (list == "mainItem") then 
                pws = findPasswordsItem(selectedM)
            elseif (list == "enemyChoice") then
                pws = findPasswordsEnemy(selectedM)
            end
            local _lvSort = {}
            for i,pass in pairs(pws) do
                _lvSort[#_lvSort + 1] = i
            end
            table.sort(_lvSort)
            for i,lv in pairs(_lvSort) do
                local pass = pws[lv]
                local pwData = Data.Passwords[pass]
                local otherItem = nil
                if (list == "mainItem") then 
                for i,v in pairs(pwData.Items) do if (not (v == selectedM)) then otherItem = v break end end
                elseif (list == "enemyChoice") then
                    otherItem = table.concat(pwData.Items," + ")
                end
                if (lv < 10) then lv = "0"..tostring(lv) end
                if (pwData.Bottle5Only) then divText = divText..[[<font color="#dd2700">]] end
                divText = divText.. string.format([[> <b>%s</b> < Lv.%s]], pass, lv)
                if (otherItem and list == "mainItem") then divText = divText .. " + <b>"..otherItem.."</b>"
                elseif (list == "enemyChoice") then divText = divText .. ", <b>"..otherItem.."</b>"
                end
                divText = divText..string.format(" [Enemies: %s] ($%s)<br>",table.concat(pwData.Enemies,", "),pwData.Gems)
                if (pwData.Bottle5Only) then divText = divText..[[</font>]] end
            end
            _lvSort = nil
            pwfield.innerHTML = divText
            message("Loading complete. Data is 1.5MB+ so recommended to leave this page open to avoid redownloads. (Probably shouldn't reload either, not very memory friendly..)")
        end
    end)()
end
function checkPassword()
    local text = document:getElementById("codeCheckBox").value
    if (text and #text == 4) then
        text = text:upper()
        local pwData = Data.Passwords[text]
        local divText = ""
        if (pwData) then
            divText = "<u>Code Check</u><br>Lv21+ requires 2+ Bottles, 31+ 3+, 41+ 4+, 51+ 5+. Red are fifth bottle only.<br>"
            local otherItem = table.concat(pwData.Items," + ")
            local lv = pwData.Level
            if (lv < 10) then lv = "0"..tostring(lv) end
            if (pwData.Bottle5Only) then divText = divText..[[<font color="#dd2700">]] end
            divText = divText.. string.format([[> <b>%s</b> < Lv.%s]], text, lv)
            divText = divText .. ", <b>"..otherItem.."</b>"
            divText = divText..string.format(" [Enemies: %s] ($%s)<br>",table.concat(pwData.Enemies,", "),pwData.Gems)
            if (pwData.Bottle5Only) then divText = divText..[[</font>]] end
        else
            divText = "<u>Invalid password!</u>"
        end
        local pwfield = document:getElementById("passwords")
        pwfield.innerHTML = divText
    end
end
document:getElementById("codeCheckBox").oninput = checkPassword
document:getElementById("surpriseMe").onclick = randomPasswords
message("Populating item list...")
populateItemList()
message("Populating enemy list...")
populateEnemyList()
message("Processing complete. Data is 1.5MB+ so recommended to leave this page open to avoid redownloads. (Probably shouldn't reload either, not very memory friendly..)")
end)()