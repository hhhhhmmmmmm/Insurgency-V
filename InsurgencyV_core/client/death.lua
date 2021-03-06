
exports.spawnmanager:setAutoSpawn(false)
function InitDeathHandler()
    Citizen.CreateThread(function()
        while player == nil do Wait(1) end
        isDead = false
        deathCam = nil
        local offset = {0.0, -4.0, 4.0}
        local deathCoords = nil

        Citizen.CreateThread(function()
            while player.health == nil do Wait(1) end
            local count = 0


            while true do

                exports.spawnmanager:setAutoSpawn(false)

                if IsEntityDead(GetPlayerPed(-1)) then
                    if not isDead then
                        isDead = true

                        deathCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                        RenderScriptCams(1, 0, 0, 0, 0)
                        offset = {0.0, 0.0, 0.0}
                        deathCoords = GetEntityCoords(GetPlayerPed(-1))
                        deathCoords = vector3(deathCoords.x + 2.0, deathCoords.y + 2.0, deathCoords.z + 2.0)
                        SetCamCoord(deathCam, deathCoords)
                        PointCamAtCoord(deathCam, GetEntityCoords(GetPlayerPed(-1)))
                        SetCamFov(deathCam, 50.0)
                        ShakeCam(deathCam, "HAND_SHAKE", 0.2)
                        StartAudioScene("MP_LEADERBOARD_SCENE")
                        count = 0
                    end
                    count = count + 1
                else
                    StopAudioScenes()
                    ClearFocus()
                    StopScreenEffect("MP_OrbitalCannon")
                    SetCamActive(deathCam, false)
                    DestroyCam(deathCam, 0)
                    DestroyCam(deathCam, 1)
                    isDead = false
                end


                if isDead then
                    --SetEntityVisible(player.ped, 0, 0)
                    if count > 300 and isDead then
                        StartScreenEffect("MP_OrbitalCannon", 5000, true)
                        SetEntityHealth(player.ped, 200)
                        Respawn()
                        count = -9999999
                    else
                        RageUI.Text({message = "You are dead, you have to wait befor respawn..."})
                        deathCoords = vector3(deathCoords.x - 0.03, deathCoords.y + 0.02, deathCoords.z + 0.03)
                        SetCamCoord(deathCam, deathCoords)
                        PointCamAtCoord(deathCam, GetEntityCoords(GetPlayerPed(-1)))
                    end
                    Wait(1)
                else
                    if not isDead and not InRespawnMenu and not InCinematicMenu then
                        ClearFocus()
                    end
                    SetEntityVisible(player.ped, 1, 1)
                    Wait(50)
                end
            end
        end)

        RMenu.Add('core', 'respawn', RageUI.CreateMenu("Insurgency V", "~b~Choose your side ..."))
        RMenu:Get('core', 'respawn').Closed = function()
            InRespawnMenu = false
        end;
        RMenu:Get("core", "respawn").Closable = false

        RMenu.Add('core', 'respawn_veh', RageUI.CreateSubMenu(RMenu:Get('core', 'respawn'), "Respawn", "~b~Choose your veh ..."))
        RMenu:Get('core', 'respawn_veh').Closed = function()
            InRespawnMenu = false
        end;



        function Respawn()
            isDead = false
            SetEntityHealth(player.ped, 50)

            if InRespawnMenu then return end
            RageUI.Visible(RMenu:Get('core', 'respawn'), true)
            InRespawnMenu = true
            SetFocusArea(deathCoords, 0.0, 0.0, 0.0)

            Citizen.CreateThread(function()
                while InRespawnMenu do
                    Wait(1)

                    deathCoords = vector3(deathCoords.x - 0.03, deathCoords.y + 0.02, deathCoords.z + 0.03)
                    SetCamCoord(deathCam, deathCoords)
                    PointCamAtCoord(deathCam, GetEntityCoords(GetPlayerPed(-1)))

                    RageUI.IsVisible(RMenu:Get('core', 'respawn_veh'), false, false, false, function()
                        if player.camp == "army" then
                            RageUI.ButtonWithStyle("No vehicle needed.", nil, {}, true, function(_, h, s)
                                if s then
                                    Limit = 0
                                    InRespawnMenu = false
                                    RageUI.CloseAll()
                                    ClearFocus()
                                    StopScreenEffect("MP_OrbitalCannon")
                                    SetCamActive(deathCam, false)
                                    DestroyCam(deathCam, 0)
                                    DestroyCam(deathCam, 1)
                                end
                            end)
                            RageUI.ButtonWithStyle("Spawn an ~b~blazer4", nil, {}, true, function(_, h, s)
                                if s then
                                    Limit = 0
                                    SpawnVeh("blazer4", 153)
                                    InRespawnMenu = false
                                    RageUI.CloseAll()
                                    ClearFocus()
                                    StopScreenEffect("MP_OrbitalCannon")
                                    SetCamActive(deathCam, false)
                                    DestroyCam(deathCam, 0)
                                    DestroyCam(deathCam, 1)
                                end
                            end)
                        else
                            RageUI.ButtonWithStyle("No vehicle needed.", nil, {}, true, function(_, h, s)
                                if s then
                                    Limit = 0
                                    InRespawnMenu = false
                                    RageUI.CloseAll()
                                    ClearFocus()
                                    StopScreenEffect("MP_OrbitalCannon")
                                    SetCamActive(deathCam, false)
                                    DestroyCam(deathCam, 0)
                                    DestroyCam(deathCam, 1)
                                end
                            end)
                            RageUI.ButtonWithStyle("Spawn an ~b~BF400", nil, {}, true, function(_, h, s)
                                if s then
                                    Limit = 0
                                    SpawnVeh("bf400", 49)
                                    InRespawnMenu = false
                                    RageUI.CloseAll()
                                    ClearFocus()
                                    StopScreenEffect("MP_OrbitalCannon")
                                    SetCamActive(deathCam, false)
                                    DestroyCam(deathCam, 0)
                                    DestroyCam(deathCam, 1)
                                end
                            end)
                        end
                    end, function()
                    end)

                    RageUI.IsVisible(RMenu:Get('core', 'respawn'), false, false, false, function()
                        if player.camp == "army" then
                            RageUI.ButtonWithStyle("Respawn at base.", nil, {}, true, function(_, h, s)
                                if s then
                                    SetEntityCoords(player.ped, 182.16, 2708.5, 41.29, 0.0, 0.0, 0.0, 0)
                                    SetEntityHeading(player.ped, 278.6)
                                    NetworkResurrectLocalPlayer(182.16, 2708.5, 41.29, 240.6, 0, 0)
                                    JoinArmy(false)

                                    isDead = false
                                    SetEntityVisible(player.ped, 1, 1)
                                    RenderScriptCams(0, 1, 1000, 0, 0)
                                    Limit = 0
                                    StopAudioScenes()
                                    ClearFocus()
                                    InRespawnMenu = false
                                    RageUI.CloseAll()
                                    StopScreenEffect("MP_OrbitalCannon")
                                    SetCamActive(deathCam, false)
                                    DestroyCam(deathCam, 0)
                                    DestroyCam(deathCam, 1)
                                end

                            end)
                        else
                            RageUI.ButtonWithStyle("Respawn at base.", nil, {}, true, function(_, _, s)
                                if s then

                                    SetEntityCoords(player.ped, 2930.63, 4623.93, 47.72, 0.0, 0.0, 0.0, 0)
                                    SetEntityHeading(player.ped, 35.92)
                                    NetworkResurrectLocalPlayer(2930.63, 4623.93, 47.72, 35.92, 0, 0)
                                    JoinResistance(false)

                                    isDead = false
                                    SetEntityVisible(player.ped, 1, 1)
                                    RenderScriptCams(0, 1, 1000, 0, 0)
                                    Limit = 0
                                    StopAudioScenes()
                                    ClearFocus()
                                    InRespawnMenu = false
                                    RageUI.CloseAll()
                                    StopScreenEffect("MP_OrbitalCannon")
                                    SetCamActive(deathCam, false)
                                    DestroyCam(deathCam, 0)
                                    DestroyCam(deathCam, 1)
                                end
                            end)
                        end


                        for k,v in pairs(captureZone) do
                            RageUI.ButtonWithStyle("Respawn at ~b~"..v.label, "Zone owned by ~b~"..v.team, {}, v.team == player.camp, function(_, h, s)
                                if s then

                                    SetEntityCoords(player.ped, v.pos, 0.0, 0.0, 0.0, 0)
                                    SetEntityHeading(player.ped, 35.92)
                                    NetworkResurrectLocalPlayer(v.pos, 35.92, 0, 0)
                                    if player.camp == "army" then
                                        JoinArmy(false)
                                    else
                                        JoinResistance(false)
                                    end


                                    isDead = false
                                    SetEntityVisible(player.ped, 1, 1)
                                    RenderScriptCams(0, 1, 1000, 0, 0)
                                    Limit = 0
                                    StopAudioScenes()
                                    ClearFocus()
                                    StopScreenEffect("MP_OrbitalCannon")
                                    SetCamActive(deathCam, false)
                                    DestroyCam(deathCam, 0)
                                    DestroyCam(deathCam, 1)
                                end
                                if h then
                                    local coords = vector3(v.pos.x + 30.0, v.pos.y + 30.0, v.pos.z + 30.0)
                                    SetCamCoord(deathCam, coords)
                                    PointCamAtCoord(deathCam, v.pos)
                                    SetFocusArea(v.pos, 0.0, 0.0, 0.0)
                                end
                            end, RMenu:Get('core', 'respawn_veh'))
                        end
                    end, function()
                    end)
                end
            end)


        end
    end)
end