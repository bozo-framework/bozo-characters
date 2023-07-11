author "TheStoicBear"
description "Characters for Bozo-Framework"
version "2.4.6"

fx_version "cerulean"
game "gta5"
lua54 "yes"

shared_script "config.lua"

client_script "client.lua"

server_script "server.lua"

files {
	"ui/ui.html",
	"ui/script.js",
	"ui/style.css"
}

ui_page "ui/ui.html"

dependencies {
    "bozo-core",
	"bozo-appearance"
}