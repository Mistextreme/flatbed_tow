Config = {}

Config.Locale = 'pt'
Config.Debug = false

-- Grupos ESX com acesso ao modo de edição e comandos administrativos
Config.AdminGroups = {
    ['admin'] = true,
    ['superadmin'] = true,
    ['mod'] = true
}

-- Configurações de Física
Config.WinchMaxDistance = 20.0 -- Distância máxima do cabo do guincho
Config.WinchSpeed = 0.5        -- Velocidade de recolhimento

-- Veículos Pré-configurados (Exemplo)
-- O modo de edição irá adicionar entradas automaticamente aqui ou imprimir no log
Config.TowVehicles = {
    ['flatbed'] = {
        bone = 'chassis',
        offset = vector3(0.0, -2.5, 0.6),
        rotation = vector3(0.0, 0.0, 0.0),
        hasRamp = false, -- Se falso, usa deployRamp (prop)
        rampOffset = vector3(0.0, -5.0, -0.5)
    }
}

-- Modelos de rampa para spawn manual
Config.RampModel = `p_steer_ramp_01m` 

function L(str)
    if Locales and Locales[Config.Locale] and Locales[Config.Locale][str] then
        return Locales[Config.Locale][str]
    end
    return str
end