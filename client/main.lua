local isTowing = false
local currentWinch = nil
local attachedVehicle = nil

ESX = exports["es_extended"]:getSharedObject()

-- Função para obter o veículo à frente usando Raycast
function GetVehicleInDirection()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local farCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
    local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, farCoords.x, farCoords.y, farCoords.z, 10, playerPed, 0)
    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
    if hit == 1 and IsEntityAVehicle(entityHit) then
        return entityHit
    end
    return nil
end

-- Sistema de Winch (Cabo Visual)
RegisterCommand('winch', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehicleInDirection()
    
    if vehicle then
        if not currentWinch then
            currentWinch = {
                targetVeh = vehicle,
                rope = nil
            }
            local myVeh = GetVehiclePedIsIn(playerPed, false)
            if myVeh ~= 0 then
                local pos1 = GetEntityCoords(myVeh)
                local pos2 = GetEntityCoords(vehicle)
                currentWinch.rope = AddRope(pos1.x, pos1.y, pos1.z, 0.0, 0.0, 0.0, 20.0, 4, 1.0, 1.0, 0.0, false, false, false, 1.0, true)
                AttachEntitiesToRope(currentWinch.rope, myVeh, vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 20.0, false, false, nil, nil)
                ActivatePhysics(currentWinch.rope)
                ESX.ShowNotification(L('winch_attach'))
            end
        else
            DeleteRope(currentWinch.rope)
            currentWinch = nil
        end
    end
end)

-- Sincronização de Attachment
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle ~= 0 and Config.TowVehicles[GetEntityModel(vehicle)] then
            sleep = 500
            -- Lógica de monitorização de veículos anexados via State Bags
            local attachedNetId = Entity(vehicle).state.attachedVehicle
            if attachedNetId then
                local targetVeh = NetToVeh(attachedNetId)
                if DoesEntityExist(targetVeh) then
                    if not IsEntityAttachedToEntity(targetVeh, vehicle) then
                        -- Re-attach se desync
                        local cfg = Config.TowVehicles[GetEntityModel(vehicle)]
                        AttachEntityToEntity(targetVeh, vehicle, GetEntityBoneIndexByName(vehicle, cfg.bone), cfg.offset, cfg.rotation, false, false, true, false, 2, true)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)