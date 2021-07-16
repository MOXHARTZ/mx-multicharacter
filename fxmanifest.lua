fx_version 'cerulean'
games { 'gta5' }
author 'MOXHA'
client_scripts {
     'src/client/cutscene.lua',
     'src/client/main.lua'
}

server_scripts {
     '@mysql-async/lib/MySQL.lua',
     'src/server/main.lua'
}

ui_page 'src/html/main.html'

files({
     'src/html/main.html',
     'src/html/script.js',
     'src/html/style.css',
     'src/html/fonts/*'
})

shared_script 'src/shared/config.lua'