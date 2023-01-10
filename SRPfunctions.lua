script_name('SRPfunctions')
script_author("Cody_Webb | Telegram: @Imikhailovich")
script_version("10.01.2023")
script_version_number(4)
local script = {checked = false, available = false, update = false, v = {date, num}, url, reload, upd = {changes = {}, sort = {}}}
-------------------------------------------------------------------------[Библиотеки]--------------------------------------------------------------------------------------
local ev = require 'samp.events'
local imgui = require 'imgui'
imgui.ToggleButton = require('imgui_addons').ToggleButton
local vkeys = require 'vkeys'
local rkeys = require 'rkeys'
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
		['Оповещение о психохиле'] = false,
		['Дата и время']           = false,
		['Ник']           		   = false,
		['Пинг']           		   = false,
		['Нарко']         		   = false,
		['Таймер до МП']           = false,
		['Прорисовка']             = false,
		['Статус']           	   = false,
		['Сквад']           	   = false
	},
	hotkey = {
		['Контекстная клавиша']    = "0",
		['Нарко']                  = "0",
		['Сменить клист']          = "0"
	},
	overlay = {
		['Дата и времяX']          = 300,
		['Дата и времяY']          = 300,
		['НикX']                   = 300,
		['НикY']                   = 350,
		['ПингX']                  = 300,
		['ПингY']                  = 400,
		['НаркоX']        		   = 500,
		['НаркоY']        		   = 300,
		['Таймер до МПX']          = 500,
		['Таймер до МПY']          = 350,
		['ПрорисовкаX']            = 500,
		['ПрорисовкаY']            = 400,
		['СтатусX']                = 600,
		['СтатусY']                = 300,
		['СквадX']                 = 850,
		['СквадY']                 = 350
	},
	values = {
		['Заправка у механика']    = 1500,
		['Заправка на АЗС']        = 5000,
		['Нарко']                  = 0,
		['clist']                  = 12
	},
	ivent = {
		['Гонка ЛС']               = false, 
		['Дерби СФ']               = false, 
		['Игра Кальмара']          = false, 
		['Пейнтбол']               = false
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
	['Оповещение о психохиле'] = srp_ini.bools['Оповещение о психохиле'] and imgui.ImBool(true) or imgui.ImBool(false),
	['Дата и время']           = srp_ini.bools['Дата и время'] 			 and imgui.ImBool(true) or imgui.ImBool(false),
	['Ник']           		   = srp_ini.bools['Ник']                    and imgui.ImBool(true) or imgui.ImBool(false),
	['Пинг']           		   = srp_ini.bools['Пинг']                   and imgui.ImBool(true) or imgui.ImBool(false),
	['Нарко']         		   = srp_ini.bools['Нарко']                  and imgui.ImBool(true) or imgui.ImBool(false),
	['Таймер до МП']           = srp_ini.bools['Таймер до МП']           and imgui.ImBool(true) or imgui.ImBool(false),
	['Прорисовка']             = srp_ini.bools['Прорисовка']             and imgui.ImBool(true) or imgui.ImBool(false),
	['Статус']           	   = srp_ini.bools['Статус']                 and imgui.ImBool(true) or imgui.ImBool(false),
	['Сквад']           	   = srp_ini.bools['Сквад']                  and imgui.ImBool(true) or imgui.ImBool(false)
}

buffer = {
	['Заправка у механика'] = imgui.ImBuffer(u8(srp_ini.values['Заправка у механика']), 256),
	['Заправка на АЗС']     = imgui.ImBuffer(u8(srp_ini.values['Заправка на АЗС']), 256),
	['clist']        		= imgui.ImInt(srp_ini.values.clist)
}

local clists = {
	numbers = {
		[16777215] = 0,    [2852758528] = 1,  [2857893711] = 2,  [2857434774] = 3,  [2855182459] = 4, [2863589376] = 5, 
		[2854722334] = 6,  [2858002005] = 7,  [2868839942] = 8,  [2868810859] = 9,  [2868137984] = 10, 
		[2864613889] = 11, [2863857664] = 12, [2862896983] = 13, [2868880928] = 14, [2868784214] = 15, 
		[2868878774] = 16, [2853375487] = 17, [2853039615] = 18, [2853411820] = 19, [2855313575] = 20, 
		[2853260657] = 21, [2861962751] = 22, [2865042943] = 23, [2860620717] = 24, [2868895268] = 25, 
		[2868899466] = 26, [2868167680] = 27, [2868164608] = 28, [2864298240] = 29, [2863640495] = 30,
		[2864232118] = 31, [2855811128] = 32, [2866272215] = 33
	},
	names = {
		"[0] Без цвета", "[1] Зелёный", "[2] Светло-зелёный", "[3] Ярко-зелёный",
		"[4] Бирюзовый", "[5] Жёлто-зелёный", "[6] Тёмно-зелёный", "[7] Серо-зелёный",
		"[8] Красный", "[9] Ярко-красный", "[10] Оранжевый", "[11] Коричневый",
		"[12] Тёмно-красный", "[13] Серо-красный", "[14] Жёлто-оранжевый", "[15] Малиновый",
		"[16] Розовый", "[17] Синий", "[18] Голубой", "[19] Синяя сталь", "[20] Cине-зелёный",
		"[21] Тёмно-синий", "[22] Фиолетовый", "[23] Индиго", "[24] Серо-синий", "[25] Жёлтый",
		"[26] Кукурузный", "[27] Золотой", "[28] Старое золото", "[29] Оливковый",
		"[30] Серый", "[31] Серебро", "[32] Чёрный", "[33] Белый"
	}
}

local main_color = 0x333d81
local prefix = "{333d81}[SRP] {FFFAFA}"
local updatingprefix = u8:decode"{FF0000}[ОБНОВЛЕНИЕ] {FFFAFA}"
local antiflood = 0

local menu = {main = imgui.ImBool(false), automatic = imgui.ImBool(true), binds = imgui.ImBool(false), overlay = imgui.ImBool(false), information = imgui.ImBool(false)}
imgui.ShowCursor = false
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local SetModeCond = 4
local SetMode = false
local SetModeFirstShow = false
local soverlay = {}
local drugtimer = 60
local isBoost = false
local checkedBoost = false
local killerid
local td = nil
local smem = {}
local saveid = {}
local rCache = {
    enable = false,
    font = nil,
    pos = {
        x = 0,
        y = 0
	}
}
local suspendkeys = 2 -- 0 хоткеи включены, 1 -- хоткеи выключены -- 2 хоткеи необходимо включить
local CTaskArr = {
	[1] = {}, -- ID событий
	-- 1 - /repairkit, 2 - репорт за ДМ, 3 - вызвать врачей в больницу по СМС
	[2] = {}, -- время начала события
	[3] = {}, -- доп. информация для события
	["CurrentID"] = 0, 
	["n"] = {
		[1] = "{FF0000}Рем. комплект",
		[2] = "{FF0000}Репорт на",
		[3] = "{00FF00}Вызвать врача в"
	}, -- имена статусов в КК по ID события
	["nn"] = {2, 3}, -- ID's которые требуют отображения доп информации (из массива №3) в статусе КК
	[10] = { -- прочие значения для работы КК (мусорка переменных)
		[1] = false, -- есть ли активное задание по id 1 на данный момент
		[2] = {
			[-1514.75 + 2518.875 + 56] = "El Quebrados Medical Center",
			[-318.75 + 1048.125 + 20.25] = "Fort Carson Medical Center",
			[1607.375 + 1815.125 + 10.75] = "Las Venturas Hospital",
			[1228.625 + 311.875 + 19.75] = "Crippen Memorial Hospital",
			[1241.375 + 325.875 + 19.75] = "Crippen Memorial Hospital",
			[2034.125 + -1401.625 + 17.25] = "Country General Hospital",
			[1172 + -1323.375 + 15.375] = "All Saints General Hospital",
			[-2655.125 + 640.125 + 14.375] = "San Fierro Medical Center",
			[261.875 + 4 + 1500.875] = 0, -- exit
			[242.75 + 7 + 1500.875] = 0 -- exit2
		}, -- координаты меток входа/выхода у больниц
	}
}
local ImVec4 = imgui.ImVec4
local imfonts = {mainFont = nil, font = nil, ovFont = nil, ovFontSquad = nil, ovFontSquadRender = nil}

local strings = {
	acceptrepair = u8:decode"^ Механик .* хочет отремонтировать ваш автомобиль за %d+ вирт.*",
	acceptrefill = u8:decode"^ Механик .* хочет заправить ваш автомобиль за (%d+) вирт%{FFFFFF%} %(%( Нажмите Y%/N для принятия%/отмены %)%)",
	gasstation   = u8:decode"Цена за 200л%: %$(%d+)",
	jfchat       = u8:decode"^ (.*)%[(%d+)]%<(.*)%>%: (.*)",
	boost        = u8:decode"^ Действует до%: %d+%/%d+%/%d+ %d+%:%d+%:%d+",
	noboost      = u8:decode"^ Бонусы отключены",
	narko        = u8:decode'^ %(%( Остаток%: %d+ грамм %)%)',
	painttime    = u8:decode"^ Внимание%! Начало пейнтбола через (%d) минуты?%. Место проведения%: военный завод K%.A%.C%.C%.",
	squidtime    = u8:decode"^ Внимание%! Начало %'Игра в Кальмара%' через (%d) минуты?%! Место проведения%: Арена LS %(%( %/gps %[Важное%] %>%> %[Игра в Кальмара%] %)%)",
	derbytime    = u8:decode"^ Внимание%! Начало гонок дерби через (%d) минуты?%. Стадион Сан Фиерро%. Регистрация на первом этаже",
	racetime     = u8:decode"^ Внимание%! Начало гонок через (%d) минуты?%. Трасса%: Аэропорт Лос Сантос%. Регистрация у въезда",
	paintfalse1  = u8:decode"^ Внимание%! Пейнтбол начался",
	paintfalse2  = u8:decode"^ Внимание%! Пейнтбол был прерван из-за отсутствия участников",
	squidfalse1  = u8:decode"^ Внимание%! %'Игра в Кальмара%' прервана из%-за недостаточного количества участников%!",
	squidfalse2  = u8:decode"^ Внимание%! %'Игра в Кальмара%' началась%!",
	squidfalse3  = u8:decode"^ Внимание%! %'Игра в Кальмара%' прервана из%-за проигрыша всех участников%! %(%( Список%: %/klmlist %)%)",
	derbyfalse1  = u8:decode"^ Внимание%! Гонки дерби начались%. Стадион Сан Фиерро",
	derbyfalse2  = u8:decode"^ Внимание%! Гонки дерби были прерваны из%-за отсутствия участников",
	derbyfalse3  = u8:decode"^ Внимание%! Гонки дерби окончены%. %(%( Список победителей%: %/derbylist %)%)",
	racefalse1   = u8:decode"^ Внимание%! Гонки были прерваны из%-за отсутствия участников",
	racefalse2   = u8:decode"^ Внимание%! Гонки начались%. Трасса%: Аэропорт Лос Сантос",
	racefalse3   = u8:decode"^ Внимание%! Гонки окончены%. %(%( Список победителей%: %/racelist %)%)",
	repair1      = u8:decode"^ Двигатель отремонтирован%. У вас осталось %d+%/%d+ комплектов %«автомеханик%»",
	repair2      = u8:decode"^ У вас нет комплекта %«автомеханик%» для ремонта",
	repair3      = u8:decode"^ В транспортном средстве нельзя",
	repair4      = u8:decode"^ Вы далеко от транспортного средства%. Подойдите к капоту",
	color = {
		mechanic = 1790050303,
		jfchat   = 815835135,
		narko    = -1,
		boost    = -1,
		noboost  = -1,
		paint    = -5570561,
		squid    = -356056833,
		race     = -1179057921, 
		derby    = 16711935
	},
	dialog = {
		narko = {str = u8:decode"%[%d+%] Таймер на Нарко(.*)", id = 22, style = 5, title = u8:decode'Бонусы'}
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
	while not script.checked do wait(600) end
	
	imgui.Process = true
	imgui.ShowCursor = false
	
	sampRegisterChatCommand("samprp",     function() for k, v in pairs(srp_ini.hotkey) do local hk = makeHotKey(k) if tonumber(hk[1]) ~= 0 then rkeys.unRegisterHotKey(hk) end end suspendkeys = 1 menu.main.v = not menu.main.v end)
	sampRegisterChatCommand("srp",        function() for k, v in pairs(srp_ini.hotkey) do local hk = makeHotKey(k) if tonumber(hk[1]) ~= 0 then rkeys.unRegisterHotKey(hk) end end suspendkeys = 1 menu.main.v = not menu.main.v end)
	sampRegisterChatCommand("setoverlay", cmd_setoverlay)
	sampRegisterChatCommand("setov",      cmd_setoverlay)
	
	if srp_ini.bools["Сквад"] then
		for i = 0, 2303 do
			if sampTextdrawIsExists(i) and sampTextdrawGetString(i):find("SQUAD") then
				local x, y = sampTextdrawGetPos(i)      
				rCache.pos.x, rCache.pos.y = convertGameScreenCoordsToWindowScreenCoords(x == 1488 and x - 1485 or x + 1, y == 1488 and y - 1291 or y + 25)
				rCache.enable = true
				td = i
				smem = {}
				saveid = {}
				local list = sampTextdrawGetString(i):split("~n~")
				table.remove(list, 1)
				for k, v in ipairs(list) do
					local id = sampGetPlayerIdByNickname(v)
					if id then
						local color = sampGetPlayerColor(id)
						local a, r, g, b = explode_argb(color)
						table.insert(smem, {
							id = id,
							name = v,
							color = join_argb(230.0, r, g, b),
							colorns = join_argb(150.0, r, g, b),
						})
						saveid[id] = #smem
					end
				end
				break
			end
		end
	end
	
	if srp_ini.bools['Статус'] then lua_thread.create(function() CTask() end) end
	if srp_ini.bools['Нарко'] and not checkedBoost then lua_thread.create(function() isBoost = true wait(1300) sampSendChat('/boostinfo') end) end -- проверка множителя КД нарко
	
	while true do
		wait(0)
		if suspendkeys == 2 then
			rkeys.registerHotKey(makeHotKey("Контекстная клавиша"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end if srp_ini.bools['Статус'] then ct() end end)
			rkeys.registerHotKey(makeHotKey("Нарко"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end lua_thread.create(function() wait(600) sampSendChat("/usedrugs") end) end)
			rkeys.registerHotKey(makeHotKey("Сменить клист"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end setclist() end)
			suspendkeys = 0
		end
		if not menu.main.v then imgui.ShowCursor = false if suspendkeys == 1 then suspendkeys = 2 sampSetChatDisplayMode(3) end end
		if SetMode then
			if isKeyDown(vkeys.VK_MBUTTON) then
				wait(300)
				if isKeyDown(vkeys.VK_MBUTTON) then
					srp_ini.overlay['Дата и времяX']          = 300
					srp_ini.overlay['Дата и времяY']          = 300
					srp_ini.overlay['НикX']                   = 300
					srp_ini.overlay['НикY']                   = 350
					srp_ini.overlay['ПингX']                  = 300
					srp_ini.overlay['ПингY']                  = 400
					srp_ini.overlay['НаркоX']        		  = 500
					srp_ini.overlay['НаркоY']        		  = 300
					srp_ini.overlay['Таймер до МПX']          = 500
					srp_ini.overlay['Таймер до МПY']          = 350
					srp_ini.overlay['ПрорисовкаX']            = 500
					srp_ini.overlay['ПрорисовкаY']            = 400
					srp_ini.overlay['СтатусX']                = 600
					srp_ini.overlay['СтатусY']                = 300
					srp_ini.overlay['СквадX']                 = 850
					srp_ini.overlay['СквадY']                 = 350
					inicfg.save(config, "SRPfunctions.ini")
					SetMode, SetModeFirstShow = true, true
					chatmsg(u8:decode"Координаты элементов были успешно сброшены")
				end
			end
		end
	end
end
-------------------------------------------------------------------------[IMGUI]-------------------------------------------------------------------------------------------
function apply_custom_styles()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
	
	imgui.GetIO().Fonts:Clear()
	imfonts.mainFont          = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.smainFont1        = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 18.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.smainFont2        = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 16.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	
	imfonts.ovFont            = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 28.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.ovFont1           = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.ovFont2           = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 25.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.ovFontSquad       = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebuc.ttf', 15.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) --trebuchet
	imfonts.ovFontSquadRender = renderCreateFont("times", 11, 12)
	
	imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 14.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imgui.RebuildFonts()
end
apply_custom_styles()

function imgui.TextColoredRGB(text)
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4
	
	local explode_argb = function(argb)
		local a = bit.band(bit.rshift(argb, 24), 0xFF)
		local r = bit.band(bit.rshift(argb, 16), 0xFF)
		local g = bit.band(bit.rshift(argb, 8), 0xFF)
		local b = bit.band(argb, 0xFF)
		return a, r, g, b
	end
	
	local getcolor = function(color)
		if color:sub(1, 6):upper() == 'SSSSSS' then
			local r, g, b = colors[1].x, colors[1].y, colors[1].z
			local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			return ImVec4(r, g, b, a / 255)
		end
		
		local color = type(color) == 'string' and tonumber(color, 16) or color
		if type(color) ~= 'number' then return end
		local r, g, b, a = explode_argb(color)
		return imgui.ImColor(r, g, b, a):GetVec4()
	end
	
	local render_text = function(text_)
		for w in text_:gmatch('[^\r\n]+') do
			local text, colors_, m = {}, {}, 1
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				local color = getcolor(w:sub(n + 1, k - 1))
				if color then
					text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					colors_[#colors_ + 1] = color
					m = n
				end
				
				w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			end
			
			if text[0] then
				for i = 0, #text do
					imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
					if imgui.IsItemClicked() then	if SelectedRow == A_Index then ChoosenRow = SelectedRow	else	SelectedRow = A_Index	end	end
					imgui.SameLine(nil, 0)
				end
				
				imgui.NewLine()
				else
				imgui.Text(u8(w))
				if imgui.IsItemClicked() then	if SelectedRow == A_Index then ChoosenRow = SelectedRow	else	SelectedRow = A_Index	end	end
			end
		end
	end
	render_text(text)
end

function imgui.CustomButton(gg, color, colorHovered, colorActive, size)
    local clr = imgui.Col
    imgui.PushStyleColor(clr.Button, color)
    imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
    imgui.PushStyleColor(clr.ButtonActive, colorActive)
	if not size then size = imgui.ImVec2(0, 0) end
	local result = imgui.Button(gg, size)
	imgui.PopStyleColor(3)
	return result
end

function imgui.OnDrawFrame()
	if menu.main.v then -- меню скрипта
		imgui.SwitchContext()
		colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
		imgui.PushFont(imfonts.mainFont)
		--sampSetChatDisplayMode(0)
		imgui.ShowCursor = true
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(1200, 700), imgui.Cond.FirstUseEver)
		imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		imgui.Begin(thisScript().name .. (script.available and ' [Доступно обновление: v' .. script.v.num .. ' от ' .. script.v.date .. ']' or ' v' .. script.v.num .. ' от ' .. script.v.date), menu.main, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		local ww = imgui.GetWindowWidth()
		local wh = imgui.GetWindowHeight()
		imgui.Text("Все настройки автоматически сохраняются в файл moonloader//config//SRPfunctions.ini")
		
		imgui.PushFont(imfonts.smainFont1)
		if imgui.Button("Автоматические действия", imgui.ImVec2(300.0, 23.0)) then menu.automatic.v = true menu.binds.v = false menu.overlay.v = false menu.information.v = false end
		imgui.SameLine()
		if imgui.Button("Клавиши и команды", imgui.ImVec2(300.0, 23.0)) then menu.automatic.v = false menu.binds.v = true menu.overlay.v = false menu.information.v = false end
		imgui.SameLine()
		if imgui.Button("Overlay", imgui.ImVec2(300.0, 23.0)) then menu.automatic.v = false menu.binds.v = false menu.overlay.v = true menu.information.v = false end
		imgui.SameLine()
		if imgui.Button("Информация о скрипте", imgui.ImVec2(300.0, 23.0)) then menu.automatic.v = false menu.binds.v = false menu.overlay.v = false menu.information.v = true end
		imgui.PopFont()
		
		if menu.automatic.v and not menu.binds.v and not menu.overlay.v and not menu.information.v then
			if imgui.ToggleButton("automatic1", togglebools['Починка у механика'])     then srp_ini.bools['Починка у механика']     = togglebools['Починка у механика'].v     inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Принимать предложение механика о починке")
			if imgui.ToggleButton("automatic2", togglebools['Заправка у механика'])    then srp_ini.bools['Заправка у механика']    = togglebools['Заправка у механика'].v    inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Принимать предложение механика о заправке (не дороже ") imgui.SameLine() imgui.PushItemWidth(90) imgui.InputText('##d1', buffer['Заправка у механика']) srp_ini.values['Заправка у механика'] = tostring(u8:decode(buffer['Заправка у механика'].v)) inicfg.save(config, "SRPfunctions.ini") imgui.SameLine() imgui.PopItemWidth() imgui.Text(" вирт.)")
			if imgui.ToggleButton("automatic3", togglebools['Заправка на АЗС']) 	   then srp_ini.bools['Заправка на АЗС'] 	    = togglebools['Заправка на АЗС'].v        inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Заправлять транспорт на АЗС (не дороже ")               imgui.SameLine() imgui.PushItemWidth(90) imgui.InputText('##d2', buffer['Заправка на АЗС'])     srp_ini.values['Заправка на АЗС']     = tostring(u8:decode(buffer['Заправка на АЗС'].v))     inicfg.save(config, "SRPfunctions.ini") imgui.SameLine() imgui.PopItemWidth() imgui.Text(" вирт.)")
			if imgui.ToggleButton("automatic4", togglebools['Покупка канистры'])       then srp_ini.bools['Покупка канистры']       = togglebools['Покупка канистры'].v       inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Покупать канистру на АЗС, (исходя из цены заправки)")
			if imgui.ToggleButton("automatic5", togglebools['Заправка канистрой'])     then srp_ini.bools['Заправка канистрой']     = togglebools['Заправка канистрой'].v     inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Заправлять транспорт канистрой в случае если закончилось топливо")
			if imgui.ToggleButton("automatic6", togglebools['Цвет ника в профе'])      then srp_ini.bools['Цвет ника в профе']      = togglebools['Цвет ника в профе'].v      inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Окрашивать ники в чате профсоюза в цвет клиста")
			if imgui.ToggleButton("automatic7", togglebools['Оповещение о выходе'])    then srp_ini.bools['Оповещение о выходе']    = togglebools['Оповещение о выходе'].v    inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Оповещать о вышедших из игры игроках в зоне прорисовки")
			if imgui.ToggleButton("automatic8", togglebools['Оповещение о психохиле']) then srp_ini.bools['Оповещение о психохиле'] = togglebools['Оповещение о психохиле'].v inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Оповещать об употреблении психохила игроками в зоне прорисовки")
		end
		
		if not menu.automatic.v and menu.binds.v and not menu.overlay.v and not menu.information.v then
			imgui.PushFont(imfonts.smainFont2)
			imgui.Hotkey("bind", "Контекстная клавиша", 100) imgui.SameLine() imgui.Text("Контекстная клавиша\n(удерживайте чтобы отменить задачу - только одиночная клавиша)")
			imgui.Hotkey("bind1", "Нарко", 100) 			 imgui.SameLine() imgui.Text("Употребить нарко\n(нужно находится на месте)")
			imgui.Hotkey("bind2", "Сменить клист", 100) 	 imgui.SameLine() imgui.Text("Сменить клист\n(если надет не нулевой клист, то будет введён /clist 0)") imgui.SetCursorPos(imgui.ImVec2(ww/2 - 120, wh/2 - 190)) imgui.PushItemWidth(200) if imgui.Combo("##Combo", buffer.clist, clists.names) then srp_ini.values.clist = tostring(u8:decode(buffer.clist.v)) inicfg.save(config, "SRPfunctions.ini") end
			imgui.PopFont()
		end
		
		if not menu.automatic.v and not menu.binds.v and menu.overlay.v and not menu.information.v then
			imgui.Text("Что бы изменить положение элемента, пропишите команду /setov")
			imgui.Text("Далее просто нужно курсором перенести все элементы")
			if imgui.ToggleButton("overlay1", togglebools['Дата и время'])   then srp_ini.bools['Дата и время']   = togglebools['Дата и время'].v   inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Отображение даты и времени на экране")
			if imgui.ToggleButton("overlay2", togglebools['Ник'])            then srp_ini.bools['Ник']            = togglebools['Ник'].v            inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Отображение никнейма и IDа в цвете клиста")
			if imgui.ToggleButton("overlay3", togglebools['Пинг'])           then srp_ini.bools['Пинг']           = togglebools['Пинг'].v           inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Отображение текущего пинга")
			if imgui.ToggleButton("overlay4", togglebools['Нарко']) 		 then srp_ini.bools['Нарко']          = togglebools['Нарко'].v          inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Отображение статуса употребления нарко")
			if imgui.ToggleButton("overlay5", togglebools['Таймер до МП'])   then srp_ini.bools['Таймер до МП']   = togglebools['Таймер до МП'].v   inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Отображение таймеров до начала системных мероприятий")
			if imgui.ToggleButton("overlay6", togglebools['Прорисовка'])     then srp_ini.bools['Прорисовка']     = togglebools['Прорисовка'].v     inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Отображение количества игроков в зоне прорисовки")
			if imgui.ToggleButton("overlay7", togglebools['Статус'])         then srp_ini.bools['Статус']         = togglebools['Статус'].v         inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Отборажение статуса контекстной клавиши")
			if imgui.ToggleButton("overlay8", togglebools['Сквад'])          then srp_ini.bools['Сквад']          = togglebools['Сквад'].v          inicfg.save(config, "SRPfunctions.ini") end imgui.SameLine() imgui.Text("Отображение улучшенного вида сквада")
		end
		
		if not menu.automatic.v and not menu.binds.v and not menu.overlay.v and menu.information.v then
			imgui.Text("Данный скрипт является многофункциональным хелпером для игроков проекта Samp RP")
			imgui.Text("Автор: Cody_Webb | Telegram: @Imikhailovich")
			imgui.Text("Информация о последних обновлениях:")
			for k in ipairs(script.upd.sort) do 
				if script.upd.changes[tostring(k)] ~= nil then
					if k > 20 then imgui.SameLine() end
					imgui.Text(k .. ') ' .. script.upd.changes[tostring(k)]) 
				end 
			end
		end
		
		imgui.SetCursorPos(imgui.ImVec2(30, wh/2 + 295))
		local found = false
		for i = 0, 1000 do 
			if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
				if sampGetPlayerNickname(i) == "Cody_Webb" then
					if imgui.CustomButton("Cody_Webb[" .. i .. "] сейчас в сети", imgui.ImVec4(0.42, 0.48, 0.16, 0.54), imgui.ImVec4(0.85, 0.98, 0.26, 0.40), imgui.ImVec4(0.85, 0.98, 0.26, 0.67), imgui.ImVec2(260.0, 30.0)) then
						sampSendChat("/sms " .. i .. u8:decode" Я пользуюсь твоим скриптом, большое спасибо")
					end
					found = true
				end
			end
		end
		if not found then
			if imgui.Button("Cody Webb сейчас не в сети", imgui.ImVec2(245.0, 30.0)) then
				chatmsg(u8:decode"Cody Webb играет на Revolution (сейчас не онлайн)", main_color)
			end
		end
		imgui.PushFont(imfonts.smainFont2)
		imgui.SetCursorPos(imgui.ImVec2(ww/2 + 400, wh/2 + 260))
		if imgui.Button("Перезагрузить скрипт", imgui.ImVec2(170.0, 23.0)) then showCursor(false) script.reload = true thisScript():reload() end
		imgui.SetCursorPos(imgui.ImVec2(ww/2 + 400, wh/2 + 295))
		if imgui.Button("Открыть GitHub", imgui.ImVec2(170.0, 23.0)) then os.execute('explorer "https://github.com/WebbLua/SRPfunctions"') end
		imgui.PopFont()
		
		imgui.End()
		imgui.PopFont()
	end
	
	imgui.SwitchContext() -- Overlay
	colors[clr.WindowBg] = ImVec4(0, 0, 0, 0)
	local SetModeCond = SetMode and 0 or 4
	
	if srp_ini.bools['Дата и время'] then -- показывать время
		if not SetMode then	imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['Дата и времяX'], srp_ini.overlay['Дата и времяY'])) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['Дата и времяX'], srp_ini.overlay['Дата и времяY']))	end end
		imgui.Begin('#empty_field', srp_ini.bools['Дата и время'], 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont)
		imgui.TextColoredRGB('{FFFF00}' .. os.date("%d.%m.%y %X") .. '')
		imgui.PopFont()
		soverlay['Дата и время'] = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools['Ник'] then -- ник и ид на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['НикX'], srp_ini.overlay['НикY'])) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['НикX'], srp_ini.overlay['НикY']))	end	end
		local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if result then
			local name = sampGetPlayerNickname(id)
			local clist = string.sub(string.format('%x', sampGetPlayerColor(id)), 3)
			local clist = clist == "ffff" and "fffafa" or clist
			imgui.Begin('#empty_field1', srp_ini.bools['Ник'], 1 + 32 + 2 + SetModeCond + 64)
			imgui.PushFont(imfonts.ovFont)
			imgui.TextColoredRGB('{' .. clist .. '}' .. name .. '')
			imgui.SameLine()
			imgui.TextColoredRGB('{' .. clist .. '}[' .. tostring(id) .. ']')
			imgui.PopFont()
			soverlay['Ник'] = imgui.GetWindowPos()
			imgui.End()
		end
	end
	
	if srp_ini.bools['Пинг'] then -- пинг на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['ПингX'], srp_ini.overlay['ПингY'])) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['ПингX'], srp_ini.overlay['ПингY']))	end	end
		imgui.Begin('#empty_field2', srp_ini.bools['Пинг'], 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont2)
		local ping = sampGetPlayerPing(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		if ping ~= nil then imgui.TextColoredRGB((ping > 80 and "{FF0000}" or "{00FF00}") .. u8:decode"Пинг: " .. ping) end
		imgui.PopFont()
		soverlay['Пинг'] = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools['Нарко'] then -- КД нарко на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['НаркоX'], srp_ini.overlay['НаркоY'])) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['НаркоX'], srp_ini.overlay['НаркоY']))	end	end
		imgui.Begin('#empty_field3', srp_ini.bools['Нарко'], 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont2)
		if (os.time() - srp_ini.values['Нарко']) < drugtimer then
			sec = drugtimer - (os.time() - srp_ini.values['Нарко'])
			local mins = math.floor(sec / 60)
			if math.fmod(sec, 60) >= 10 then secs = math.fmod(sec, 60) end
			if math.fmod(sec, 60) < 10 then secs = "0" .. math.fmod(sec, 60) .. "" end
			imgui.TextColoredRGB("{00FF00}" .. mins .. ":" .. secs .. "")
			else
			imgui.TextColoredRGB("{00FF00}" .. u8:decode"Юзай!")
		end
		imgui.PopFont()
		soverlay['Нарко'] = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools['Таймер до МП'] then -- таймеры до начала системных МП
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['Таймер до МПX'], srp_ini.overlay['Таймер до МПY'])) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['Таймер до МПX'], srp_ini.overlay['Таймер до МПY']))	end	end
		imgui.Begin('#empty_field4', srp_ini.bools['Таймер до МП'], 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont1)
		if SetMode then imgui.TextColoredRGB("{00FF00}" .. u8:decode"Здесь находятся таймеры МП") end
		for k, v in pairs(srp_ini.ivent) do
			if v ~= false and tonumber(v) ~= nil then
				local sec = tonumber(v) - os.time()
				local mins = math.floor(sec / 60)
				if math.fmod(sec, 60) >= 10 then secs = math.fmod(sec, 60) end
				if math.fmod(sec, 60) < 10 then secs = "0" .. math.fmod(sec, 60) .. "" end
				if sec > 0 then
					imgui.TextColoredRGB((sec > 60 and '{00FF00}' or "{FCF803}") .. u8:decode(k) .. u8:decode' через: ' .. mins .. ":" .. secs .. "")
					else
					if sec > -30 then
						imgui.TextColoredRGB("{FF0000}" .. u8:decode(k) .. u8:decode' начнётся СЕЙЧАС')
					end
				end
			end
		end
		imgui.PopFont()
		soverlay['Таймер до МП'] = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools['Прорисовка'] then -- количество игроков в зоне прорисовки на экране 
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['ПрорисовкаX'], srp_ini.overlay['ПрорисовкаY'])) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['ПрорисовкаX'], srp_ini.overlay['ПрорисовкаY']))	end	end
		imgui.Begin('#empty_field5', srp_ini.bools['Прорисовка'], 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont1)
		imgui.TextColoredRGB(u8:decode'Количество персонажей в прорисовке: ' .. (sampGetPlayerCount(true) - 1) .. '')
		imgui.PopFont()
		soverlay['Прорисовка'] = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools['Статус'] then -- статус контекстной клавиши на экране 
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['СтатусX'], srp_ini.overlay['СтатусY'])) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['СтатусX'], srp_ini.overlay['СтатусY']))	end	end
		imgui.Begin('#empty_field6', srp_ini.bools['Статус'], 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont1)
		local CStatus = CTaskArr["CurrentID"] == 0 and "{FFFAFA}" .. u8:decode"Ожидание события" or "" .. u8:decode(CTaskArr["n"][CTaskArr[1][CTaskArr["CurrentID"]]]) .. " " .. u8:decode((indexof(CTaskArr[1][CTaskArr["CurrentID"]], CTaskArr["nn"]) ~= false and CTaskArr[3][CTaskArr["CurrentID"]] or "")) .. ""
		imgui.TextColoredRGB(u8:decode'Статус контекстной клавиши: ' .. CStatus .. '')
		imgui.PopFont()
		soverlay['Статус'] = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools['Сквад'] and ((not sampIsChatInputActive() and not isSampfuncsConsoleActive() and rCache.enable) or SetMode) then -- улучшенный сквад на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['СквадX'], srp_ini.overlay['СквадY'])) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay['СквадX'], srp_ini.overlay['СквадY']))	end	end
		imgui.Begin('#empty_field7', srp_ini.bools['Сквад'], 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFontSquad)
		local count = 0
		for k in pairs(smem) do count = count + 1 end				
		imgui.TextColoredRGB("{B30000}" .. u8:decode"Состав отряда - " .. count .. ":")
		soverlay['Сквад'] = imgui.GetWindowPos()
		local x = SetMode and soverlay['Сквад'].x + 5 or srp_ini.overlay['СквадX'] + 5
		local y = SetMode and soverlay['Сквад'].y or srp_ini.overlay['СквадY']
		for k, v in ipairs(smem) do
			y = y + 25
			renderFontDrawText(imfonts.ovFontSquadRender, v.name .. " [" .. v.id .. "]", x, y, sampGetCharHandleBySampPlayerId(v.id) and v.color or v.colorns)
			renderDrawLine(x + 2, y + 22, x + (sampGetPlayerHealth(v.id) > 100 and 144 or 90), y + 22, 5.0, 0xFF808080)
			renderDrawLine(x + 2 + (sampGetPlayerHealth(v.id) > 100 and 160 or 100) - (sampGetPlayerHealth(v.id) > 100 and 6 or 0), y + 22, x + (sampGetPlayerHealth(v.id) > 100 and 160 or 100) + 90, y + 22, 5.0, 0xFF808080)
			if v.id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
				local myHP = getCharHealth(PLAYER_PED)
				local myARM = getCharArmour(PLAYER_PED)
				if myHP ~= 0 then renderDrawLine(x + 2, y + 22, x + ((sampGetPlayerHealth(v.id) > 100 and 144/160 or 90/100) * myHP), y + 22, 5.0, 0xFF800000) end
				if myARM ~= 0 then renderDrawLine(x + 2 + (sampGetPlayerHealth(v.id) > 100 and 160 or 100) - (sampGetPlayerHealth(v.id) > 100 and 6 or 0), y + 22, x + (sampGetPlayerHealth(v.id) > 100 and 160 or 100) + ((sampGetPlayerHealth(v.id) > 100 and 144/160 or 90/100) * myARM), y + 22, 5.0, 0xFFC0C0C0) end
				else
				local HP
				local ARM
				if sampGetCharHandleBySampPlayerId(v.id) then
					ARM = sampGetPlayerArmor(v.id)
					HP = sampGetPlayerHealth(v.id)
					else
					ARM = 0
					HP = 0
				end
				if HP ~= 0 then renderDrawLine(x + 2, y + 22, x + ((sampGetPlayerHealth(v.id) > 100 and 144/160 or 90/100) * HP), y + 22, 5.0, 0xFF800000) end
				if ARM ~= 0 then renderDrawLine(x + 2 + (sampGetPlayerHealth(v.id) > 100 and 160 or 100) - (sampGetPlayerHealth(v.id) > 100 and 6 or 0), y + 22, x + (sampGetPlayerHealth(v.id) > 100 and 160 or 100) + ((sampGetPlayerHealth(v.id) > 100 and 144/160 or 90/100) * ARM), y + 22, 5.0, 0xFFC0C0C0) end
			end
		end
		imgui.PopFont()
		imgui.End()
	end
	
	SetModeFirstShow = false
end
-------------------------------------------------------------------------[ФУНКЦИИ]-----------------------------------------------------------------------------------------
function ev.onServerMessage(col, text)
	if col == strings.color.mechanic then
		if srp_ini.bools['Починка у механика'] then -- починка у механика
			if text:match(strings.acceptrepair) then sampSendChat("/ac repair") return end
		end
		if srp_ini.bools['Заправка у механика'] then -- заправка у механика
			local cost = tonumber(text:match(strings.acceptrefill))
			if cost ~= nil then
				local ncost = tonumber(srp_ini.values['Заправка у механика'])
				if ncost ~= nil and cost <= ncost then sampSendChat("/ac refill") return end
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
	if col == strings.color.boost then if text:match(strings.boost) and isBoost then return false end end
	if col == strings.color.noboost then if text:match(strings.noboost) and isBoost then isBoost = false return false end end
	if col == strings.color.narko then
		if srp_ini.bools['Нарко'] then -- КД нарко
			if text:match(strings.narko) then
				srp_ini.values['Нарко'] = os.time() 
				inicfg.save(config, "SRPfunctions.ini")
			end
		end
	end
	local paint = tonumber(text:match(strings.painttime))
	local squid = tonumber(text:match(strings.squidtime))
	local derby = tonumber(text:match(strings.derbytime))
	local race = tonumber(text:match(strings.racetime))
	if text:match(strings.paintfalse1) then paint = false end
	if text:match(strings.paintfalse2) then paint = false end
	if text:match(strings.squidfalse1) then squid = false end
	if text:match(strings.squidfalse2) then squid = false end
	if text:match(strings.squidfalse3) then squid = false end
	if text:match(strings.derbyfalse1) then derby = false end
	if text:match(strings.derbyfalse2) then derby = false end
	if text:match(strings.derbyfalse3) then derby = false end
	if text:match(strings.racefalse1)  then race  = false end
	if text:match(strings.racefalse2)  then race  = false end
	if text:match(strings.racefalse3)  then race  = false end
	
	if paint ~= nil and (col == strings.color.paint or paint == false) then
		if tonumber(paint) ~= nil then paint = os.time() + paint * 60 end
		srp_ini.ivent['Пейнтбол'] = paint
		inicfg.save(config, "SRPfunctions.ini")
	end
	if squid ~= nil and (col == strings.color.squid or paint == false) then
		if tonumber(squid) ~= nil then squid = os.time() + squid * 60 end
		srp_ini.ivent['Игра Кальмара'] = squid
		inicfg.save(config, "SRPfunctions.ini")
	end
	if race ~= nil and (col == strings.color.race or paint == false) then
		if tonumber(race) ~= nil then
			if race == 5 then race = 7 end
			race = os.time() + race * 60 
		end
		srp_ini.ivent['Гонка ЛС'] = race
		inicfg.save(config, "SRPfunctions.ini")
	end
	if derby ~= nil and (col == strings.color.derby or derby == false) then 
		if tonumber(derby) ~= nil then derby = os.time() + derby * 60 end
		srp_ini.ivent['Дерби СФ'] = derby
		inicfg.save(config, "SRPfunctions.ini")
	end
	if (text:match(strings.repair1) or text:match(strings.repair2) ~= nil or text:match(strings.repair3) ~= nil or text:match(strings.repair4) ~= nil) and CTaskArr[10][1] then CTaskArr[10][1] = false end
end

function ev.onShowDialog(dialogid, style, title, button1, button2, text)
	if dialogid == strings.dialog.narko.id and style == strings.dialog.narko.style and title == strings.dialog.narko.title then
		for v in text:gmatch("[^\n]+") do
			if v:match(strings.dialog.narko.str) then
				local faktor = tonumber(v:match(strings.dialog.narko.str))
				drugtimer = drugtimer * faktor
				checkedBoost = true
			end
		end
		if isBoost then chatmsg(1) sampCloseCurrentDialogWithButton(0) isBoost = false return false end
	end
end

function ev.onDisplayGameText(style, time, str)
	if srp_ini.bools['Заправка канистрой'] and str == "~r~Fuel has ended" and style == 4 and time == 3000 then -- заправка канистрой
		sampSendChat("/fillcar")
	end
end

function ev.onCreate3DText(id, color, position, distanse, testLOS , attachedPlayerId, attachedVehicleId, text)
	lua_thread.create(function() 
		local cen = tonumber(text:match(strings.gasstation))
		if cen ~= nil then
			local ncost = tonumber(srp_ini.values['Заправка на АЗС'])
			if ncost ~= nil and cen <= ncost then
				if srp_ini.bools['Покупка канистры'] then sampSendChat("/get fuel") end
				if srp_ini.bools['Заправка на АЗС'] then if isCharInAnyCar(PLAYER_PED) and getDriverOfCar(storeCarCharIsInNoSave(PLAYER_PED)) == PLAYER_PED then wait(1300) sampSendChat("/fill") end end
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

function ev.onSendTakeDamage(playerId)
	if playerId ~= 65535 then
		killerid = tonumber(playerId)
	end
end

function ev.onSendDeathNotification(reason, id)
	if tonumber(killerid) ~= nil then
		table.insert(CTaskArr[1], 2)
		table.insert(CTaskArr[2], os.time())
		table.insert(CTaskArr[3], killerid)
	end
end

function ev.onSendPickedUpPickup(id)
	local x, y, z = getPickupCoordinates(sampGetPickupHandleBySampId(id))
	local pick = CTaskArr[10][2][x + y + z]
	if pick ~= nil then
		if pick ~= 0 then
			table.insert(CTaskArr[1], 3)
			table.insert(CTaskArr[2], os.time())
			table.insert(CTaskArr[3], pick)
			else
			local key = indexof(3, CTaskArr[1])
			if key ~= false then CTaskArr[2][key] = os.time() - 100 end
		end
	end
end

function ev.onSetPlayerColor(id, color)
	if rCache.enable and saveid[id] then
		local r, g, b, a = explode_argb(color)
		smem[saveid[id]].color = join_argb(230.0, r, g, b)
		smem[saveid[id]].colorns = join_argb(150.0, r, g, b)
	end
end

function ev.onShowTextDraw(id, data)
	if data.text:find("SQUAD") then
		rCache.pos.x, rCache.pos.y = convertGameScreenCoordsToWindowScreenCoords(data.position.x + 1, data.position.y + 25)
		rCache.enable = true
		td = id
		smem = {}
		saveid = {}
		local list = data.text:split("~n~")
		table.remove(list, 1)
		for k, v in ipairs(list) do
			local id = sampGetPlayerIdByNickname(v)
			if id then
				local color = sampGetPlayerColor(id)
				local a, r, g, b = explode_argb(color)
				table.insert(smem, {
					id = id,
					name = v,
					color = join_argb(230.0, r, g, b),
					colorns = join_argb(150.0, r, g, b),
				})
				saveid[id] = #smem
			end
		end
		data.position.x = 1488
		data.position.y = 1488
		return {id, data}
	end
end

function ev.onTextDrawSetString(id, str)
	if td == nil then
		if str:find("SQUAD") then
			local x, y = sampTextdrawGetPos(id)
			rCache.pos.x, rCache.pos.y = convertGameScreenCoordsToWindowScreenCoords(x + 1, y + 25)
			rCache.enable = true
			td = id
			if sampTextdrawIsExists(id) then
				sampTextdrawSetPos(id, 1488, 1488)
			end
		end
	end
	if id == td and str then
		smem = {}
		saveid = {}
		local list = str:split("~n~")
		table.remove(list, 1)
		for k, v in ipairs(list) do
			local id = sampGetPlayerIdByNickname(v)
			if id then
				local color = sampGetPlayerColor(id)
				local a, r, g, b = explode_argb(color)
				table.insert(smem, {
					id = id,
					name = v,
					color = join_argb(230.0, r, g, b),
					colorns = join_argb(150.0, r, g, b),
				})
				saveid[id] = #smem
			end
		end
	end
end

function ev.onTextDrawHide(id)
	if id == td then
		rCache.enable = false
		smem = {}
		saveid = {}
	end
end

function sampGetPlayerIdByNickname(name)
	local name = tostring(name)
	local _, localId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	for i = 0, 1000 do
		if (sampIsPlayerConnected(i) or localId == i) and sampGetPlayerNickname(i) == name then
			return i
		end
	end
end

function join_argb(a, r, g, b)
	local argb = b  -- b
	argb = bit.bor(argb, bit.lshift(g, 8))  -- g
	argb = bit.bor(argb, bit.lshift(r, 16)) -- r
	argb = bit.bor(argb, bit.lshift(a, 24)) -- a
	return argb
end

function explode_argb(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
end

function CTask() -- ### КОНТЕКСТНАЯ КЛАВИША
	while true do
		wait(0)					
		----------- id 1
		if isCharOnFoot(PLAYER_PED) then
			local car = storeClosestEntities(PLAYER_PED)
			if car ~= -1 and not CTaskArr[10][1] then
				local myX, myY, myZ = getCharCoordinates(PLAYER_PED) -- получаем свои координаты
				local cX, cY, cZ = getCarCoordinates(car) -- получаем координаты машины
				local distanse = math.ceil(math.sqrt( ((myX-cX)^2) + ((myY-cY)^2) + ((myZ-cZ)^2))) 
				if (getCarHealth(car) == 300 or (isCarTireBurst(car, 0) or isCarTireBurst(car, 1) or isCarTireBurst(car, 2) or isCarTireBurst(car, 3) or isCarTireBurst(car, 4))) and distanse <= 5 then
					table.insert(CTaskArr[1], 1)
					table.insert(CTaskArr[2], os.time())
					table.insert(CTaskArr[3], "")
					CTaskArr[10][1] = true
				end
			end
		end
		
		if CTaskArr[10][1] then -- если отошел от машины то время начала задания смещается на 100 сек. назад для удаления функцией сортировки
			local bool = false
			local car = storeClosestEntities(PLAYER_PED)
			if car == -1 then 
				bool = true
				else
				local myX, myY, myZ = getCharCoordinates(PLAYER_PED) -- получаем свои координаты
				local cX, cY, cZ = getCarCoordinates(car) -- получаем координаты машины
				local distanse = math.ceil(math.sqrt( ((myX-cX)^2) + ((myY-cY)^2) + ((myZ-cZ)^2)))
				if (getCarHealth(car) > 300 and not isCarTireBurst(car, 0) and not isCarTireBurst(car, 1) and not isCarTireBurst(car, 2) and not isCarTireBurst(car, 3) and not isCarTireBurst(car, 4)) or distanse > 5 then
					local key = indexof(1, CTaskArr[1])
					if key ~= false then CTaskArr[2][key] = os.time() - 100 end
				end
			end
		end
		sortCarr() --### Очистка массива контекстной клавиши, назначение нового контекстного действия
	end
end

function ct()
	lua_thread.create(function()
		local key = CTaskArr["CurrentID"]
		if key == 0 then chatmsg(u8:decode"Событие не найдено") return end
		if isKeyDown(makeHotKey("Контекстная клавиша")[1]) then
			wait(300)
			if isKeyDown(makeHotKey("Контекстная клавиша")[1]) then goto done end
		end
		
		if CTaskArr[1][key] == 1 then sampSendChat("/repairkit") end
		if CTaskArr[1][key] == 2 then
			local nick = sampGetPlayerNickname(CTaskArr[3][key]):gsub("_", " ")
			if nick ~= nil then
				sampSendChat("/rep " .. CTaskArr[3][key] .. u8:decode" ДМщик, следите за ним")
			end
		end
		if CTaskArr[1][key] == 3 then 
			medcall(CTaskArr[3][key])
		end
		
		::done::
		table.remove(CTaskArr[1], key)
		table.remove(CTaskArr[2], key)
		table.remove(CTaskArr[3], key)
		CTaskArr["CurrentID"] = 0
	end)
end

function setclist()
	lua_thread.create(function()
		local res, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if not res then chatmsg(u8:decode"Не удалось узнать свой ID") return end
		local myclist = clists.numbers[sampGetPlayerColor(myid)]
		if myclist == nil then chatmsg(u8:decode"Не удалось узнать номер своего цвета") return end
		if myclist == 0 then
			if srp_ini.values.clist == 0 then chatmsg(u8:decode"На вас уже нету клиста!") return end
			sampSendChat("/clist " .. srp_ini.values.clist .. "")
			wait(1300)
			local newmyclist = clists.numbers[sampGetPlayerColor(myid)]
			if newmyclist == nil then chatmsg(u8:decode"Не удалось узнать номер своего цвета") return end
			if newmyclist ~= tonumber(srp_ini.values.clist) then chatmsg(u8:decode"Клист не был надет") return end
			else
			sampSendChat("/clist 0")
			wait(1300)
			local newmyclist = clists.numbers[sampGetPlayerColor(myid)]
			if newmyclist == nil then chatmsg(u8:decode"Не удалось узнать номер своего цвета", 0xFFFF0000) return end
			if newmyclist ~= 0 then chatmsg(u8:decode"Клист не был снят", 0xFFFF0000) return end
		end
	end)
end

function sortCarr()
	local arr = {}
	for k, v in ipairs(CTaskArr[2]) do
		wait(0)
		if (os.time() - v >= 20) then
			if CTaskArr["CurrentID"] == k then CTaskArr["CurrentID"] = 0 end
			if CTaskArr[1][k] == 1 then CTaskArr[10][1] = false end
			table.insert(arr, k)	
		end
	end
	
	for k, v in ipairs(arr) do -- удаление устаревшиХ ID
		wait(0)
		table.remove(CTaskArr[1], v)
		table.remove(CTaskArr[2], v)
		table.remove(CTaskArr[3], v)
		if CTaskArr["CurrentID"] >= v then CTaskArr["CurrentID"] = CTaskArr["CurrentID"] - 1 end
	end
	
	-- выбор нового CurrentID
	if CTaskArr["CurrentID"] == 0 then
		local lastrarr = {}
		for k, v in ipairs(CTaskArr[1]) do 
			wait(0) 
			if v == 1 then CTaskArr["CurrentID"] = k break end
			if v == 2 and lastrarr[2] == nil then lastrarr[2] = k end
			if v == 3 and lastrarr[3] == nil then lastrarr[3] = k end
			if v == 4 and lastrarr[4] == nil then lastrarr[4] = k end
			if v == 5 and lastrarr[5] == nil then lastrarr[5] = k end
			if v == 6 and lastrarr[6] == nil then lastrarr[6] = k end
			if v == 7 and lastrarr[7] == nil then lastrarr[7] = k end
			if v == 8 and lastrarr[8] == nil then lastrarr[8] = k end
			if v == 9 and lastrarr[9] == nil then lastrarr[9] = k end
			if v == 10 and lastrarr[10] == nil then lastrarr[10] = k end
			if v == 11 and lastrarr[11] == nil then lastrarr[11] = k end
			if v == 12 and lastrarr[12] == nil then lastrarr[12] = k end
		end
		
		if CTaskArr["CurrentID"] == 0 then for k, v in pairs(lastrarr) do wait(0) CTaskArr["CurrentID"] = v break end end	
	end
	
	if CTaskArr["CurrentID"] < 0 or CTaskArr[1][CTaskArr["CurrentID"]] == nil then CTaskArr["CurrentID"] = 0 end
end

function cmd_setoverlay()
	if not SetMode then
		sampSendChat("/mm")
		chatmsg(u8:decode"Начата настройка местоположения элементов overlay")
		chatmsg(u8:decode"Перетащите элементы в нужное место и пропишите /setov - произойдет сохранение координат")
		chatmsg(u8:decode"Для сброса всех координат зажмите среднюю кнопку мыши")
		srp_ini.bools['Дата и время']      = true
		srp_ini.bools['Ник']           	   = true
		srp_ini.bools['Пинг']              = true
		srp_ini.bools['Нарко']             = true
		srp_ini.bools['Таймер до МП']      = true
		srp_ini.bools['Прорисовка']        = true
		srp_ini.bools['Статус']            = true
		srp_ini.bools['Сквад']             = true
		SetMode, SetModeFirstShow          = true, true
		imgui.ShowCursor, imgui.LockPlayer = true, true
		
		else
		
		srp_ini.overlay['Дата и времяX'],   srp_ini.overlay['Дата и времяY']   = soverlay['Дата и время'].x,   soverlay['Дата и время'].y
		srp_ini.overlay['НикX'],            srp_ini.overlay['НикY']            = soverlay['Ник'].x,            soverlay['Ник'].y
		srp_ini.overlay['ПингX'],           srp_ini.overlay['ПингY']           = soverlay['Пинг'].x,           soverlay['Пинг'].y                     
		srp_ini.overlay['НаркоX'],          srp_ini.overlay['НаркоY']          = soverlay['Нарко'].x, soverlay['Нарко'].y        
		srp_ini.overlay['Таймер до МПX'],   srp_ini.overlay['Таймер до МПY']   = soverlay['Таймер до МП'].x,   soverlay['Таймер до МП'].y     
		srp_ini.overlay['ПрорисовкаX'],     srp_ini.overlay['ПрорисовкаY']     = soverlay['Прорисовка'].x,     soverlay['Прорисовка'].y   
		srp_ini.overlay['СтатусX'],         srp_ini.overlay['СтатусY']         = soverlay['Статус'].x,         soverlay['Статус'].y 
		srp_ini.overlay['СквадX'],          srp_ini.overlay['СквадY']          = soverlay['Сквад'].x,          soverlay['Сквад'].y
		inicfg.save(config, "SRPfunctions.ini")
		
		chatmsg(u8:decode"Местоположения всех элементов успешно задано")
		srp_ini.bools['Дата и время']   = togglebools['Дата и время'].v   and true or false
		srp_ini.bools['Ник']           	= togglebools['Ник'].v			  and true or false
		srp_ini.bools['Пинг']           = togglebools['Пинг'].v			  and true or false
		srp_ini.bools['Нарко']          = togglebools['Нарко'].v          and true or false
		srp_ini.bools['Таймер до МП']   = togglebools['Таймер до МП'].v   and true or false
		srp_ini.bools['Прорисовка']     = togglebools['Прорисовка'].v     and true or false
		srp_ini.bools['Статус']         = togglebools['Статус'].v         and true or false
		srp_ini.bools['Сквад']          = togglebools['Сквад'].v          and true or false
		SetMode, SetModeFirstShow, imgui.ShowCursor, imgui.LockPlayer = false, false, false, false
	end
end

function medcall(hospital)
	lua_thread.create(function()
		wait(1300)
		sampSendChat("/dir")
		while not sampIsDialogActive() do wait(0) end
		sampSendDialogResponse(sampGetCurrentDialogId(), 1, 2)
		while sampGetDialogCaption() ~= u8:decode"Организации" do wait(0) end
		wait(100)
		sampCloseCurrentDialogWithButton(1)
		while sampGetDialogCaption() ~= u8:decode"Меню" do wait(0) end
		local med = sampGetDialogText()
		sampCloseCurrentDialogWithButton(0) wait(100) sampCloseCurrentDialogWithButton(0) wait(100) sampCloseCurrentDialogWithButton(0)
		for v in med:gmatch('[^\n]+') do
			local n, fname, sname, id, numb, afk = v:match("%[(%d+)%] (%a+)_(%a+)%[(%d+)%]	(%d+)(.*)")
			if n ~= nil then
				sampSendChat("/t " .. id .. u8:decode" Нужен медик в " .. hospital .. "")
				wait(1300)
			end
		end
	end)
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
	while (os.clock() * 1000) - antiflood < 1300 do wait(0) end sampSendChat(t)
	sampSendChat(t)
end

function chatmsg(t)
	sampAddChatMessage(prefix .. t, main_color)
end

function indexof(var, arr)
	for k, v in ipairs(arr) do if v == var then return k end end return false
end

function string.split(str, delim, plain) -- bh FYP
	local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
	repeat
		local npos, epos = string.find(str, delim, pos, plain)
		table.insert(tokens, string.sub(str, pos, npos and npos - 1))
		pos = epos and epos + 1
	until not pos
	return tokens
end

function makeHotKey(numkey)
	local rett = {}
	for _, v in ipairs(string.split(srp_ini.hotkey[numkey], ", ")) do
		if tonumber(v) ~= 0 then table.insert(rett, tonumber(v)) end
	end
	return rett
end

function imgui.Hotkey(name, numkey, width)
	imgui.BeginChild(name, imgui.ImVec2(width, 32), true)
	imgui.PushItemWidth(width)
	
	local hstr = ""
	for _, v in ipairs(string.split(srp_ini.hotkey[numkey], ", ")) do
		if v ~= "0" then
			hstr = hstr == "" and tostring(vkeys.id_to_name(tonumber(v))) or "" .. hstr .. " + " .. tostring(vkeys.id_to_name(tonumber(v))) .. ""
		end
	end
	hstr = (hstr == "" or hstr == "nil") and "Нет" or hstr
	
	imgui.Text(hstr)
	imgui.PopItemWidth()
	imgui.EndChild()
	if imgui.IsItemClicked() then
		lua_thread.create(
			function()
				local curkeys = ""
				local tbool = false
				while true do
					wait(0)
					if not tbool then
						for k, v in pairs(vkeys) do
							sv = tostring(v)
							if isKeyDown(v) and (v == vkeys.VK_MENU or v == vkeys.VK_CONTROL or v == vkeys.VK_SHIFT or v == vkeys.VK_LMENU or v == vkeys.VK_RMENU or v == vkeys.VK_RCONTROL or v == vkeys.VK_LCONTROL or v == vkeys.VK_LSHIFT or v == vkeys.VK_RSHIFT) then
								if v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT then
									if not curkeys:find(sv) then
										curkeys = tostring(curkeys):len() == 0 and sv or curkeys .. " " .. sv
									end
								end
							end
						end
						
						for k, v in pairs(vkeys) do
							sv = tostring(v)
							if isKeyDown(v) and (v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT and v ~= vkeys.VK_LMENU and v ~= vkeys.VK_RMENU and v ~= vkeys.VK_RCONTROL and v ~= vkeys.VK_LCONTROL and v ~= vkeys.VK_LSHIFT and v ~=vkeys. VK_RSHIFT) then
								if not curkeys:find(sv) then
									curkeys = tostring(curkeys):len() == 0 and sv or curkeys .. " " .. sv
									tbool = true
								end
							end
						end
						else
						tbool2 = false
						for k, v in pairs(vkeys) do
							sv = tostring(v)
							if isKeyDown(v) and (v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT and v ~= vkeys.VK_LMENU and v ~= vkeys.VK_RMENU and v ~= vkeys.VK_RCONTROL and v ~= vkeys.VK_LCONTROL and v ~= vkeys.VK_LSHIFT and v ~=vkeys. VK_RSHIFT) then
								tbool2 = true
								if not curkeys:find(sv) then
									curkeys = tostring(curkeys):len() == 0 and sv or curkeys .. " " .. sv
								end
							end
						end
						
						if not tbool2 then break end
					end
				end
				
				local keys = ""
				if tonumber(curkeys) == vkeys.VK_BACK then
					srp_ini.hotkey[numkey] = "0"
					else
					local tNames = string.split(curkeys, " ")
					for _, v in ipairs(tNames) do
						local val = (tonumber(v) == 162 or tonumber(v) == 163) and 17 or (tonumber(v) == 160 or tonumber(v) == 161) and 16 or (tonumber(v) == 164 or tonumber(v) == 165) and 18 or tonumber(v)
						keys = keys == "" and val or "" .. keys .. ", " .. val .. ""
					end
				end
				
				srp_ini.hotkey[numkey] = keys
				inicfg.save(config, "SRPfunctions.ini")
			end
		)
	end
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
					script.v.num = info.version_num
					script.v.date = info.version_date
					script.url = info.version_url
					script.upd.changes = info.version_upd
					if script.upd.changes then
						for k in pairs(script.upd.changes) do
							table.insert(script.upd.sort, k)
						end
						table.sort(script.upd.sort, function(a, b) return a > b end)
					end
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
		if not script.reload then
			if not script.update then 
				chatmsg(u8:decode"Скрипт крашнулся: откройте консоль sampfuncs (кнопка ~), скопируйте текст ошибки и отправьте разработчику") 
				else
				chatmsg(updatingprefix .. u8:decode"Старый скрипт был выгружен, загружаю обновлённую версию...") 
			end
		end
	end
end																																