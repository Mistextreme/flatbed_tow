local curVersion = '1.0.0'
local resourceName = GetCurrentResourceName()

Citizen.CreateThread(function()
    print('^2' .. resourceName .. ' carregado com sucesso! Versão: ' .. curVersion .. '^7')
    -- Aqui poderia ser adicionado um PerformHttpRequest para check de updates no GitHub
end)