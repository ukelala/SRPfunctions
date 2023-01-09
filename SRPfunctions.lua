script_name('SRPfunctions')
script_author("Cody_Webb | Telegram: @Imikhailovich")
script_version("09.01.2023")
script_version_number(2)
local script = {checked = false, available = false, update = false, v = {date, num}, url}
-------------------------------------------------------------------------[Библиотеки]--------------------------------------------------------------------------------------
local ev = require 'samp.events'
local imgui = require 'imgui'
imgui.ToggleButton = require('imgui_addons').ToggleButton
local vkeys = require 'vkeys'
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
-------------------------------------------------------------------------[Переменные и маcсивы]-----------------------------------------------------------------------------
local config = {
	bools = {
		['Починка у механика']     = false, 
		['Заправка у механика']    = false,
		['Заправка на АЗС'] 	   = false,
		['Покупка канистры'] 	   = false,
		['Заправка канистрой'] 	   = false,
		['Цвет ника в профе'] 	   = false,
		['Оповещение о выходе']    = false,
		['Оповещение о психохиле'] = false
	},
	values = {
		['Заправка у механика'] = 1500,
		['Заправка на АЗС'] = 5000
	}
}

local srp_ini = inicfg.load(config, "SRPfunctions.ini") -- загружаем ини
if os.remove("" .. thisScript().directory .. "\\config\\SRPfunctions.ini") ~= nil then 
	inicfg.save(config, "SRPfunctions.ini")
end

togglebools = {
	['Починка у механика']     = srp_ini.bools['Починка у механика']     and imgui.ImBool(true) or imgui.ImBool(false),
	['Заправка на АЗС'] 	   = srp_ini.bools['Заправка на АЗС']	     and imgui.ImBool(true) or imgui.ImBool(false),
	['Заправка у механика']    = srp_ini.bools['Заправка у механика']    and imgui.ImBool(true) or imgui.ImBool(false),
	['Заправка канистрой']     = srp_ini.bools['Заправка канистрой']     and imgui.ImBool(true) or imgui.ImBool(false),
	['Покупка канистры']       = srp_ini.bools['Покупка канистры']       and imgui.ImBool(true) or imgui.ImBool(false),
	['Цвет ника в профе']      = srp_ini.bools['Цвет ника в профе']      and imgui.ImBool(true) or imgui.ImBool(false),
	['Оповещение о выходе']    = srp_ini.bools['Оповещение о выходе']    and imgui.ImBool(true) or imgui.ImBool(false),
	['Оповещение о психохиле'] = srp_ini.bools['Оповещение о психохиле'] and imgui.ImBool(true) or imgui.ImBool(false)
}

buffer = {
	['Заправка у механика'] = imgui.ImBuffer(u8(srp_ini.values['Заправка у механика']), 256),
	['Заправка на АЗС']     = imgui.ImBuffer(u8(srp_ini.values['Заправка на АЗС']), 256),
}

local main_color = 0x333d81
local prefix = "{333d81}[SRP] {FFFAFA}"
local updatingprefix = u8:decode"{FF0000}[ОБНОВЛЕНИЕ] {FFFAFA}"
local antiflood = 0

local menu = {main = imgui.ImBool(false), information = imgui.ImBool(false)}
imgui.ShowCursor = false
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4
local imfonts = {mainfont = nil, font = nil}

local strings = {
	acceptrepair = u8:decode"^ Механик .* хочет отремонтировать ваш автомобиль за %d+ вирт.*",
	acceptrefill = u8:decode"^ Механик .* хочет заправить ваш автомобиль за (%d+) вирт%{FFFFFF%} %(%( Нажмите Y%/N для принятия%/отмены %)%)",
	gasstation   = u8:decode"Цена за 200л%: %$(%d+)",
	jfchat       = u8:decode"(.*)%[(%d+)]%<(.*)%>%: (.*)",
	color = {
		mechanic = 1790050303,
		jfchat   = 815835135
	}
}

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
-------------------------------------------------------------------------[IMGUI]-------------------------------------------------------------------------------------------
function apply_custom_styles()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
	
	imgui.GetIO().Fonts:Clear()
	imfonts.mainfont = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 18.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.font = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
end
apply_custom_styles()

function imgui.OnDrawFrame()
	if menu.main.v then -- меню скрипта
		imgui.SwitchContext()
		colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
		imgui.PushFont(imfonts.mainfont)
		sampSetChatDisplayMode(0)
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(1200, 730), imgui.Cond.Always)
		imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		imgui.Begin(thisScript().name .. (script.available and ' [Доступно обновление: v' .. script.v.num .. ' от ' .. script.v.date .. ']' or ' v' .. script.v.num .. ' от ' .. script.v.date), menu.main, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		imgui.Text("Можно перемещатся по меню, настройки сохраняются сразу!")
		
		imgui.NewLine()
		if imgui.ToggleButton("##1", togglebools['Починка у механика'])     then srp_ini.bools['Починка у механика']     = togglebools['Починка у механика'].v     inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Принимать предложение механика о починке")
		if imgui.ToggleButton("##2", togglebools['Заправка у механика'])    then srp_ini.bools['Заправка у механика']    = togglebools['Заправка у механика'].v    inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Принимать предложение механика о заправке (не дороже ") imgui.SameLine() imgui.PushItemWidth(90) imgui.InputText('##d2', buffer['Заправка у механика']) srp_ini.values['Заправка у механика'] = tostring(u8:decode(buffer['Заправка у механика'].v)) inicfg.save(config, "SRPfunctions.ini") imgui.SameLine() imgui.PopItemWidth() imgui.Text(" вирт.)")
		if imgui.ToggleButton("##3", togglebools['Заправка на АЗС']) 	    then srp_ini.bools['Заправка на АЗС'] 	     = togglebools['Заправка на АЗС'].v        inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Заправлять транспорт на АЗС (не дороже ")               imgui.SameLine() imgui.PushItemWidth(90) imgui.InputText('##d2', buffer['Заправка на АЗС'])     srp_ini.values['Заправка на АЗС']     = tostring(u8:decode(buffer['Заправка на АЗС'].v))     inicfg.save(config, "SRPfunctions.ini") imgui.SameLine() imgui.PopItemWidth() imgui.Text(" вирт.)")
		if imgui.ToggleButton("##4", togglebools['Покупка канистры'])       then srp_ini.bools['Покупка канистры']       = togglebools['Покупка канистры'].v       inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Покупать канистру на АЗС, (исходя из цены заправки)")
		if imgui.ToggleButton("##5", togglebools['Заправка канистрой'])     then srp_ini.bools['Заправка канистрой']     = togglebools['Заправка канистрой'].v     inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Заправлять транспорт канистрой в случае если закончилось топливо")
		if imgui.ToggleButton("##6", togglebools['Цвет ника в профе'])      then srp_ini.bools['Цвет ника в профе']      = togglebools['Цвет ника в профе'].v      inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Окрашивать ники в чате профсоюза в цвет клиста")
		if imgui.ToggleButton("##7", togglebools['Оповещение о выходе'])    then srp_ini.bools['Оповещение о выходе']    = togglebools['Оповещение о выходе'].v    inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Оповещать о вышедших из игры игроках в зоне прорисовки")
		if imgui.ToggleButton("##8", togglebools['Оповещение о психохиле']) then srp_ini.bools['Оповещение о психохиле'] = togglebools['Оповещение о психохиле'].v inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Оповещать об употреблении психохила игроками в зоне прорисовки")
		
		imgui.ShowCursor = true
		imgui.End()
		imgui.PopFont()
	end
end
-------------------------------------------------------------------------[MAIN]--------------------------------------------------------------------------------------------
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(0) end
	imgui.ShowCursor = false
	repeat wait(0) until sampGetCurrentServerName() ~= "SA-MP"
	repeat wait(0) until sampGetCurrentServerName():find("Samp%-Rp.Ru") or sampGetCurrentServerName():find("SRP")
	repeat wait(0) until sampIsLocalPlayerSpawned()
	server = sampGetCurrentServerName():gsub('|', '')
	server = (server:find('02') and 'Two' or (server:find('Revo') and 'Revolution' or (server:find('Legacy') and 'Legacy' or (server:find('Classic') and 'Classic' or ''))))
	if server == '' then thisScript():unload() end
	chatmsg(u8:decode"Скрипт загружен. Открыть главное меню - /srp")
	
	checkUpdates()
	while not script.checked do wait(0) end
	
	sampRegisterChatCommand("samprp", function()
        menu.main.v = not menu.main.v
	end)
    sampRegisterChatCommand("srp", function()
        menu.main.v = not menu.main.v
	end)
	
	while true do
		wait(0)
		imgui.Process = menu.main.v
		if not menu.main.v then imgui.ShowCursor = false sampSetChatDisplayMode(2) end
	end
end
-------------------------------------------------------------------------[ФУНКЦИИ]-----------------------------------------------------------------------------------------
function ev.onServerMessage(col, text)
	if col == strings.color.mechanic then
		if srp_ini.bools['Починка у механика'] then -- починка у механика
			if text:match(strings.acceptrepair) then sendchat("/ac repair") return end
		end
		if srp_ini.bools['Заправка у механика'] then -- заправка у механика
			local cost = tonumber(text:match(strings.acceptrefill))
			if cost ~= nil then
				local ncost = tonumber(srp_ini.values['Заправка у механика'])
				if ncost ~= nil and cost <= ncost then sendchat("/ac refill") return end
			end
		end
	end
	if col == strings.color.jfchat then
		if srp_ini.bools['Цвет ника в профе'] then -- окраска цветов в чате профсоюза
			local nick, stringid, rank, txt = text:match(strings.jfchat)
			id = tonumber(stringid)
			if id ~= nil then
				local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)) .. "}"
				local color2 = "{" .. ("%06x"):format(bit.band(bit.rshift(col, 8), 0xFFFFFF)) .. "}"
				text = clist .. nick .. "[" .. id .. "]" .. color2 .. "<" .. rank .. "> " .. txt
				return {col, text}
			end
		end
	end
end

function ev.onDisplayGameText(style, time, str)
	if srp_ini.bools['Заправка канистрой'] and str == "~r~Fuel has ended" and style == 4 and time == 3000 then -- заправка канистрой
		sendchat("/fillcar")
	end
end

function ev.onCreate3DText(id, color, position, distanse, testLOS , attachedPlayerId, attachedVehicleId, text)
	lua_thread.create(function() 
		local cen = tonumber(text:match(strings.gasstation))
		if cen ~= nil then
			local ncost = tonumber(srp_ini.values['Заправка на АЗС'])
			if ncost ~= nil and cen <= ncost then
				if srp_ini.bools['Покупка канистры'] then sendchat("/get fuel") end
				if srp_ini.bools['Заправка на АЗС'] then if isCharInAnyCar(PLAYER_PED) and getDriverOfCar(storeCarCharIsInNoSave(PLAYER_PED)) == PLAYER_PED then wait(1300) sendchat("/fill") end end
			end
		end
	end)
end

function ev.onPlayerQuit(id, reason)
	if srp_ini.bools['Оповещение о выходе'] and sampGetCharHandleBySampPlayerId(id) then
		local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)) .. "}"
		local reasons = {[0] = u8:decode'рестарт/краш', [1] = u8:decode'/q', [2] = u8:decode'кик'}
		chatmsg(u8:decode"Игрок " .. clist .. sampGetPlayerNickname(id) .. u8:decode"[" .. tostring(id) .. u8:decode"] {FFFAFA}вышел с игры. Причина: {FF0000}" .. reasons[reason] .. ".")
	end
end

function ev.onPlayerChatBubble(playerId, color, distanse, duration, message)
	if srp_ini.bools['Оповещение о психохиле'] and (message == u8:decode"Употребил психохил" or message == u8:decode"Употребила психохил") then
		local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(playerId), 0xFFFFFF)) .. "}"
		chatmsg(u8:decode"Игрок " .. clist .. sampGetPlayerNickname(playerId) .. u8:decode"[" .. playerId .. u8:decode"] {FFFAFA}- употребил психохил") 
	end
end

function ev.onSendChat(message)
	antiflood = os.clock() * 1000
	return {message}
end

function ev.onSendCommand(message)
	antiflood = os.clock() * 1000
	return {message}
end

function sendchat(t)
	lua_thread.create(function()
		while (os.clock() * 1000) - antiflood < 1300 do wait(0) end sampSendChat(t)
	end)
end

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
					script.v.num = info['version_num']
					script.v.date = info['version_date']
					script.url = info['version_url']
					script.checked = true
					if info['version_num'] > thisScript()['version_num'] then
						script.available = true
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
	downloadUrlToFile(script.url, thisScript().path, function(_, status, _, _)
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