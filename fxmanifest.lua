fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'camou <vergeilt>'
description 'SQLite database library for FiveM'
version '1.0'
server_only 'yes'

server_scripts {
    'index.js'
}

convar_category 'camou_db' {
    'Config',
    {
        { 'Database Path', 'db_path', 'CV_STRING', '/db/database.sqlite' }
    }
}