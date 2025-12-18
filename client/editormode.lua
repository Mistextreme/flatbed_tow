local inEditor = false
local laserColor = {r = 255, g = 0, b = 0, a = 200}
local tempRamp = nil

RegisterCommand('towedit', function()
    TriggerServerEvent('advanced_tow:checkPerms')
end)

RegisterNetEvent('advanced_tow:startEditor')
AddEventHandler('advanced_tow:startEditor', function()
    inEditor = not inEditor
    if inEditor then
        ESX.ShowNotification(L('edit_mode_on'))
        StartEditorLoop()
    else
        ESX.ShowNotification(L('edit_mode_off'))
        if tempRamp then DeleteEntity(tempRamp) end
    end
end)

function StartEditorLoop()
    Citizen.CreateThread(function()
        while inEditor do
            local sleep = 0
            local playerPed = PlayerPedId()
            local camCoords = GetGameplayCamCoords()
            local farCoords = GetOffsetFromCamByDist(15.0)
            
            local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, farCoords.x, farCoords.y, farCoords.z, 10, playerPed, 0)
            local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
            
            if hit == 1 then
                DrawLine(camCoords.x, camCoords.y, camCoords.z, endCoords.x, endCoords.y, endCoords.z, laserColor.r, laserColor.g, laserColor.b, laserColor.a)
                DrawMarker(28, endCoords.x, endCoords.y, endCoords.z, 0,0,0,0,0,0, 0.1, 0.1, 0.1, laserColor.r, laserColor.g, laserColor.b, laserColor.a, false, false, 2, nil, nil, false)
                
                if IsEntityAVehicle(entityHit) then
                    DisplayHelpText(L('laser_info'))
                    if IsControlJustPressed(0, 38) then -- [E]
                        IdentifyVehicleBones(entityHit, endCoords)
                    end
                end
            end
            
            if IsControlJustPressed(0, 47) then -- [G]
                inEditor = false
            end
            
            Citizen.Wait(sleep)
        end
    end)
end

function IdentifyVehicleBones(vehicle, hitCoords)
    local bones = {
        'chassis', 'chassis_dummy', 'bodyshell', 'attach_female', 'engine'
    }
    
    local foundBone = "chassis"
    local minDict = 999.0
    
    for _, boneName in ipairs(bones) do
        local boneIdx = GetEntityBoneIndexByName(vehicle, boneName)
        if boneIdx ~= -1 then
            local boneCoords = GetWorldPositionOfEntityBone(vehicle, boneIdx)
            local dist = #(hitCoords - boneCoords)
            if dist < minDict then
                minDict = dist
                foundBone = boneName
            end
        end
    end
    
    local offset = GetOffsetFromEntityGivenWorldCoords(vehicle, hitCoords.x, hitCoords.y, hitCoords.z)
    
    print("^2[TOW DEBUG] ^7Veículo: " .. GetEntityModel(vehicle))
    print("^2[TOW DEBUG] ^7Bone Detectado: " .. foundBone)
    print("^2[TOW DEBUG] ^7Offset Sugerido: vector3(" .. offset.x .. ", " .. offset.y .. ", " .. offset.z .. ")")
    
    ESX.ShowNotification(string.format(L('bone_selected'), foundBone))
end

function GetOffsetFromCamByDist(dist)
    local rot = GetGameplayCamRot(2)
    local tX = rot.x * 0.0174532924
    local tZ = rot.z * 0.0174532924
    local num = math.abs(math.cos(tX))
    return vector3(
        GetGameplayCamCoords().x - math.sin(tZ) * num * dist,
        GetGameplayCamCoords().y + math.cos(tZ) * num * dist,
        GetGameplayCamCoords().z + math.sin(tX) * dist
    )
end

function DisplayHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end