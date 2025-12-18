ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('advanced_tow:checkPerms')
AddEventHandler('advanced_tow:checkPerms', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.AdminGroups[xPlayer.getGroup()] then
        TriggerClientEvent('advanced_tow:startEditor', source)
    else
        TriggerClientEvent('esx:showNotification', source, L('not_allowed'))
    end
end)

-- Sincronização de Estado do Veículo (State Bags)
RegisterServerEvent('advanced_tow:syncAttach')
AddEventHandler('advanced_tow:syncAttach', function(towNetId, targetNetId)
    local towVeh = NetworkGetEntityFromNetworkId(towNetId)
    if DoesEntityExist(towVeh) then
        Entity(towVeh).state:set('attachedVehicle', targetNetId, true)
    end
end)

-- Persistência Básica
-- Nota: Para persistência após restart, este script monitoriza as State Bags.
-- Em produção, os dados do State Bag podem ser salvos numa DB via este evento.