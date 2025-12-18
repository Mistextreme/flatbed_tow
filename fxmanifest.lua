fx_version 'cerulean'
game 'gta5'

author 'Gemini Developer'
description 'Sistema de Reboque Profissional com Laser e Detecção de Bones'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'locales/pt.lua',
    'client/main.lua',
    'client/editormode.lua'
}

server_scripts {
    'server/main.lua',
    'server/version.lua'
}

lua54 'yes'