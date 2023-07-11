BozoCore = exports["bozo-core"]:GetCoreObject()
local changeAppearence = false
local started = false
local firstSpawn = true

function startChangeAppearence()
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        tattoos = false
    }

    exports["bozo-appearance"]:startPlayerCustomization(function(appearance)
        if appearance then
            local ped = PlayerPedId()
            local clothing = {
                model = GetEntityModel(ped),
                tattoos = exports["bozo-appearance"]:getPedTattoos(ped),
                appearance = exports["bozo-appearance"]:getPedAppearance(ped)
            }
            Wait(4000)
            TriggerServerEvent("bozo:updateClothes", clothing)
        else
            start(true)
        end
        changeAppearence = false
    end, config)
end

function setCharacterClothes(character)
    if not character.data.clothing or next(character.data.clothing) == nil then
        changeAppearence = true
    else
        changeAppearence = false
        exports["bozo-appearance"]:setPlayerModel(character.data.clothing.model)
        local ped = PlayerPedId()
        exports["bozo-appearance"]:setPedTattoos(ped, character.data.clothing.tattoos)
        exports["bozo-appearance"]:setPedAppearance(ped, character.data.clothing.appearance)
    end
end

function tablelength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function SetDisplay(bool, typeName, bg, characters)
    local characterAmount = characters
    if not characterAmount then
        characterAmount = BozoCore.Functions.GetCharacters()
    end
    if not bg then
        background = "https://user-images.githubusercontent.com/106028948/226692268-098c3309-8271-4a40-99aa-bc02e2804b5d.jpg"
    end
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = typeName,
        background = background,
        status = bool,
        serverName = BozoCore.Config.serverName,
        characterAmount = tablelength(characterAmount) .. "/" .. BozoCore.Config.characterLimit
    })
    Wait(500)
end

function start(switch)
    TriggerServerEvent("bozo:GetCharacters")
    if not started then
        TriggerServerEvent("bozo-characters:checkPerms")
        started = true
    end
    if switch then
        local ped = PlayerPedId()
        SwitchOutPlayer(ped, 0, 1)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
    end
end

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Wait(2000)
    start(false)
end)

AddEventHandler("playerSpawned", function()
    start(true)
end)

RegisterNetEvent("bozo-characters:permsChecked", function(allowedRoles)
    SendNUIMessage({
        type = "givePerms",
        deptRoles = json.encode(allowedRoles)
    })
end)

RegisterNetEvent("bozo:returnCharacters", function(characters)
    local playerCharacters = {}
    for id, characterInfo in pairs(characters) do
        playerCharacters[tostring(id)] = characterInfo
    end
    SendNUIMessage({
        type = "refresh",
        characters = json.encode(playerCharacters)
    })
    SetDisplay(true, "ui", background, characters)
end)

RegisterNUICallback("setMainCharacter", function(data)
    local characters = BozoCore.Functions.GetCharacters()
    local defaultSpawns = config.spawns["DEFAULT"]
    local spawns = {}
    for _, spawn in pairs(defaultSpawns) do
        spawns[#spawns + 1] = spawn
    end
    local job = characters[data.id].job
    local jobSpawns = config.spawns[job]
    if jobSpawns then
        for _, newSpawn in pairs(jobSpawns) do
            spawns[#spawns + 1] = newSpawn
        end
    end
    SendNUIMessage({
        type = "setSpawns",
        spawns = json.encode(spawns),
        id = characters[data.id].id
    })
    Wait(1000)
    TriggerServerEvent("bozo:setCharacterOnline", data.id)
end)

RegisterNUICallback("newCharacter", function(data)
    if tablelength(BozoCore.Characters) < BozoCore.Config.characterLimit then
        TriggerServerEvent("bozo-characters:newCharacter", {
            firstName = data.firstName,
            lastName = data.lastName,
            dob = data.dateOfBirth,
            gender = data.gender,
            job = data.department
        })
    end
end)

RegisterNUICallback("editCharacter", function(data)
    TriggerServerEvent("bozo-characters:editCharacter", {
        id = data.id,
        firstName = data.firstName,
        lastName = data.lastName,
        dob = data.dateOfBirth,
        gender = data.gender,
        job = data.department
    })
end)

RegisterNUICallback("delCharacter", function(data)
    TriggerServerEvent("bozo:deleteCharacter", data.character)
end)

RegisterNUICallback("exitGame", function()
    TriggerServerEvent("bozo:exitGame")
end)

RegisterNUICallback("tpToLocation", function(data)
    local ped = PlayerPedId()
    SetEntityCoords(ped, tonumber(data.x), tonumber(data.y), tonumber(data.z), false, false, false, false)
    FreezeEntityPosition(ped, true)
    SwitchInPlayer(ped)
    Wait(500)
    SetDisplay(false, "ui")
    Wait(500)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, 0)
    setCharacterClothes(BozoCore.Functions.GetSelectedCharacter())
    if changeAppearence then
        startChangeAppearence()
    end
    if firstSpawn then
        firstSpawn = false
        SendNUIMessage({
            type = "firstSpawn"
        })
    end
end)

RegisterNUICallback("tpDoNot", function(data)
    local ped = PlayerPedId()
    if firstSpawn then
        local character = BozoCore.Functions.GetCharacters()[data.id]
        if character.lastLocation and next(character.lastLocation) ~= nil then
            SetEntityCoords(ped, character.lastLocation.x, character.lastLocation.y, character.lastLocation.z, false, false, false, false)
            FreezeEntityPosition(ped, true)
        end
        firstSpawn = false
        SendNUIMessage({
            type = "firstSpawn"
        })
    else
        FreezeEntityPosition(ped, true)
    end
    SwitchInPlayer(ped)
    Wait(500)
    SetDisplay(false, "ui")
    Wait(500)
    SetEntityVisible(ped, true, 0)
    FreezeEntityPosition(ped, false)
    Wait(100)
    setCharacterClothes(BozoCore.Functions.GetSelectedCharacter())
    if changeAppearence then
        startChangeAppearence()
    end
end)