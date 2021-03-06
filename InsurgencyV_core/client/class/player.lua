


function InitPlayerClass()
    player = {
        pPed = function()
            return self.ped
        end,

        pVeh = function()
            return self.veh
        end,

        pLastVeh = function()
            return self.lastVeh
        end,

        phealth = function()
            return self.health
        end,

        pName = function()
            return self.name
        end,

        pCoords = function()
            return self.coords
        end,
    }

    -- Main player loop
    Citizen.CreateThread(function()
        Wait(5000)
        while true do
            player.ped = GetPlayerPed(-1)
            player.veh = GetVehiclePedIsIn(player.ped, 0)
            player.lastVeh = GetVehiclePedIsIn(player.ped, 1)
            player.health = GetEntityHealth(player.ped)
            player.name = GetPlayerName(GetPlayerIndex())
            player.coords = GetEntityCoords(player.ped)

            ClearPlayerWantedLevel(GetPlayerIndex())

            if player.camp == "resistance" then
                if GetEntityModel(GetPlayerPed(-1)) ~= GetHashKey("s_m_y_blackops_01") then
                    Wait(1500)
                    if GetEntityModel(GetPlayerPed(-1)) ~= GetHashKey("s_m_y_blackops_01") then
                        OpenCinematicMenu()
                    end
                    Wait(3000)
                end
            else
                if GetEntityModel(GetPlayerPed(-1)) ~= GetHashKey("s_m_y_marine_03") then
                    Wait(1500)
                    if GetEntityModel(GetPlayerPed(-1)) ~= GetHashKey("s_m_y_marine_03") then
                        OpenCinematicMenu()
                    end
                    Wait(3000)
                end
            end
           
            Wait(1000)
        end
    end)
end