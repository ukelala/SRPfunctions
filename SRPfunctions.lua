script_name('SRPfunctions')
script_author("Cody_Webb from Revolution")
script_version("09.01.2023")
script_version_number(1)
script.update = false
local scriptURL
-------------------------------------------------------------------------[Библиотеки]--------------------------------------------------------------------------------------
local ev = require 'samp.events'
local imgui = require 'imgui'
local vkeys = require 'vkeys'
local dlstatus = require('moonloader').download_status
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
-------------------------------------------------------------------------[Переменные и маcсивы]-----------------------------------------------------------------------------
local main_color = 0x333d81
local prefix = "{333d81}[SRP] {FFFFFF}"
local updatingprefix = u8:decode"{FF0000}[ОБНОВЛЕНИЕ] {FFFFFF}"
local antiflood = 0

local vehicles = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
	"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
	"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
	"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
	"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
	"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
	"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
	"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
	"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
	"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
	"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
	"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
	"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
-------------------------------------------------------------------------[MAIN]--------------------------------------------------------------------------------------------
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(0) end
	repeat wait(0) until sampGetCurrentServerName() ~= "SA-MP"
	repeat wait(0) until sampGetCurrentServerName():find("Samp%-Rp.Ru") or sampGetCurrentServerName():find("SRP")
	repeat wait(0) until sampIsLocalPlayerSpawned()
	server = sampGetCurrentServerName():gsub('|', '')
	server = (server:find('02') and 'Two' or (server:find('Revo') and 'Revolution' or (server:find('Legacy') and 'Legacy' or (server:find('Classic') and 'Classic' or ''))))
	if server == '' then thisScript():unload() end
	checkUpdates()
	chatmsg(u8:decode"Скрипт загружен!")
	while true do
		wait(0)
	end
end
-------------------------------------------------------------------------[IMGUI]-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------[ФУНКЦИИ]-----------------------------------------------------------------------------------------
function chatmsg(t)
	sampAddChatMessage(prefix .. t, main_color)
end

function checkUpdates() -- проверка обновлений
	local fpath = os.tmpname()
	if doesFileExist(fpath) then os.remove(fpath) end
	downloadUrlToFile("https://raw.githubusercontent.com/WebbLua/SRPfunctions/main/version.json", fpath, function(_, status, _, _)
		if status == 58 then
			if doesFileExist(fpath) then
				local file = io.open(fpath, 'r')
				if file then
					local info = decodeJson(file:read('*a'))
					file:close()
					os.remove(fpath)
					if info['version_num'] > thisScript()['version_num'] then
						scriptURL = info['version_url']
						sampRegisterChatCommand('srpup', updateScript)
						chatmsg(updatingprefix .. u8:decode"Обнаружена новая версия скрипта от " .. info['version_date'] .. u8:decode", пропишите /srpup для обновления") 
						return true
					end
					else
					chatmsg(u8:decode"Не удалось получить информацию про обновления(") 
				end
				else
				chatmsg(u8:decode"Не удалось получить информацию про обновления(") 
			end
		end
	end)
end

function updateScript()
	script.update = true
	downloadUrlToFile(scriptURL, thisScript().path, function(_, status, _, _)
		if status == 6 then
			chatmsg(updatingprefix .. u8:decode"Скрипт был обновлён!")
			if script.find("ML-AutoReboot") == nil then
				thisScript():reload()
			end
		end
	end)
end

function onScriptTerminate(s, bool)
	if s == thisScript() and not bool then
		if not script.update then 
			chatmsg(u8:decode"Скрипт крашнулся: откройте консоль sampfuncs (кнопка ~), скопируйте текст ошибки и отправьте разработчику") 
			else
			chatmsg(updatingprefix .. u8:decode"Старый скрипт был выгружен, загружаю обновлённую версию...") 
		end
	end
end