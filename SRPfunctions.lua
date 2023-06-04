script_name('SRPfunctions')
script_author("Cody_Webb")
script_version("04.06.2023")
script_version_number(28)
local script = {
	telegram = {
		nick = "@ibm287",
		url = "https://t.me/ibm287"
	},
	checked = false, 
	available = false, 
	update = false, 
	v = {date, num}, 
	url, 
	reload,
	loaded, 
	unload, 
	quest = {}, 
	upd = {
		changes = {}, 
		sort = {}
	}, 
	label = {}
}
-------------------------------------------------------------------------[Библиотеки/Зависимости]---------------------------------------------------------------------
local ev = require 'samp.events'
local imgui = require 'imgui'
imgui.ToggleButton = require('imgui_addons').ToggleButton
local vkeys = require 'vkeys'
local rkeys = require 'rkeys'
local inicfg = require 'inicfg'
local ffi = require 'ffi'
local dlstatus = require "moonloader".download_status
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
-------------------------------------------------------------------------[Конфиг скрипта]-----------------------------------------------------------------------------
local AdressConfig, AdressFolder, settings, srp_ini, binds, binder_ini, server

local config = {
	bools = {
		autorepair = false,
		autorefill = false,
		autofill = false,
		autocanister = false,
		autorefillcanister = false,
		jfcoloring = false,
		fcoloring = false,
		quit = false,
		psychoheal = false,
		autologin = false,
		autorent = false,
		robbing = false,
		lomka = false,
		withoutcops = false,
		date = false,
		nick = false,
		ping = false,
		drugs = false,
		event = false,
		stream = false,
		status = false,
		squad = false,
		hpcars = false,
		chatinfo = false,
		equest = false,
		inventory = false,
		kd = false,
		variables = false,
		spam = false,
		house = false,
		repairkits = false
	},
	hotkey = {
		contextkey = "0",
		drugs = "0",
		changeclist = "0",
		enterhouse	= "0",
		lock = "0",
		autowalk	= "0",
		fastmenu = "0",
		eject = "0"
	},
	overlay = {
		dateX = 846,
		dateY = 215,
		nickX = 823,
		nickY = 249,
		pingX = 892,
		pingY = 312,
		narkoX = 901,
		narkoY = 284,
		eventX = 803,
		eventY = 647,
		streamX = 786,
		streamY = 340,
		statusX = 775,
		statusY = 366,
		squadX = 515,
		squadY = 338,
		deilyX = 803,
		deilyY = 407,
		inventoryX = 789,
		inventoryY = 755,
		robbingX = 799,
		robbingY = 544,
	},
	values = {
		autorefill = 1500,
		autofill = 5000,
		drugs = 0,
		clist = 0,
		password = '', -- ДЛЯ АВТОЛОГИНА, ЭТО НЕ СТИЛЛЕР БЛЕАТЬ!!!
		autorent = 5000,
		timezonedifference = 0,
        robbing = 0,
		cartheft = 0,
		house = 0,
		repairkits = 2500
	},
	ivent = {
		race = false,
		derby = false,
		squid = false,
		paintball = false
	},
	quest = {
		updating = 0
	},
	description = {},
	task = {},
	inventory = {
		narko = false,
		mats = false,
		directory = false,
		mp3 = false,
		keys = false,
		canister = false,
		drivelicense = false,
		helilicense = false,
		planelicense = false,
		boatlicense = false,
		fishlicense = false,
		weaponlicense = false,
		fish = false,
		cookedfish = false,
		mushrooms = false,
		repairkit = false,
		psychoheal = false,
		cookedmushroom = false,
		cigarette = false,
		adrenaline = false,
		cork = false,
		balaclava = false,
		scrap = false,
		energy = false,
		robkit = false
	},
	inventory = {}
}
local bindertable = {
	list = {}
}
-------------------------------------------------------------------------[Переменные и маcсивы]-----------------------------------------------------------------
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

local timezones = {
	"МСК-14", "МСК-13", "МСК-12", "МСК-11",
	"МСК-10", "МСК-9", "МСК-8", "МСК-7",
	"МСК-6", "МСК-5", "МСК-4", "МСК-3",
	"МСК-2", "МСК-1", "Московское время", "МСК+1",
	"МСК+2", "МСК+3", "МСК+4", "МСК+5",
	"МСК+6", "МСК+7", "МСК+8", "МСК+9"
}

local copskins = { -- модели скинов мусоров, на которые будет реагировать скрипт
	[76] = '',  [265] = '', [266] = '', [267] = '', 
	[280] = '', [281] = '', [282] = '', [283] = '', 
	[284] = '', [285] = '', [288] = '', [265] = '', 
	[300] = '', [301] = '', [302] = '', [303] = '', 
	[304] = '', [305] = '', [306] = '', [307] = '', 
	[308] = '', [309] = '', [310] = '', [311] = ''
}

local main_color = 0xB30000
local prefix = "{B30000}[SRP] {FFFAFA}"
local updatingprefix = "{FF0000}[ОБНОВЛЕНИЕ] {FFFAFA}"
local antiflood = 0

local menu = { -- imgui-меню
	main = imgui.ImBool(false), 
	automatic = imgui.ImBool(true), 
	commands = imgui.ImBool(false), 
	binds = imgui.ImBool(false), 
	overlay = imgui.ImBool(false), 
	password = imgui.ImBool(false), 
	inventory = imgui.ImBool(false), 
	binder = imgui.ImBool(false),
	information = imgui.ImBool(false),
	editor = imgui.ImBool(false),
	fastbinder = imgui.ImBool(false),
	variables = imgui.ImBool(false)
}
local overlay = {
	date = imgui.ImBool(true),
	nick = imgui.ImBool(true),
	drugs = imgui.ImBool(true),
	event = imgui.ImBool(true),
	stream = imgui.ImBool(true),
	status = imgui.ImBool(true),
	squad = imgui.ImBool(true),
	chatinfo = imgui.ImBool(true),
	equest = imgui.ImBool(true),
	inventory = imgui.ImBool(true),
    robbing = imgui.ImBool(true)
}
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
local isQuest = false
local checkedQuest = false
local noequest = false
local isInventory = false
local checkedInventory = false
local isFlood = false
local needtoreload = false
local isRobbing = false
local isLomka = false
local needtohold = false
local needtobuy = true
local rent
local killerid
local taxipassenger
local argument = {}
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
local currentNick
local currentBind
local currentClient
local gekauft = false
local keybbb = {KeyboardLayoutName = ffi.new("char[?]", 32), LocalInfo = ffi.new("char[?]", 32)}
ffi.cdef[[
	int SendMessageA(int, int, int, int);
	unsigned int GetModuleHandleA(const char* lpModuleName);
	short GetKeyState(int nVirtKey);
	bool GetKeyboardLayoutNameA(char* pwszKLID);
	int GetLocaleInfoA(int Locale, int LCType, char* lpLCData, int cchData);
]]
local sym = {["myid"] = -1, ["mynick"] = -1, [1] = 144 - 7, ["s"] = 132 - 15, ["w"] = 134 - 20, ["me"] = 116 - 2, ["do"] = 136 - 10, ["try"] = 116 - 2, ["todo"] = 82 - 23, ["m"] = 114 - 21, ["r"] = 178 - 49, ["f"] = 178 - 49, ["fs"] = 121 - 18, ["u"] = 121 - 18, ["report"] = 218 - 29, ["b"] = 117 - 8, ["dep"] = 161 - 41}
local suspendkeys = 2 -- 0 хоткеи включены, 1 -- хоткеи выключены -- 2 хоткеи необходимо включить
local CTaskArr = {
	[1] = {}, -- ID событий
	-- 1 - /repairkit, 2 - репорт за ДМ, 3 - вызвать врачей в больницу по СМС, 4 - спросить куда едем у клиента такси, 5 - сказать что заказ принят, 6 - попрощаться с клиентом, 7 - садись в такси
	[2] = {}, -- время начала события
	[3] = {}, -- доп. информация для события
	["CurrentID"] = 0,
	["n"] = {
		[1] = "{FF0000}Рем. комплект",
		[2] = "{FF0000}Репорт на",
		[3] = "{00FF00}Вызвать врача в",
		[4] = "{00FF00}Куда едем?",
		[5] = "{00FF00}Хорошо, выезжаем",
		[6] = "{00FF00}Попрощаться с клиентом",
		[7] = "{00FF00}Садись"
	}, -- имена статусов в КК по ID события
	["nn"] = {2, 3, 7}, -- ID's которые требуют отображения доп информации (из массива №3) в статусе КК
	[10] = { -- прочие значения для работы КК (мусорка переменных)
		[1] = false, -- есть ли активное задание по id 1 на данный момент
		[2] = {
			[-1514.75 + 2518.875 + 56] = "El Quebrados Medical Center",
			[-318.75 + 1048.125 + 20.25] = "Fort Carson Medical Center",
			[1607.375 + 1815.125 + 10.75] = "Las Venturas Hospital",
			[1228.625 + 311.875 + 19.75] = "Crippen Memorial Hospital",
			[1241.375 + 325.875 + 19.75] = "Crippen Memorial Hospital",
			[2034.125 + -1401.625 + 17.25] = "County General Hospital",
			[1172 + -1323.375 + 15.375] = "All Saints General Hospital",
			[-2655.125 + 640.125 + 14.375] = "San Fierro Medical Center",
			[261.875 + 4 + 1500.875] = 0, -- exit
			[242.75 + 7 + 1500.875] = 0 -- exit2
		}, -- координаты меток входа/выхода у больниц
	}
}
local ImVec4 = imgui.ImVec4
local imfonts = {mainFont = nil, font = nil, ovFont = nil, ovFontSquad = nil, ovFontCars = nil, ovFontSquadRender = nil}

local strings = {
	acceptrepair = u8:decode"^ Механик .* хочет отремонтировать ваш автомобиль за %d+ вирт.*",
	acceptrefill = u8:decode"^ Механик .* хочет заправить ваш автомобиль за (%d+) вирт%{FFFFFF%} %(%( Нажмите Y%/N для принятия%/отмены %)%)",
	gasstation = u8:decode"Цена за 200л%: %$(%d+)",
	jfchat = u8:decode"^ (.*)%[(%d+)]%<(.*)%>%: (.*)",
	faction = u8:decode"^ (.*)  (.*)%[(%d+)%]%: (.*)",
	boost = u8:decode"^ Действует до%: %d+%/%d+%/%d+ %d+%:%d+%:%d+",
	noboost = u8:decode"^ Бонусы отключены",
	narko = u8:decode'^ %(%( Остаток%: (%d+) грамм %)%)',
	painttime = u8:decode"^ Внимание%! Начало пейнтбола через (%d) минуты?%. Место проведения%: военный завод K%.A%.C%.C%.",
	squidtime = u8:decode"^ Внимание%! Начало %'Игра в Кальмара%' через (%d) минуты?%! Место проведения%: Арена LS %(%( %/gps %[Важное%] %>%> %[Игра в Кальмара%] %)%)",
	derbytime = u8:decode"^ Внимание%! Начало гонок дерби через (%d) минуты?%. Стадион Сан Фиерро%. Регистрация на первом этаже",
	racetime = u8:decode"^ Внимание%! Начало гонок через (%d) минуты?%. Трасса%: Аэропорт Лос Сантос%. Регистрация у въезда",
	paintfalse1 = u8:decode"^ Внимание%! Пейнтбол начался",
	paintfalse2 = u8:decode"Внимание%! Пейнтбол был прерван из%-за отсутствия участников",
	squidfalse1 = u8:decode"^ Внимание%! %'Игра в Кальмара%' прервана из%-за недостаточного количества участников%!",
	squidfalse2 = u8:decode"^ Внимание%! %'Игра в Кальмара%' началась%!",
	squidfalse3 = u8:decode"^ Внимание%! %'Игра в Кальмара%' прервана из%-за проигрыша всех участников%! %(%( Список%: %/klmlist %)%)",
	derbyfalse1 = u8:decode"^ Внимание%! Гонки дерби начались%. Стадион Сан Фиерро",
	derbyfalse2 = u8:decode"^ Внимание%! Гонки дерби были прерваны из%-за отсутствия участников",
	derbyfalse3 = u8:decode"^ Внимание%! Гонки дерби окончены%. %(%( Список победителей%: %/derbylist %)%)",
	racefalse1 = u8:decode"^ Внимание%! Гонки были прерваны из%-за отсутствия участников",
	racefalse2 = u8:decode"^ Внимание%! Гонки начались%. Трасса%: Аэропорт Лос Сантос",
	racefalse3 = u8:decode"^ Внимание%! Гонки окончены%. %(%( Список победителей%: %/racelist %)%)",
	repair1 = u8:decode"^ Двигатель отремонтирован%. У вас осталось (%d+)%/%d+ комплектов %«автомеханик%»",
	repair2 = u8:decode"^ У вас нет комплекта %«автомеханик%» для ремонта",
	repair3 = u8:decode"^ В транспортном средстве нельзя",
	repair4 = u8:decode"^ Вы далеко от транспортного средства%. Подойдите к капоту",
	connected = u8:decode"^ Для восстановления доступа нажмите клавишу %'F6%' и введите %'%/restoreAccess%'",
	changequest = u8:decode"^ %[Quest%] %{FFFFFF%}Вы заменили задание %{6AB1FF%}(.*) %{FFFFFF%}на %{6AB1FF%}(.*)",
	donequest = u8:decode"^ %[Quest%] %{FFFFFF%}Выполнено задание %{6AB1FF%}\"(.*)\"",
	newpassenger = u8:decode"^ Пассажир (.*) сел в ваше Такси%. Довезите его и государство заплатит вам",
	outpassenger1 = u8:decode"^ Пассажир вышел из такси. Деньги будут зачислены во время зарплаты$",
	outpassenger2 = u8:decode"^ Пассажир вышел из такси. Использован купон на бесплатный проезд$",
	sms = u8:decode"^ SMS%: (.*)%. Отправитель%: (.*)%[(%d+)%]$",
	normalchat = u8:decode"^%- (.*)%[(%d+)%]%: (.*)",
	taxi = u8:decode"%<%< Бесплатное такси %>%>",
	rent = u8:decode"^ Вы арендовали транспортное средство$",
	minusbalaklava = u8:decode"^ Вы надели балаклаву$",
	minuslom = u8:decode"^ Отлично! Замок взломан, скорее выноси ценные вещи$",
	kanistra = u8:decode"^ Вы купили канистру с 50 литрами бензина за .* вирт",
	fillcar = u8:decode"^ Вы дозаправили свою машину на 50",
	outbagazhnik = u8:decode"^ Вы забрали из багажника%: %{FFFFFF%}%'(.*)%' %{C0C0C0%}в количестве%: %{FFFFFF%}(%d+)",
	inbagazhnik = u8:decode"^ Вы положили в багажник %{FFFFFF%}%'(.*)%' %{6AB1FF%}в количестве %d+ штук%, остаток (%d+) штук",
	shop24 = u8:decode"^ (.*) приобретена?%. Осталось%: (%d+)%/%d+",
	grib = u8:decode"^ Вы нашли гриб \".+\". Теперь у вас (%d+) грибов",
	fish = u8:decode"^ Сытость полностью восстановлена%. У вас осталось (%d+) %/ %d+ пачек рыбы$",
	cookfish = u8:decode"^ У вас (%d+) %/ %d+ пачек рыбы$",
	trash = u8:decode"^ (.*) выбросила? %'(.*)%'$",
	reward = u8:decode"^ %[Quest%] %{FFFFFF%}Ваша награда%: %{FF9DB6%}(.*)",
	disconnect = u8:decode"^ Вы отключились от сообщества$",
	cookgrib= u8:decode"^ Грибы готовы%. Грибы%: (%d+)%. Психохил%: (%d+)%/%d+%. Г%.Грибы%: (%d+)%/%d+$",
	adr = u8:decode"^ Вы приняли адреналин. Эффект продлится (%d+) минут$",
	gribeat = u8:decode"^ Сытость пополнена до %d+%. У вас осталось (%d+)%/%d+ готовых грибов$",
	psiho = u8:decode"^ Здоровье %d+%/%d+%. Сытость %d+%/%d+%. У вас осталось (%d+)%/%d+ психохила$",
	roul = u8:decode"^ Вы получили %{FFFFFF%}(.*)%{EAC700%}%. Количество%: %{FFFFFF%}%d+%{EAC700%}%. В инвентаре%: (%d+) %/ %d+$",
	stolen = u8:decode"^ Вы украли (.*), отнесите награбленное в фургон$",
	breaken = u8:decode"^ Отлично! Замок взломан, скорее выноси ценные вещи$",
	open = u8:decode"^ Дверь открыта без использования лома$",
	put = u8:decode"^ Вы положили награбленное в фургон. Загружено: (%d+)%/(%d+)$",
	rob = u8:decode"^ Emmet%: Купить лом и маску можешь в любом магазине 24%/7$",
	donerob = u8:decode"^ За ограбление дома вы получили %d+ вирт$",
	donetheft = u8:decode"^ Отличная тачка. Будет нужна работа, приходи%.$",
	stay = u8:decode"^ %(%( После ввода команды вы должны стоять на месте %)%)$",
	wasAFK = u8:decode"^ В AFK ввод команд заблокирован$",
	lomka = u8:decode"^ ~~~~~~~~ У вас началась ломка ~~~~~~~~$",
	plswait = u8:decode"^ Пожалуйста подождите$",
	spam = u8:decode"^ SMS%: {FF8000}СКРЫТО%. {FFFF00}Отправитель%: .*%[(%d+)%]",
	noequest = u8:decode"^ Доступно со 2 уровня",
	metka = u8:decode"^ Пассажир (.*) установил точку прибытия %(%( Для отключения введите %/gps %)%)",
	slet = u8:decode"^ Домашний счёт оплачен до (.*)",
	accepttaxi = u8:decode"^ Диспетчер%: (.*) принял вызов от (.*)%[%d+%]$",
	full24 = u8:decode"^ У вас нет места$",
	full24sec = u8:decode"^ У вас нет дома%/квартиры$",
	afksec = u8:decode"%[AFK%] %[(%d+) секунд%]",
	
	color = {
		mechanic = 1790050303,
		jfchat = 815835135,
		faction = {33357823, -1920073729},
		narko = -1,
		boost = -1,
		noboost = -1,
		paint = -5570561,
		squid = -356056833,
		race = -1179057921,
		derby = 16711935,
		connected = -356056833,
		quest = 1790050303,
		taxi = 1790050303,
		sms = -65281,
		normalchat = {-926365496, -1431655766, -1936946036, 1852730990},
		rent = -1,
		fish = -1342193921,
		grib = -1,
		minusbalaklava = -1347440641,
		minuslom = 1790050303,
		kanistra = 1687547391,
		fillcar = 1687547391,
		outbagazhnik = -1061109505,
		inbagazhnik =  1790050303,
		shop24 =  1687547391,
		trash = -1029514497,
		reward = 1790050303,
		disconnect = -1,
		cookgrib = 1358862079,
		adr = -1342193921,
		psiho = -1,
		roul = -356056833,
		repair1 = 1358862079,
		repair2 = -1347440641,
		stolen = 1790050303,
		breaken = 1790050303,
		open = -1,
		put = -1061109505,
		rob = -1061109505,
		donerob = -1061109505,
		donetheft =  1790050303,
		stay = -1347440641,
		wasAFK = -2769921,
		lomka = -1627389697,
		plswait = -1347440641,
		spam = -65281,
		noequest = -1347440641,
		accepttaxi = -1137955670,
		full24 = -1347440641
	},
	
	dialog = {
		narko = {str  = u8:decode"%[%d+%] Таймер на Нарко(.*)", id = 22, style = 5, title = u8:decode'Бонусы'},
		login = {str  = u8:decode"Этот аккаунт зарегистрирован", id = 1, style = 3, title = u8:decode'Авторизация'},
		quest = {str  = u8:decode"%{FFFFFF%}(.*).+%{[F3][F3][4A][2A][43][23]%}(%[Н?е?.?[Вв]ыполнено%])", id = 1013, style = 5, title = u8:decode'%{FFFFFF%}Обновление заданий%: %{6AB1FF%}(.*)'},
		description = {str1 = u8:decode"%{FFFFFF%}Название квеста%: ", str2 = u8:decode"Описание%: ", str3 = u8:decode"%{6AB1FF%}(.*)%{FFFFFF%}", id = 1014, style = 0, title = u8:decode'{6AB1FF}Ежедневные квесты'},
		inventory = {id = 22, style = 4, title = u8:decode'Карманы'},
		autorent = {str = u8:decode"Стоимость аренды%: {FFFF00}(%d+) вирт", id = {276, 277}, style = 0, title = u8:decode'Аренда транспорта'}
	}
}
local motos = {[522] = "NRG-500", [463] = "Freeway", [461] = "PCJ-600", [581] = "BF-400", [521] = "FCR-900", [468] = "Sanchez", [462] = "Faggio"}
-------------------------------------------------------------------------[MAIN]--------------------------------------------------------------------------------------------
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(0) end
	
	while sampGetCurrentServerName() == "SA-MP" do wait(0) end
	server = sampGetCurrentServerName():gsub('|', '')
	server = (server:find('02') and 'Two' or (server:find('Revo') and 'Revolution' or (server:find('Legacy') and 'Legacy' or (server:find('Classic') and 'Classic' or nil))))
    if server == nil then script.sendMessage('Данный сервер не поддерживается, выгружаюсь...') script.unload = true thisScript():unload() end
	currentNick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
	
	AdressConfig = string.format("%s\\config", thisScript().directory)
    AdressFolder = string.format("%s\\config\\SRPfunctions by Webb\\%s\\%s", thisScript().directory, server, currentNick)
	settings = string.format("SRPfunctions by Webb\\%s\\%s\\settings.ini", server, currentNick)
	binds = string.format("SRPfunctions by Webb\\%s\\%s\\binder.ini", server, currentNick)
	
	if not doesDirectoryExist(AdressConfig) then createDirectory(AdressConfig) end
	if not doesDirectoryExist(AdressFolder) then createDirectory(AdressFolder) end
	
	if srp_ini == nil then -- загружаем конфиг
		srp_ini = inicfg.load(config, settings)
		inicfg.save(srp_ini, settings)
	end
	
	if binder_ini == nil then -- загружаем биндер
		binder_ini = inicfg.load(bindertable, binds)
		inicfg.save(binder_ini, binds)
	end
	
	togglebools = {
		autorepair = srp_ini.bools.autorepair and imgui.ImBool(true) or imgui.ImBool(false),
		autofill = srp_ini.bools.autofill and imgui.ImBool(true) or imgui.ImBool(false),
		autorefill = srp_ini.bools.autorefill and imgui.ImBool(true) or imgui.ImBool(false),
		autorefillcanister = srp_ini.bools.autorefillcanister and imgui.ImBool(true) or imgui.ImBool(false),
		autocanister = srp_ini.bools.autocanister and imgui.ImBool(true) or imgui.ImBool(false),
		jfcoloring = srp_ini.bools.jfcoloring and imgui.ImBool(true) or imgui.ImBool(false),
		fcoloring = srp_ini.bools.fcoloring and imgui.ImBool(true) or imgui.ImBool(false),
		quit = srp_ini.bools.quit and imgui.ImBool(true) or imgui.ImBool(false),
		psychoheal = srp_ini.bools.psychoheal and imgui.ImBool(true) or imgui.ImBool(false),
		autologin = srp_ini.bools.autologin and imgui.ImBool(true) or imgui.ImBool(false),
		autorent = srp_ini.bools.autorent and imgui.ImBool(true) or imgui.ImBool(false),
		robbing = srp_ini.bools.robbing and imgui.ImBool(true) or imgui.ImBool(false),
		lomka = srp_ini.bools.lomka and imgui.ImBool(true) or imgui.ImBool(false),
		withoutcops = srp_ini.bools.withoutcops and imgui.ImBool(true) or imgui.ImBool(false),
		date = srp_ini.bools.date and imgui.ImBool(true) or imgui.ImBool(false),
		nick = srp_ini.bools.nick and imgui.ImBool(true) or imgui.ImBool(false),
		ping = srp_ini.bools.ping and imgui.ImBool(true) or imgui.ImBool(false),
		drugs = srp_ini.bools.drugs and imgui.ImBool(true) or imgui.ImBool(false),
		event = srp_ini.bools.event and imgui.ImBool(true) or imgui.ImBool(false),
		stream = srp_ini.bools.stream and imgui.ImBool(true) or imgui.ImBool(false),
		status = srp_ini.bools.status and imgui.ImBool(true) or imgui.ImBool(false),
		squad = srp_ini.bools.squad and imgui.ImBool(true) or imgui.ImBool(false),
		hpcars = srp_ini.bools.hpcars and imgui.ImBool(true) or imgui.ImBool(false),
		chatinfo = srp_ini.bools.chatinfo and imgui.ImBool(true) or imgui.ImBool(false),
		equest = srp_ini.bools.equest and imgui.ImBool(true) or imgui.ImBool(false),
		inventory = srp_ini.bools.inventory and imgui.ImBool(true) or imgui.ImBool(false),
		narko = srp_ini.inventory.narko and imgui.ImBool(true) or imgui.ImBool(false),
		mats = srp_ini.inventory.mats and imgui.ImBool(true) or imgui.ImBool(false),
		directory = srp_ini.inventory.directory and imgui.ImBool(true) or imgui.ImBool(false),
		mp3 = srp_ini.inventory.mp3 and imgui.ImBool(true) or imgui.ImBool(false),
		keys = srp_ini.inventory.keys and imgui.ImBool(true) or imgui.ImBool(false),
		canister = srp_ini.inventory.canister and imgui.ImBool(true) or imgui.ImBool(false),
		drivelicense = srp_ini.inventory.drivelicense and imgui.ImBool(true) or imgui.ImBool(false),
		helilicense = srp_ini.inventory.helilicense and imgui.ImBool(true) or imgui.ImBool(false),
		planelicense = srp_ini.inventory.planelicense and imgui.ImBool(true) or imgui.ImBool(false),
		boatlicense = srp_ini.inventory.boatlicense and imgui.ImBool(true) or imgui.ImBool(false),
		fishlicense = srp_ini.inventory.fishlicense and imgui.ImBool(true) or imgui.ImBool(false),
		weaponlicense = srp_ini.inventory.weaponlicense and imgui.ImBool(true) or imgui.ImBool(false),
		fish = srp_ini.inventory.fish and imgui.ImBool(true) or imgui.ImBool(false),
		cookedfish = srp_ini.inventory.cookedfish and imgui.ImBool(true) or imgui.ImBool(false),
		mushroom = srp_ini.inventory.mushroom and imgui.ImBool(true) or imgui.ImBool(false),
		repairkit = srp_ini.inventory.repairkit and imgui.ImBool(true) or imgui.ImBool(false),
		psychoheal = srp_ini.inventory.psychoheal and imgui.ImBool(true) or imgui.ImBool(false),
		cookedmushroom = srp_ini.inventory.cookedmushroom and imgui.ImBool(true) or imgui.ImBool(false),
		cigarette = srp_ini.inventory.cigarette and imgui.ImBool(true) or imgui.ImBool(false),
		adrenaline = srp_ini.inventory.adrenaline and imgui.ImBool(true) or imgui.ImBool(false),
		cork = srp_ini.inventory.cork and imgui.ImBool(true) or imgui.ImBool(false),
		balaclava  = srp_ini.inventory.balaclava and imgui.ImBool(true) or imgui.ImBool(false),
		scrap = srp_ini.inventory.scrap and imgui.ImBool(true) or imgui.ImBool(false),
		energy = srp_ini.inventory.energy and imgui.ImBool(true) or imgui.ImBool(false),
		robkit = srp_ini.inventory.robkit and imgui.ImBool(true) or imgui.ImBool(false),
		kd = srp_ini.bools.kd and imgui.ImBool(true) or imgui.ImBool(false),
		variables = srp_ini.bools.variables and imgui.ImBool(true) or imgui.ImBool(false),
		spam = srp_ini.bools.spam and imgui.ImBool(true) or imgui.ImBool(false),
		house = srp_ini.bools.house and imgui.ImBool(true) or imgui.ImBool(false),
		repairkits = srp_ini.bools.repairkits and imgui.ImBool(true) or imgui.ImBool(false)
	}
	
	buffer = {
		autorefill = imgui.ImBuffer(u8(srp_ini.values.autorefill), 256),
		autofill = imgui.ImBuffer(u8(srp_ini.values.autofill), 256),
		clist = imgui.ImInt(srp_ini.values.clist),
		password = imgui.ImBuffer(u8(srp_ini.values.password), 256),
		autorent = imgui.ImBuffer(u8(srp_ini.values.autorent), 256),
		timezonedifference = imgui.ImInt(srp_ini.values.timezonedifference + 14),
		repairkits = imgui.ImBuffer(u8(srp_ini.values.repairkits), 256)
	}
	
	sampRegisterChatCommand("samprp", function() 
		for k, v in pairs(srp_ini.hotkey) do 
			local hk = makeHotKey(k) 
			if tonumber(hk[1]) ~= 0 then 
				rkeys.unRegisterHotKey(hk) 
			end 
		end
		for k, v in ipairs(binder_ini.list) do
			if v ~= nil then
				local b = decodeJson(v)
				local bhk = makebinderHotKey(k)
				if tonumber(hk) ~= 0 then
					rkeys.unRegisterHotKey(bhk)
				end
				sampUnregisterChatCommand(b.cmd)
				argument[k] = nil
			end
		end
		suspendkeys = 1 
		menu.main.v = not menu.main.v
	end)
	sampRegisterChatCommand("srp", function() 
		for k, v in pairs(srp_ini.hotkey) do 
			local hk = makeHotKey(k) 
			if tonumber(hk[1]) ~= 0 then 
				rkeys.unRegisterHotKey(hk) 
			end 
		end
		for k, v in ipairs(binder_ini.list) do
			if v ~= nil then
				local b = decodeJson(v)
				local bhk = makebinderHotKey(k) 
				if tonumber(hk) ~= 0 then
					rkeys.unRegisterHotKey(bhk)
				end
				sampUnregisterChatCommand(b.cmd)
				argument[k] = nil
			end
		end
		suspendkeys = 1 
		menu.main.v = not menu.main.v
	end)
	sampRegisterChatCommand("setoverlay", cmd_setoverlay)
	sampRegisterChatCommand("setov", cmd_setoverlay)
	sampRegisterChatCommand("srpflood", cmd_flood)
	sampRegisterChatCommand("samprpflood", cmd_flood)
	sampRegisterChatCommand("srpstop", function() chatManager.initQueue() script.sendMessage("Очередь отправляемых сообщений очищена!") end)
	sampRegisterChatCommand("samprpstop", function() chatManager.initQueue() script.sendMessage("Очередь отправляемых сообщений очищена!") end)
	sampRegisterChatCommand('srpup', updateScript)
	sampRegisterChatCommand('samprpup', updateScript)
	sampRegisterChatCommand("whenhouse", function() whenhouse() end)
	sampRegisterChatCommand("st", cmd_st)
	sampRegisterChatCommand("sw", cmd_sw)
	
	script.loaded = true
	while sampGetGamestate() ~= 3 do wait(0) end
	while sampGetPlayerScore(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) <= 0 and not sampIsLocalPlayerSpawned() do wait(0) end
	checkUpdates()
	script.sendMessage("Скрипт запущен. Открыть главное меню - /srp")
	imgui.Process = true
	if srp_ini.bools.house then whenhouse() end
	needtoreload = true
	lua_thread.create(function() CTask() end)
	lua_thread.create(function() onfoot() end)
	
	findsquad()
	
	chatManager.initQueue()
	lua_thread.create(chatManager.checkMessagesQueueThread)
	checkdialogs()
	while true do
		wait(0)
		if time then setTimeOfDay(time, 0) end
		for i = 0, 3000 do
			if sampTextdrawIsExists(i) and sampTextdrawGetString(i):match(u8:decode"SQUAD") then
				if srp_ini.bools.squad then
					sampTextdrawSetPos(i, 1488, 1488)
					else
					sampTextdrawSetPos(i, 1, 172)
				end
			end
		end
		if suspendkeys == 2 then
			rkeys.registerHotKey(makeHotKey("Контекстная клавиша"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end if srp_ini.bools.status then ct() end end)
			rkeys.registerHotKey(makeHotKey("Нарко"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end usedrugs() end)
			rkeys.registerHotKey(makeHotKey("Сменить клист"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end setclist() end)
			rkeys.registerHotKey(makeHotKey("Войти в дом"), true, function() if sampIsChatInputActive() or isSampfuncsConsoleActive() then return end enterhouse() end)
			rkeys.registerHotKey(makeHotKey("Lock"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end chatManager.addMessageToQueue("/lock") end)
			rkeys.registerHotKey(makeHotKey("Автобег"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end needtohold = not needtohold end)
			rkeys.registerHotKey(makeHotKey("eject"), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end eject() end)
			for k, v in ipairs(binder_ini.list) do
				if v ~= nil then
					local b = decodeJson(v)
					if b.hotkey ~= "0" then
						rkeys.registerHotKey(makebinderHotKey(k), true, function() if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then return end binder(k) end)
						else
						rkeys.unRegisterHotKey(makebinderHotKey(k))
					end
					if b.cmd ~= "" and b.cmd ~= " " then
						sampRegisterChatCommand(b.cmd,  function(params) if params ~= nil and params ~= "" then argument[k] = params else argument[k] = nil end binder(k) end)
					end
				end
			end
			suspendkeys = 0
		end
		if not menu.main.v then 
			imgui.ShowCursor = false
			if suspendkeys == 1 then 
				suspendkeys = 2 
				sampSetChatDisplayMode(3) 
			end
		end
		textLabelOverPlayerNickname()
		-- Активация быстрого меню биндера
		if isKeyDown(makeHotKey('Быстрое меню биндера')[1]) and not menu.main.v and not sampIsChatInputActive() and not sampIsDialogActive(-1) and not isSampfuncsConsoleActive() then 
			wait(0) 
			menu.fastbinder.v = true 
			else 
			wait(0) 
			menu.fastbinder.v = false 
			imgui.ShowCursor = false 
		end
		if SetMode then
			if isKeyDown(vkeys.VK_MBUTTON) then
				wait(300)
				if isKeyDown(vkeys.VK_MBUTTON) then
					srp_ini.overlay.dateX = 846
					srp_ini.overlay.dateY = 215
					srp_ini.overlay.nickX = 823
					srp_ini.overlay.nickY = 249
					srp_ini.overlay.pingX = 892
					srp_ini.overlay.pingY = 312
					srp_ini.overlay.narkoX = 901
					srp_ini.overlay.narkoY = 284
					srp_ini.overlay.eventX  = 803
					srp_ini.overlay.eventY = 647
					srp_ini.overlay.streamX = 786
					srp_ini.overlay.streamY = 340
					srp_ini.overlay.statusX = 775
					srp_ini.overlay.statusY = 366
					srp_ini.overlay.squadX = 515
					srp_ini.overlay.squadY = 338
					srp_ini.overlay.deilyX = 803
					srp_ini.overlay.deilyY = 407
					srp_ini.overlay.inventoryX = 789
					srp_ini.overlay.inventoryY  = 755
					srp_ini.overlay.robbingX = 799
					srp_ini.overlay.robbingY = 544
					inicfg.save(srp_ini, settings)
					SetMode, SetModeFirstShow = true, true
					script.sendMessage("Координаты элементов были успешно сброшены")
				end
			end
		end
		if needtohold and not sampIsChatInputActive() and not sampIsDialogActive(-1) and not isSampfuncsConsoleActive() and (wasKeyPressed(vkeys.VK_W) or wasKeyPressed(vkeys.VK_S)) then needtohold = false end
		if getActiveInterior() == 0 then needtobuy = true gekauft = false end
	end
end
-------------------------------------------------------------------------[IMGUI]-------------------------------------------------------------------------------------------
function apply_custom_styles()
	imgui.SwitchContext()
	local style  = imgui.GetStyle()
	local colors = style.Colors
	local clr    = imgui.Col
	local ImVec4 = imgui.ImVec4
	
    style.FrameRounding    = 4.0
	style.GrabRounding     = 4.0
	
	colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.48, 0.16, 0.16, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
	colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
	colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
	
	
	imgui.GetIO().Fonts:Clear()
	imfonts.mainFont = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.smainFont1 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 18.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.smainFont2 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 16.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	
	imfonts.ovFont = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 28.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.ovFont1 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.ovFont2 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\times.ttf', 25.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imfonts.ovFontSquad = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebuc.ttf', 15.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	
	imfonts.ovFontCars = renderCreateFont("times", 14, 12)
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
	if menu.main.v and script.checked then -- меню скрипта
		imgui.SwitchContext()
		colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
		imgui.PushFont(imfonts.mainFont)
		imgui.ShowCursor = true
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(1200, 700), imgui.Cond.FirstUseEver)
		imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		imgui.Begin(thisScript().name .. (script.available and ' [Доступно обновление: v' .. script.v.num .. ' от ' .. script.v.date .. ']' or ' v' .. script.v.num .. ' от ' .. script.v.date), menu.main, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		local ww = imgui.GetWindowWidth()
		local wh = imgui.GetWindowHeight()
		
		imgui.PushFont(imfonts.smainFont1)
		imgui.SetCursorPos(imgui.ImVec2(ww/2 - 568, wh/2 - 320))
		if imgui.Button("Автоматические действия", imgui.ImVec2(280.0, 35.0)) then menu.automatic.v = true menu.commands.v = false menu.binds.v = false menu.overlay.v = false menu.information.v = false menu.binder.v = false  menu.password.v = false menu.inventory.v = false menu.editor.v = false menu.variables.v = false end
		imgui.SameLine()
		if imgui.Button("Клавиши и команды", imgui.ImVec2(280.0, 35.0)) then menu.automatic.v = false menu.commands.v = false menu.binds.v = true menu.overlay.v = false menu.information.v = false menu.binder.v = false  menu.password.v = false menu.inventory.v = false menu.editor.v = false menu.variables.v = false end
		imgui.SameLine()
		if imgui.Button("Overlay", imgui.ImVec2(280.0, 35.0)) then menu.automatic.v = false menu.commands.v = false menu.binds.v = false menu.overlay.v = true menu.information.v = false menu.binder.v = false  menu.password.v = false menu.inventory.v = false menu.editor.v = false menu.variables.v = false end
		imgui.SameLine()
		if imgui.Button("Кастомный биндер", imgui.ImVec2(280.0, 35.0)) then currentBind = nil menu.automatic.v = false menu.commands.v = false menu.binds.v = false menu.overlay.v = false menu.information.v = false menu.binder.v = true menu.password.v = false menu.inventory.v = false menu.editor.v = false menu.variables.v = false end
		imgui.PopFont()
		
		if menu.automatic.v and not menu.binds.v and not menu.overlay.v and not menu.binder.v and not menu.information.v and not menu.editor.v then
			imgui.BeginChild('automatics', imgui.ImVec2(1185, 500), true)
			if imgui.ToggleButton("automatic1", togglebools.autorepair) then srp_ini.bools.autorepair = togglebools.autorepair.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Принимать предложение механика о починке") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Если вы водитель транспорта, то скрипт будет автоматически соглашатся с предложением починить вас от механика") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic2", togglebools.autorefill) then srp_ini.bools.autorefill = togglebools.autorefill.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Принимать предложение механика о заправке (не дороже ") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Если вы водитель транспорта, то скрипт будет автоматически соглашатся с предложением заправить вас от механика") imgui.EndTooltip() end imgui.SameLine() imgui.PushItemWidth(90) if imgui.InputText('##d1', buffer.autorefill) then srp_ini.values.autorefill = tostring(u8:decode(buffer.autorefill.v)) inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.PopItemWidth() imgui.Text(" вирт.)")
			if imgui.ToggleButton("automatic3", togglebools.autofill) then srp_ini.bools.autofill = togglebools.autofill.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Заправлять транспорт на АЗС (не дороже ") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Как только вы заедите на заправку и скрипт убедится в том что цена приемлима, вы будете автоматически заправлены") imgui.EndTooltip() end imgui.SameLine() imgui.PushItemWidth(90) if imgui.InputText('##d2', buffer.autofill) then srp_ini.values.autofill = tostring(u8:decode(buffer.autofill.v)) inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.PopItemWidth() imgui.Text(" вирт.)")
			if imgui.ToggleButton("automatic4", togglebools.autocanister) then srp_ini.bools.autocanister = togglebools.autocanister.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Покупать канистру на АЗС, (исходя из цены заправки)") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Как только вы заедите на заправку и скрипт убедится в том что цена приемлима (цена заправки на АЗС), вы автоматически купите канистру если её нет в инвентаре") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic5", togglebools.autorefillcanister) then srp_ini.bools.autorefillcanister = togglebools.autorefillcanister.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Заправлять транспорт канистрой в случае если закончилось топливо") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Как только в вашем транспорте закончится топливо, скрипт моментально использует канистру (если она есть в инвентаре)") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic6", togglebools.jfcoloring) then srp_ini.bools.jfcoloring = togglebools.jfcoloring.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Окрашивать ники в чате профсоюза в цвет клиста") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Все новые появляющиеся сообщения в рации профсоюза будут иметь одну особенность: ник и ID игрока будет в цвете его клиста") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic7", togglebools.fcoloring) then srp_ini.bools.fcoloring = togglebools.fcoloring.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Окрашивать ники в чате фракции в цвет клиста") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Все новые появляющиеся сообщения в рации фракции будут иметь одну особенность: ник и ID игрока будет в цвете его клиста") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic8", togglebools.quit) then srp_ini.bools.quit = togglebools.quit.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Оповещать о вышедших из игры игроках в зоне прорисовки") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Если кто-то в зоне прорисовке, по той или иной причине покинет игру, то в чате появится сообщение о том кто вышел (в цвете клиста) и с какой причиной") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic9", togglebools.psychoheal) then srp_ini.bools.psychoheal = togglebools.psychoheal.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Оповещать об употреблении психохила игроками в зоне прорисовки") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Если кто-то в зоне прорисовке употребит психохил, то в чате появится сообщение о том кто употребил (в цвете клиста)") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic10", togglebools.autologin) then srp_ini.bools.autologin = togglebools.autologin.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Вводить пароль в диалог авторизации") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Как только вы подключитесь к серверу и вам высветится диалог авторизации, скрипт моментально введёт ваш пароль в строку и примет диалог") imgui.EndTooltip() end imgui.SameLine(350)  imgui.PushFont(imfonts.smainFont2) if imgui.Button("Ввести пароль для автологина", imgui.ImVec2(215.0, 23.0)) then menu.variables.v = false menu.commands.v = false menu.inventory.v = false menu.password.v = true end imgui.PopFont()
			if imgui.ToggleButton("automatic11", togglebools.autorent) then srp_ini.bools.autorent = togglebools.autorent.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Арендовать транспорт (не дороже ") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Как только вам высветится диалог с предложением арендовать транспорт и цена аренды будет приемлима, то вы его моментально арендуете и запустите двигатель") imgui.EndTooltip() end imgui.SameLine() imgui.PushItemWidth(90) if imgui.InputText('##d3', buffer.autorent) then srp_ini.values.autorent = tostring(u8:decode(buffer.autorent.v)) inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.PopItemWidth() imgui.Text(" вирт.)")
			if imgui.ToggleButton("automatic12", togglebools.robbing) then srp_ini.bools.robbing = togglebools.robbing.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Помощник для ограбления домов (автоматически выносит из дома и заходит обратно)") if imgui.IsItemHovered() then local hstr = "" for _, v in ipairs(string.split(srp_ini.hotkey.enterhouse, ", ")) do if v ~= "0" then hstr = hstr == "" and tostring(vkeys.id_to_name(tonumber(v))) or "" .. hstr .. " + " .. tostring(vkeys.id_to_name(tonumber(v))) .. "" end end hstr = (hstr == "" or hstr == "nil") and "" or hstr imgui.BeginTooltip() imgui.TextUnformatted("Что бы взломать дом нажмите " .. (hstr ~= "" and hstr .. " (клавиша входа в дом)" or "клавишу входа в дом (можно задать в разделе 'Клавиши')") .. ", обязательно припаркуйте фургон таким образом, что бы его пикап находился чётко возле пикапа дома") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic13", togglebools.lomka) then srp_ini.bools.lomka = togglebools.lomka.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Употребить нарко в случае если у вас началась ломка") imgui.SameLine(475) if imgui.Checkbox("Не употреблять нарко при ломке, если на экране есть копы", togglebools.withoutcops) then srp_ini.bools.withoutcops = togglebools.withoutcops.v inicfg.save(srp_ini, settings) end
			if imgui.ToggleButton("automatic14", togglebools.spam) then srp_ini.bools.spam = togglebools.spam.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Сразу отвечать на спам-СМС (что бы увидеть что хотел вам написать игрок)") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("На сервере работает анти-спам система, игроки до 3 LVL не могут всем рассылать сообщения, от них стоит защита и у них КД на СМС 30 секунд") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic15", togglebools.house) then srp_ini.bools.house = togglebools.house.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Уведомлять о слете недвижимости при заходе в игру") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Когда вы оплатите квартплату или же наступит пейдей, скрипт запомнит дату слета недвижимости") imgui.EndTooltip() end
			if imgui.ToggleButton("automatic16", togglebools.repairkits) then srp_ini.bools.repairkits = togglebools.repairkits.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Автоматически покупать ремкомплекты (не дороже ") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Если вдруг вам нужно купить их ещё раз (не сработало из-за лимита), то перезайдите в магазин") imgui.EndTooltip() end imgui.SameLine() imgui.PushItemWidth(90) if imgui.InputText('##d4', buffer.repairkits) then srp_ini.values.repairkits = tostring(u8:decode(buffer.repairkits.v)) inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.PopItemWidth() imgui.Text(" вирт.)")
			imgui.EndChild()
		end
		
		if menu.password.v then
			imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(470, 195), imgui.Cond.FirstUseEver)
			imgui.Begin("Ввод пароля", menu.password, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			imgui.Text("Введите в текстовую строку ваш пароль от аккаунта\nВНИМАНИЕ!!! Ваш пароль никуда не отправляется\nОн всего лишь сохранится в ваш .ini файл\nНикому не отправляйте свой конфиг!")
			imgui.NewLine()
			imgui.PushItemWidth(300)
			if imgui.InputText('##password', buffer.password) then srp_ini.values.password = tostring(u8:decode(buffer.password.v)) inicfg.save(srp_ini, settings) end
			imgui.PopItemWidth()
			imgui.End()
		end
		
		if not menu.automatic.v and menu.binds.v and not menu.overlay.v and not menu.binder.v then
			imgui.BeginChild('hotkeys', imgui.ImVec2(1185, 500), true)
			imgui.PushFont(imfonts.smainFont2)
			imgui.Hotkey("hotkey", "Контекстная клавиша", 100) imgui.SameLine() imgui.Text("Контекстная клавиша\n(удерживайте чтобы отменить задачу - только одиночная клавиша)") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Контекстная клавиша - это единичный биндер который отправляет сообщение в чат в той или иной ситуации.") imgui.TextUnformatted("На данный момент имеются следующие ситуации:") imgui.TextUnformatted("1) Возле вас поломанный транспорт - /rkt") imgui.TextUnformatted("2) Вы зашли в больницу а в ней нет врачей? - отправить всем врачам (кто в игре) СМС прийти в вашу больницу") imgui.TextUnformatted("3) Вас заДМили? - отправить репорт на жалкого урода ДМщика") imgui.TextUnformatted("4) Кто-то сел к вам в такси - спросить куда ехать") imgui.TextUnformatted("5) Клиент сказал куда ехать - положительно ответить") imgui.TextUnformatted("6) Клиент вышел из такси - красиво попрощаться") imgui.TextUnformatted("7) Приняли вызов и приехали к клиенту - сказать что бы сел в такси") imgui.TextUnformatted("Функция работает только если у вас включён рендер статуса контекстной клавиши в меню Overlay") imgui.EndTooltip() end
			imgui.Hotkey("hotkey1", "Нарко", 100) imgui.SameLine() imgui.Text("Употребить нарко\n(нужно находится на месте)")
			imgui.Hotkey("hotkey2", "Сменить клист", 100) imgui.SameLine() imgui.Text("Сменить клист\n(если надет не нулевой клист, то будет введён /clist 0)") imgui.SameLine(800 - imgui.CalcTextSize('(если надет не нулевой клист, то будет введён /clist 0)').x) imgui.PushItemWidth(200) if imgui.Combo("##Combo", buffer.clist, clists.names) then srp_ini.values.clist = tostring(u8:decode(buffer.clist.v)) inicfg.save(srp_ini, settings) end
			imgui.Hotkey("hotkey3", "Войти в дом", 100) imgui.SameLine() imgui.Text("Войти в ближайший дом\n(Аналогично если вы находитесь внутри дома возле входа, то скрипт выйдет из него)") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Настоятельно рекомендую использовать эту клавишу для ограбления домов!") imgui.EndTooltip() end 
			imgui.Hotkey("hotkey4", "Lock", 100) imgui.SameLine() imgui.Text("Открыть дверь транспорта\n(/lock)")
			imgui.Hotkey("hotkey5", "Автобег", 100) imgui.SameLine() imgui.Text("Зажать клавишу бега\n(Работает как переключатель)")
			imgui.Hotkey("hotkey6", "Быстрое меню биндера", 100) imgui.SameLine() imgui.Text("При зажатии откроется быстрое меню биндера\n(Что бы настроить биндер см.меню 'Кастомный биндер')")
			imgui.Hotkey("hotkey7", "eject", 100) imgui.SameLine() imgui.Text("Выкинуть всех игроков из транспорта\n(Работает только если игрок не в АФК)") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Если клавишу зажать, то можно будет выбрать конкретного игрока") imgui.EndTooltip() end 
			imgui.PopFont()
			imgui.EndChild()
		end
		
		if not menu.automatic.v and not menu.binds.v and menu.overlay.v and not menu.binder.v then
			imgui.Text("Что бы изменить положение элемента, пропишите команду /setov")
			imgui.Text("Далее просто нужно курсором перенести все элементы")
			imgui.BeginChild('overlay', imgui.ImVec2(1185, 452), true)
			if imgui.ToggleButton("overlay.1", togglebools.date) then srp_ini.bools.date = togglebools.date.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение даты и времени на экране")
			if imgui.ToggleButton("overlay.2", togglebools.nick) then srp_ini.bools.nick = togglebools.nick.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение никнейма и IDа в цвете клиста")
			if imgui.ToggleButton("overlay.3", togglebools.ping) then srp_ini.bools.ping = togglebools.ping.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение текущего пинга")
			if imgui.ToggleButton("overlay.4", togglebools.drugs) then srp_ini.bools.drugs = togglebools.drugs.v inicfg.save(srp_ini, settings) if srp_ini.bools.drugs then isBoost = true chatManager.addMessageToQueue("/boostinfo") end end imgui.SameLine() imgui.Text("Отображение статуса употребления нарко")
			if imgui.ToggleButton("overlay.5", togglebools.event) then srp_ini.bools.event = togglebools.event.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение таймеров до начала системных мероприятий")
			if imgui.ToggleButton("overlay.6", togglebools.stream) then srp_ini.bools.stream = togglebools.stream.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение количества игроков в зоне прорисовки")
			if imgui.ToggleButton("overlay.7", togglebools.status) then srp_ini.bools.status = togglebools.status.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение статуса контекстной клавиши") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Контекстная клавиша - это единичный биндер который отправляет сообщение в чат в той или иной ситуации.") imgui.TextUnformatted("На данный момент имеются следующие ситуации:") imgui.TextUnformatted("1) Возле вас поломанный транспорт - /rkt") imgui.TextUnformatted("2) Вы зашли в больницу а в ней нет врачей? - отправить всем врачам (кто в игре) СМС прийти в вашу больницу") imgui.TextUnformatted("3) Вас заДМили? - отправить репорт на жалкого урода ДМщика") imgui.TextUnformatted("4) Кто-то сел к вам в такси - спросить куда ехать") imgui.TextUnformatted("5) Клиент сказал куда ехать - положительно ответить") imgui.TextUnformatted("6) Клиент вышел из такси - красиво попрощаться") imgui.TextUnformatted("7) Приняли вызов и приехали к клиенту - сказать что бы сел в такси") imgui.TextUnformatted("Обязательно задайте клавишу в меню 'Команды и клавиши'") imgui.EndTooltip() end
			if imgui.ToggleButton("overlay.8", togglebools.squad) then srp_ini.bools.squad = togglebools.squad.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение улучшенного вида сквада")
			if imgui.ToggleButton("overlay.9", togglebools.hpcars) then srp_ini.bools.hpcars = togglebools.hpcars.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение ХП на окружающем транспорте")
			if imgui.ToggleButton("overlay.10", togglebools.chatinfo) then srp_ini.bools.chatinfo = togglebools.chatinfo.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение раскладки, капса, и кол-ва символов под строкой чата")
			if imgui.ToggleButton("overlay.11", togglebools.equest) then srp_ini.bools.equest = togglebools.equest.v inicfg.save(srp_ini, settings) if srp_ini.bools.equest then isQuest = true chatManager.addMessageToQueue("/equest") end end imgui.SameLine() imgui.Text("Отображение активных ежедневных заданий. Обязательно установите ваш часовой пояс:") if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("Если в рендере описание не указано (задание светится красным), то это означает что в базе данных скрипта отсутствует описание данного задания") imgui.TextUnformatted("Что бы получить описание задания, нужно открыть его в /equest, далее скрипт сохранит описание") imgui.TextUnformatted("Настоятельно рекомендую в такой ситуации отписать разработчику в тг " .. script.telegram.nick .. " название и описание задания") imgui.EndTooltip() end imgui.SameLine(750) imgui.PushItemWidth(200) if imgui.Combo("##Combo", buffer.timezonedifference, timezones) then srp_ini.values.timezonedifference = tostring(u8:decode(buffer.timezonedifference.v) - 14) inicfg.save(srp_ini, settings) if srp_ini.bools.equest then chatManager.addMessageToQueue("/equest") end end
			if imgui.ToggleButton("overlay.12", togglebools.inventory) then srp_ini.bools.inventory = togglebools.inventory.v inicfg.save(srp_ini, settings) if srp_ini.bools.inventory then isInventory = true chatManager.addMessageToQueue("/inventory") end end imgui.SameLine() imgui.Text("Отображение содержимого инвентаря") imgui.SameLine(355) imgui.PushFont(imfonts.smainFont2) if imgui.Button("Настроить предметы инвентаря", imgui.ImVec2(215.0, 23.0)) then menu.variables.v = false menu.commands.v = false menu.inventory.v = true menu.password.v = false end imgui.PopFont()
			if imgui.ToggleButton("overlay.13", togglebools.kd) then srp_ini.bools.kd = togglebools.kd.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Отображение КД до следующего ограбления домов/автоугона")
			imgui.EndChild()			
		end
		
		if menu.inventory.v then
			imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(580, 820), imgui.Cond.FirstUseEver)
			imgui.Begin("Выбор предметов для отображения", menu.inventory, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			imgui.Text("Выберите предметы, количество которых будет выводится на экран\nЕсли предмет светится жёлтым/красным - значит его мало/отсутствует")
			imgui.BeginChild('inventory', imgui.ImVec2(565, 730), true)
			if imgui.ToggleButton("inventory1", togglebools.narko) then srp_ini.inventory.narko = togglebools.narko.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Наркотики\"")
			if imgui.ToggleButton("inventory2", togglebools.mats) then srp_ini.inventory.mats = togglebools.mats.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Материалы\"")
			if imgui.ToggleButton("inventory3", togglebools.directory) then srp_ini.inventory.directory = togglebools.directory.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Телефонная книга\"")
			if imgui.ToggleButton("inventory4", togglebools.mp3) then srp_ini.inventory.mp3 = togglebools.mp3.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"MP3\"")
			if imgui.ToggleButton("inventory5", togglebools.keys) then srp_ini.inventory.keys = togglebools.keys.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Ключи от камеры\"")
			if imgui.ToggleButton("inventory6", togglebools.canister) then srp_ini.inventory.canister = togglebools.canister.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Канистра с бензином\"")
			if imgui.ToggleButton("inventory7", togglebools.drivelicense) then srp_ini.inventory.drivelicense = togglebools.drivelicense.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Водительские права\"")
			if imgui.ToggleButton("inventory8", togglebools.helilicense) then srp_ini.inventory.helilicense = togglebools.helilicense.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Лицензия на вертолеты\"")
			if imgui.ToggleButton("inventory9", togglebools.planelicense) then srp_ini.inventory.planelicense = togglebools.planelicense.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Лицензия на самолеты\"")
			if imgui.ToggleButton("inventory10", togglebools.boatlicense) then srp_ini.inventory.boatlicense = togglebools.boatlicense.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Лицензия на лодки\"")
			if imgui.ToggleButton("inventory11", togglebools.fishlicense) then srp_ini.inventory.fishlicense = togglebools.fishlicense.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Лицензия на рыболовство\"")
			if imgui.ToggleButton("inventory12", togglebools.weaponlicense) then srp_ini.inventory.weaponlicense = togglebools.weaponlicense.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Лицензия на оружие\"")
			if imgui.ToggleButton("inventory13", togglebools.fish) then srp_ini.inventory.fish = togglebools.fish.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Сырая рыба\"")
			if imgui.ToggleButton("inventory14", togglebools.cookedfish) then srp_ini.inventory.cookedfish = togglebools.cookedfish.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Готовая рыба\"")
			if imgui.ToggleButton("inventory15", togglebools.mushrooms) then srp_ini.inventory.mushrooms = togglebools.mushrooms.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Грибы\"")
			if imgui.ToggleButton("inventory16", togglebools.repairkit) then srp_ini.inventory.repairkit = togglebools.repairkit.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Комплект «автомеханик»\"")
			if imgui.ToggleButton("inventory17", togglebools.psychoheal) then srp_ini.inventory.psychoheal = togglebools.psychoheal.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Психохил\"")
			if imgui.ToggleButton("inventory18", togglebools.cookedmushroom) then srp_ini.inventory.cookedmushroom = togglebools.cookedmushroom.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Готовые грибы\"")
			if imgui.ToggleButton("inventory19", togglebools.cigarette) then srp_ini.inventory.cigarette = togglebools.cigarette.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Сигареты\"")
			if imgui.ToggleButton("inventory20", togglebools.adrenaline) then srp_ini.inventory.adrenaline = togglebools.adrenaline.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Адреналин\"")
			if imgui.ToggleButton("inventory21", togglebools.cork) then srp_ini.inventory.cork = togglebools.cork.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Защита от насильников\"")
			if imgui.ToggleButton("inventory22", togglebools.balaclava) then srp_ini.inventory.balaclava = togglebools.balaclava.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Балаклава\"")
			if imgui.ToggleButton("inventory23", togglebools.scrap) then srp_ini.inventory.scrap = togglebools.scrap.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Лом\"")
			if imgui.ToggleButton("inventory24", togglebools.energy) then srp_ini.inventory.energy = togglebools.energy.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Энергетик\"")
			if imgui.ToggleButton("inventory25", togglebools.robkit) then srp_ini.inventory.robkit = togglebools.robkit.v inicfg.save(srp_ini, settings) end imgui.SameLine() imgui.Text("Предмет: \"Набор для взлома\"")
			imgui.EndChild()
			imgui.End()
		end
		
		if not menu.automatic.v and not menu.binds.v and not menu.overlay.v and menu.binder.v and not menu.information.v and not menu.editor.v then
			imgui.Text("Меню кастомного биндера на клавиши / команды (крайне не рекомендую вручную изменять .ini файл)")
			imgui.PushFont(imfonts.smainFont2)
			if imgui.Button("Добавить бинд", imgui.ImVec2(170.0, 23.0)) then
				table.insert(binder_ini.list, encodeJson({
					name   = "Новый бинд",
					msg    = {},
					cmd    = "",
					hotkey = "0",
					fast   = false
				}))
				inicfg.save(binder_ini, binds) 
			end
			imgui.SameLine()
			if imgui.Button("Редактировать", imgui.ImVec2(175.0, 23.0)) then
				if currentBind ~= nil then
					menu.editor.v = true
				end
			end
			imgui.SameLine()
			if imgui.Button("Вниз", imgui.ImVec2(175.0, 23.0)) then
				if currentBind ~= nil then
					if binder_ini.list[currentBind + 1] ~= nil then
						local bk = binder_ini.list[currentBind]
						binder_ini.list[currentBind] = binder_ini.list[currentBind + 1]
						binder_ini.list[currentBind + 1] = bk
						currentBind = currentBind + 1
						inicfg.save(binder_ini, binds)
					end
				end
			end
			imgui.SameLine()
			if imgui.Button("Вверх", imgui.ImVec2(175.0, 23.0)) then
				if currentBind ~= nil then
					if binder_ini.list[currentBind - 1] ~= nil then
						local bk = binder_ini.list[currentBind]
						binder_ini.list[currentBind] = binder_ini.list[currentBind - 1]
						binder_ini.list[currentBind - 1] = bk
						currentBind = currentBind - 1
						inicfg.save(binder_ini, binds)
					end
				end
			end
			imgui.SameLine()
			if imgui.CustomButton("Настройка текстовых переменных", imgui.ImVec4(0.48, 0.16, 0.16, 0.54), imgui.ImVec4(0.98, 0.43, 0.26, 0.67), imgui.ImVec4(0.98, 0.43, 0.26, 0.40), imgui.ImVec2(250.0, 23.0)) then
				menu.variables.v = true
				menu.commands.v = false 
				menu.inventory.v = false 
				menu.password.v = false
			end
			imgui.BeginChild('binds', imgui.ImVec2(1185, 449), true)
			for k, v in ipairs(binder_ini.list) do
				imgui.PushID(k)
				v = decodeJson(v)
				local cmd = imgui.ImBuffer(v.cmd, 256)
				if imgui.Button(tostring(k), imgui.ImVec2(50.0, 23.0)) then
					currentBind = k
					menu.editor.v = true
				end
				imgui.SameLine()
				if currentBind == k then
					if imgui.CustomButton(v.name, imgui.ImVec4(0.48, 0.16, 0.16, 0.54), imgui.ImVec4(0.98, 0.43, 0.26, 0.67), imgui.ImVec4(0.98, 0.43, 0.26, 0.40), imgui.ImVec2(350.0, 23.0)) then
						currentBind = nil
					end
					else
					if imgui.Button(v.name, imgui.ImVec2(350.0, 23.0)) then
						currentBind = k
					end
				end
				imgui.SameLine()
				imgui.binderHotkey(k, k, 23)
				imgui.SameLine()
				imgui.PushItemWidth(125) 
				if imgui.InputText('##bindсommand', cmd) then
					if not cmd.v:match("srp") then
						v.cmd = cmd.v
						binder_ini.list[k] = encodeJson(v)
						inicfg.save(binder_ini, binds)
					end
				end
				imgui.PopItemWidth()
				imgui.PushFont(imfonts.mainFont)
				if imgui.IsItemHovered() then 
					imgui.BeginTooltip() 
					imgui.TextUnformatted('Команду вводить без "/"') 
					imgui.TextUnformatted('Для работы бинда достаточно либо клавиши либо команды, но также можно и то и другое') 
					imgui.EndTooltip()
				end
				imgui.PopFont()
				imgui.SameLine()
				if imgui.CustomButton("Удалить", imgui.ImVec4(0.48, 0.16, 0.16, 0.54), imgui.ImVec4(0.98, 0.43, 0.26, 0.67), imgui.ImVec4(0.98, 0.43, 0.26, 0.40)) then
					table.remove(binder_ini.list, k) 
					inicfg.save(binder_ini, binds) 
				end
				imgui.SameLine()
				local bool = v.fast and imgui.ImBool(true) or imgui.ImBool(false)
				if imgui.Checkbox("##fastbinder", bool) then 
					v.fast = bool.v
					binder_ini.list[k] = encodeJson(v)
					inicfg.save(binder_ini, binds)
				end
				imgui.PushFont(imfonts.mainFont)
				if imgui.IsItemHovered() then 
					imgui.BeginTooltip() 
					imgui.TextUnformatted("Добавить бинд в быстрое-меню") 
					imgui.TextUnformatted("Активировать быстрое меню можно в разделе 'Клавиши'") 
					imgui.EndTooltip()
				end
				imgui.PopFont()
				imgui.PopID()
			end
			imgui.EndChild()
			imgui.PopFont()
		end
		
		if menu.variables.v then
			local vars = {
				"@params@ - заменится на все параметры команды, которой активируется ваш бинд (напр. /test 1 1 1 => В чате будет текст бинда и 1 1 1",
				"@param1@ - заменится на 1 параметр команды, которой активируется ваш бинд (напр. /test 1 2 3 => В чате будет текст бинда и 1; аналогично можно брать @param2@, @param3@ и.т.д.",
				"@myid@ - заменится на ваш ID",
				"@mynick@ - заменится на ваш ник",
				"@myrpnick@ - заменится на ваш РП ник (без '_', в случае если ник нонрп, то напишет просто ник)",
				"@myname@ - заменится на ваше имя (если ник нонРП то напишет просто ник)",
				"@mysurname@ - заменится на вашу фамилию (если ник нонРП то напишет просто ник)",
				"@date@ - текущая дата вашего ПК в формате: dd.mm.yy",
				"@hour@ - текущий час вашего ПК в 24-часовом формате",
				"@min@ - текущая минута вашего ПК",
				"@sec@ - текущая секунда вашего ПК",
				"@myclist@ - текущий ваш клист",
				"@mainclist@ - ваш главный клист (см.меню 'Клавиши')",
				"@kv@ - текущий квадрат/сектор на карте"
			}
			local w = 0
			local sortvars = {}
			for k, v in ipairs(vars) do table.insert(sortvars, imgui.CalcTextSize(v).x) end
			table.sort(sortvars, function(a, b) return a < b end)
			for k, v in ipairs(sortvars) do
				w = v + 50
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(w, 400), imgui.Cond.FirstUseEver, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			imgui.Begin("Все текстовые переменные скрипта", menu.variables, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			imgui.Text("Переменные можно использовать в биндере, и просто в чате:")
			if imgui.ToggleButton("variables",  togglebools.variables) then 
				srp_ini.bools.variables = togglebools.variables.v     
				inicfg.save(srp_ini, settings) 
			end 
			imgui.SameLine() 
			imgui.Text("Использовать переменные и для обычного чата")    
			if imgui.IsItemHovered() then 
				imgui.BeginTooltip() 
				imgui.TextUnformatted("Разница заключается в том, что если параметр будет активирован, то вы сможете помимо биндера также использовать переменные и просто в чате.")                                                
				imgui.EndTooltip() 
			end
			imgui.BeginChild('variables', imgui.ImVec2(w - 15, 300), true)
			for k, v in ipairs(vars) do imgui.Text(v) end
			imgui.EndChild()
			imgui.End()
		end
		
		if menu.editor.v then
			if currentBind ~= nil then
				if tonumber(currentBind) ~= nil then
					imgui.Text("Редактор бинда #" .. currentBind .. " | Настройки сохраняются автоматически, доступно использование текстовых переменных")
					imgui.PushFont(imfonts.smainFont2)
					local str = binder_ini.list[currentBind]
					local b   = decodeJson(str)
					local name = imgui.ImBuffer(b.name, 256)
					imgui.BeginChild('Editor', imgui.ImVec2(1185, 456), true)
					imgui.Text("Установить название бинда: ")
					imgui.SameLine()
					imgui.PushItemWidth(300) 
					if imgui.InputText('##bindname', name) then
						b.name = name.v
					end
					imgui.PopItemWidth()
					imgui.SameLine()
					if imgui.CustomButton("Настройка текстовых переменных", imgui.ImVec4(0.48, 0.16, 0.16, 0.54), imgui.ImVec4(0.98, 0.43, 0.26, 0.67), imgui.ImVec4(0.98, 0.43, 0.26, 0.40), imgui.ImVec2(250.0, 22.0)) then
						menu.variables.v = true
						menu.commands.v = false 
						menu.inventory.v = false 
						menu.password.v = false
					end
					imgui.SameLine(860)
					if imgui.Button("Вернутся назад", imgui.ImVec2(300.0, 23.0)) then menu.automatic.v = false menu.commands.v = false menu.binds.v = false menu.overlay.v = false menu.information.v = false menu.binder.v = true menu.password.v = false menu.inventory.v = false menu.editor.v = false menu.variables.v = false end
					if imgui.Button("Добавить строку", imgui.ImVec2(170.0, 23.0)) then
						table.insert(b.msg, "")
					end
					for k, v in ipairs(b.msg) do
						local str = imgui.ImBuffer(v, 256)
						imgui.PushItemWidth(1060)
						if imgui.InputText('##bindmsg' .. k, str) then
							b.msg[k] = str.v
						end
						imgui.SameLine()
						imgui.PushID(k)
						if imgui.Button('Удалить', imgui.ImVec2(90.0, 22.0)) then 
							table.remove(b.msg, k)
						end
						imgui.PopID()
					end
					binder_ini.list[currentBind] = encodeJson(b)
					inicfg.save(binder_ini, binds)
					imgui.EndChild()
					imgui.PopFont()
					else
					imgui.Text("Произошла ошибка, попробуйте ещё раз!")
				end
				else
				imgui.Text("Произошла ошибка, попробуйте ещё раз!")
			end
		end
		
		if not menu.automatic.v and not menu.binds.v and not menu.overlay.v and not menu.binder.v and menu.information.v and not menu.editor.v then
			imgui.Text("Данный скрипт является многофункциональным хелпером для игроков проекта Samp RP")
			imgui.Text("Автор: Cody_Webb | Telegram: @Imykhailovich")
			imgui.SameLine()
			imgui.PushFont(imfonts.smainFont2)
			if imgui.Button("Написать разработчику", imgui.ImVec2(180.0, 23.0)) then os.execute("explorer " .. script.telegram.url) end
			imgui.PopFont()
			if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("При нажатии, в браузере по умолчанию откроется ссылка на телеграм разработчика") imgui.EndTooltip() end
			imgui.Text("Все настройки автоматически сохраняются в файл moonloader//config//SRPfunctions by Webb//Server//Nick_Name")
			--imgui.NewLine()
			imgui.Text("Информация о последних обновлениях:")
			imgui.BeginChild('information', imgui.ImVec2(1185, 384), true)
			for k in ipairs(script.upd.sort) do
				if script.upd.changes[tostring(k)] ~= nil then
					imgui.Text(k .. ') ' .. script.upd.changes[tostring(k)])
					imgui.NewLine()
				end
			end
			imgui.EndChild()
		end
		
		imgui.SetCursorPos(imgui.ImVec2(30, wh/2 + 305))
		local found = false
		for i = 0, 1000 do
			if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
				if sampGetPlayerNickname(i) == "Cody_Webb" then
					if imgui.Button("Cody_Webb[" .. i .. "] сейчас в сети", imgui.ImVec2(260.0, 30.0)) then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/t " .. i .. " ")
					end
					found = true
				end
			end
		end
		if not found then
			if imgui.Button("Cody Webb сейчас не в сети", imgui.ImVec2(245.0, 30.0)) then
				script.sendMessage("Cody Webb играет на Revolution (сейчас не онлайн)")
			end
		end
		
		imgui.PushFont(imfonts.smainFont2)
		imgui.SetCursorPos(imgui.ImVec2(30, wh/2 + 235))
		if imgui.Button("Все команды скрипта", imgui.ImVec2(170.0, 23.0)) then menu.variables.v = false menu.commands.v = true menu.inventory.v = false menu.password.v = false end
		imgui.SetCursorPos(imgui.ImVec2(30, wh/2 + 270))
		if imgui.Button("Информация о скрипте", imgui.ImVec2(170.0, 23.0)) then menu.automatic.v = false menu.commands.v = false menu.binds.v = false menu.overlay.v = false menu.information.v = true menu.binder.v = false menu.password.v = false menu.inventory.v = false menu.editor.v = false menu.variables.v = false end
		imgui.SetCursorPos(imgui.ImVec2(ww/2 + 400, wh/2 + 235))
		if imgui.Button("Выгрузить скрипт", imgui.ImVec2(170.0, 23.0)) then showCursor(false) script.unload = true thisScript():unload() end if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("При нажатии, скрипт будет отключён до следующего запуска игры") imgui.EndTooltip() end
		imgui.SetCursorPos(imgui.ImVec2(ww/2 + 400, wh/2 + 270))
		if imgui.Button("Перезагрузить скрипт", imgui.ImVec2(170.0, 23.0)) then showCursor(false) script.reload = true thisScript():reload() end
		imgui.SetCursorPos(imgui.ImVec2(ww/2 + 400, wh/2 + 305))
		if imgui.Button("Открыть GitHub", imgui.ImVec2(170.0, 23.0)) then os.execute('explorer "https://github.com/WebbLua/SRPfunctions"') end if imgui.IsItemHovered() then imgui.BeginTooltip() imgui.TextUnformatted("При нажатии, в браузере по умолчанию откроется ссылка на GitHub скрипта") imgui.EndTooltip() end
		imgui.PopFont()
		
		if menu.commands.v then
			local cmds = {
				"/srp (/samprp) - открыть/закрыть главное меню скрипта",
				"/setov (/setoverlay) - изменить местоположения элементов оверлея на экране",
				"/srpflood [Text] (/samprpflood [Text]) - флудить заданным текстом в чат",
				"/srpstop - очистить очередь отправляемых сообщений в чат (очень полезно если биндер флудит без остановки)",
				"/srpup (/samprpup) - обновить скрипт",
				"/whenhouse - узнать когда слетит недвижимость",
				"/st [0-24] - установить игровое время",
				"/sw [0-45] - установить игровую погоду"
			}
			local w = 0
			local sortcmds = {}
			for k, v in ipairs(cmds) do table.insert(sortcmds, imgui.CalcTextSize(v).x) end
			table.sort(sortcmds, function(a, b) return a < b end)
			for k, v in ipairs(sortcmds) do
				w = v + 50
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(w, 300), imgui.Cond.FirstUseEver, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			imgui.Begin("Все команды скрипта", menu.commands, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			imgui.Text("Данные команды являются системными, их нельзя изменить:")
			imgui.BeginChild('commands', imgui.ImVec2(w - 15, 235), true)
			for k, v in ipairs(cmds) do imgui.Text(v) end
			imgui.EndChild()
			imgui.End()
		end
		
		imgui.End()
		imgui.PopFont()
	end
	
	if menu.fastbinder.v then
		imgui.SwitchContext()
		colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
		imgui.PushFont(imfonts.mainFont)
		imgui.ShowCursor = true
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(400, 500), imgui.Cond.FirstUseEver)
		imgui.Begin("Быстрое меню биндера", nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		imgui.BeginChild('fastbinder', imgui.ImVec2(385, 455), true)
		for k, v in ipairs(binder_ini.list) do
			local b = decodeJson(v)
			if b.fast then
				imgui.PushID(k)
				if imgui.Button(b.name, imgui.ImVec2(368, 25.0)) then 
					binder(k)
				end
				imgui.PopID()
			end
		end
		imgui.EndChild()
		imgui.End()
		imgui.PopFont()
	end
	
	imgui.SwitchContext() -- Overlay
	colors[clr.WindowBg] = ImVec4(0, 0, 0, 0)
	local SetModeCond = SetMode and 0 or 4
	
	if srp_ini.bools.date then -- показывать время
		if not SetMode then	imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.dateX, srp_ini.overlay.dateY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.dateX, srp_ini.overlay.dateY))	end end
		imgui.Begin('#empty_field', overlay.date, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont)
		imgui.TextColoredRGB('{FFFF00}' .. os.date("%d.%m.%y %X") .. '')
		imgui.PopFont()
		soverlay.date = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools.nick then -- ник и ид на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.nickX, srp_ini.overlay.nickY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.nickX, srp_ini.overlay.nickY))	end	end
		local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if result then
			local name = sampGetPlayerNickname(id)
			local clist = string.sub(string.format('%x', sampGetPlayerColor(id)), 3)
			local clist = clist == "ffff" and "fffafa" or clist
			imgui.Begin('#empty_field1', overlay.nick, 1 + 32 + 2 + SetModeCond + 64)
			imgui.PushFont(imfonts.ovFont)
			imgui.TextColoredRGB('{' .. clist .. '}' .. name .. '')
			imgui.SameLine()
			imgui.TextColoredRGB('{' .. clist .. '}[' .. tostring(id) .. ']')
			imgui.PopFont()
			soverlay.nick = imgui.GetWindowPos()
			imgui.End()
		end
	end
	
	if srp_ini.bools.ping then -- пинг на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.pingX, srp_ini.overlay.pingY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.pingX, srp_ini.overlay.pingY))	end	end
		imgui.Begin('#empty_field2', overlay.ping, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont2)
		local ping = sampGetPlayerPing(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		if ping ~= nil then imgui.TextColoredRGB((ping > 80 and "{FF0000}" or "{00FF00}") .. u8:decode"Пинг: " .. ping) end
		imgui.PopFont()
		soverlay.ping = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools.drugs then -- КД нарко на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.narkoX, srp_ini.overlay.narkoY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.narkoX, srp_ini.overlay.narkoY))	end	end
		imgui.Begin('#empty_field3', overlay.drugs, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont2)
		if (os.time() - tonumber(srp_ini.values.drugs)) < drugtimer then
			sec = drugtimer - (os.time() - tonumber(srp_ini.values.drugs))
			local mins = math.floor(sec / 60)
			if math.fmod(sec, 60) >= 10 then secs = math.fmod(sec, 60) end
			if math.fmod(sec, 60) < 10 then secs = "0" .. math.fmod(sec, 60) .. "" end
			imgui.TextColoredRGB("{FF0000}" .. mins .. ":" .. secs .. "")
			else
			imgui.TextColoredRGB("{00FF00}" .. u8:decode"Юзай!")
		end
		imgui.PopFont()
		soverlay.drugs = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools.event then -- таймеры до начала системных МП
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.eventX, srp_ini.overlay.eventY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.eventX, srp_ini.overlay.eventY))	end	end
		imgui.Begin('#empty_field4', overlay.event, 1 + 32 + 2 + SetModeCond + 64)
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
		soverlay.event = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools.stream then -- количество игроков в зоне прорисовки на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.streamX, srp_ini.overlay.streamY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.streamX, srp_ini.overlay.streamY))	end	end
		imgui.Begin('#empty_field5', overlay.stream, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont1)
		imgui.TextColoredRGB(u8:decode'Количество персонажей в прорисовке: ' .. (sampGetPlayerCount(true) - 1) .. '')
		imgui.PopFont()
		soverlay.stream = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools.status then -- статус контекстной клавиши на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.statusX, srp_ini.overlay.statusY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.statusX, srp_ini.overlay.statusY))	end	end
		imgui.Begin('#empty_field6', overlay.status, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont1)
		local CStatus = CTaskArr["CurrentID"] == 0 and "{FFFAFA}" .. u8:decode"Ожидание события" or "" .. u8:decode(CTaskArr["n"][CTaskArr[1][CTaskArr["CurrentID"]]]) .. " " .. u8:decode((indexof(CTaskArr[1][CTaskArr["CurrentID"]], CTaskArr["nn"]) ~= false and CTaskArr[3][CTaskArr["CurrentID"]] or "")) .. ""
		imgui.TextColoredRGB(u8:decode'Статус контекстной клавиши: ' .. CStatus .. '')
		imgui.PopFont()
		soverlay.status = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools.squad and ((not sampIsChatInputActive() and not isSampfuncsConsoleActive() and rCache.enable) or SetMode) then -- улучшенный сквад на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.squadX, srp_ini.overlay.squadY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.squadX, srp_ini.overlay.squadY))	end	end
		imgui.Begin('#empty_field7', overlay.squad, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFontSquad)
		local count = 0
		for k in pairs(smem) do count = count + 1 end
		imgui.TextColoredRGB("{B30000}" .. u8:decode"Состав отряда - " .. count .. ":")
		soverlay.squad = imgui.GetWindowPos()
		local x = SetMode and soverlay.squad.x + 5 or srp_ini.overlay.squadX + 5
		local y = SetMode and soverlay.squad.y or srp_ini.overlay.squadY
		for k, v in ipairs(smem) do
			y = y + 25
			local status = ""
			if sampIsPlayerPaused(v.id) then 
				status = " {008000}[AFK] " .. (v.afk ~= nil and "[" .. v.afk .. u8:decode" секунд]" or "")
				else
				v.afk = nil
			end
			renderFontDrawText(imfonts.ovFontSquadRender, v.name .. " [" .. v.id .. "]" .. status, x, y, (sampGetCharHandleBySampPlayerId(v.id) or v.id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) and v.color or v.colorns)
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
	
	if srp_ini.bools.hpcars then -- показывать ХП машин вокруг
		local carhandles = getcars() -- получаем все машины вокруг
		if carhandles ~= nil then -- если машина обнаружена
			for k, v in pairs(carhandles) do -- перебор всех машин в прорисовке
				if doesVehicleExist(v) and isCarOnScreen(v) and not sampIsDialogActive(-1) then -- если машина на экране и не открыт диалог
					local idcar = getCarModel(v) -- получаем ид модельки
					local myX, myY, myZ = getCharCoordinates(PLAYER_PED) -- получаем свои координаты
					local cX, cY, cZ = getCarCoordinates(v) -- получаем координаты машины
					local distance = math.ceil(math.sqrt( ((myX-cX)^2) + ((myY-cY)^2) + ((myZ-cZ)^2))) -- расстояние между мной и машиной
					if isLineOfSightClear(myX, myY, myZ, cX, cY, cZ, true, false, false, true, false) and distance <= 20 then
						-- если между мной и машиной нет стен (персонажи и машины не считаются за стены) и расстояние не более 20 то...
						local cHP = getCarHealth(v) -- получаем хп машины
						local cPosX, cPosY = convert3DCoordsToScreen(cX, cY, cZ) -- переводим 3Д координаты мира в координаты на экране
						local col = cHP > 800 and 0xFF00FF00 or cHP > 500 and 0xFFFFFF00 or 0xFFFFFAFA -- получаем цвет текста в зависимости от ХП машины
						local col = motos[idcar] ~= nil and isCarTireBurst(v, 1) and 0xFFFF0000 or col -- если колесо МОТОЦИКЛА пробито то цвет ХП всегда красный
						local ctext = cHP
						renderFontDrawText(imfonts.ovFontCars, ctext, cPosX - (renderGetFontDrawTextLength(imfonts.ovFontCars, ctext, false) / 2), cPosY, col, false) -- рисуем текст
					end
				end
			end
		end
	end
	
	if srp_ini.bools.chatinfo and sampIsChatInputActive() then -- раскладка, капс, символы под строкой чата
		local in1 = sampGetInputInfoPtr()
		local in1_1 = getStructElement(in1, 0x8, 4)
		local in2 = getStructElement(--[[int]] in1_1, --[[int]] 0x8, --[[int]] 4)
		local in3 = getStructElement(--[[int]] in1_1, --[[int]] 0xC, --[[int]] 4)
		local fib = in3 + 40
		local fib2 = in2 + 5
		local success = ffi.C.GetKeyboardLayoutNameA(keybbb.KeyboardLayoutName)
		local errorCode = ffi.C.GetLocaleInfoA(tonumber(ffi.string(keybbb.KeyboardLayoutName), 16), 0x00000002, keybbb.LocalInfo, 32)
		local localName = ffi.string(keybbb.LocalInfo)
		local capsState = ffi.C.GetKeyState(20)
		imgui.SetNextWindowPos(imgui.ImVec2(fib2, fib))
		imgui.Begin('#empty_field8', overlay.chatinfo, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.exFontsquad)
		local a = sampGetChatInputText()
		local b = a:match("%/(%a+) .*")
		local c = (b == nil or sym[b] == nil) and sym[1] or sym[b]
		if sym.myid == -1 then
			sym.myid = #tostring(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			sym.mynick = #sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		end
		local d = c - sym.myid - sym.mynick
		local e = #a > d and "{FF0000}" .. #a .. "" or #a
		imgui.TextColoredRGB(u8:decode"Раскладка: {ffffff}" .. localName .. "; CAPS: " .. getStrByState(capsState) .. u8:decode", Символы: " .. e .. "/" .. d .. ".")
		imgui.PopFont()
		imgui.End()
	end
	
	if srp_ini.bools.equest then -- ежедневные задания на экране
		if not SetMode then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.deilyX, srp_ini.overlay.deilyY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.deilyX, srp_ini.overlay.deilyY))	end	end
		imgui.Begin('#empty_field9', overlay.equest, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont1)
		if SetMode then imgui.TextColoredRGB("{00FF00}" .. u8:decode"Здесь находятся ежедневные задания") end
		if srp_ini.questupdating ~= nil then
			local sec = os.difftime(srp_ini.questupdating, os.time())
			if sec >= 0 then
				local mins = math.floor(sec / 60)
				local hours = math.floor(sec / 3600)
				hours = hours > 24 and hours - 24 or hours
				if math.fmod(sec, 60) >= 10 then secs = math.fmod(sec, 60) end
				if math.fmod(sec, 60) < 10 then secs = "0" .. math.fmod(sec, 60) .. "" end
				if hours >= 1 then
					if math.fmod(mins, 60) >= 10 then mins = math.fmod(mins, 60) end
					if math.fmod(mins, 60) < 10 then mins = "0" .. math.fmod(mins, 60) .. "" end
					timer = hours .. ":" .. mins .. ":" .. secs
					else
					timer = mins .. ":" .. secs
				end
				imgui.TextColoredRGB("{00FF00}" .. u8:decode"Обновление заданий через: " .. timer .. "")
				else
				imgui.TextColoredRGB("{FF0000}" .. u8:decode"Обновление заданий СЕЙЧАС")
			end
		end
		for k, v in pairs(srp_ini.task) do
			if not v then
				local inf = srp_ini.description[k] ~= nil and srp_ini.description[k] or 'Нет информации'
				local col = srp_ini.description[k] ~= nil and "{FCF803}" or "{FF0000}"
				imgui.TextColoredRGB(col .. u8:decode(k) .. " - " .. u8:decode(inf))
			end
		end
		imgui.PopFont()
		soverlay.equest = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools.inventory then -- cодержимое инвентаря на экране
		if not SetMode then	imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.inventoryX, srp_ini.overlay.inventoryY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.inventoryX, srp_ini.overlay.inventoryY))	end end
		imgui.Begin('#empty_field10', overlay.inventory, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont1)
		if SetMode then imgui.TextColoredRGB("{00FF00}" .. u8:decode"Здесь находятся предметы инвентаря") end
		if checkedInventory then
			for k, v in pairs(srp_ini.inventory) do
				if v and tonumber(srp_ini.inventory[k]) ~= nil then
					if u8:decode(k) == u8:decode"Наркотики" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 25 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Материалы" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 50 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Телефонная книга" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"MP3" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Ключи от камеры" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 2 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Канистра с бензином" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Водительские права" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Лицензия на вертолеты" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Лицензия на самолеты" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Лицензия на лодки" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Лицензия на рыболовство" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Лицензия на оружие" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Сырая рыба" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 50000 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Готовая рыба" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 15 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Грибы" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 50 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Комплект «автомеханик»" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 5 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Психохил" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 15 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Готовые грибы" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 15 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Сигареты" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 5 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Адреналин" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 5 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Защита от насильников" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 2 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Балаклава" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 3 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Лом" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 4 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Энергетик" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = "{00FF00}" else col = "{FF0000}" end end
					if u8:decode(k) == u8:decode"Набор для взлома" then if tonumber(srp_ini.inventory[k]) ~= nil and tonumber(srp_ini.inventory[k]) >= 1 then col = tonumber(srp_ini.inventory[k]) > 2 and "{00FF00}" or "{FCF803}" else col = "{FF0000}" end end
					imgui.TextColoredRGB(col .. u8:decode(k) .. (tonumber(srp_ini.inventory[k]) > 1 and ": " .. srp_ini.inventory[k] or (tonumber(srp_ini.inventory[k]) == 1 and "" or u8:decode": Нету!")))
				end
			end
		end
		imgui.PopFont()
		soverlay.inventory = imgui.GetWindowPos()
		imgui.End()
	end
	
	if srp_ini.bools.kd then -- КД ограбы и автоугона
		if not SetMode then	imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.robbingX, srp_ini.overlay.robbingY)) else if SetModeFirstShow then imgui.SetNextWindowPos(imgui.ImVec2(srp_ini.overlay.robbingX, srp_ini.overlay.robbingY))	end end
		imgui.Begin('#empty_field11', overlay.robbing, 1 + 32 + 2 + SetModeCond + 64)
		imgui.PushFont(imfonts.ovFont1)
		if SetMode then imgui.TextColoredRGB("{00FF00}" .. u8:decode"Здесь находится КД ограбления домов и автоугона") end
		if ((os.time() - tonumber(srp_ini.values.cartheft))/60) < 15 then
			local sec = 15*60 - (os.time() - tonumber(srp_ini.values.cartheft))
			local mins = math.floor(sec / 60)
			if math.fmod(sec, 60) >= 10 then secs = math.fmod(sec, 60) end
			if math.fmod(sec, 60) < 10 then secs = "0" .. math.fmod(sec, 60) .. "" end
			imgui.TextColoredRGB("{00FF00}" .. u8:decode"Угонять можно через: " .. mins .. ":" .. secs .. "")
			else
			local sec = 15*60 - (os.time() - tonumber(srp_ini.values.cartheft))
			if sec > -30 then
				imgui.TextColoredRGB("{FF0000}" .. u8:decode"Угонять можно СЕЙЧАС")
			end
		end
		if ((os.time() - tonumber(srp_ini.values.robbing))/60) < 35 then
			local sec = 35*60 - (os.time() - tonumber(srp_ini.values.robbing))
			local mins = math.floor(sec / 60)
			if math.fmod(sec, 60) >= 10 then secs = math.fmod(sec, 60) end
			if math.fmod(sec, 60) < 10 then secs = "0" .. math.fmod(sec, 60) .. "" end
			imgui.TextColoredRGB("{00FF00}" .. u8:decode"Грабить можно через: " .. mins .. ":" .. secs .. "")
			else
			local sec = 35*60 - (os.time() - tonumber(srp_ini.values.robbing))
			if sec > -30 then
				imgui.TextColoredRGB("{FF0000}" .. u8:decode"Грабить можно СЕЙЧАС")
			end
		end
		imgui.PopFont()
		soverlay.robbing = imgui.GetWindowPos()
		imgui.End()
		
		SetModeFirstShow = false
	end
end
-------------------------------------------------------------------------[ФУНКЦИИ]-----------------------------------------------------------------------------------------
function ev.onServerMessage(col, text)
	if script.loaded then
		if col == strings.color.connected and text:match(strings.connected) then if needtoreload then script.reload = true thisScript():reload() end end
		if col == strings.color.mechanic then
			if isCharInAnyCar(PLAYER_PED) then
				carHandle = storeCarCharIsInNoSave(PLAYER_PED)
				if getDriverOfCar(carHandle) == PLAYER_PED then
					if srp_ini.bools.autorepair then -- починка у механика
						if text:match(strings.acceptrepair) and getCarHealth(carHandle) < 100 then chatManager.addMessageToQueue("/ac repair") return end
					end
					if srp_ini.bools.autorefill then -- заправка у механика
						local cost = tonumber(text:match(strings.acceptrefill))
						local ncost = tonumber(srp_ini.values.autorefill)
						if cost ~= nil and ncost ~= nil then
							if cost <= ncost then
								chatManager.addMessageToQueue("/ac refill") 
								return
								else
								script.sendMessage("Транспорт не будет заправлен, так как цена выше лимита")
							end
						end
					end
				end
			end
		end
		if col == strings.color.jfchat then
			if srp_ini.bools.jfcoloring then -- окраска ников в чате профсоюза
				local nick, stringid, rank, txt = text:match(strings.jfchat)
				id = tonumber(stringid)
				if id ~= nil then
					local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)) .. "}"
					local color2 = "{" .. ("%06x"):format(bit.band(bit.rshift(col, 8), 0xFFFFFF)) .. "}"
					text = clist .. nick .. "[" .. id .. "]" .. color2 .. "<" .. rank .. ">: " .. txt
					return {col, text}
				end
			end
		end
		if indexof(col, strings.color.faction) then
			if srp_ini.bools.fcoloring then -- окраска ников в чате фракции
				local frank, fnick, fid, ftxt = text:match(strings.faction)
				if fid ~= nil then
					local color = "{" .. bit.tohex(bit.rshift(col, 8), 6) .. "}"
					local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(fid), 0xFFFFFF)) .. "}"
					local color2 = "{" .. ("%06x"):format(bit.band(bit.rshift(col, 8), 0xFFFFFF)) .. "}"
					text = " " .. color .. frank .. " " .. clist .. fnick .. "[" .. fid .. "]" .. color .. ": " .. ftxt .. ""
					return {col, text}
				end
			end
		end
		if col == strings.color.boost then 
			if text:match(strings.boost) and isBoost then 
				checkedBoost = true
				return false 
			end 
		end
		if col == strings.color.noboost then 
			if text:match(strings.noboost) and isBoost then
				isBoost = false 
				checkedBoost = true 
				return false 
			end 
		end
		if col == strings.color.narko then
			if srp_ini.bools.drugs then -- КД нарко
				if tonumber(text:match(strings.narko)) then
					isLomka = false
					srp_ini.inventory.narko = tonumber(text:match(strings.narko))
					srp_ini.values.drugs = os.time()
				end
			end
		end
		if col == strings.color.paint then
			if text:match(strings.painttime) then
				local paint = tonumber(text:match(strings.painttime))
				if paint ~= nil then 
					paint = os.time() + paint * 60
					srp_ini.iventpaintball = paint
				end
			end
			if text:match(strings.paintfalse1) then
				srp_ini.iventpaintball = false
			end
			if text:match(strings.paintfalse2) then
				srp_ini.iventpaintball = false
			end
		end
		if col == strings.color.squid then
			if text:match(strings.squidtime) then
				local squid = tonumber(text:match(strings.squidtime))
				if squid ~= nil then squid = os.time() + squid * 60 end
				srp_ini.iventsquid = squid
			end
			if text:match(strings.squidfalse1) then
				srp_ini.iventsquid = false
			end
			if text:match(strings.squidfalse2) then
				srp_ini.iventsquid = false
			end
			if text:match(strings.squidfalse3) then
				srp_ini.iventsquid = false
			end
		end
		if col == strings.color.race then
			if text:match(strings.racetime) then
				local race = tonumber(text:match(strings.racetime))
				if race ~= nil then
					if race == 5 then race = 7 end
					race = os.time() + race * 60
					srp_ini.iventrace = race
				end
			end
			if text:match(strings.racefalse1) then
				srp_ini.iventrace = false
			end
			if text:match(strings.racefalse2) then
				srp_ini.iventrace = false
			end
			if text:match(strings.racefalse3) then
				srp_ini.iventrace = false
			end
		end
		if col == strings.color.derby then
			if text:match(strings.derbytime) then
				local derby = tonumber(text:match(strings.derbytime))
				if derby ~= nil then derby = os.time() + derby * 60 end
				srp_ini.iventderby = derby
			end
			if text:match(strings.derbyfalse1) then
				srp_ini.iventderby = false
			end
			if text:match(strings.derbyfalse2) then
				srp_ini.iventderby = false
			end
			if text:match(strings.derbyfalse3) then
				srp_ini.iventderby = false
			end
		end
		if (text:match(strings.repair1) or text:match(strings.repair2) ~= nil or text:match(strings.repair3) ~= nil or text:match(strings.repair4) ~= nil) and CTaskArr[10][1] then CTaskArr[10][1] = false end
		if col == strings.color.quest and srp_ini.bools.equest then
			local fq, sq = text:match(strings.changequest)
			local equest  = text:match(strings.donequest)
			if fq ~= nil and sq ~= nil then
				local firstquest = fq
				local secondquest = ''
				for w in string.gmatch(sq, "%S+") do
					secondquest = secondquest == '' and w or secondquest .. ' ' .. w
				end
				for k, v in pairs(srp_ini.task) do
					if u8:decode(k) == firstquest then srp_ini.task[k] = nil srp_ini.task[u8(secondquest)] = v return end
				end
			end
			if equest then
				equest = equest:gsub("%.", "!")
				equest = u8(equest)
				if srp_ini.task[equest] ~= nil then 
					srp_ini.task[equest] = true 
				end
			end
		end
		if indexof(col, strings.color.normalchat) or col == strings.color.sms then
			local fpassenger, fid, ftxt = text:match(strings.normalchat)
			local stxt, spassenger, sid = text:match(strings.sms)
			if (fpassenger ~= nil and ftxt ~= nil and ftxt ~= "" and fpassenger == taxipassenger) or (spassenger ~= nil and stxt ~= nil and stxt ~= "" and spassenger == taxipassenger) then
				if isCharInAnyCar(PLAYER_PED) then
					fcarHandle = storeCarCharIsInNoSave(PLAYER_PED)
					if getDriverOfCar(fcarHandle) == PLAYER_PED then
						if isCarTaxi(fcarHandle) then
							taxipassenger = nil
							CTaskTaxiClear()
							table.insert(CTaskArr[1], 5)
							table.insert(CTaskArr[2], os.time())
							table.insert(CTaskArr[3], "")
						end
					end
				end
			end
		end
		--if col == strings.color.disconnect and text:match(strings.disconnect) then findsquad() end
		if col == strings.color.taxi then
			if isCharInAnyCar(PLAYER_PED) then
				fcarHandle = storeCarCharIsInNoSave(PLAYER_PED)
				if getDriverOfCar(fcarHandle) == PLAYER_PED then
					local passenger = text:match(strings.newpassenger)
					if sampGetPlayerIdByNickname(passenger) then
						taxipassenger = passenger
						local passengerId = sampGetPlayerIdByNickname(passenger)
						if sampGetCharHandleBySampPlayerId(tonumber(passengerId)) then
							local res, passengerHandle = sampGetCharHandleBySampPlayerId(tonumber(passengerId))
							if isCharInAnyCar(passengerHandle) then
								scarHandle = storeCarCharIsInNoSave(passengerHandle)
								if fcarHandle == scarHandle then
									CTaskTaxiClear()
									table.insert(CTaskArr[1], 4)
									table.insert(CTaskArr[2], os.time())
									table.insert(CTaskArr[3], "")
									lua_thread.create(function()
										local A_Index = 0
										while true do
											if A_Index == 5 then break end
											local str = sampGetChatString(99 - A_Index)
											if str:match(strings.normalchat) then
												local nick, id, txt = str:match(strings.normalchat)
												local stxt, spassenger, sid = str:match(strings.sms)
												if (nick == passenger and id ~= nil and txt ~= nil) or (nick == spassenger and sid ~= nil and stxt ~= nil) then
													CTaskTaxiClear()
													table.insert(CTaskArr[1], 5)
													table.insert(CTaskArr[2], os.time())
													table.insert(CTaskArr[3], "")
													return
												end
											end
											A_Index = A_Index + 1
										end
									end)
								end
							end
						end
					end
					if text:match(strings.outpassenger1) or text:match(strings.outpassenger2) then
						CTaskTaxiClear()
						table.insert(CTaskArr[1], 6)
						table.insert(CTaskArr[2], os.time())
						table.insert(CTaskArr[3], "")
					end
				end
			end
		end
		if col == strings.color.taxi and text:match(strings.metka) then
			CTaskTaxiClear()
			table.insert(CTaskArr[1], 5)
			table.insert(CTaskArr[2], os.time())
			table.insert(CTaskArr[3], "")
		end
		if indexof(col, strings.color.normalchat) and text:match(strings.normalchat) then
			local nickone, id, txt = text:match(strings.normalchat)
			if txt:match(u8:decode'[МмMm][ЕеEe][ТтTt][КкKk][АаAa]?') then
				lua_thread.create(function()
					local A_Index = 0
					while true do
						if A_Index == 5 then break end
						local str = sampGetChatString(99 - A_Index)
						if str:match(strings.metka) then
							local nicktwo = str:match(strings.metka)
							if nickone == nicktwo then
								chatManager.addMessageToQueue('Вижу метку!') 
								return
							end
						end
						A_Index = A_Index + 1
					end
				end)
			end
		end
		if col == strings.color.rent and text:match(strings.rent) and rent ~= nil then
			script.sendMessage('Вы арендовали транспортное средство за ' .. rent .. ' вирт')
			chatManager.addMessageToQueue('/en')
			return false
		end
		if col == strings.color.minusbalaklava and text:match(strings.minusbalaklava) then 
			if tonumber(srp_ini.inventory.balaclava) ~= nil and tonumber(srp_ini.inventory.balaclava) > 0 then 
				srp_ini.inventory.balaclava = tonumber(srp_ini.inventory.balaclava) - 1                                                                
			end 
		end
		if col == strings.color.minuslom and text:match(strings.minuslom) then 
			if tonumber(srp_ini.inventory.scrap) ~= nil and tonumber(srp_ini.inventory.scrap) > 0 then 
				srp_ini.inventory.scrap = tonumber(srp_ini.inventory.scrap) - 1                                                                
			end 
		end
		if col == strings.color.kanistra and text:match(strings.kanistra) then 
			if tonumber(srp_ini.inventory.canister) == 0 then 
				srp_ini.inventory.canister   = 1                                                                                                          		
			end 
		end
		if col == strings.color.fillcar and text:match(strings.fillcar) then 
			if tonumber(srp_ini.inventory.canister) == 1 then 
				srp_ini.inventory.canister = 0                                                                                                          		
			end 
		end
		if col == strings.color.inbagazhnik and text:match(strings.inbagazhnik) then 
			local n, k = text:match(strings.inbagazhnik) 
			if n ~= nil and tonumber(k) ~= nil then 
				if tonumber(srp_ini.inventory[u8(n)]) ~= nil then 
					srp_ini.inventory[u8(n)] = tonumber(k) 												                                                      
				end
			end
		end
		if col == strings.color.outbagazhnik and text:match(strings.outbagazhnik) then 
			local n, k = text:match(strings.outbagazhnik) 
			if n ~= nil and tonumber(k) ~= nil then 
				if tonumber(srp_ini.inventory[u8(n)]) ~= nil then
					srp_ini.inventory[u8(n)] = tonumber(srp_ini.inventory[u8(n)]) + tonumber(k)                                                    
				end 
			end 
		end
		if col == strings.color.shop24 and text:match(strings.shop24) then 
			local n, k = text:match(strings.shop24) 
			if n ~= nil and tonumber(k) ~= nil then 
				if tonumber(srp_ini.inventory[u8(n)]) ~= nil then 
					srp_ini.inventory[u8(n)] = tonumber(k)                                                                                             
				end 
			end
		end
		if col == strings.color.grib and text:match(strings.grib) then 
			local k = text:match(strings.grib)
			if tonumber(k) ~= nil then 
				srp_ini.inventory.mushrooms = tonumber(k)                                                                                                     
			end 
		end
		if col == strings.color.fish and text:match(strings.fish) then
			local k = text:match(strings.fish)
			if tonumber(k)  ~= nil then 
				srp_ini.inventory.cookedfish = tonumber(k)                                                 										               
			end 
		end
		if col == strings.color.fish and text:match(strings.cookfish) then 
			local k = text:match(strings.cookfish) 
			if tonumber(k) ~= nil then 
				srp_ini.inventory.cookedfish = tonumber(k)  
				srp_ini.inventory['Cырая рыба'] = tonumber(srp_ini.inventory.fish) - 20000    
			end 
		end
		if col == strings.color.cookgrib and text:match(strings.cookgrib) then 
			local sg, p, gg = text:match(strings.cookgrib) 
			if tonumber(sg) ~= nil and tonumber(p) ~= nil and tonumber(gg) ~= nil then 
				srp_ini.inventory.mushrooms = tonumber(sg) srp_ini.inventory.psychoheal = tonumber(p) 
				srp_ini.inventory.cookedmushroom = tonumber(gg) 
			end
		end
		if col == strings.color.trash and text:match(strings.trash) then 
			local n, k = text:match(strings.trash) 
			if n ~= nil and k ~= nil then 
				if n == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then 
					if tonumber(srp_ini.inventory[u8(k)]) ~= nil then 
						srp_ini.inventory[u8(k)] = 0                                                         		    		
					end 
				end
			end 
		end
		if col == strings.color.adr and text:match(strings.adr) then 
			if tonumber(srp_ini.inventory.adrenaline) ~= nil and tonumber(srp_ini.inventory.adrenaline) > 0 then 
				srp_ini.inventory.adrenaline = tonumber(srp_ini.inventory.adrenaline) - 1                                                               
			end 
		end
		if col == strings.color.gribeat and text:match(strings.gribeat) then 
			local k = text:match(strings.gribeat) 
			if tonumber(k) ~= nil then 
				srp_ini.inventory.cookedmushroom = tonumber(k)                                                 										               
			end
		end
		if col == strings.color.psiho and text:match(strings.psiho) then 
			local k = text:match(strings.psiho) 
			if tonumber(k) ~= nil then 
				srp_ini.inventory.psychoheal = tonumber(k)                                                                                                     
			end 
		end
		if col == strings.color.roul and text:match(strings.roul) then 
			local n, k = text:match(strings.roul) 
			if n ~= nil and tonumber(k) ~= nil then 
				if tonumber(srp_ini.inventory[u8(n)]) ~= nil then 
					srp_ini.inventory[u8(n)]           		 = tonumber(k) 												                                                        
				end 
			end 
		end
		if col == strings.color.repair1	and text:match(strings.repair1) then 
			local k = text:match(strings.repair1) 
			if tonumber(k) ~= nil then 
				srp_ini.inventory.repairkit = tonumber(k)              																						
			end 
		end
		if col == strings.color.repair2	and text:match(strings.repair2) 
			then srp_ini.inventory.repairkit = 0                                                                                                               
		end                                                    							
		if col == strings.color.reward then
			if text:match(strings.reward) then
				local rewards = {
					["Психохил"] = "психохил", ["Комплект «автомеханик»"] = "ремкомплект",
					["Адреналин"] = "адреналин", ["Ключи от камеры"] = "ключ",
					["Набор для взлома"] = "взлом", ["Защита от насильников"] = "насильник",
					["Готовые грибы"] = "готов", ["Балаклава"] = "балаклав"
				}
				local list = string.split(text:match(strings.reward), u8:decode"/")
				for _, l in ipairs(list) do
					for k, v in pairs(rewards) do
						local amount, r = l:match("(%d+) (.*)")
						if tonumber(amount) ~= nil and r:match(u8:decode(v)) then srp_ini.inventory[k] = tonumber(srp_ini.inventory[k]) + tonumber(amount) end
					end
				end
			end
		end
		if srp_ini.bools.robbing then
			if col == strings.color.stolen and text:match(strings.stolen) then 				   
				script.sendMessage("Украл предмет, пытаюсь выйти из дома") 
				enterhouse() 
				return false 
			end
			if col == strings.color.breaken and text:match(strings.breaken) then 
				isRobbing = false script.sendMessage("Дверь вскрыта ломом, пытаюсь зайти в дом") 
				if tonumber(srp_ini.inventory.scrap) ~= nil then 
					srp_ini.inventory.scrap = tonumber(srp_ini.inventory.scrap) - 1 
				end 
				enterhouse() 
				return false 
			end
			if col == strings.color.open and text:match(strings.open) then 
				isRobbing = false 
				script.sendMessage("Дверь открыта без лома, пытаюсь зайти в дом") 
				enterhouse() 
				return false 
			end
			if col == strings.color.put and text:match(strings.put) then 
				local loaded, maxloaded = text:match(strings.put) 
				if tonumber(loaded) ~= nil and tonumber(maxloaded) ~= nil then 
					if tonumber(loaded) < tonumber(maxloaded) then 
						script.sendMessage("Положил награбленное в фургон: " .. loaded .. "/" .. maxloaded .. ", пытаюсь зайти в дом") 
						enterhouse() 
						return false 
					end 
				end 
			end
			if col == strings.color.rob and text:match(strings.rob) then 
				isRobbing = true 
				if tonumber(srp_ini.inventory.balaclava) ~= nil then 
					if tonumber(srp_ini.inventory.balaclava) == 0 then 
						script.sendMessage("У вас нету балаклав, срочно едьте покупайте в ближайшем 24/7") 
					end 
				end
			end
		end
		if col == strings.color.donerob and text:match(strings.donerob) then 
			isRobbing = false 
			srp_ini.values.robbing = os.time() 
		end
		if col == strings.color.donetheft and text:match(strings.donetheft) then 
			srp_ini.values.cartheft = os.time() 						
		end
		if srp_ini.bools.lomka then
			if col == strings.color.stay and text:match(strings.stay) then 
				if isLomka then 
					usedrugs() 
				end 
			end
			if col == strings.color.wasAFK and text:match(strings.wasAFK) and isLomka then 
				usedrugs()
			end
			if col == strings.color.lomka and text:match(strings.lomka) then
				isLomka = true 
				usedrugs() 
			end
		end
		if srp_ini.bools.spam then
			if col == strings.color.spam and text:match(strings.spam) then
				local smsid = text:match(strings.spam)
				chatManager.addMessageToQueue('/t ' .. smsid .. ' СМС попало в спам, попробуй ещё раз написать через 30 сек')
			end
		end
		if col == strings.color.noequest and text:match(strings.noequest) then noequest = true end
		local slet = text:match(strings.slet)
		if slet ~= nil then
			srp_ini.values.house = slet:match("(%d%d%d%d%/%d%d%/%d%d %d%d%:%d%d)")
			whenhouse()
		end
		if col == strings.color.accepttaxi then
			local who, whom = text:match(strings.accepttaxi)
			if who ~= nil and whom ~= nil then
				if who == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
					currentClient = whom
				end
			end
		end
		if col == strings.color.full24 then
			-- if text:match(strings.full24sec) then
			-- end
			if text:match(strings.full24) then
				if not gekauft then gekauft = true return end
			end
		end
		inicfg.save(srp_ini, settings)
	end
end

function ev.onShowDialog(dialogid, style, title, button1, button2, text)
	if script.loaded then
		if srp_ini.bools.drugs then
			if dialogid == strings.dialog.narko.id and style == strings.dialog.narko.style and title == strings.dialog.narko.title then
				for v in text:gmatch("[^\n]+") do
					if v:match(strings.dialog.narko.str) then
						local faktor = tonumber(v:match(strings.dialog.narko.str))
						drugtimer = math.ceil(drugtimer * faktor)
					end
				end
				if isBoost then 
					sampCloseCurrentDialogWithButton(0) 
					isBoost = false
					checkedBoost = true
					return false 
				end
			end
		end
		if srp_ini.bools.equest then
			if dialogid == strings.dialog.quest.id and style == strings.dialog.quest.style and title:match(strings.dialog.quest.title) then
				local date = title:match(strings.dialog.quest.title)
				local datetime = {}
				datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min = string.match(date,"(%d%d%d%d)%/(%d%d)%/(%d%d) (%d%d)%:(%d%d)")
				datetime.hour = tostring(tonumber(datetime.hour) + tonumber(srp_ini.values["Разница часовых поясов"]))
				srp_ini.questupdating = os.time(datetime)
				srp_ini.task = {}
				local list = string.split(text, "\n")
				for k, v in ipairs(list) do
					local n, s = v:match(strings.dialog.quest.str)
					if n ~= nil and n ~= "" then
						local name = u8(n):gsub("%.", "!")
						srp_ini.task[name] = s == u8:decode"[Выполнено]" and true or false
					end
				end
				if isQuest then 
					sampCloseCurrentDialogWithButton(0) 
					isQuest = false 
					checkedQuest = true
					return false 
				end
			end
			if dialogid == strings.dialog.description.id and style == strings.dialog.description.style and title == strings.dialog.description.title then
				local name, description
				local list = string.split(text, "\n")
				for k, v in ipairs(list) do
					if v:match(strings.dialog.description.str1) then
						name = list[k + 1]:match(strings.dialog.description.str3)
						name = name:gsub("%.", "!")
					end
					if v:match(strings.dialog.description.str2) then
						description = list[k + 1]:match(strings.dialog.description.str3)
					end
				end
				if name ~= nil and description ~= nil then srp_ini.description[u8(name)] = u8(description) end
			end
		end
		if dialogid == strings.dialog.inventory.id and style == strings.dialog.inventory.style and title == strings.dialog.inventory.title then
			srp_ini.inventory = {}
			for k, v in pairs(srp_ini.inventory) do
				if text:match(u8:decode(k)) then
					local amount = tonumber(text:match(u8:decode(k) .. "%s(%d+) %/ %d+"))
					srp_ini.inventory[k] = amount ~= nil and amount or 1
				end
			end
			for k, v in pairs(srp_ini.inventory) do if tonumber(srp_ini.inventory[k]) == nil then srp_ini.inventory[k] = 0 end end
			if isInventory then 
				sampCloseCurrentDialogWithButton(0) 
				isInventory = false 
				checkedInventory = true
				return false 
			end
		end
		if dialogid == strings.dialog.login.id and style == strings.dialog.login.style and title:match(strings.dialog.login.title) and text:match(strings.dialog.login.str) then
			if srp_ini.bools.autologin then
				lua_thread.create(function()
					local A_Index = 0
					while true do
						if A_Index == 5 then break end
						local str = sampGetChatString(99 - A_Index)
						if str:match(strings.connected) then
							if srp_ini.values.password == nil or srp_ini.values.password == '' then script.sendMessage("Автологина не будет, пароль не задан в меню!") return end
							sampSendDialogResponse(dialogid, 1, 0, srp_ini.values.password)
							return false
						end
						A_Index = A_Index + 1
					end
				end)
			end
		end
		if srp_ini.bools.autorent then
			if indexof(dialogid, strings.dialog.autorent.id) and strings.dialog.autorent.style == 0 and title:match(strings.dialog.autorent.title) then
				local dialid = dialogid
				local cost = tonumber(text:match(strings.dialog.autorent.str))
				local ncost = tonumber(srp_ini.values.autorent)
				if ncost ~= nil and cost ~= nil then
					if cost <= ncost then
						rent = cost
						sampSendDialogResponse(dialid, 1, 0, '')
						return false
						else
						script.sendMessage("Транспорт не будет арендован, так как цена выше лимита")
					end
				end
			end
		end
		if srp_ini.bools.repairkits then
			if needtobuy and dialogid == 16 and style == 4 and title == u8:decode"Магазин 24/7" and button1 == u8:decode"Купить" and button2 == u8:decode"Отмена" then
				local rem = tonumber(text:match(u8:decode"Комплект %«автомеханик%»%s+%[%$(%d+)%]"))
				if rem ~= nil and not gekauft then
					if tonumber(srp_ini.values.repairkits) ~= nil then
						if rem <= tonumber(srp_ini.values.repairkits) then
							lua_thread.create(function() wait(200) sampSendDialogResponse(16, 1, 8, "") sampCloseCurrentDialogWithButton(0) end) return false
							else
							script.sendMessage("Покупки ремкомплектов не будет, цена выше лимита. Измените лимит (если хотите) и перезайдите в магазин")
						end
					end
				end
				needtobuy = false
			end
		end
		inicfg.save(srp_ini, settings)
	end
end

function ev.onDisplayGameText(style, time, str)
	if script.loaded then
		if srp_ini.bools.autorefillcanister and str == "~r~Fuel has ended" and style == 4 and time == 3000 then -- заправка канистрой
			chatManager.addMessageToQueue("/fillcar")
		end
	end
end

function ev.onCreate3DText(id, color, position, distance, testLOS , attachedPlayerId, attachedVehicleId, text)
	if script.loaded then
		lua_thread.create(function()
			local cost = tonumber(text:match(strings.gasstation))
			local ncost = tonumber(srp_ini.values.autofill)
			if ncost ~= nil and cost ~= nil then
				if cost <= ncost then
					if srp_ini.bools.autocanister then chatManager.addMessageToQueue("/get fuel") end
					if srp_ini.bools.autofill then if isCharInAnyCar(PLAYER_PED) and getDriverOfCar(storeCarCharIsInNoSave(PLAYER_PED)) == PLAYER_PED then wait(1300) chatManager.addMessageToQueue("/fill") end end
					else
					script.sendMessage("Покупки/заправки не будет, так как цена выше лимита")
				end
			end
		end)
	end
end

function ev.onPlayerQuit(id, reason)
	if script.loaded then
		if srp_ini.bools.quit and sampGetCharHandleBySampPlayerId(id) then
			local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)) .. "}"
			local reasons = {[0] = 'рестарт/краш', [1] = '/q', [2] = 'кик'}
			script.sendMessage("Игрок " .. clist .. sampGetPlayerNickname(id) .. "[" .. tostring(id) .. "] {FFFAFA}вышел с игры. Причина: {FF0000}" .. reasons[reason] .. ".")
		end
	end
end

function ev.onPlayerChatBubble(playerId, color, distance, duration, message)
	if script.loaded then
		if srp_ini.bools.psychoheal and (message == u8:decode"Употребил психохил" or message == u8:decode"Употребила психохил") then
			local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(playerId), 0xFFFFFF)) .. "}"
			script.sendMessage("Игрок " .. clist .. sampGetPlayerNickname(playerId) .. "[" .. playerId .. "] {FFFAFA}- употребил психохил")
		end
		if srp_ini.bools.squad then
			local afk = tonumber(message:match(strings.afksec))
			if afk ~= nil then
				for k, v in ipairs(smem) do
					if v.id == playerId then
						smem[k].afk = afk
					end
				end
			end
		end
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
					afk = 0,
					color = join_argb(230.0, r, g, b),
					colorns = join_argb(150.0, r, g, b),
				})
				saveid[id] = #smem
			end
		end
		--data.position.x = 1488
		--data.position.y = 1488
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
			--[[if sampTextdrawIsExists(id) then
				sampTextdrawSetPos(id, 1488, 1488)
			end]]
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
					afk = 0,
					color = join_argb(230.0, r, g, b),
					colorns = join_argb(150.0, r, g, b),
				})
				saveid[id] = #smem
			end
		end
	end
end

function usedrugs(arg)
	lua_thread.create(function()
		if srp_ini.bools.lomka and isLomka and srp_ini.bools.withoutcops then 
			for _, v in ipairs(getAllChars()) do 
				if v ~= PLAYER_PED then 
					if copskins[getCharModel(v)] ~= nil and sampGetPlayerIdByCharHandle(v) then 
						local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
						local cX, cY, cZ = getCharCoordinates(v) 
						if math.ceil(math.sqrt( ((myX-cX)^2) + ((myY-cY)^2) + ((myZ-cZ)^2))) <= 35 and isLineOfSightClear(myX, myY, myZ, cX, cY, cZ, true, false, false, true, false) then 
							script.sendMessage("Наркотики не будут употреблены, возле вас стоит коп!")
							return 
						end
					end
				end
			end
		end
		if tonumber(arg) == nil then chatManager.addMessageToQueue('/usedrugs') else chatManager.addMessageToQueue('/usedrugs ' .. arg) end
	end)
end

function checkdialogs()
	script.sendMessage("Начинаю собирать информацию из диалогов...")
	if srp_ini.bools.drugs then isBoost = true checkedBoost = false chatManager.addMessageToQueue("/boostinfo") else checkedBoost = true end -- проверка множителя КД нарко
	if srp_ini.bools.equest then isQuest = true checkedQuest = false chatManager.addMessageToQueue("/equest") else checkedQuest = true end -- проверка ежедневных квестов
	isInventory = true checkedInventory = false chatManager.addMessageToQueue("/inventory") -- проверка предметов инвентаря
end

function getcars()
	local chandles = {}
	local tableIndex = 1
	local vehicles = getAllVehicles()
	local fcarhandle = isCharInAnyCar(PLAYER_PED) and storeCarCharIsInNoSave(PLAYER_PED) or 12
	for k, v in pairs(vehicles) do
		if doesVehicleExist(v) and v ~= fcarhandle then table.insert(chandles, tableIndex, v) tableIndex = tableIndex + 1 end
	end
	
	if table.maxn(chandles) == 0 then return nil else return chandles end
end

function findsquad()
	for i = 0, 3000 do
		if sampTextdrawIsExists(i) and sampTextdrawGetString(i):match(u8:decode"SQUAD") then
			local x, y = sampTextdrawGetPos(i)
			rCache.pos.x, rCache.pos.y = convertGameScreenCoordsToWindowScreenCoords(x == 1488 and x - 1485 or x + 1, y == 1488 and y - 1291 or y + 25)
			rCache.enable = true
			td = i
			smem = {}
			saveid = {}
			local list = sampTextdrawGetString(i):split("~n~")
			table.remove(list, 1)
			for k, v in ipairs(list) do
				if v == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then currentNick = v end
				local id = sampGetPlayerIdByNickname(v)
				if id then
					local color = sampGetPlayerColor(id)
					local a, r, g, b = explode_argb(color)
					table.insert(smem, {
						id = id,
						name = v,
						afk = 0,
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

function ev.onTextDrawHide(id)
	if id == td then
		rCache.enable = false
		smem = {}
		saveid = {}
	end
end

function isCarTaxi(vehicleHandle) -- взято из taximate.lua
	local result, id = sampGetVehicleIdByCarHandle(vehicleHandle)
	if result then
		for textId = 0, 2048 do
			if sampIs3dTextDefined(textId) then
				local string, _, _, _, _, _, _, _, vehicleId =
				sampGet3dTextInfoById(textId)
				if string.find(string, strings.taxi) and vehicleId == id then
					return true
				end
			end
		end
	end
	
	return false
end

function getClosestPlayersId()
	local players = {}
	local res, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local pHandles = getAllChars()
	local bool = false
	for k, v in pairs(pHandles) do
		local result, id = sampGetPlayerIdByCharHandle(v) -- получить samp-ид игрока по хендлу персонажа
		if result and id ~= myid then
			players[sampGetPlayerNickname(id)] = v
			bool = true
		end
	end
	
	if bool then return players end
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
				local distance = math.ceil(math.sqrt( ((myX-cX)^2) + ((myY-cY)^2) + ((myZ-cZ)^2)))
				if (getCarHealth(car) == 300 or (isCarTireBurst(car, 0) or isCarTireBurst(car, 1) or isCarTireBurst(car, 2) or isCarTireBurst(car, 3) or isCarTireBurst(car, 4))) and distance <= 5 then
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
				local distance = math.ceil(math.sqrt( ((myX-cX)^2) + ((myY-cY)^2) + ((myZ-cZ)^2)))
				if (getCarHealth(car) > 300 and not isCarTireBurst(car, 0) and not isCarTireBurst(car, 1) and not isCarTireBurst(car, 2) and not isCarTireBurst(car, 3) and not isCarTireBurst(car, 4)) or distance > 5 then
					local key = indexof(1, CTaskArr[1])
					if key ~= false then CTaskArr[2][key] = os.time() - 100 end
				end
			end
		end
		
		if currentClient ~= nil then
			local players = getClosestPlayersId()
			if players ~= nil then
				if players[currentClient] ~= nil then
					local clientHandle = players[currentClient]
					if isCharInAnyCar(PLAYER_PED) then
						fcarHandle = storeCarCharIsInNoSave(PLAYER_PED)
						if getDriverOfCar(fcarHandle) == PLAYER_PED then
							if isCarTaxi(fcarHandle) then
								local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
								local cX, cY, cZ = getCharCoordinates(clientHandle)
								local distance = math.ceil(math.sqrt( ((myX-cX)^2) + ((myY-cY)^2) + ((myZ-cZ)^2)))
								if distance <= 20 then
									CTaskTaxiClear()
									currentClientRP = currentClient:gsub("_", " ")
									table.insert(CTaskArr[1], 7)
									table.insert(CTaskArr[2], os.time())
									table.insert(CTaskArr[3], currentClientRP)
									currentClient = nil
								end
							end
						end
					end
				end
			end
		end
		
		sortCarr() --### Очистка массива контекстной клавиши, назначение нового контекстного действия
	end
end

function ct()
	lua_thread.create(function()
		local key = CTaskArr["CurrentID"]
		if key == 0 then script.sendMessage("Событие не найдено") return end
		if isKeyDown(makeHotKey("Контекстная клавиша")[1]) then
			sortCarr()
			wait(300)
			if isKeyDown(makeHotKey("Контекстная клавиша")[1]) then goto done end
		end
		
		if CTaskArr[1][key] == 1 then chatManager.addMessageToQueue("/repairkit") end
		if CTaskArr[1][key] == 2 then local nick = sampGetPlayerNickname(CTaskArr[3][key]):gsub("_", " ") if nick ~= nil then chatManager.addMessageToQueue("/rep " .. CTaskArr[3][key] .. " ДМщик, следите за ним") else script.sendMessage("ДМщик не в игре") end end
		if CTaskArr[1][key] == 3 then medcall(CTaskArr[3][key]) end
		if CTaskArr[1][key] == 4 then chatManager.addMessageToQueue("Куда едем?") end
		if CTaskArr[1][key] == 5 then chatManager.addMessageToQueue("Хорошо, выезжаем") end
		if CTaskArr[1][key] == 6 then chatManager.addMessageToQueue("Удачи!") end
		if CTaskArr[1][key] == 7 then chatManager.addMessageToQueue("/s " .. CTaskArr[3][key] .. " садись в такси!") end
		
		::done::
		table.remove(CTaskArr[1], key)
		table.remove(CTaskArr[2], key)
		table.remove(CTaskArr[3], key)
		CTaskArr["CurrentID"] = 0
		while isKeyDown(0x5D) do wait(0) end
	end)
end

function onfoot()
	while true do
		wait(0)
		if isCharOnFoot(PLAYER_PED) then
			if needtohold then setGameKeyState(1, (isCharInWater(PLAYER_PED) or isKeyDown(vkeys.VK_RBUTTON)) and -128 or -256) end
		end
	end
end

function setclist()
	lua_thread.create(function()
		local res, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if not res then script.sendMessage("Не удалось узнать свой ID") return end
		local myclist = clists.numbers[sampGetPlayerColor(myid)]
		if myclist == nil then script.sendMessage("Не удалось узнать номер своего цвета") return end
		if myclist == 0 then
			if tonumber(srp_ini.values.clist) == 0 then script.sendMessage("На вас уже нету клиста!") return end
			chatManager.addMessageToQueue("/clist " .. srp_ini.values.clist .. "")
			wait(1300)
			local newmyclist = clists.numbers[sampGetPlayerColor(myid)]
			if newmyclist == nil then script.sendMessage("Не удалось узнать номер своего цвета") return end
			if newmyclist ~= tonumber(srp_ini.values.clist) then script.sendMessage("Клист не был надет") return end
			else
			chatManager.addMessageToQueue("/clist 0")
			wait(1300)
			local newmyclist = clists.numbers[sampGetPlayerColor(myid)]
			if newmyclist == nil then script.sendMessage("Не удалось узнать номер своего цвета") return end
			if newmyclist ~= 0 then script.sendMessage("Клист не был снят") return end
		end
	end)
end

function eject()
	if isCharInAnyCar(PLAYER_PED) then
		lua_thread.create(function()
			local carhandle1 = storeCarCharIsInNoSave(PLAYER_PED)
			if isKeyDown(makeHotKey("eject")[1]) then
				wait(600)
				if isKeyDown(makeHotKey("eject")[1]) then
					sampSetChatInputEnabled(true)
					sampSetChatInputText("/eject ")
					return
				end
			end
			for _, v in ipairs(getAllChars()) do
				if v ~= PLAYER_PED then
					if isCharInAnyCar(v) then
						local carhandle2 = storeCarCharIsInNoSave(v)
						if carhandle1 == carhandle2 then
							local res, id = sampGetPlayerIdByCharHandle(v)			
							if res then
								local isAFK = sampIsPlayerPaused(id)
								if not isAFK then
									chatManager.addMessageToQueue("/eject " .. id)
									else
									local nick = sampGetPlayerNickname(id)
									script.sendMessage("Не удалось выкинуть игрока " .. nick .. "[" .. id .. "] - сейчас АФК!")
								end
							end
						end
					end
				end
			end
		end)
		else 
		script.sendMessage("Вы не в транспорте!")
		return false
	end
end

function binder(i)
	if i ~= nil then
		if tonumber(i) ~= nil then
			if binder_ini.list[i] ~= nil then
				local b = decodeJson(binder_ini.list[i])
				if b.msg ~= nil then
					local empty, kol = 0, 0
					for k, v in ipairs(b.msg) do
						kol = kol + 1
						if v ~= "" then
							chatManager.addMessageToQueue(insertvars(v, i))
							else
							empty = empty + 1
						end
					end
					if empty ~= 0 then script.sendMessage("В бинде №" .. i .. (empty ~= 0 and " обнаружено пустых строк: " .. empty or " обнаружена пустая строка")) end
					if kol   == 0 then script.sendMessage("В бинде №" .. i .. " отсутствуют строки") end
					return 
				end
			end
		end
	end
end

function insertvars(str, bind)
	local str = tostring(str)
	if str:match("@params@") then 
		if bind ~= nil then
			if tonumber(bind) ~= nil then
				if binder_ini.list[bind] ~= nil then
					if argument[bind] ~= nil then
						str = str:gsub("@params@", u8(tostring(argument[bind])))
						else
						script.sendMessage("Аргумент команды бинда №" .. bind .. ' не задан!')
					end
				end
			end
		end
	end
	if str:match("@param%d+@") then
		if bind ~= nil then
			if tonumber(bind) ~= nil then
				if binder_ini.list[bind] ~= nil then
					if argument[bind] ~= nil then
						local params = {}
						for s in string.gmatch(argument[bind], "[^ ]+") do
							table.insert(params, s)
						end
						for i = 1, #params do
							local arg = tonumber(str:match("@param(%d+)@"))
							if arg == i then
								if tostring(params[i]) ~= nil then
									str = str:gsub("@param" .. i .. "@", u8(tostring(params[i])))
								end
							end
						end
					end
				end
			end
		end
	end
	if str:match("@myid@") then str = str:gsub("@myid@", tostring(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))) end
	if str:match("@mynick@") then str = str:gsub("@mynick@", sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))) end
	if str:match("@myrpnick@") then str = str:gsub("@myrpnick@", sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " ")) end
	if str:match("@myname@") then str = str:gsub("@myname@", sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):match("(.*)%_.*")) end
	if str:match("@mysurname@") then str = str:gsub("@mysurname@", sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):match(".*%_(.*)")) end
	if str:match("@date@") then str = str:gsub("@date@", os.date("%d.%m.%Y")) end
	if str:match("@hour@") then str = str:gsub("@hour@", os.date("%H")) end
	if str:match("@min@") then str = str:gsub("@min@", os.date("%M")) end
	if str:match("@sec@") then str = str:gsub("@sec@", os.date("%S")) end
	if str:match("@myclist@") then str = str:gsub("@myclist@", tostring(clists.numbers[sampGetPlayerColor(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))])) end
	if str:match("@mainclist@") then str = str:gsub("@mainclist@", tostring(srp_ini.values.clist)) end
	if str:match("@kv@") then str = str:gsub("@kv@", currentSector()) end
	return str
end

function enterhouse()
	if getActiveInterior() == 0 then 
		for _, v in pairs(getAllObjects()) do
			local _, tX, tY, tZ = getObjectCoordinates(v)
			local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
			local model = getObjectModel(v)
			if (model == 1272 or model == 19523) and math.ceil(math.sqrt( ((myX-tX)^2) + ((myY-tY)^2) + ((myZ-tZ)^2))) <= 3 then
				local carhandles = getcars() -- получаем все машины вокруг
				if carhandles ~= nil then -- если машина обнаружена
					for k, v in pairs(carhandles) do -- перебор всех машин в прорисовке
						if doesVehicleExist(v) then
							local idcar = getCarModel(v) -- получаем ид модельки
							local myX, myY, myZ = getCharCoordinates(PLAYER_PED) -- получаем свои координаты
							local cX, cY, cZ = getCarCoordinates(v) -- получаем координаты машины
							local distance = math.ceil(math.sqrt( ((myX-cX)^2) + ((myY-cY)^2) + ((myZ-cZ)^2))) -- расстояние между мной и машиной
							local cars = {[482] = "Burrito", [498] = "Boxville", [609] = "Boxville"} -- ид фургонов ограбы домов
							if sampGetDialogCaption():match(u8:decode"Дом занят") then sampCloseCurrentDialogWithButton(0) end
							if cars[idcar] ~= nil and distance <= 30 and isRobbing then
								for _, l in pairs(getAllObjects()) do
									local _, bX, bY, bZ = getObjectCoordinates(l)
									local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
									local bmodel = getObjectModel(l)
									local distance = math.ceil(math.sqrt( ((myX-bX)^2) + ((myY-bY)^2) + ((myZ-bZ)^2))) -- расстояние между мной и объектом
									if bmodel == 19801 and distance < 1.5 then -- если объект Балаклава и расстояние меньше 1.5 м
										script.sendMessage("Пытаюсь вскрыть дом")
										chatManager.addMessageToQueue("/rhouse")
										return
									end
								end
								if tonumber(srp_ini.inventory.balaclava) ~= nil then if tonumber(srp_ini.inventory.balaclava) > 0 then chatManager.addMessageToQueue("/robmask") return else script.sendMessage('У вас нет балаклавы, если желаете вскрыть дом - /rhouse') return end end
							end
						end
					end
					chatManager.addMessageToQueue("/enter")
					return
				end
			end
		end
		script.sendMessage("Возле вас нету пикапа дома, подойдите ближе")
		else
		chatManager.addMessageToQueue("/exit")
	end
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
	
	for k, v in ipairs(arr) do -- удаление устаревших ID
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
		end
		
		if CTaskArr["CurrentID"] == 0 then for k, v in pairs(lastrarr) do wait(0) CTaskArr["CurrentID"] = v break end end
	end
	
	if CTaskArr["CurrentID"] < 0 or CTaskArr[1][CTaskArr["CurrentID"]] == nil then CTaskArr["CurrentID"] = 0 end
end

function CTaskTaxiClear()
	for k, v in ipairs(CTaskArr[1]) do
		if v == 4 or v == 5 or v == 6 or v == 7 then
			table.remove(CTaskArr[1], k)
			table.remove(CTaskArr[2], k)
			table.remove(CTaskArr[3], k)
		end
	end
end

function cmd_setoverlay()
	if not SetMode then
		chatManager.addMessageToQueue("/mm")
		script.sendMessage("Начата настройка местоположения элементов overlay")
		script.sendMessage("Перетащите элементы в нужное место и пропишите /setov - произойдет сохранение координат")
		script.sendMessage("Для сброса всех координат зажмите среднюю кнопку мыши")
		srp_ini.bools.date = true
		srp_ini.bools.nick = true
		srp_ini.bools.ping = true
		srp_ini.bools.drugs = true
		srp_ini.bools.event = true
		srp_ini.bools.stream = true
		srp_ini.bools.status = true
		srp_ini.bools.squad = true
		srp_ini.bools.equest = true
		srp_ini.bools.inventory = true
		srp_ini.bools.kd = true
		SetMode, SetModeFirstShow = true, true
		imgui.ShowCursor, imgui.LockPlayer = true, true
		
		else
		
		srp_ini.overlay.dateX, srp_ini.overlay.dateY = soverlay.date.x, soverlay.date.y
		srp_ini.overlay.nickX, srp_ini.overlay.nickY = soverlay.nick.x, soverlay.nick.y
		srp_ini.overlay.pingX, srp_ini.overlay.pingY = soverlay.ping.x, soverlay.ping.y
		srp_ini.overlay.narkoX, srp_ini.overlay.narkoY = soverlay.drugs.x, soverlay.drugs.y
		srp_ini.overlay.eventX, srp_ini.overlay.eventY = soverlay.event.x, soverlay.event.y
		srp_ini.overlay.streamX, srp_ini.overlay.streamY = soverlay.stream.x, soverlay.stream.y
		srp_ini.overlay.statusX, srp_ini.overlay.statusY = soverlay.status.x, soverlay.status.y
		srp_ini.overlay.squadX, srp_ini.overlay.squadY = soverlay.squad.x, soverlay.squad.y
		srp_ini.overlay.deilyX, srp_ini.overlay.deilyY = soverlay.equest.x, soverlay.equest.y
		srp_ini.overlay.inventoryX, srp_ini.overlay.inventoryY = soverlay.inventory.x, soverlay.inventory.y
		srp_ini.overlay.robbingX, srp_ini.overlay.robbingY = soverlay.robbing.x, soverlay.robbing.y
		
		script.sendMessage("Местоположения всех элементов успешно задано")
		srp_ini.bools.date = togglebools.date.v and true or false
		srp_ini.bools.nick = togglebools.nick.v and true or false
		srp_ini.bools.ping = togglebools.ping.v and true or false
		srp_ini.bools.drugs = togglebools.drugs.v and true or false
		srp_ini.bools.event = togglebools.event.v and true or false
		srp_ini.bools.stream = togglebools.stream.v and true or false
		srp_ini.bools.status = togglebools.status.v and true or false
		srp_ini.bools.squad = togglebools.squad.v and true or false
		srp_ini.bools.equest = togglebools.equest.v and true or false
		srp_ini.bools.inventory = togglebools.inventory.v and true or false
		srp_ini.bools.kd = togglebools.kd.v and true or false
		inicfg.save(srp_ini, settings)
		SetMode, SetModeFirstShow, imgui.ShowCursor, imgui.LockPlayer = false, false, false, false
	end
end

function cmd_flood(arg)
	isFlood = not isFlood
	if not isFlood then script.sendMessage("Флуд сообщением завершён") chatManager.initQueue() return end
	if arg ~= nil and arg ~= "" then
		script.sendMessage("Начинаю флудить сообщением: " .. arg)
		lua_thread.create(function()
			while isFlood do
				wait(0)
				chatManager.addMessageToQueue(u8(arg))
			end
		end)
	end
end

function medcall(hospital)
	local fc = u8:decode"Организации"
	local sc = u8:decode"Меню"
	lua_thread.create(function()
		wait(0)
		chatManager.addMessageToQueue("/dir")
		while not sampIsDialogActive() do wait(0) end
		sampSendDialogResponse(sampGetCurrentDialogId(), 1, 2)
		while sampGetDialogCaption() ~= fc do wait(0) end
		wait(100)
		sampCloseCurrentDialogWithButton(1)
		while sampGetDialogCaption() ~= sc do wait(0) end
		local med = sampGetDialogText()
		sampCloseCurrentDialogWithButton(0) wait(100) sampCloseCurrentDialogWithButton(0) wait(100) sampCloseCurrentDialogWithButton(0)
		for v in med:gmatch('[^\n]+') do
			local n, fname, sname, id, numb, afk = v:match("%[(%d+)%] (%a+)_(%a+)%[(%d+)%]	(%d+)(.*)")
			if n ~= nil then
				chatManager.addMessageToQueue("/t " .. id .. " Нужен медик в " .. hospital .. "")
			end
		end
	end)
end

function whenhouse()
	if srp_ini.values.house ~= nil then 
		if srp_ini.values.house ~= 0 then
			local datetime = {}
			datetime.year, datetime.month, datetime.day, hour = srp_ini.values.house:match("(%d%d%d%d)%/(%d%d)%/(%d%d) (%d%d%:%d%d)")
			script.sendMessage("Недвижимость слетит через " .. math.floor((os.difftime(os.time(datetime), os.time())) / 3600 / 24) .. " дней | " .. srp_ini.values.house)
			else
			script.sendMessage("Дата слета неизвестна, оплатите квартплату в банкомате")
			return
		end
		else
		script.sendMessage("Произошла ошибка, перезагрузите скрипт")
		return
	end
end

function cmd_st(sparams)
	local hour = tonumber(sparams)
	if hour ~= nil and hour >= 0 and hour <= 23 then
		time = hour
		patch_samp_time_set(true)
		else
		patch_samp_time_set(false)
		time = nil
	end
end

function patch_samp_time_set(enable)
	if enable and default == nil then
		default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
		writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
		elseif enable == false and default ~= nil then
		writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
		default = nil
	end
end

function cmd_sw(sparams)
	local weather = tonumber(sparams)
	if weather ~= nil and weather >= 0 and weather <= 45 then
		forceWeatherNow(weather)
	end
end

function currentSector()
	local KV = {
		[1] = "А",
		[2] = "Б",
		[3] = "В",
		[4] = "Г",
		[5] = "Д",
		[6] = "Ж",
		[7] = "З",
		[8] = "И",
		[9] = "К",
		[10] = "Л",
		[11] = "М",
		[12] = "Н",
		[13] = "О",
		[14] = "П",
		[15] = "Р",
		[16] = "С",
		[17] = "Т",
		[18] = "У",
		[19] = "Ф",
		[20] = "Х",
		[21] = "Ц",
		[22] = "Ч",
		[23] = "Ш",
		[24] = "Я",
	}
	local X, Y, Z = getCharCoordinates(playerPed)
	X = math.ceil((X + 3000) / 250)
	Y = math.ceil((Y * - 1 + 3000) / 250)
	Y = u8:decode(KV[Y])
	local KVX = (Y .. "-" .. X)
	return KVX
end

function ev.onSendChat(message)
	chatManager.lastMessage = message
	chatManager.updateAntifloodClock()
	if script.loaded then
		if srp_ini.bools.variables then
			message = insertvars(message)
			return {message}
		end
	end
end

function ev.onSendCommand(message)
	chatManager.lastMessage = message
	chatManager.updateAntifloodClock()
	if script.loaded then
		if srp_ini.bools.variables then
			message = insertvars(message)
			return {message}
		end
	end
end
-------------------------------------------[ChatManager -> взято из donatik.lua]------------------------------------------
chatManager = {}
chatManager.messagesQueue = {}
chatManager.messagesQueueSize = 1000
chatManager.antifloodClock = os.clock()
chatManager.lastMessage = ""
chatManager.antifloodDelay = 0.8

function chatManager.initQueue() -- очистить всю очередь сообщений
	for messageIndex = 1, chatManager.messagesQueueSize do
		chatManager.messagesQueue[messageIndex] = {
			message = "",
		}
	end
end

function chatManager.addMessageToQueue(string, _nonRepeat) -- добавить сообщение в очередь
	local isRepeat = false
	local nonRepeat = _nonRepeat or false
	
	if nonRepeat then
		for messageIndex = 1, chatManager.messagesQueueSize do
			if string == chatManager.messagesQueue[messageIndex].message then
				isRepeat = true
			end
		end
	end
	
	if not isRepeat then
		for messageIndex = 1, chatManager.messagesQueueSize - 1 do
			chatManager.messagesQueue[messageIndex].message = chatManager.messagesQueue[messageIndex + 1].message
		end
		chatManager.messagesQueue[chatManager.messagesQueueSize].message = string
	end
end

function chatManager.checkMessagesQueueThread() -- проверить поток очереди сообщений
	while true do
		wait(0)
		for messageIndex = 1, chatManager.messagesQueueSize do
			local message = chatManager.messagesQueue[messageIndex]
			if message.message ~= "" then
				if string.sub(chatManager.lastMessage, 1, 1) ~= "/" and string.sub(message.message, 1, 1) ~= "/" then
					chatManager.antifloodDelay = chatManager.antifloodDelay + 0.5
				end
				if os.clock() - chatManager.antifloodClock > chatManager.antifloodDelay then
					
					local sendMessage = true
					
					local command = string.match(message.message, "^(/[^ ]*).*")
					
					if sendMessage then
						chatManager.lastMessage = u8:decode(message.message)
						sampSendChat(u8:decode(message.message))
					end
					
					message.message = ""
				end
				chatManager.antifloodDelay = 0.8
			end
		end
	end
end

function chatManager.updateAntifloodClock() -- обновить задержку из-за определённых сообщений
	chatManager.antifloodClock = os.clock()
	if string.sub(chatManager.lastMessage, 1, 5) == "/sms " or string.sub(chatManager.lastMessage, 1, 3) == "/t " then
		chatManager.antifloodClock = chatManager.antifloodClock + 0.5
	end
end
--------------------------------------------------------------------------------------------------------------------------
textlabel = {}
function textLabelOverPlayerNickname()
	for i = 0, 1000 do
		if textlabel[i] ~= nil then
			sampDestroy3dText(textlabel[i])
			textlabel[i] = nil
		end
	end
	for i = 0, 1000 do 
		if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
			local nick = sampGetPlayerNickname(i)
			if script.label[nick] ~= nil then
				if textlabel[i] == nil then
					textlabel[i] = sampCreate3dText(u8:decode(script.label[nick].text), tonumber(script.label[nick].color), 0.0, 0.0, 0.8, 21.5, false, i, -1)
				end
			end
			else
			if textlabel[i] ~= nil then
				sampDestroy3dText(textlabel[i])
				textlabel[i] = nil
			end
		end
	end
end

function script.sendMessage(t)
	sampAddChatMessage(prefix .. u8:decode(t), main_color)
end

function getcars()
	local chandles = {}
	local tableIndex = 1
	local vehicles = getAllVehicles()
	local fcarhandle = isCharInAnyCar(PLAYER_PED) and storeCarCharIsInNoSave(PLAYER_PED) or 12
	for k, v in pairs(vehicles) do
		if doesVehicleExist(v) and v ~= fcarhandle then table.insert(chandles, tableIndex, v) tableIndex = tableIndex + 1 end
	end
	
	if table.maxn (chandles) == 0 then return nil else return chandles end
end

function getStrByState(keyState)
	if keyState == 0 then
		return "{ff8533}OFF{ffffff}"
	end
	return "{85cf17}ON{ffffff}"
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

function makebinderHotKey(k)
	local rett = {}
	if binder_ini.list[k] ~= nil then
		local b = decodeJson(binder_ini.list[k])
		if b ~= nil then
			if b.hotkey ~= nil then
				for _, v in ipairs(string.split(b.hotkey, ", ")) do
					if tonumber(v) ~= 0 then table.insert(rett, tonumber(v)) end
				end
				return rett
			end
		end
	end
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
	hstr = (hstr == "" or hstr == "nil") and "Нет клавиши" or hstr
	
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
				inicfg.save(srp_ini, settings)
			end
		)
	end
end

function imgui.binderHotkey(name, numkey, width)
	local hstr = ""
	local b = decodeJson(binder_ini.list[numkey])
	for _, v in ipairs(string.split(b.hotkey, ", ")) do
		if v ~= "0" then
			hstr = hstr == "" and tostring(vkeys.id_to_name(tonumber(v))) or "" .. hstr .. " + " .. tostring(vkeys.id_to_name(tonumber(v))) .. ""
		end
	end
	hstr = (hstr == "" or hstr == "nil") and "Нет клавиши" or hstr
	imgui.Button(hstr, imgui.ImVec2(90.0, width))
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
					b.hotkey = "0"
					else
					local tNames = string.split(curkeys, " ")
					for _, v in ipairs(tNames) do
						local val = (tonumber(v) == 162 or tonumber(v) == 163) and 17 or (tonumber(v) == 160 or tonumber(v) == 161) and 16 or (tonumber(v) == 164 or tonumber(v) == 165) and 18 or tonumber(v)
						keys = keys == "" and val or "" .. keys .. ", " .. val .. ""
					end
				end
				b.hotkey = tostring(keys)
				binder_ini.list[numkey] = encodeJson(b)
				inicfg.save(binder_ini, binds)
			end
		)
	end
end

function checkUpdates() -- проверка обновлений
	local fpath = getWorkingDirectory() .. '/SRPfunctions.dat'
	downloadUrlToFile("https://raw.githubusercontent.com/WebbLua/SRPfunctions/main/version.json", fpath, function(_, status, _, _)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(fpath) then
				local file = io.open(fpath, 'r')
				if file then
					local info = decodeJson(file:read('*a'))
					file:close()
					os.remove(fpath)
					script.v.num = info.version_num
					script.v.date = info.version_date
					script.url = info.version_url
					script.quest = info.version_quest
					script.label = info.version_label
					script.upd.changes = info.version_upd
					if script.quest then
						for k, v in pairs(script.quest) do
							srp_ini.description[k] = v
						end
						inicfg.save(srp_ini, settings)
					end
					if script.upd.changes then
						for k in pairs(script.upd.changes) do
							table.insert(script.upd.sort, k)
						end
						table.sort(script.upd.sort, function(a, b) return a > b end)
					end
					script.checked = true
					if info['version_num'] > thisScript()['version_num'] then
						script.available = true
						updateScript()
						if script.update then updateScript() return end
						script.sendMessage(updatingprefix .. "Обнаружена новая версия скрипта от " .. info['version_date'] .. ", пропишите /srpup для обновления")
						script.sendMessage(updatingprefix .. "Изменения в новой версии:")
						if script.upd.sort ~= {} then
							for k in ipairs(script.upd.sort) do
								if script.upd.changes[tostring(k)] ~= nil then
									script.sendMessage(updatingprefix .. k .. ') ' .. script.upd.changes[tostring(k)])
								end
							end
						end
						return true
						else
						if script.update then script.sendMessage("Обновлений не обнаружено, вы используете самую актуальную версию: v" .. script.v.num .. " за " .. script.v.date) script.update = false return end
					end
					else
					script.sendMessage("Не удалось получить информацию про обновления(")
					thisScript():unload()
				end
				else
				script.sendMessage("Не удалось получить информацию про обновления(")
				thisScript():unload()
			end
		end
	end)
end

function updateScript()
	script.update = true
	if script.available then
		downloadUrlToFile(script.url, thisScript().path, function(_, status, _, _)
			if status == 6 then
				script.sendMessage(updatingprefix .. "Скрипт был обновлён!")
				if script.find("ML-AutoReboot") == nil then
					thisScript():reload()
				end
			end
		end)
		else
		checkUpdates()
	end
end

function onScriptTerminate(s, bool)
	if s == thisScript() and not bool then
		imgui.Process = false
		for i = 0, 1000 do
			if textlabel[i] ~= nil then
				sampDestroy3dText(textlabel[i])
				textlabel[i] = nil
			end
		end
		if not script.reload then
			if not script.update then
				if not script.unload then
					script.sendMessage("Скрипт крашнулся: отправьте moonloader.log разработчику tg: " .. script.telegram.nick)
					else
					script.sendMessage("Скрипт был выгружен")
				end
				else
				script.sendMessage(updatingprefix .. "Старый скрипт был выгружен, загружаю обновлённую версию...")
			end
			else
			script.sendMessage("Перезагружаюсь...")
		end
	end
end		
