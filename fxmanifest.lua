fx_version 'adamant'

game 'gta5'

description 'Oskar-BanQueue'
author 'https://github.com/kapicaoskar'
lua54 'yes'
version '1.0'

shared_scripts {
    'config.lua'
}


server_scripts {
    '@oxmysql/lib/MySQL.lua', -- you can add here your own sql script
    'config.lua',
	'server/server.lua',
}

