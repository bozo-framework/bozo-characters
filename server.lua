AFCore = exports["af-core"]:GetCoreObject()

function validateDepartment(player, department)
    local departmentExists = config.departments[department]
    if departmentExists then
        local discordUserId = AFCore.Functions.GetPlayerIdentifierFromType("discord", player):gsub("discord:", "")
        local discordInfo = AFCore.Functions.GetUserDiscordInfo(discordUserId)

        for _, roleId in pairs(departmentExists) do
            if roleId == 0 or roleId == "0" or (discordInfo and discordInfo.roles[roleId]) then
                return true
            end
        end
    end
    return false
end

RegisterNetEvent("af-characters:newCharacter", function(newCharacter)
    local player = source

    local departmentCheck = validateDepartment(player, newCharacter.job)
    if not departmentCheck then return end

    AFCore.Functions.CreateCharacter(player, newCharacter.firstName, newCharacter.lastName, newCharacter.dob, newCharacter.gender, function(characterId)
        AFCore.Functions.SetPlayerJob(characterId, newCharacter.job, 1)
    end)
end)

RegisterNetEvent("af-characters:editCharacter", function(newCharacter)
    local player = source

    local characters = AFCore.Functions.GetPlayerCharacters(player)
    if not characters[newCharacter.id] then return end

    local departmentCheck = validateDepartment(player, newCharacter.job)
    if not departmentCheck then return end

    AFCore.Functions.UpdateCharacter(newCharacter.id, newCharacter.firstName, newCharacter.lastName, newCharacter.dob, newCharacter.gender)
    AFCore.Functions.SetPlayerData(newCharacter.id, "job", newCharacter.job, 1)

    TriggerClientEvent("af:returnCharacters", player, AFCore.Functions.GetPlayerCharacters(player))
end)

RegisterNetEvent("af-characters:checkPerms", function()
    local player = source
    local discordUserId = AFCore.Functions.GetPlayerIdentifierFromType("discord", player):gsub("discord:", "")
    local allowedRoles = {}
    local discordInfo = AFCore.Functions.GetUserDiscordInfo(discordUserId)

    for dept, roleTable in pairs(config.departments) do
        for _, roleId in pairs(roleTable) do
            if roleId == 0 or roleId == "0" or (discordInfo and discordInfo.roles[roleId]) then
                table.insert(allowedRoles, dept)
            end
        end
    end
    TriggerClientEvent("af-characters:permsChecked", player, allowedRoles)
end)

CreateThread(function()
    while true do
        Wait(6 * 60000)   -- Paycheck Interval (in minutes)
        for player, playerInfo in pairs(AFCore.Functions.GetPlayers()) do
            local salary = config.departmentSalaries[playerInfo.job]
            if salary then
                AFCore.Functions.AddMoney(salary, player, "bank")
                TriggerClientEvent("af-core:notify", player, "Received Paycheck $" .. salary .. "")
            end
        end
    end
end)