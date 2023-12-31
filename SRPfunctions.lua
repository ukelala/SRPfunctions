script_name('SRPfunctions')
script_author("Webb")
--[[
    Спасибо также данным разработчкам, некоторые функции были взяты из их скриптов:
    Binder_for_CO_by_Belka.lua / Author: Belo4ka_Belka
    donatik.lua / Author: vlaek aka bier from Revolution
    taximate.lua / Author: 21se aka pivo
]]
script_version("23.06.2023")
script_version_number(36)

local main_color, main_color_hex = 0xB30000, "{B30000}"
local prefix, updating_prefix, error_prefix = "{B30000}[SRP] {FFFAFA}", "{FF0000}[ОБНОВЛЕНИЕ] {FFFAFA}",
    "{FF0000}[ERROR] "

local script = {
    telegram = {
        nick = "@ibm287",
        url = "https://t.me/ibm287"
    },
    request = {
        complete = true,
        free = true
    },
    checkedUpdates = false,
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
function try(f, catch_f)
    local status, exception = pcall(f)
    if not status then
        catch_f(exception)
    end
end

try(function()
    ev = require 'samp.events'
    imgui = require 'imgui'
    imgui.ToggleButton = require('imgui_addons').ToggleButton
    vkeys = require 'vkeys'
    rkeys = require 'rkeys'
    inicfg = require 'inicfg'
    ffi = require 'ffi'
    lfs = require 'lfs'
    dlstatus = require'moonloader'.download_status
    encoding = require 'encoding'
    encoding.default = 'CP1251'
    u8 = encoding.UTF8
end, function(e)
    sampAddChatMessage(prefix .. error_prefix .. "An error occurred while loading libraries", 0xFF0000)
    sampAddChatMessage(prefix .. error_prefix .. "For more information, view the console (~)", 0xFF0000)
    print(error_prefix .. e)
    thisScript():unload()
end)
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
        psycho = false,
        knockpsycho = false,
        psychoeat = false,
        knockmushroom = false,
        autologin = false,
        autorent = false,
        robbing = false,
        withdrawal = false,
        withoutcops = false,
        date = false,
        nick = false,
        ping = false,
        drugscooldown = false,
        event = false,
        stream = false,
        status = false,
        squad = false,
        disablesquad = false,
        hpcars = false,
        chatinfo = false,
        equest = false,
        inventory = false,
        kd = false,
        variables = false,
        spam = false,
        house = false,
        rkt = false,
        jfleader = false,
        quitfromcops = false
    },
    hotkey = {
        context = "0",
        drugs = "0",
        psycho = "0",
        changeclist = "0",
        enterhouse = "0",
        lock = "0",
        autowalk = "0",
        fastmenu = "0",
        eject = "0"
    },
    render = {
        dateX = 0,
        dateY = 0,
        nickX = 0,
        nickY = 0,
        pingX = 0,
        pingY = 0,
        drugsX = 0,
        drugsY = 0,
        eventX = 0,
        eventY = 0,
        streamX = 0,
        streamY = 0,
        statusX = 0,
        statusY = 0,
        squadX = 0,
        squadY = 0,
        equestX = 0,
        equestY = 0,
        inventoryX = 0,
        inventoryY = 0,
        robbingX = 0,
        robbingY = 0,
        fastbinderX = 0,
        fastbinderY = 0
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
        rkt = 2500,
        jf = "",
        jfjob = ""
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
    inventoryItem = {
        drugs = false,
        mats = false,
        keys = false,
        canister = false,
        fish = false,
        cookedfish = false,
        mushroom = false,
        repairkit = false,
        psychoheal = false,
        cookedmushroom = false,
        adrenaline = false,
        cork = false,
        balaclava = false,
        scrap = false,
        energy = false,
        robkit = false
    },
    inventory = {
        drugs = 0,
        mats = 0,
        keys = 0,
        canister = 0,
        fish = 0,
        cookedfish = 0,
        mushroom = 0,
        repairkit = 0,
        psychoheal = 0,
        cookedmushroom = 0,
        adrenaline = 0,
        cork = 0,
        balaclava = 0,
        scrap = 0,
        energy = 0,
        robkit = 0
    }
}
local bindertable = {
    list = {}
}
-------------------------------------------------------------------------[Переменные и маcсивы]-----------------------------------------------------------------
local clists = {
    numbers = {
        [16777215] = 0,
        [2852758528] = 1,
        [2857893711] = 2,
        [2857434774] = 3,
        [2855182459] = 4,
        [2863589376] = 5,
        [2854722334] = 6,
        [2858002005] = 7,
        [2868839942] = 8,
        [2868810859] = 9,
        [2868137984] = 10,
        [2864613889] = 11,
        [2863857664] = 12,
        [2862896983] = 13,
        [2868880928] = 14,
        [2868784214] = 15,
        [2868878774] = 16,
        [2853375487] = 17,
        [2853039615] = 18,
        [2853411820] = 19,
        [2855313575] = 20,
        [2853260657] = 21,
        [2861962751] = 22,
        [2865042943] = 23,
        [2860620717] = 24,
        [2868895268] = 25,
        [2868899466] = 26,
        [2868167680] = 27,
        [2868164608] = 28,
        [2864298240] = 29,
        [2863640495] = 30,
        [2864232118] = 31,
        [2855811128] = 32,
        [2866272215] = 33,

        [-256] = 0,
        [161743018] = 1,
        [1476349866] = 2,
        [1358861994] = 3,
        [782269354] = 4,
        [-1360527190] = 5,
        [664477354] = 6,
        [1504073130] = 7,
        [-16382294] = 8,
        [-23827542] = 9,
        [-196083542] = 10,
        [-1098251862] = 11,
        [-1291845462] = 12,
        [-1537779798] = 13,
        [-5889878] = 14,
        [-30648662] = 15,
        [-6441302] = 16,
        [319684522] = 17,
        [233701290] = 18,
        [328985770] = 19,
        [815835050] = 20,
        [290288042] = 21,
        [-1776943190] = 22,
        [-988414038] = 23,
        [-2120503894] = 24,
        [-2218838] = 25,
        [-1144150] = 26,
        [-188481366] = 27,
        [-189267798] = 28,
        [-1179058006] = 29,
        [-1347440726] = 30,
        [-1195985238] = 31,
        [943208618] = 32,
        [-673720406] = 33
    },
    names = {"[0] Без цвета", "[1] Зелёный", "[2] Светло-зелёный",
             "[3] Ярко-зелёный", "[4] Бирюзовый", "[5] Жёлто-зелёный",
             "[6] Тёмно-зелёный", "[7] Серо-зелёный", "[8] Красный",
             "[9] Ярко-красный", "[10] Оранжевый", "[11] Коричневый",
             "[12] Тёмно-красный", "[13] Серо-красный", "[14] Жёлто-оранжевый",
             "[15] Малиновый", "[16] Розовый", "[17] Синий", "[18] Голубой",
             "[19] Синяя сталь", "[20] Cине-зелёный", "[21] Тёмно-синий",
             "[22] Фиолетовый", "[23] Индиго", "[24] Серо-синий", "[25] Жёлтый",
             "[26] Кукурузный", "[27] Золотой", "[28] Старое золото",
             "[29] Оливковый", "[30] Серый", "[31] Серебро", "[32] Чёрный", "[33] Белый"}
}
local timezones = {"МСК-14", "МСК-13", "МСК-12", "МСК-11", "МСК-10", "МСК-9", "МСК-8", "МСК-7",
                   "МСК-6", "МСК-5", "МСК-4", "МСК-3", "МСК-2", "МСК-1",
                   "Московское время", "МСК+1", "МСК+2", "МСК+3", "МСК+4", "МСК+5",
                   "МСК+6", "МСК+7", "МСК+8", "МСК+9"}
local antiflood = 0

imgui.main = imgui.ImBool(false)
local menu = { -- imgui-меню
    automatic = {
        sure = true,
        bool = imgui.ImBool(true)
    },
    binds = {
        sure = true,
        bool = imgui.ImBool(false)
    },
    render = {
        sure = true,
        bool = imgui.ImBool(false)
    },
    binder = {
        sure = true,
        bool = imgui.ImBool(false)
    },
    information = {
        sure = true,
        bool = imgui.ImBool(false)
    },
    commands = {
        sure = false,
        bool = imgui.ImBool(false)
    },
    password = {
        sure = false,
        bool = imgui.ImBool(false)
    },
    jf = {
        sure = false,
        bool = imgui.ImBool(false)
    },
    inventory = {
        sure = false,
        bool = imgui.ImBool(false)
    },
    editor = {
        sure = false,
        bool = imgui.ImBool(false)
    },
    fastbinder = {
        sure = false,
        bool = imgui.ImBool(false)
    },
    variables = {
        sure = false,
        bool = imgui.ImBool(false)
    }
}

local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local var = {
    satiety, -- сытость
    drugtimer = 60, -- КД на употребление нарко по умолчанию
    rent, -- цена аренды транспорта
    killerid, -- id последнего убийцы
    taxipassenger, -- ник последнего пассажира такси
    td, -- id текстдрава сквада
    squadenable = false, -- статус отображения текстдрава сквада
    squad = {}, -- массив информации о текущих игроках в скваде
    squadIndex = {}, -- дополнительный массив для сквада
    argument = {}, -- аргумент команды для активации бинда
    current = { -- массив текущих переменных
    nick, bind, client, clientRP},
    is = {
        boost = false,
        equest = false,
        inventory = false,
        flood = false,
        robbing = false,
        withdrawal = false,
        purchased = false
    }, -- массив статусов некоторых действий
    need = {
        reload = false,
        hold = false,
        buy = true,
        jf = true
    }, -- необходимо сделать...
    jf = {
        nick = nil,
        id = nil,
        sec = nil,
        fine = nil,
        list = {}, -- массив работ по названию профсоюзов
        checklist = false, -- статус проверки списка профсоюзов
        combo -- лист профсоюзов для выбора
    }, -- информация о члене профсоюза
    offer = {
        bool = false,
        status = false
    }, -- статус текущих предложений от скрипта
    items = {
        IndexFromName = {
            ["Наркотики"] = "drugs",
            ["Материалы"] = "mats",
            ["Ключи от камеры"] = "keys",
            ["Канистра с бензином"] = "canister",
            ["Сырая рыба"] = "fish",
            ["Готовая рыба"] = "cookedfish",
            ["Грибы"] = "mushroom",
            ["Комплект «автомеханик»"] = "repairkit",
            ["Психохил"] = "psychoheal",
            ["Готовые грибы"] = "cookedmushroom",
            ["Адреналин"] = "adrenaline",
            ["Защита от насильников"] = "cork",
            ["Балаклава"] = "balaclava",
            ["Лом"] = "scrap",
            ["Энергетик"] = "energy",
            ["Набор для взлома"] = "robkit"
        },
        NameFromIndex = {
            ["drugs"] = "Наркотики",
            ["mats"] = "Материалы",
            ["keys"] = "Ключи от камеры",
            ["canister"] = "Канистра с бензином",
            ["fish"] = "Сырая рыба",
            ["cookedfish"] = "Готовая рыба",
            ["mushroom"] = "Грибы",
            ["repairkit"] = "Комплект «автомеханик»",
            ["psychoheal"] = "Психохил",
            ["cookedmushroom"] = "Готовые грибы",
            ["adrenaline"] = "Адреналин",
            ["cork"] = "Защита от насильников",
            ["balaclava"] = "Балаклава",
            ["scrap"] = "Лом",
            ["energy"] = "Энергетик",
            ["robkit"] = "Набор для взлома"
        }
    }, -- для связи названий предметов инвентаря и индексов соответствующих массивов
    ivents = {
        NameFromIndex = {
            ["race"] = "Гонки ЛС",
            ["derby"] = "Дерби СФ",
            ["squid"] = "Игра в Кальмара",
            ["paint"] = "Пейнтбол"
        }
    }, -- названия серверных МП
    vehicles = { -- массив всего транспорта
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter", "Premier", "Enforcer", "Securicar",
    "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion",
    "Rumpo", "RCBandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram",
    "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley'sRCVan",
    "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
    "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet",
    "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher",
    "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick", "Boxvillde", "Benson",
    "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey",
    "Bike", "MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer",
    "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000", "CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck",
    "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak",
    "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa",
    "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan",
    "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito", "FreightFlat",
    "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley",
    "Stafford", "BF-400", "NewsVan", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox",
    "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar", "PoliceCar", "PoliceRanger", "Picador",
    "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage", "Luggage", "Stairs", "Boxville", "Tiller",
    "UtilityTrailer"},
    motos = { -- массив всех двухколёсных транспортов
        [581] = "BF-400",
        [522] = "NRG-500",
        [521] = "FCR-900",
        [468] = "Sanchez",
        [463] = "Freeway",
        [462] = "Faggio",
        [461] = "PCJ-600"
    },
    copskins = {
        [76] = true,
        [265] = true,
        [266] = true,
        [267] = true,
        [280] = true,
        [281] = true,
        [282] = true,
        [283] = true,
        [284] = true,
        [285] = true,
        [288] = true,
        [300] = true,
        [301] = true,
        [302] = true,
        [303] = true,
        [304] = true,
        [305] = true,
        [306] = true,
        [307] = true,
        [308] = true,
        [309] = true,
        [310] = true,
        [311] = true
    } -- скины полицейских, на которые будет срабатывать анти-ломка и автоофф от ареста
}
local keybbb = {
    KeyboardLayoutName = ffi.new("char[?]", 32),
    LocalInfo = ffi.new("char[?]", 32)
}
ffi.cdef [[
    int SendMessageA(int, int, int, int);
    unsigned int GetModuleHandleA(const char* lpModuleName);
    short GetKeyState(int nVirtKey);
    bool GetKeyboardLayoutNameA(char* pwszKLID);
    int GetLocaleInfoA(int Locale, int LCType, char* lpLCData, int cchData);
]]
local sym = {
    ["myid"] = -1,
    ["mynick"] = -1,
    [1] = 144 - 7,
    ["s"] = 132 - 15,
    ["w"] = 134 - 20,
    ["me"] = 116 - 2,
    ["do"] = 136 - 10,
    ["try"] = 116 - 2,
    ["todo"] = 82 - 23,
    ["m"] = 114 - 21,
    ["r"] = 178 - 49,
    ["f"] = 178 - 49,
    ["fs"] = 121 - 18,
    ["u"] = 121 - 18,
    ["report"] = 218 - 29,
    ["b"] = 117 - 8,
    ["dep"] = 161 - 41
}
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
        [7] = "{00FF00}Садись",
        [8] = "{FF0000}Репорт перевернуть"
    }, -- имена статусов в КК по ID события
    ["nn"] = {2, 3, 7, 8}, -- ID's которые требуют отображения доп информации (из массива №3) в статусе КК
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
        [3] = false -- есть ли активное задание по id 8 на данный момент
    }
}
local ImVec4 = imgui.ImVec4
local fonts = {}

local strings = {
    acceptrepair = u8:decode "^ Механик .* хочет отремонтировать ваш автомобиль за %d+ вирт.*",
    acceptrefill = u8:decode "^ Механик .* хочет заправить ваш автомобиль за (%d+) вирт%{FFFFFF%} %(%( Нажмите Y%/N для принятия%/отмены %)%)",
    gasstation = u8:decode "Цена за 200л%: %$(%d+)",
    jfchat = u8:decode "^ (.*)%[(%d+)%]%<(.*)%>%: (.*)",
    faction = u8:decode "^ (.*)  (.*)%[(%d+)%]%: (.*)",
    boost = u8:decode "^ Действует до%: %d+%/%d+%/%d+ %d+%:%d+%:%d+",
    noboost = u8:decode "^ Бонусы отключены",
    drugs = u8:decode '^ %(%( Остаток%: (%d+) грамм %)%)',
    painttime = u8:decode "^ Внимание%! Начало пейнтбола через (%d) минуты?%. Место проведения%: %/gps %>%> Пейнтбол",
    squidtime = u8:decode "^ Внимание%! Начало %'Игра в Кальмара%' через (%d) минуты?%! Место проведения%: Арена LS %(%( %/gps %[Важное%] %>%> %[Игра в Кальмара%] %)%)",
    derbytime = u8:decode "^ Внимание%! Начало гонок дерби через (%d) минуты?%. Место проведения%: %/gps %>%> Стадион %[SF%]",
    racetime = u8:decode "^ Внимание%! Начало гонок через (%d) минуты?%. Место проведения%: %/gps %>%> Аэропорт %[LS%]",
    paintfalse1 = u8:decode "^ Внимание%! Пейнтбол начался",
    paintfalse2 = u8:decode "Внимание%! Пейнтбол был прерван из%-за отсутствия участников",
    squidfalse1 = u8:decode "^ Внимание%! %'Игра в Кальмара%' прервана из%-за недостаточного количества участников%!",
    squidfalse2 = u8:decode "^ Внимание%! %'Игра в Кальмара%' началась%!",
    squidfalse3 = u8:decode "^ Внимание%! %'Игра в Кальмара%' прервана из%-за проигрыша всех участников%! %(%( Список%: %/klmlist %)%)",
    derbyfalse1 = u8:decode "^ Внимание%! Гонки дерби начались%. Стадион Сан Фиерро",
    derbyfalse2 = u8:decode "^ Внимание%! Гонки дерби были прерваны из%-за отсутствия участников",
    derbyfalse3 = u8:decode "^ Внимание%! Гонки дерби окончены%. %(%( Список победителей%: %/derbylist %)%)",
    racefalse1 = u8:decode "^ Внимание%! Гонки были прерваны из%-за отсутствия участников",
    racefalse2 = u8:decode "^ Внимание%! Гонки начались%. Трасса%: Аэропорт Лос Сантос",
    racefalse3 = u8:decode "^ Внимание%! Гонки окончены%. %(%( Список победителей%: %/racelist %)%)",
    repair1 = u8:decode "^ Двигатель отремонтирован%. У вас осталось (%d+)%/%d+ комплектов %«автомеханик%»",
    repair2 = u8:decode "^ У вас нет комплекта %«автомеханик%» для ремонта",
    repair3 = u8:decode "^ В транспортном средстве нельзя",
    repair4 = u8:decode "^ Вы далеко от транспортного средства%. Подойдите к капоту",
    connected = u8:decode "^ Для восстановления доступа нажмите клавишу %'F6%' и введите %'%/restoreAccess%'",
    changequest = u8:decode "^ %[Quest%] %{FFFFFF%}Вы заменили задание %{6AB1FF%}(.*) %{FFFFFF%}на %{6AB1FF%}(.*)",
    donequest = u8:decode "^ %[Quest%] %{FFFFFF%}Выполнено задание %{6AB1FF%}\"(.*)\"",
    newpassenger = u8:decode "^ Пассажир (.*) сел в ваше Такси%. Довезите его и государство заплатит вам",
    outpassenger1 = u8:decode "^ Пассажир вышел из такси. Деньги будут зачислены во время зарплаты$",
    outpassenger2 = u8:decode "^ Пассажир вышел из такси. Использован купон на бесплатный проезд$",
    sms = u8:decode "^ SMS%: (.*)%. Отправитель%: (.*)%[(%d+)%]$",
    normalchat = u8:decode "^%- (.*)%[(%d+)%]%: (.*)",
    taxi = u8:decode "%<%< Бесплатное такси %>%>",
    rent = u8:decode "^ Вы арендовали транспортное средство$",
    minusbalaklava = u8:decode "^ Вы надели балаклаву$",
    minusscrap = u8:decode "^ Отлично! Замок взломан, скорее выноси ценные вещи$",
    canister = u8:decode "^ Вы купили канистру с 50 литрами бензина за .* вирт",
    fillcar = u8:decode "^ Вы дозаправили свою машину на 50",
    outtrunk = u8:decode "^ Вы забрали из багажника%: %{FFFFFF%}%'(.*)%' %{C0C0C0%}в количестве%: %{FFFFFF%}(%d+)",
    intrunk = u8:decode "^ Вы положили в багажник %{FFFFFF%}%'(.*)%' %{6AB1FF%}в количестве %d+ штук%, остаток (%d+) штук",
    sellekey = u8:decode "^ .* передал%(а%) ключи от камеры (.*)",
    shop24 = u8:decode "^ (.*) приобретена?%. Осталось%: (%d+)%/%d+",
    grib = u8:decode "^ Вы нашли гриб \".+\". Теперь у вас (%d+) грибов",
    fish = u8:decode "^ Сытость полностью восстановлена%. У вас осталось (%d+) %/ %d+ пачек рыбы$",
    cookfish = u8:decode "^ У вас (%d+) %/ %d+ пачек рыбы$",
    trash = u8:decode "^ (.*) выбросила? %'(.*)%'$",
    reward = u8:decode "^ %[Quest%] %{FFFFFF%}Ваша награда%: %{FF9DB6%}(.*)",
    cookgrib = u8:decode "^ Грибы готовы%. Грибы%: (%d+)%. Психохил%: (%d+)%/%d+%. Г%.Грибы%: (%d+)%/%d+$",
    adr = u8:decode "^ Вы приняли адреналин%. Эффект продлится (%d+) минут$",
    gribeat = u8:decode "^ Сытость пополнена до (%d+)%. У вас осталось (%d+)%/%d+ готовых грибов$",
    psycho = u8:decode "^ Здоровье %d+%/%d+%. Сытость (%d+)%/%d+%. У вас осталось (%d+)%/%d+ психохила$",
    armour = u8:decode "^ Выдано%: Броня$",
    psychohungry = u8:decode "^ Вы истощены%. Здоровье снижено до %d+%/%d+%. У вас осталось (%d+)/%d+ психохила$",
    roul = u8:decode "^ Вы получили %{FFFFFF%}(.*)%{EAC700%}%. Количество%: %{FFFFFF%}%d+%{EAC700%}%. В инвентаре%: (%d+) %/ %d+$",
    stolen = u8:decode "^ Вы украли (.*), отнесите награбленное в фургон$",
    breaken = u8:decode "^ Отлично! Замок взломан, скорее выноси ценные вещи$",
    open = u8:decode "^ Дверь открыта без использования лома$",
    put = u8:decode "^ Вы положили награбленное в фургон. Загружено: (%d+)%/(%d+)$",
    rob = u8:decode "^ Emmet%: Купить лом и маску можешь в любом магазине 24%/7$",
    donerob = u8:decode "^ За ограбление дома вы получили %d+ вирт$",
    donetheft = u8:decode "^ Отличная тачка. Будет нужна работа, приходи%.$",
    stay = u8:decode "^ %(%( После ввода команды вы должны стоять на месте %)%)$",
    wasAFK = u8:decode "^ В AFK ввод команд заблокирован$",
    withdrawal = u8:decode "^ ~~~~~~~~ У вас началась ломка ~~~~~~~~$",
    plswait = u8:decode "^ Пожалуйста подождите$",
    spam = u8:decode "^ SMS%: {FF8000}СКРЫТО%. {FFFF00}Отправитель%: .*%[(%d+)%]",
    noequest = u8:decode "^ Доступно со 2 уровня",
    metka = u8:decode "^ Пассажир (.*) установил точку прибытия %(%( Для отключения введите %/gps %)%)",
    slet = u8:decode "^ Домашний счёт оплачен до (.*)",
    nohouse = u8:decode "^ У вас нет дома$",
    accepttaxi = u8:decode "^ Диспетчер%: (.*) принял вызов от (.*)%[%d+%]$",
    full24 = u8:decode "^ У вас нет места$",
    afksec = u8:decode "%[AFK%] %[(%d+) секунд%]",
    changenick = u8:decode 'Ваш новый ник %" (.*) %"%. Укажите его в клиенте SA%-MP%, в поле %"Name%"',
    changenickmsg = u8:decode ".* одобрил%(а%) заявку на смену ника%: (.*) %>%> ",
    repairkitshop = u8:decode "Комплект %«автомеханик%»%s+%[%$(%d+)%]",
    jfalready = u8:decode "^ Игрок уже состоит во фракции$",
    jfnojob = u8:decode "^ Игрок не устроен на работу соответсвующей фракции$",
    jfadded = u8:decode "^ Рабочий добавлен$",
    jfdeleted = u8:decode "^ Рабочий удален$",
    jfmuted = u8:decode "^ Игрок забанен в чате$",
    jffined = u8:decode "^ Штраф установлен$",
    cuff = u8:decode "^ (.*) надела? наручники (.*)$",
    frisk = u8:decode "^ (.*) обыскала? (.*)$",

    color = {
        mechanic = 1790050303,
        jfchat = 815835135,
        faction = {33357823, -1920073729},
        drugs = -1,
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
        minusscrap = 1790050303,
        canister = 1687547391,
        fillcar = 1687547391,
        outtrunk = -1061109505,
        intrunk = 1790050303,
        me = -1029514497,
        shop24 = 1687547391,
        reward = 1790050303,
        cookgrib = 1358862079,
        adr = 1790050303,
        psycho = -1,
        armour = 162529535,
        roul = -356056833,
        repair1 = 1358862079,
        repair2 = -1347440641,
        stolen = 1790050303,
        breaken = 1790050303,
        open = -1,
        put = -1061109505,
        rob = -1061109505,
        donerob = -1061109505,
        donetheft = 1790050303,
        stay = -1347440641,
        wasAFK = -2769921,
        withdrawal = -1627389697,
        plswait = -1347440641,
        spam = -65281,
        noequest = -1347440641,
        nohouse = -1347440641,
        accepttaxi = -1137955670,
        full24 = -1347440641,
        changenick = {-65281, -10270721},
        jftry = -1347440641,
        jfdone = 866792447
    }
}
local dialogs = {
    drugs = {
        str = u8:decode "%[%d+%] Таймер на Нарко(.*)",
        id = 22,
        style = 5,
        title = u8:decode 'Бонусы'
    },
    login = {
        str = u8:decode "Этот аккаунт зарегистрирован",
        id = 1,
        style = 3,
        title = u8:decode 'Авторизация'
    },
    errorlogin = {
        str = u8:decode "Внимание! Вы ввели неверный пароль!",
        id = 57,
        style = 0,
        title = u8:decode 'Ошибка!'
    },
    quest = {
        str = u8:decode "%{FFFFFF%}(.*).+%{[F3][F3][4A][2A][43][23]%}(%[Н?е?.?[Вв]ыполнено%])",
        id = 1013,
        style = 5,
        title = u8:decode '%{FFFFFF%}Обновление заданий%: %{6AB1FF%}(.*)'
    },
    description = {
        str1 = u8:decode "%{FFFFFF%}Название квеста%: ",
        str2 = u8:decode "Описание%: ",
        str3 = u8:decode "%{6AB1FF%}(.*)%{FFFFFF%}",
        id = 1014,
        style = 0,
        title = u8:decode '{6AB1FF}Ежедневные квесты'
    },
    inventory = {
        id = 22,
        style = 4,
        title = u8:decode 'Карманы'
    },
    autorent = {
        str = u8:decode "Стоимость аренды%: {FFFF00}(%d+) вирт",
        id = {276, 277},
        style = 0,
        title = u8:decode 'Аренда транспорта'
    },
    shop = {
        id = 16,
        style = 4,
        title = u8:decode "Магазин 24/7",
        button1 = u8:decode "Купить",
        button2 = u8:decode "Отмена"
    },
    cmdjf = {
        id = 22,
        style = 2,
        title = u8:decode "Фракции рабочих"
    },
    jflist = {
        id = 22,
        style = 5,
        title = u8:decode "Список"
    }
}
-------------------------------------------------------------------------[MAIN]--------------------------------------------------------------------------------------------
local servers = {"Underground", "Revolution", "Legacy"}

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(0)
    end
    while sampGetCurrentServerName() == "SA-MP" do
        wait(0)
    end
    local serverName = sampGetCurrentServerName()
    for k, v in ipairs(servers) do
        if serverName:find(v) then
            server = v
            break
        end
    end
    if server == nil then
        script.sendMessage('Данный сервер не поддерживается, выгружаюсь...')
        script.unload = true
        thisScript():unload()
    end
    var.current.nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))

    imgui.ApplyCustomStyle()
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local path = getFolderPath(0x14)
    fonts.arial28 = imgui.GetIO().Fonts:AddFontFromFileTTF(path .. '\\arial.ttf', toScreenX(28 / 3), nil, glyph_ranges)
    fonts.arial25 = imgui.GetIO().Fonts:AddFontFromFileTTF(path .. '\\arial.ttf', toScreenX(25 / 3), nil, glyph_ranges)
    fonts.arial20 = imgui.GetIO().Fonts:AddFontFromFileTTF(path .. '\\arial.ttf', toScreenX(20 / 3), nil, glyph_ranges)
    fonts.arial18 = imgui.GetIO().Fonts:AddFontFromFileTTF(path .. '\\arial.ttf', toScreenX(18 / 3), nil, glyph_ranges)
    fonts.arial16 = imgui.GetIO().Fonts:AddFontFromFileTTF(path .. '\\arial.ttf', toScreenX(16 / 3), nil, glyph_ranges)
    fonts.times14 = renderCreateFont("times", toScreenX(14 / 3), 12)
    fonts.trebuc20 =
        imgui.GetIO().Fonts:AddFontFromFileTTF(path .. '\\trebuc.ttf', toScreenX(20 / 3), nil, glyph_ranges)
    fonts.trebuc17 =
        imgui.GetIO().Fonts:AddFontFromFileTTF(path .. '\\trebuc.ttf', toScreenX(17 / 3), nil, glyph_ranges)

    AdressConfig = string.format("%s\\config", thisScript().directory)
    AdressFolder = string.format("%s\\config\\SRPfunctions by Webb\\%s\\%s", thisScript().directory, server,
        var.current.nick)
    settings = string.format("SRPfunctions by Webb\\%s\\%s\\settings.ini", server, var.current.nick)
    binds = string.format("SRPfunctions by Webb\\%s\\%s\\binder.ini", server, var.current.nick)

    if not doesDirectoryExist(AdressConfig) then
        createDirectory(AdressConfig)
    end
    if not doesDirectoryExist(AdressFolder) then
        createDirectory(AdressFolder)
    end

    if srp_ini == nil then -- загружаем конфиг
        srp_ini = inicfg.load(config, settings)
        inicfg.save(srp_ini, settings)
    end

    if binder_ini == nil then -- загружаем биндер
        binder_ini = inicfg.load(bindertable, binds)
        inicfg.save(binder_ini, binds)
    end

    buffer = {
        autorefill = imgui.ImBuffer(u8(srp_ini.values.autorefill), 256),
        autofill = imgui.ImBuffer(u8(srp_ini.values.autofill), 256),
        clist = imgui.ImInt(srp_ini.values.clist),
        password = imgui.ImBuffer(u8(srp_ini.values.password), 256),
        autorent = imgui.ImBuffer(u8(srp_ini.values.autorent), 256),
        timezonedifference = imgui.ImInt(srp_ini.values.timezonedifference + 14),
        rkt = imgui.ImBuffer(u8(srp_ini.values.rkt), 256)
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
                var.argument[k] = nil
            end
        end
        suspendkeys = 1
        imgui.main.v = not imgui.main.v
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
                var.argument[k] = nil
            end
        end
        suspendkeys = 1
        imgui.main.v = not imgui.main.v
    end)
    sampRegisterChatCommand("srpflood", cmd_flood)
    sampRegisterChatCommand("samprpflood", cmd_flood)
    sampRegisterChatCommand("srpstop", function()
        chatManager.initQueue()
        script.sendMessage("Очередь отправляемых сообщений очищена!")
    end)
    sampRegisterChatCommand("samprpstop", function()
        chatManager.initQueue()
        script.sendMessage("Очередь отправляемых сообщений очищена!")
    end)
    sampRegisterChatCommand("whenhouse", whenhouse)
    sampRegisterChatCommand("st", cmd_st)
    sampRegisterChatCommand("sw", cmd_sw)

    if srp_ini.bools.jfleader then
        sampRegisterChatCommand("jfadd", cmd_jfadd)
        sampRegisterChatCommand("jfdel", cmd_jfdel)
        sampRegisterChatCommand("jfmute", cmd_jfmute)
        sampRegisterChatCommand("jffine", cmd_jffine)
    end

    script.loaded = true

    while sampGetGamestate() ~= 3 do
        wait(0)
    end
    while sampGetPlayerScore(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) <= 0 and not sampIsLocalPlayerSpawned() do
        wait(0)
    end
    var.need.reload = true

    script.checkUpdates()

    while not script.checkedUpdates do
        wait(0)
    end

    script.sendMessage("Скрипт запущен. Открыть меню - " .. main_color_hex .. "/srp")

    chatManager.initQueue()
    lua_thread.create(chatManager.checkMessagesQueueThread)

    if srp_ini.bools.house then
        whenhouse()
    end

    lua_thread.create(function()
        onfoot()
    end)
    lua_thread.create(function()
        CTask()
    end)
    lua_thread.create(function()
        setSquadPos()
    end)

    findsquad()

    script.sendMessage("Начинаю сбор информации из диалогов...")
    checkDialog("boostinfo")
    while var.is.boost do
        wait(0)
    end
    if srp_ini.bools.equest then
        checkDialog("equest")
        while var.is.equest do
            wait(0)
        end
    end
    if srp_ini.bools.inventory then
        checkDialog("inventory")
        while var.is.inventory do
            wait(0)
        end
    end
    script.sendMessage("Информация успешно получена, приятной игры")

    imgui.Process = true

    while true do
        wait(0)

        imgui.ShowCursor = false

        if time then
            setTimeOfDay(time, 0)
        end

        if suspendkeys == 2 then
            rkeys.registerHotKey(makeHotKey('context'), true, function()
                if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then
                    return
                end
                if srp_ini.bools.status then
                    ct()
                end
            end)
            rkeys.registerHotKey(makeHotKey('drugs'), true, function()
                if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then
                    return
                end
                usedrugs()
            end)
            rkeys.registerHotKey(makeHotKey('psycho'), true, function()
                if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then
                    return
                end
                if not srp_ini.bools.psychoeat then
                    sampSendChat("/grib heal")
                    return
                end
                if var.satiety == nil then
                    sampSendChat("/grib heal")
                    return
                end
                if var.satiety >= 20 then
                    sampSendChat("/grib heal")
                else
                    lua_thread.create(function()
                        wait(100)
                        sampSendChat("/" .. (srp_ini.bools.knockmushroom and "grib" or "fish") .. " eat")
                        wait(1300)
                        sampSendChat("/grib heal")
                    end)
                end
            end)
            rkeys.registerHotKey(makeHotKey('changeclist'), true, function()
                if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then
                    return
                end
                setclist()
            end)
            rkeys.registerHotKey(makeHotKey('enterhouse'), true, function()
                if sampIsChatInputActive() or isSampfuncsConsoleActive() then
                    return
                end
                enterhouse()
            end)
            rkeys.registerHotKey(makeHotKey('lock'), true, function()
                if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then
                    return
                end
                chatManager.addMessageToQueue("/lock")
            end)
            rkeys.registerHotKey(makeHotKey('autowalk'), true, function()
                if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then
                    return
                end
                var.need.hold = not var.need.hold
            end)
            rkeys.registerHotKey(makeHotKey('eject'), true, function()
                if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then
                    return
                end
                eject()
            end)
            for k, v in ipairs(binder_ini.list) do
                if v ~= nil then
                    local b = decodeJson(v)
                    if b.hotkey ~= "0" then
                        rkeys.registerHotKey(makebinderHotKey(k), true, function()
                            if sampIsChatInputActive() or sampIsDialogActive(-1) or isSampfuncsConsoleActive() then
                                return
                            end
                            binder(k)
                        end)
                    else
                        rkeys.unRegisterHotKey(makebinderHotKey(k))
                    end
                    if b.cmd ~= "" and b.cmd ~= " " then
                        sampRegisterChatCommand(b.cmd, function(params)
                            if params ~= nil and params ~= "" then
                                var.argument[k] = params
                            else
                                var.argument[k] = nil
                            end
                            binder(k)
                        end)
                    end
                end
            end
            suspendkeys = 0
        end

        if not imgui.main.v then
            if not menu.fastbinder.bool.v then
                imgui.closeAllSections()
            end
            if suspendkeys == 1 then
                suspendkeys = 2
                sampSetChatDisplayMode(3)
            end
        end

        textLabelOverPlayerNickname()

        -- Активация быстрого меню биндера
        if isKeyDown(makeHotKey('fastmenu')[1]) and not imgui.main.v and not sampIsChatInputActive() and
            not sampIsDialogActive(-1) and not isSampfuncsConsoleActive() then
            wait(0)
            menu.fastbinder.bool.v = true
        else
            wait(0)
            menu.fastbinder.bool.v = false
        end

        if var.need.hold and not sampIsChatInputActive() and not sampIsDialogActive(-1) and
            not isSampfuncsConsoleActive() and (wasKeyPressed(vkeys.VK_W) or wasKeyPressed(vkeys.VK_S)) then
            var.need.hold = false
        end

        if getActiveInterior() == 0 then
            var.need.buy = true
            var.is.purchased = false
        end

        if var.offer.bool then
            if isKeyDown(vkeys.VK_Y) then
                var.offer.status = true
                var.offer.bool = false
            end
            if isKeyDown(vkeys.VK_N) then
                var.offer.status = false
                var.offer.bool = false
                script.sendMessage("Предложение отклонено")
            end
        end

    end
end
-------------------------------------------------------------------------[IMGUI]-------------------------------------------------------------------------------------------
function imgui.ApplyCustomStyle()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = toScreenX(2.0)
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ChildWindowRounding = toScreenX(2.0)
    style.FrameRounding = toScreenX(2.0)
    style.ScrollbarSize = toScreenX(4.3)
    style.ScrollbarRounding = toScreenX(2.0)
    style.GrabMinSize = toScreenX(2.0)
    style.GrabRounding = toScreenX(1.0)
    style.WindowPadding = vec(2.5, 2.5)
    style.FramePadding = vec(1, 1)
    style.ItemSpacing = vec(2, 2)
    style.ItemInnerSpacing = vec(2, 2)
    style.IndentSpacing = toScreenX(0)
    style.TouchExtraPadding = vec(0, 0)
    style.ColumnsMinSpacing = toScreenX(0)
    style.DisplayWindowPadding = vec(0, 0)
    style.DisplaySafeAreaPadding = vec(0, 0)

    colors[clr.FrameBg] = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered] = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive] = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg] = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgActive] = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark] = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab] = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive] = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button] = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered] = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.80, 0.16, 0.16, 1.00)
    colors[clr.Header] = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered] = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive] = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator] = colors[clr.Border]
    colors[clr.SeparatorHovered] = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive] = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered] = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive] = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg] = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg] = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg] = colors[clr.PopupBg]
    colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg] = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab] = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton] = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end

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
        if type(color) ~= 'number' then
            return
        end
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
                    imgui.TextColored(colors_[i] or colors[1], text[i])
                    if imgui.IsItemClicked() then
                        if SelectedRow == A_Index then
                            ChoosenRow = SelectedRow
                        else
                            SelectedRow = A_Index
                        end
                    end
                    imgui.SameLine(nil, 0)
                end

                imgui.NewLine()
            else
                imgui.Text(w)
                if imgui.IsItemClicked() then
                    if SelectedRow == A_Index then
                        ChoosenRow = SelectedRow
                    else
                        SelectedRow = A_Index
                    end
                end
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
    if not size then
        size = imgui.ImVec2(0, 0)
    end
    local result = imgui.Button(gg, size)
    imgui.PopStyleColor(3)
    return result
end

function imgui.OnDrawFrame()
    if imgui.main.v and script.checkedUpdates then -- меню скрипта
        imgui.SwitchContext()
        colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
        imgui.PushFont(fonts.arial20)
        imgui.ShowCursor = true
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowSize(vec(400, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, vec(0.5 / 3, 0.25))
        imgui.Begin(thisScript().name .. ' v' .. script.v.num .. ' от ' .. script.v.date, imgui.main,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)

        imgui.BeginChild('top', vec(395, 13), false)
        imgui.PushFont(fonts.arial18)
        if imgui.Button("Автоматические действия", vec(97, 12)) then
            imgui.section('automatic')
        end
        imgui.SameLine()
        if imgui.Button("Клавиши и команды", vec(97, 12)) then
            imgui.section('binds')
        end
        imgui.SameLine()
        if imgui.Button("Рендер", vec(97, 12)) then
            imgui.section('render')
        end
        imgui.SameLine()
        if imgui.Button("Кастомный биндер", vec(97, 12)) then
            var.current.bind = nil
            imgui.section('binder')
        end
        imgui.PopFont()
        imgui.EndChild()

        imgui.BeginChild('main', vec(395, 233.5), true)
        if menu.automatic.bool.v then
            if imgui.ToggleButton("autorepair", imgui.ImBool(srp_ini.bools.autorepair)) then
                srp_ini.bools.autorepair = not srp_ini.bools.autorepair
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Принимать предложение механика о починке")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Если вы водитель транспорта, то скрипт будет автоматически соглашатся с предложением починить вас от механика")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("autorefill", imgui.ImBool(srp_ini.bools.autorefill)) then
                srp_ini.bools.autorefill = not srp_ini.bools.autorefill
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Принимать предложение механика о заправке (не дороже ")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Если вы водитель транспорта, то скрипт будет автоматически соглашатся с предложением заправить вас от механика")
                imgui.EndTooltip()
            end
            imgui.SameLine()
            imgui.PushItemWidth(toScreenX(30))
            if imgui.InputText('##d1', buffer.autorefill) then
                srp_ini.values.autorefill = tostring(u8:decode(buffer.autorefill.v))
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.PopItemWidth()
            imgui.Text(" вирт.)")
            if imgui.ToggleButton("autofill", imgui.ImBool(srp_ini.bools.autofill)) then
                srp_ini.bools.autofill = not srp_ini.bools.autofill
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Заправлять транспорт на АЗС (не дороже ")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Как только вы заедите на заправку и скрипт убедится в том что цена приемлима, вы будете автоматически заправлены")
                imgui.EndTooltip()
            end
            imgui.SameLine()
            imgui.PushItemWidth(toScreenX(30))
            if imgui.InputText('##d2', buffer.autofill) then
                srp_ini.values.autofill = tostring(u8:decode(buffer.autofill.v))
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.PopItemWidth()
            imgui.Text(" вирт.)")
            if imgui.ToggleButton("autocanister", imgui.ImBool(srp_ini.bools.autocanister)) then
                srp_ini.bools.autocanister = not srp_ini.bools.autocanister
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Покупать канистру на АЗС, (исходя из цены заправки)")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Как только вы заедите на заправку и скрипт убедится в том что цена приемлима (цена заправки на АЗС), вы автоматически купите канистру если её нет в инвентаре")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("autorefillcanister", imgui.ImBool(srp_ini.bools.autorefillcanister)) then
                srp_ini.bools.autorefillcanister = not srp_ini.bools.autorefillcanister
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Заправлять транспорт канистрой в случае если закончилось топливо")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Как только в вашем транспорте закончится топливо, скрипт моментально использует канистру (если она есть в инвентаре)")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("jfcoloring", imgui.ImBool(srp_ini.bools.jfcoloring)) then
                srp_ini.bools.jfcoloring = not srp_ini.bools.jfcoloring
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Окрашивать ники в чате профсоюза в цвет клиста")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Все новые появляющиеся сообщения в рации профсоюза будут иметь одну особенность: ник и ID игрока будет в цвете его клиста")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("fcoloring", imgui.ImBool(srp_ini.bools.fcoloring)) then
                srp_ini.bools.fcoloring = not srp_ini.bools.fcoloring
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Окрашивать ники в чате фракции в цвет клиста")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Все новые появляющиеся сообщения в рации фракции будут иметь одну особенность: ник и ID игрока будет в цвете его клиста")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("quit", imgui.ImBool(srp_ini.bools.quit)) then
                srp_ini.bools.quit = not srp_ini.bools.quit
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Оповещать о вышедших из игры игроках в зоне прорисовки")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Если кто-то в зоне прорисовке, по той или иной причине покинет игру, то в чате появится сообщение о том кто вышел (в цвете клиста) и с какой причиной")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("psycho", imgui.ImBool(srp_ini.bools.psycho)) then
                srp_ini.bools.psycho = not srp_ini.bools.psycho
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Оповещать об употреблении психохила игроками в зоне прорисовки")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Если кто-то в зоне прорисовке употребит психохил, то в чате появится сообщение о том кто употребил (в цвете клиста)")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("knockpsycho", imgui.ImBool(srp_ini.bools.knockpsycho)) then
                srp_ini.bools.knockpsycho = not srp_ini.bools.knockpsycho
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Сбивать анимацию употребления психохила")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "При употреблении психохила (/grib heal) анимация собъётся пустым сообщением в чат")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("autologin", imgui.ImBool(srp_ini.bools.autologin)) then
                srp_ini.bools.autologin = not srp_ini.bools.autologin
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Вводить пароль в диалог авторизации")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Как только вы подключитесь к серверу и вам высветится диалог авторизации, скрипт моментально введёт ваш пароль в строку и примет диалог")
                imgui.EndTooltip()
            end
            if srp_ini.bools.autologin then
                imgui.SameLine()
                imgui.PushFont(fonts.arial16)
                if imgui.Button("Ввести пароль для автологина", vec(71.0, 9.5)) then
                    imgui.section('password')
                end
                imgui.PopFont()
            end
            if imgui.ToggleButton("autorent", imgui.ImBool(srp_ini.bools.autorent)) then
                srp_ini.bools.autorent = not srp_ini.bools.autorent
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Арендовать транспорт (не дороже ")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Как только вам высветится диалог с предложением арендовать транспорт и цена аренды будет приемлима, то вы его моментально арендуете и запустите двигатель")
                imgui.EndTooltip()
            end
            imgui.SameLine()
            imgui.PushItemWidth(toScreenX(30))
            if imgui.InputText('##d3', buffer.autorent) then
                srp_ini.values.autorent = tostring(u8:decode(buffer.autorent.v))
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.PopItemWidth()
            imgui.Text(" вирт.)")
            if imgui.ToggleButton("robbing", imgui.ImBool(srp_ini.bools.robbing)) then
                srp_ini.bools.robbing = not srp_ini.bools.robbing
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Помощник для ограбления домов (автоматически выносит из дома и заходит обратно)")
            if imgui.IsItemHovered() then
                local hstr = ""
                for _, v in ipairs(string.split(srp_ini.hotkey.enterhouse, ", ")) do
                    if v ~= "0" then
                        hstr = hstr == "" and tostring(vkeys.id_to_name(tonumber(v))) or "" .. hstr .. " + " ..
                                   tostring(vkeys.id_to_name(tonumber(v))) .. ""
                    end
                end
                hstr = (hstr == "" or hstr == "nil") and "" or hstr
                imgui.BeginTooltip()
                imgui.TextUnformatted("Что бы взломать дом нажмите " ..
                                          (hstr ~= "" and hstr .. " (клавиша входа в дом)" or
                                              "клавишу входа в дом (можно задать в разделе \"Клавиши и команды\")") ..
                                          ", обязательно припаркуйте фургон таким образом, что бы его пикап находился чётко возле пикапа дома")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("withdrawal", imgui.ImBool(srp_ini.bools.withdrawal)) then
                srp_ini.bools.withdrawal = not srp_ini.bools.withdrawal
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Употребить нарко в случае если у вас началась ломка")
            imgui.SameLine()
            if imgui.Checkbox(
                "Не употреблять нарко при ломке, если на экране есть копы",
                imgui.ImBool(srp_ini.bools.withoutcops)) then
                srp_ini.bools.withoutcops = not srp_ini.bools.withoutcops
                inicfg.save(srp_ini, settings)
            end
            if imgui.ToggleButton("spam", imgui.ImBool(srp_ini.bools.spam)) then
                srp_ini.bools.spam = not srp_ini.bools.spam
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Сразу отвечать на спам-СМС (что бы увидеть что хотел вам написать игрок)")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "На сервере работает анти-спам система, игроки до 3 LVL не могут всем рассылать сообщения, от них стоит защита и у них КД на СМС 30 секунд")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("house", imgui.ImBool(srp_ini.bools.house)) then
                srp_ini.bools.house = not srp_ini.bools.house
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Уведомлять о слёте недвижимости при заходе в игру")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Когда вы оплатите квартплату или же наступит пейдей, скрипт запомнит дату слёта недвижимости")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("rkt", imgui.ImBool(srp_ini.bools.rkt)) then
                srp_ini.bools.rkt = not srp_ini.bools.rkt
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Автоматически покупать ремкомплекты (не дороже ")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Если вдруг вам нужно купить их ещё раз (не сработало из-за лимита), то перезайдите в магазин")
                imgui.EndTooltip()
            end
            imgui.SameLine()
            imgui.PushItemWidth(toScreenX(30))
            if imgui.InputText('##d4', buffer.rkt) then
                srp_ini.values.rkt = tostring(u8:decode(buffer.rkt.v))
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.PopItemWidth()
            imgui.Text(" вирт.)")
            if imgui.ToggleButton("jfleader", imgui.ImBool(srp_ini.bools.jfleader)) then
                srp_ini.bools.jfleader = not srp_ini.bools.jfleader
                inicfg.save(srp_ini, settings)
                if srp_ini.bools.jfleader then
                    sampRegisterChatCommand("jfadd", cmd_jfadd)
                    sampRegisterChatCommand("jfdel", cmd_jfdel)
                    sampRegisterChatCommand("jfmute", cmd_jfmute)
                    sampRegisterChatCommand("jffine", cmd_jffine)
                else
                    sampUnregisterChatCommand("jfadd")
                    sampUnregisterChatCommand("jfdel")
                    sampUnregisterChatCommand("jfmute")
                    sampUnregisterChatCommand("jffine")
                end
            end
            imgui.SameLine()
            imgui.Text("Включить режим лидера профсоюза")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Можно выбрать ваш профсоюз\nДобавляются команды:\n/jfadd [id] - добавить в профсоюз\n/jfdel [id/nick] - удалить из профсоюза\n/jfmute [id] [sec] - выдать бан чата профсоюза игроку\n/jffine [id] [вирт] - оштрафовать игрока профсоюза")
                imgui.EndTooltip()
            end
            if srp_ini.bools.jfleader then
                imgui.SameLine()
                imgui.PushFont(fonts.arial16)
                if imgui.Button("Указать профсоюз из списка", vec(71.0, 9.5)) then
                    var.need.jf = true
                    imgui.section('jf')
                end
                imgui.PopFont()
            end
            if imgui.ToggleButton("quitfromcops", imgui.ImBool(srp_ini.bools.quitfromcops)) then
                srp_ini.bools.quitfromcops = not srp_ini.bools.quitfromcops
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Автоматически отсоединяться от сервера при аресте")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Если вам попытаются надеть наручники, обыскать, зафризить тэйзером - вы отключитесь от сервера")
                imgui.TextColoredRGB(
                    "{FF0606}ВНИМАНИЕ!!! Не включайте данную функцию если:\n{FF0606}1) Боитесь оказаться в деморгане за офф от ареста\n{FF0606}2) Боитесь получить WARN, т.к. функция может быть запрещена. Ответственность за использование исключительно на вас!")
                imgui.EndTooltip()
            end
        end

        if menu.binds.bool.v then
            imgui.PushFont(fonts.arial16)
            imgui.Hotkey("context", "context", 100 / 3)
            imgui.SameLine()
            imgui.Text(
                "Контекстная клавиша\n(удерживайте чтобы отменить задачу - только одиночная клавиша)")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Контекстная клавиша - это единичный биндер который отправляет сообщение в чат в той или иной ситуации.")
                imgui.TextUnformatted(
                    "На данный момент имеются следующие ситуации:")
                imgui.TextUnformatted(
                    "1) Возле вас поломанный транспорт (< 300 dl) или у него пробиты колёса - /rkt")
                imgui.TextUnformatted(
                    "2) Вы зашли в больницу а в ней нет врачей? - отправить всем врачам (кто в игре) СМС прийти в вашу больницу")
                imgui.TextUnformatted(
                    "3) Вас заДМили? - отправить репорт на жалкого урода ДМщика")
                imgui.TextUnformatted(
                    "4) Кто-то сел к вам в такси - спросить куда ехать")
                imgui.TextUnformatted(
                    "5) Клиент сказал куда ехать - положительно ответить")
                imgui.TextUnformatted(
                    "6) Клиент вышел из такси - красиво попрощаться")
                imgui.TextUnformatted(
                    "7) Приняли вызов и приехали к клиенту - сказать что бы сел в такси")
                imgui.TextUnformatted(
                    "8) Перевернулись на машине - отправить репорт администрации что бы флипнули")
                imgui.TextUnformatted(
                    "Функция работает только если у вас включён рендер статуса контекстной клавиши в меню \"Рендер\"")
                imgui.EndTooltip()
            end
            imgui.Hotkey("drugs", "drugs", 100 / 3)
            imgui.SameLine()
            imgui.Text("Употребить нарко\n(нужно находится на месте)")
            imgui.Hotkey("psycho", "psycho", 100 / 3)
            imgui.SameLine()
            imgui.Text("Употребить психохил\n(/grib heal)")
            if srp_ini.hotkey["psycho"] ~= "0" then
                imgui.SameLine()
                if imgui.ToggleButton("psychoeat", imgui.ImBool(srp_ini.bools.psychoeat)) then
                    srp_ini.bools.psychoeat = not srp_ini.bools.psychoeat
                    inicfg.save(srp_ini, settings)
                end
                imgui.SameLine()
                local hstr = ""
                for _, v in ipairs(string.split(srp_ini.hotkey.psycho, ", ")) do
                    if v ~= "0" then
                        hstr = hstr == "" and tostring(vkeys.id_to_name(tonumber(v))) or "" .. hstr .. " + " ..
                                   tostring(vkeys.id_to_name(tonumber(v))) .. ""
                    end
                end
                hstr = (hstr == "" or hstr == "nil") and "" or hstr
                imgui.Text(
                    "Кушать рыбу от голода при нажатии горячей клавиши " ..
                        (hstr ~= "" and hstr or "приёма психохила"))
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.TextUnformatted(
                        "При попытке употребить психохил горячей клавишей, если сытость будет ниже 20 ед., то сначало будет употреблена готовая рыба")
                    imgui.EndTooltip()
                end
                if srp_ini.bools.psychoeat then
                    imgui.SameLine()
                    if imgui.Checkbox("Кушать грибы вместо рыбы",
                        imgui.ImBool(srp_ini.bools.knockmushroom)) then
                        srp_ini.bools.knockmushroom = not srp_ini.bools.knockmushroom
                        inicfg.save(srp_ini, settings)
                    end
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.TextUnformatted(
                            "Аналогично функции левее, однако теперь вместо рыбы будут поедаться готовые грибы")
                        imgui.EndTooltip()
                    end
                end
            end
            imgui.Hotkey("changeclist", "changeclist", 100 / 3)
            imgui.SameLine()
            imgui.Text(
                "Сменить клист\n(если надет не нулевой клист, то будет введён /clist 0)")
            imgui.SameLine()
            imgui.PushItemWidth(toScreenX(67))
            if imgui.Combo("##Combo", buffer.clist, clists.names) then
                srp_ini.values.clist = tostring(u8:decode(buffer.clist.v))
                inicfg.save(srp_ini, settings)
            end
            imgui.Hotkey("enterhouse", "enterhouse", 100 / 3)
            imgui.SameLine()
            imgui.Text(
                "Войти в ближайший дом\n(Аналогично если вы находитесь внутри дома возле входа, то скрипт выйдет из него)")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Настоятельно рекомендую использовать эту клавишу для ограбления домов!")
                imgui.EndTooltip()
            end
            imgui.Hotkey("lock", "lock", 100 / 3)
            imgui.SameLine()
            imgui.Text("Открыть дверь транспорта\n(/lock)")
            imgui.Hotkey("autowalk", "autowalk", 100 / 3)
            imgui.SameLine()
            imgui.Text("Зажать клавишу бега\n(Работает как переключатель)")
            imgui.Hotkey("fastmenu", "fastmenu", 100 / 3)
            imgui.SameLine()
            imgui.Text(
                "При зажатии откроется быстрое меню биндера\n(Что бы настроить биндер см.меню 'Кастомный биндер')")
            imgui.Hotkey("eject", "eject", 100 / 3)
            imgui.SameLine()
            imgui.Text(
                "Выкинуть всех игроков из транспорта\n(Работает только если игрок не в АФК)")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Если клавишу зажать, то можно будет выбрать конкретного игрока")
                imgui.EndTooltip()
            end
            imgui.PopFont()
        end

        if menu.render.bool.v then
            imgui.Text(
                "Что бы изменить положение элемента, перетяните его на экране")
            imgui.Text("Положение элемента сохранится автоматически")
            if imgui.ToggleButton("date", imgui.ImBool(srp_ini.bools.date)) then
                srp_ini.bools.date = not srp_ini.bools.date
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Отображение даты и времени на экране")
            if imgui.ToggleButton("nick", imgui.ImBool(srp_ini.bools.nick)) then
                srp_ini.bools.nick = not srp_ini.bools.nick
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Отображение никнейма и IDа в цвете клиста")
            if imgui.ToggleButton("ping", imgui.ImBool(srp_ini.bools.ping)) then
                srp_ini.bools.ping = not srp_ini.bools.ping
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Отображение текущего пинга")
            if imgui.ToggleButton("drugscooldown", imgui.ImBool(srp_ini.bools.drugscooldown)) then
                srp_ini.bools.drugscooldown = not srp_ini.bools.drugscooldown
                inicfg.save(srp_ini, settings)
                if srp_ini.bools.drugscooldown then
                    checkDialog("boostinfo")
                end
            end
            imgui.SameLine()
            imgui.Text(
                "Отображение КД употребления нарко (синхронизировано с /boostinfo)")
            if imgui.ToggleButton("event", imgui.ImBool(srp_ini.bools.event)) then
                srp_ini.bools.event = not srp_ini.bools.event
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Отображение таймеров до начала системных мероприятий")
            if imgui.ToggleButton("stream", imgui.ImBool(srp_ini.bools.stream)) then
                srp_ini.bools.stream = not srp_ini.bools.stream
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Отображение количества игроков в зоне прорисовки")
            if imgui.ToggleButton("status", imgui.ImBool(srp_ini.bools.status)) then
                srp_ini.bools.status = not srp_ini.bools.status
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Отображение статуса контекстной клавиши")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Контекстная клавиша - это единичный биндер который отправляет сообщение в чат в той или иной ситуации.")
                imgui.TextUnformatted(
                    "На данный момент имеются следующие ситуации:")
                imgui.TextUnformatted("1) Возле вас поломанный транспорт - /rkt")
                imgui.TextUnformatted(
                    "2) Вы зашли в больницу а в ней нет врачей? - отправить всем врачам (кто в игре) СМС прийти в вашу больницу")
                imgui.TextUnformatted(
                    "3) Вас заДМили? - отправить репорт на жалкого урода ДМщика")
                imgui.TextUnformatted(
                    "4) Кто-то сел к вам в такси - спросить куда ехать")
                imgui.TextUnformatted(
                    "5) Клиент сказал куда ехать - положительно ответить")
                imgui.TextUnformatted(
                    "6) Клиент вышел из такси - красиво попрощаться")
                imgui.TextUnformatted(
                    "7) Приняли вызов и приехали к клиенту - сказать что бы сел в такси")
                imgui.TextUnformatted(
                    "Обязательно задайте клавишу в меню \"Клавиши и команды\"")
                imgui.EndTooltip()
            end
            if imgui.ToggleButton("squad", imgui.ImBool(srp_ini.bools.squad)) then
                srp_ini.bools.squad = not srp_ini.bools.squad
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Отображение улучшенного вида сквада")
            if srp_ini.bools.squad then
                imgui.SameLine()
                if imgui.Checkbox("Скрывать сквад если активна строка чата",
                    imgui.ImBool(srp_ini.bools.disablesquad)) then
                    srp_ini.bools.disablesquad = not srp_ini.bools.disablesquad
                    inicfg.save(srp_ini, settings)
                end
            end
            if imgui.ToggleButton("hpcars", imgui.ImBool(srp_ini.bools.hpcars)) then
                srp_ini.bools.hpcars = not srp_ini.bools.hpcars
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text("Отображение ХП на окружающем транспорте")
            if imgui.ToggleButton("chatinfo", imgui.ImBool(srp_ini.bools.chatinfo)) then
                srp_ini.bools.chatinfo = not srp_ini.bools.chatinfo
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Отображение раскладки, капса, и кол-ва символов под строкой чата")
            if imgui.ToggleButton("equest", imgui.ImBool(srp_ini.bools.equest)) then
                srp_ini.bools.equest = not srp_ini.bools.equest
                inicfg.save(srp_ini, settings)
                if srp_ini.bools.equest then
                    checkDialog("equest")
                end
            end
            imgui.SameLine()
            imgui.Text(
                "Отображение активных ежедневных заданий. Обязательно установите ваш часовой пояс:")
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "Если в рендере описание не указано (задание светится красным), то это означает что в базе данных скрипта отсутствует описание данного задания")
                imgui.TextUnformatted(
                    "Что бы получить описание задания, нужно открыть его в /equest, далее скрипт сохранит описание")
                imgui.TextUnformatted(
                    "Настоятельно рекомендую в такой ситуации отписать разработчику в тг " ..
                        script.telegram.nick .. " название и описание задания")
                imgui.EndTooltip()
            end
            imgui.SameLine()
            imgui.PushItemWidth(toScreenX(67))
            if imgui.Combo("##Combo", buffer.timezonedifference, timezones) then
                srp_ini.values.timezonedifference = tostring(u8:decode(buffer.timezonedifference.v) - 14)
                inicfg.save(srp_ini, settings)
                if srp_ini.bools.equest then
                    checkDialog("equest")
                end
            end
            if imgui.ToggleButton("inventory", imgui.ImBool(srp_ini.bools.inventory)) then
                srp_ini.bools.inventory = not srp_ini.bools.inventory
                inicfg.save(srp_ini, settings)
                if srp_ini.bools.inventory then
                    checkDialog("inventory")
                end
            end
            imgui.SameLine()
            imgui.Text("Отображение содержимого инвентаря")
            imgui.SameLine()
            imgui.PushFont(fonts.arial16)
            if imgui.Button("Настроить предметы инвентаря", vec(80.00, 9.54)) then
                imgui.section('inventory')
            end
            imgui.PopFont()
            if imgui.ToggleButton("kd", imgui.ImBool(srp_ini.bools.kd)) then
                srp_ini.bools.kd = not srp_ini.bools.kd
                inicfg.save(srp_ini, settings)
            end
            imgui.SameLine()
            imgui.Text(
                "Отображение КД до следующего ограбления домов/автоугона")
        end

        if menu.binder.bool.v then
            imgui.Text(
                "Меню кастомного биндера на клавиши / команды (крайне не рекомендую вручную изменять .ini файл)")
            imgui.PushFont(fonts.arial16)
            if imgui.Button("Добавить бинд", vec(56, 10)) then
                table.insert(binder_ini.list, encodeJson({
                    name = "Новый бинд",
                    msg = {},
                    cmd = "",
                    hotkey = "0",
                    fast = false
                }))
                inicfg.save(binder_ini, binds)
            end
            imgui.SameLine()
            if imgui.Button("Редактировать", vec(58, 10)) then
                if var.current.bind ~= nil then
                    menu.editor.bool.v = true
                end
            end
            imgui.SameLine()
            if imgui.Button("Вниз", vec(58, 10)) then
                if var.current.bind ~= nil then
                    if binder_ini.list[var.current.bind + 1] ~= nil then
                        local bk = binder_ini.list[var.current.bind]
                        binder_ini.list[var.current.bind] = binder_ini.list[var.current.bind + 1]
                        binder_ini.list[var.current.bind + 1] = bk
                        var.current.bind = var.current.bind + 1
                        inicfg.save(binder_ini, binds)
                    end
                end
            end
            imgui.SameLine()
            if imgui.Button("Вверх", vec(58, 10)) then
                if var.current.bind ~= nil then
                    if binder_ini.list[var.current.bind - 1] ~= nil then
                        local bk = binder_ini.list[var.current.bind]
                        binder_ini.list[var.current.bind] = binder_ini.list[var.current.bind - 1]
                        binder_ini.list[var.current.bind - 1] = bk
                        var.current.bind = var.current.bind - 1
                        inicfg.save(binder_ini, binds)
                    end
                end
            end
            imgui.SameLine()
            if imgui.CustomButton("Настройка текстовых переменных",
                ImVec4(0.85, 0.98, 0.26, 0.40), ImVec4(0.85, 0.98, 0.26, 1.00), ImVec4(0.82, 0.98, 0.06, 1.00),
                vec(84, 10)) then
                imgui.section('variables')
            end
            for k, v in ipairs(binder_ini.list) do
                imgui.PushID(k)
                v = decodeJson(v)
                local cmd = imgui.ImBuffer(v.cmd, 256)
                if imgui.Button(tostring(k), vec(17, 9)) then
                    var.current.bind = k
                    menu.binder.bool.v = false
                    imgui.section('editor')
                end
                imgui.SameLine()
                if var.current.bind == k then
                    if imgui.CustomButton(v.name, ImVec4(0.85, 0.98, 0.26, 0.40), ImVec4(0.85, 0.98, 0.26, 1.00),
                        ImVec4(0.82, 0.98, 0.06, 1.00), vec(115, 9)) then
                        var.current.bind = nil
                    end
                else
                    if imgui.Button(v.name, vec(115, 9)) then
                        var.current.bind = k
                    end
                end
                imgui.SameLine()
                imgui.binderHotkey(k, k, 9)
                imgui.SameLine()
                imgui.PushItemWidth(toScreenX(40))
                if imgui.InputText('##bindсommand', cmd) then
                    if not cmd.v:match("srp") then
                        v.cmd = cmd.v
                        binder_ini.list[k] = encodeJson(v)
                        inicfg.save(binder_ini, binds)
                    end
                end
                imgui.PopItemWidth()
                imgui.PushFont(fonts.arial20)
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.TextUnformatted('Команду вводить без "/"')
                    imgui.TextUnformatted(
                        'Для работы бинда достаточно либо клавиши либо команды, но также можно и то и другое')
                    imgui.EndTooltip()
                end
                imgui.PopFont()
                imgui.SameLine()
                if imgui.CustomButton("Удалить", imgui.ImVec4(0.48, 0.16, 0.16, 0.54),
                    imgui.ImVec4(0.98, 0.43, 0.26, 0.67), imgui.ImVec4(0.98, 0.43, 0.26, 0.40), vec(30.00, 9)) then
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
                imgui.PushFont(fonts.arial20)
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.TextUnformatted("Добавить бинд в быстрое-меню")
                    imgui.TextUnformatted(
                        "Активировать быстрое меню можно в разделе \"Клавиши и команды\"")
                    imgui.EndTooltip()
                end
                imgui.PopFont()
                imgui.PopID()
            end
            imgui.PopFont()
        end

        if menu.editor.bool.v then
            if var.current.bind ~= nil then
                if tonumber(var.current.bind) ~= nil then
                    imgui.Text("Редактор бинда #" .. var.current.bind ..
                                   " | Настройки сохраняются автоматически, доступно использование текстовых переменных")
                    imgui.PushFont(fonts.arial16)
                    local str = binder_ini.list[var.current.bind]
                    local b = decodeJson(str)
                    local name = imgui.ImBuffer(b.name, 256)
                    imgui.Text("Установить название бинда: ")
                    imgui.SameLine()
                    imgui.PushItemWidth(toScreenX(100))
                    if imgui.InputText('##bindname', name) then
                        b.name = name.v
                    end
                    imgui.PopItemWidth()
                    imgui.SameLine()
                    if imgui.CustomButton("Настройка текстовых переменных",
                        ImVec4(0.85, 0.98, 0.26, 0.40), ImVec4(0.85, 0.98, 0.26, 1.00), ImVec4(0.82, 0.98, 0.06, 1.00),
                        vec(84, 9)) then
                        imgui.section('variables')
                    end
                    imgui.SameLine(toScreenX(293))
                    if imgui.Button("Вернутся назад", vec(100.00, 9)) then
                        imgui.section('binder')
                    end
                    if imgui.Button("Добавить строку", vec(57, 9)) then
                        table.insert(b.msg, "")
                    end
                    for k, v in ipairs(b.msg) do
                        local str = imgui.ImBuffer(v, 256)
                        imgui.PushItemWidth(toScreenX(354))
                        if imgui.InputText('##bindmsg' .. k, str) then
                            b.msg[k] = str.v
                        end
                        imgui.SameLine()
                        imgui.PushID(k)
                        if imgui.Button('Удалить', vec(30, 9)) then
                            table.remove(b.msg, k)
                        end
                        imgui.PopID()
                    end
                    binder_ini.list[var.current.bind] = encodeJson(b)
                    inicfg.save(binder_ini, binds)
                    imgui.PopFont()
                else
                    imgui.Text("Произошла ошибка, попробуйте ещё раз!")
                end
            else
                imgui.Text("Произошла ошибка, попробуйте ещё раз!")
            end
        end

        if menu.information.bool.v then
            imgui.Text(
                "Данный скрипт является многофункциональным хелпером для игроков проекта Samp RP")
            imgui.Text("Автор: " .. unpack(thisScript().authors) .. " | Telegram: " .. script.telegram.nick)
            imgui.SameLine()
            imgui.PushFont(fonts.arial16)
            if imgui.Button("Написать разработчику", vec(60.00, 9.54)) then
                os.execute("explorer " .. script.telegram.url)
            end
            imgui.PopFont()
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "При нажатии, в браузере по умолчанию откроется ссылка на телеграм разработчика")
                imgui.EndTooltip()
            end
            imgui.Text("Все настройки автоматически сохраняются config")
            imgui.SameLine()
            imgui.PushFont(fonts.arial16)
            if imgui.Button("Открыть папку с настройками", vec(71.67, 9.54)) then
                os.execute(string.format("explorer %s\\config\\SRPfunctions by Webb\\%s\\%s", thisScript().directory,
                    server, var.current.nick))
            end
            imgui.PopFont()
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.TextUnformatted(
                    "При нажатии откроется папка, где сохранены настройки вашего текущего сервера и ника")
                imgui.EndTooltip()
            end
            imgui.Text("Информация о последних обновлениях:")
            imgui.BeginChild('changelog', vec(390.00, -1), true)
            for _, ver in ipairs(script.upd.sort) do
                local upd = script.upd.changes[tostring(ver)]
                if upd ~= nil then
                    if imgui.CollapsingHeader("Версия v" .. ver .. " от " .. upd.date) then
                        imgui.PushTextWrapPos(toScreenX(390))
                        imgui.Text(upd.text)
                        imgui.PopTextWrapPos()
                    end
                end
            end
            imgui.EndChild()
        end
        imgui.EndChild()

        imgui.BeginChild('bottom', vec(395, 40), false)
        local found = false
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
                local nick = sampGetPlayerNickname(i)
                if script.label[server][nick] and not found then
                    if script.label[server][nick].button then
                        found = true
                        if imgui.CustomButton(string.format("%s[%d] сейчас в сети", nick, i),
                            ImVec4(0.85, 0.98, 0.26, 0.40), ImVec4(0.85, 0.98, 0.26, 1.00),
                            ImVec4(0.82, 0.98, 0.06, 1.00), vec(100, 12)) then
                            chatManager.addMessageToQueue(string.format("/t %d Привет, мой хороший", i))
                        end
                    end
                end
            end
        end
        if not found then
            if imgui.Button("Разработчик сейчас не в сети", vec(100.00, 12.00)) then
                script.sendMessage(unpack(thisScript().authors) .. " играет на Samp-RP (на " .. server ..
                                       " сейчас не онлайн)")
            end
        end
        imgui.PushFont(fonts.arial16)
        imgui.SameLine(toScreenX(329))
        if imgui.Button("Перезагрузить скрипт", vec(66.00, 12.00)) then
            showCursor(false)
            script.reload = true
            thisScript():reload()
        end
        if imgui.Button("Все команды скрипта", vec(66.00, 9.50)) then
            imgui.section('commands')
        end
        imgui.SameLine(toScreenX(329))
        if imgui.Button("Отключить скрипт", vec(66.00, 9.50)) then
            showCursor(false)
            script.unload = true
            thisScript():unload()
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.TextUnformatted(
                "При нажатии, скрипт будет отключён до следующего запуска игры")
            imgui.EndTooltip()
        end
        if imgui.Button("Информация о скрипте", vec(66.00, 9.50)) then
            imgui.section('information')
        end
        imgui.SameLine(toScreenX(329))
        if imgui.Button("Открыть GitHub", vec(66.00, 9.50)) then
            os.execute('explorer "https://github.com/WebbLua/SRPfunctions"')
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.TextUnformatted(
                "При нажатии, в браузере по умолчанию откроется ссылка на GitHub скрипта")
            imgui.EndTooltip()
        end
        imgui.PopFont()
        imgui.EndChild()

        imgui.End()
        imgui.PopFont()
    end

    if menu.password.bool.v then
        imgui.PushFont(fonts.arial20)
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, vec(0.17, 0.21))
        imgui.SetNextWindowSize(vec(156, 65), imgui.Cond.FirstUseEver)
        imgui.Begin("Ввод пароля", menu.password.bool,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
        imgui.Text(
            "Введите в текстовую строку ваш пароль от аккаунта\nВНИМАНИЕ!!! Ваш пароль никуда не отправляется\nОн всего лишь сохранится в ваш .ini файл\nНикому не отправляйте свой конфиг!")
        imgui.PushItemWidth(toScreenX(100))
        if imgui.InputText('##password', buffer.password) then
            srp_ini.values.password = tostring(u8:decode(buffer.password.v))
            inicfg.save(srp_ini, settings)
        end
        imgui.PopItemWidth()
        imgui.End()
        imgui.PopFont()
    end

    if menu.inventory.bool.v then
        imgui.PushFont(fonts.arial20)
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, vec(0.17, 0.21))
        imgui.SetNextWindowSize(vec(210.00, 232.00), imgui.Cond.FirstUseEver)
        imgui.Begin("Выбор предметов для отображения", menu.inventory.bool,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
        imgui.BeginChild('inventory', vec(205.00, 215.00), true)
        imgui.Text(
            "Выберите предметы, количество которых будет выводится на экран\nЕсли предмет светится жёлтым/красным - значит его мало/отсутствует")
        if imgui.ToggleButton("drugs", imgui.ImBool(srp_ini.inventoryItem.drugs)) then
            srp_ini.inventoryItem.drugs = not srp_ini.inventoryItem.drugs
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Наркотики\"")
        if imgui.ToggleButton("mats", imgui.ImBool(srp_ini.inventoryItem.mats)) then
            srp_ini.inventoryItem.mats = not srp_ini.inventoryItem.mats
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Материалы\"")
        if imgui.ToggleButton("keys", imgui.ImBool(srp_ini.inventoryItem.keys)) then
            srp_ini.inventoryItem.keys = not srp_ini.inventoryItem.keys
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Ключи от камеры\"")
        if imgui.ToggleButton("canister", imgui.ImBool(srp_ini.inventoryItem.canister)) then
            srp_ini.inventoryItem.canister = not srp_ini.inventoryItem.canister
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Канистра с бензином\"")
        if imgui.ToggleButton("fish", imgui.ImBool(srp_ini.inventoryItem.fish)) then
            srp_ini.inventoryItem.fish = not srp_ini.inventoryItem.fish
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Сырая рыба\"")
        if imgui.ToggleButton("cookedfish", imgui.ImBool(srp_ini.inventoryItem.cookedfish)) then
            srp_ini.inventoryItem.cookedfish = not srp_ini.inventoryItem.cookedfish
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Готовая рыба\"")
        if imgui.ToggleButton("mushroom", imgui.ImBool(srp_ini.inventoryItem.mushroom)) then
            srp_ini.inventoryItem.mushroom = not srp_ini.inventoryItem.mushroom
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Грибы\"")
        if imgui.ToggleButton("repairkit", imgui.ImBool(srp_ini.inventoryItem.repairkit)) then
            srp_ini.inventoryItem.repairkit = not srp_ini.inventoryItem.repairkit
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Комплект «автомеханик»\"")
        if imgui.ToggleButton("psychoheal", imgui.ImBool(srp_ini.inventoryItem.psychoheal)) then
            srp_ini.inventoryItem.psychoheal = not srp_ini.inventoryItem.psychoheal
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Психохил\"")
        if imgui.ToggleButton("cookedmushroom", imgui.ImBool(srp_ini.inventoryItem.cookedmushroom)) then
            srp_ini.inventoryItem.cookedmushroom = not srp_ini.inventoryItem.cookedmushroom
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Готовые грибы\"")
        if imgui.ToggleButton("adrenaline", imgui.ImBool(srp_ini.inventoryItem.adrenaline)) then
            srp_ini.inventoryItem.adrenaline = not srp_ini.inventoryItem.adrenaline
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Адреналин\"")
        if imgui.ToggleButton("cork", imgui.ImBool(srp_ini.inventoryItem.cork)) then
            srp_ini.inventoryItem.cork = not srp_ini.inventoryItem.cork
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Защита от насильников\"")
        if imgui.ToggleButton("balaclava", imgui.ImBool(srp_ini.inventoryItem.balaclava)) then
            srp_ini.inventoryItem.balaclava = not srp_ini.inventoryItem.balaclava
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Балаклава\"")
        if imgui.ToggleButton("scrap", imgui.ImBool(srp_ini.inventoryItem.scrap)) then
            srp_ini.inventoryItem.scrap = not srp_ini.inventoryItem.scrap
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Лом\"")
        if imgui.ToggleButton("energy", imgui.ImBool(srp_ini.inventoryItem.energy)) then
            srp_ini.inventoryItem.energy = not srp_ini.inventoryItem.energy
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Энергетик\"")
        if imgui.ToggleButton("robkit", imgui.ImBool(srp_ini.inventoryItem.robkit)) then
            srp_ini.inventoryItem.robkit = not srp_ini.inventoryItem.robkit
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Предмет: \"Набор для взлома\"")
        imgui.EndChild()
        imgui.End()
        imgui.PopFont()
    end

    if menu.jf.bool.v then
        imgui.PushFont(fonts.arial20)
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, vec(0.17, 0.21))
        imgui.SetNextWindowSize(vec(250, 40), imgui.Cond.FirstUseEver)
        imgui.Begin("Выбор профсоюза", menu.jf.bool,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
        imgui.Text(
            "Откройте меню и выберите профсоюз, в котором вы занимаете должность \"Начальник\"")
        if var.jf.combo ~= nil and not var.need.jf then
            if buffer.jf == nil then
                buffer.jf = imgui.ImInt('0')
            end
            imgui.PushItemWidth(toScreenX(120))
            if imgui.Combo("##jf", buffer.jf, var.jf.combo) then
                srp_ini.values.jf = var.jf.combo[buffer.jf.v + 1]
                srp_ini.values.jfjob = u8(var.jf.list[u8:decode(srp_ini.values.jf)])
                inicfg.save(srp_ini, settings)
            end
            imgui.PopItemWidth()
        else
            imgui.TextColoredRGB("{B30000}Получаю список из диалогов...")
            if not var.jf.checklist then
                var.jf.checklist = true
                chatManager.addMessageToQueue("/jf")
            end
        end
        imgui.End()
        imgui.PopFont()
    end

    if menu.variables.bool.v then
        imgui.PushFont(fonts.arial20)
        local vars =
            {"@params@ - заменится на все параметры команды, которой активируется ваш бинд (напр. /test 1 1 1 => В чате будет текст бинда и 1 1 1",
             "@param1@ - заменится на 1 параметр команды, которой активируется ваш бинд (напр. /test 1 2 3 => В чате будет текст бинда и 1; аналогично можно брать @param2@, @param3@ и.т.д.",
             "@myid@ - заменится на ваш ID", "@mynick@ - заменится на ваш ник",
             "@myrpnick@ - заменится на ваш РП ник (без '_', в случае если ник нонрп, то напишет просто ник)",
             "@myname@ - заменится на ваше имя (если ник нонРП то напишет просто ник)",
             "@mysurname@ - заменится на вашу фамилию (если ник нонРП то напишет просто ник)",
             "@date@ - текущая дата вашего ПК в формате: dd.mm.yy",
             "@hour@ - текущий час вашего ПК в 24-часовом формате",
             "@min@ - текущая минута вашего ПК",
             "@sec@ - текущая секунда вашего ПК", "@myclist@ - текущий ваш клист",
             "@mainclist@ - ваш главный клист (см.меню \"Клавиши и команды\")",
             "@kv@ - текущий квадрат/сектор на карте"}
        local sortvars = {}
        for k, v in ipairs(vars) do
            table.insert(sortvars, imgui.CalcTextSize(v).x)
        end
        table.sort(sortvars, function(a, b)
            return a < b
        end)
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, vec(0.17, 0.21))
        imgui.SetNextWindowSize(vec(600, 185), imgui.Cond.FirstUseEver, imgui.WindowFlags.NoCollapse +
            imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
        imgui.Begin("Все текстовые переменные скрипта", menu.variables.bool,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
        imgui.Text(
            "Переменные можно использовать в биндере, и просто в чате:")
        if imgui.ToggleButton("variables", imgui.ImBool(srp_ini.bools.variables)) then
            srp_ini.bools.variables = not srp_ini.bools.variables
            inicfg.save(srp_ini, settings)
        end
        imgui.SameLine()
        imgui.Text("Использовать переменные и для обычного чата")
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.TextUnformatted(
                "Разница заключается в том, что если параметр будет активирован, то вы сможете помимо биндера также использовать переменные и просто в чате.")
            imgui.EndTooltip()
        end
        imgui.BeginChild('variables', vec(594, 144), true)
        for k, v in ipairs(vars) do
            imgui.Text(v)
        end
        imgui.EndChild()
        imgui.End()
        imgui.PopFont()
    end

    if menu.commands.bool.v then
        imgui.PushFont(fonts.arial20)
        local cmds = {"/srp (/samprp) - открыть/закрыть главное меню скрипта",
                      "/srpflood [Text] (/samprpflood [Text]) - флудить заданным текстом в чат",
                      "/srpstop - очистить очередь отправляемых сообщений в чат (очень полезно если биндер флудит без остановки)",
                      "/whenhouse - узнать когда слетит недвижимость",
                      "/st [0-24] - установить игровое время",
                      "/sw [0-45] - установить игровую погоду"}
        local w = 0
        local sortcmds = {}
        for k, v in ipairs(cmds) do
            table.insert(sortcmds, imgui.CalcTextSize(v).x)
        end
        table.sort(sortcmds, function(a, b)
            return a < b
        end)
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, vec(0.17, 0.21))
        imgui.SetNextWindowSize(vec(400, 94), imgui.Cond.FirstUseEver, imgui.WindowFlags.NoCollapse +
            imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
        imgui.Begin("Все команды скрипта", menu.commands.bool,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
        imgui.Text(
            "Данные команды являются системными, их нельзя изменить:")
        imgui.BeginChild('commands', vec(395, 67), true)
        for k, v in ipairs(cmds) do
            imgui.Text(v)
        end
        imgui.EndChild()
        imgui.End()
        imgui.PopFont()
    end

    if menu.fastbinder.bool.v then
        imgui.SwitchContext()
        colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
        imgui.PushFont(fonts.arial20)
        imgui.ShowCursor = true
        imgui.SetNextWindowPos(vec(srp_ini.render.fastbinderX, srp_ini.render.fastbinderY), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(vec(133.00, 207.00), imgui.Cond.FirstUseEver)
        imgui.Begin("Быстрое меню биндера", _,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
        imgui.BeginChild('fastbinder', vec(128.00, 190.00), true)
        for k, v in ipairs(binder_ini.list) do
            local b = decodeJson(v)
            if b.fast then
                imgui.PushID(k)
                if imgui.Button(b.name, vec(122.00, 10.00)) then
                    binder(k)
                end
                imgui.PopID()
            end
        end
        imgui.EndChild()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.fastbinderX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.fastbinderY)) and imgui.IsRootWindowOrAnyChildFocused() and
            imgui.IsMouseDragging(0) and imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.fastbinderX = math.ceil(savePosX)
            srp_ini.render.fastbinderY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
        imgui.PopFont()
    end

    imgui.SwitchContext() -- render
    colors[clr.WindowBg] = ImVec4(0, 0, 0, 0)

    if srp_ini.bools.date then -- показывать время
        imgui.SetNextWindowPos(vec(srp_ini.render.dateX, srp_ini.render.dateY), imgui.Cond.FirstUseEver)
        imgui.Begin('date', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial28)
        imgui.TextColoredRGB('{FFFF00}' .. os.date("%d.%m.%y %X"))
        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.dateX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.dateY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.dateX = math.ceil(savePosX)
            srp_ini.render.dateY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end

    if srp_ini.bools.nick then -- ник и ид на экране
        imgui.SetNextWindowPos(vec(srp_ini.render.nickX, srp_ini.render.nickY), imgui.Cond.FirstUseEver)
        local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if result then
            local name = sampGetPlayerNickname(id)
            local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)) .. "}"
            imgui.Begin('nick', _,
                imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                    imgui.WindowFlags.AlwaysAutoResize)
            imgui.PushFont(fonts.arial28)
            imgui.TextColoredRGB(clist .. name)
            imgui.SameLine()
            imgui.TextColoredRGB(clist .. '[' .. tostring(id) .. ']')
            imgui.PopFont()
            local newPos = imgui.GetWindowPos()
            local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
            if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.nickX) or math.ceil(savePosY) ~=
                math.ceil(srp_ini.render.nickY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
                imgui.IsRootWindowOrAnyChildHovered() then
                srp_ini.render.nickX = math.ceil(savePosX)
                srp_ini.render.nickY = math.ceil(savePosY)
                inicfg.save(srp_ini, settings)
            end
            imgui.End()
        end
    end

    if srp_ini.bools.ping then -- пинг на экране
        imgui.SetNextWindowPos(vec(srp_ini.render.pingX, srp_ini.render.pingY), imgui.Cond.FirstUseEver)
        imgui.Begin('ping', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial25)
        local ping = sampGetPlayerPing(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        if ping ~= nil then
            imgui.TextColoredRGB((ping > 80 and "{FF0000}" or "{00FF00}") .. "Пинг: " .. ping)
        end
        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.pingX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.pingY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.pingX = math.ceil(savePosX)
            srp_ini.render.pingY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end

    if srp_ini.bools.drugscooldown then -- КД нарко на экране
        imgui.SetNextWindowPos(vec(srp_ini.render.drugsX, srp_ini.render.drugsY), imgui.Cond.FirstUseEver)
        imgui.Begin('drugs', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial25)
        if (os.time() - tonumber(srp_ini.values.drugs)) < var.drugtimer then
            sec = var.drugtimer - (os.time() - tonumber(srp_ini.values.drugs))
            local mins = math.floor(sec / 60)
            if math.fmod(sec, 60) >= 10 then
                secs = math.fmod(sec, 60)
            end
            if math.fmod(sec, 60) < 10 then
                secs = "0" .. math.fmod(sec, 60) .. ""
            end
            imgui.TextColoredRGB("{FF0000}" .. mins .. ":" .. secs .. "")
        else
            imgui.TextColoredRGB("{00FF00}Юзай!")
        end
        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.drugsX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.drugsY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.drugsX = math.ceil(savePosX)
            srp_ini.render.drugsY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end

    if srp_ini.bools.event then -- таймеры до начала системных МП
        imgui.SetNextWindowPos(vec(srp_ini.render.eventX, srp_ini.render.eventY), imgui.Cond.FirstUseEver)
        imgui.Begin('event', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial20)
        for k, v in pairs(srp_ini.ivent) do
            if v ~= false and tonumber(v) ~= nil then
                local ivent = var.ivents.NameFromIndex[k]
                if ivent ~= nil then
                    local sec = tonumber(v) - os.time()
                    local mins = math.floor(sec / 60)
                    if math.fmod(sec, 60) >= 10 then
                        secs = math.fmod(sec, 60)
                    end
                    if math.fmod(sec, 60) < 10 then
                        secs = "0" .. math.fmod(sec, 60) .. ""
                    end
                    if sec > 0 then
                        imgui.TextColoredRGB(
                            (sec > 60 and '{00FF00}' or "{FCF803}") .. ivent .. ' через: ' .. mins .. ":" .. secs)
                    else
                        if sec > -30 then
                            imgui.TextColoredRGB("{FF0000}" .. ivent .. ' начнётся СЕЙЧАС')
                        end
                    end
                end
            end
        end
        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.eventX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.eventY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.eventX = math.ceil(savePosX)
            srp_ini.render.eventY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end

    if srp_ini.bools.stream then -- количество игроков в зоне прорисовки на экране
        imgui.SetNextWindowPos(vec(srp_ini.render.streamX, srp_ini.render.streamY), imgui.Cond.FirstUseEver)
        imgui.Begin('stream', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial20)
        imgui.TextColoredRGB('Количество персонажей в прорисовке: ' ..
                                 (sampGetPlayerCount(true) - 1) .. '')
        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.streamX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.streamY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.streamX = math.ceil(savePosX)
            srp_ini.render.streamY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end

    if srp_ini.bools.status then -- статус контекстной клавиши на экране
        imgui.SetNextWindowPos(vec(srp_ini.render.statusX, srp_ini.render.statusY), imgui.Cond.FirstUseEver)
        imgui.Begin('status', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial20)
        local CStatus = CTaskArr["CurrentID"] == 0 and "{FFFAFA}Ожидание события" or "" ..
                            CTaskArr["n"][CTaskArr[1][CTaskArr["CurrentID"]]] ..
                            (indexof(CTaskArr[1][CTaskArr["CurrentID"]], CTaskArr["nn"]) ~= false and " " ..
                                CTaskArr[3][CTaskArr["CurrentID"]] or "") .. " " .. "[" ..
                            (20 - (os.time() - CTaskArr[2][CTaskArr["CurrentID"]])) .. "]"
        imgui.TextColoredRGB(CStatus)

        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.statusX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.statusY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.statusX = math.ceil(savePosX)
            srp_ini.render.statusY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end

    if srp_ini.bools.squad and var.squadenable then -- улучшенный сквад на экране
        local enable = true
        if srp_ini.bools.disablesquad and (sampIsChatInputActive() or isSampfuncsConsoleActive()) then
            enable = false
        else
            enable = true
        end
        if enable then
            imgui.SetNextWindowPos(vec(srp_ini.render.squadX, srp_ini.render.squadY), imgui.Cond.FirstUseEver)
            imgui.Begin('squad', _,
                imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                    imgui.WindowFlags.AlwaysAutoResize)
            imgui.PushFont(fonts.trebuc17)
            local count = 0
            for k in pairs(var.squad) do
                count = count + 1
            end
            imgui.Text("SQUAD - " .. count .. ":")
            local newPos = imgui.GetWindowPos()
            local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
            if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.squadX) or math.ceil(savePosY) ~=
                math.ceil(srp_ini.render.squadY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
                imgui.IsRootWindowOrAnyChildHovered() then
                srp_ini.render.squadX = math.ceil(savePosX)
                srp_ini.render.squadY = math.ceil(savePosY)
                inicfg.save(srp_ini, settings)
            end
            for k, v in ipairs(var.squad) do
                local color, HP, ARM
                if sampGetCharHandleBySampPlayerId(v.id) then
                    color = "{" .. v.clist .. "}"
                    HP = sampGetPlayerHealth(v.id)
                    ARM = sampGetPlayerArmor(v.id)
                else
                    local red = tonumber(v.clist:sub(1, 2), 16)
                    local green = tonumber(v.clist:sub(3, 4), 16)
                    local blue = tonumber(v.clist:sub(5, 6), 16)
                    color =
                        "{" .. string.format("%02X%02X%02X%s", red, green, blue, string.format("%02X", 0.75 * 255)) ..
                            "}"
                    HP = 0
                    ARM = 0
                    v.afk = nil
                end
                local afk = sampIsPlayerPaused(v.id) and " {008000}[AFK] " ..
                                (v.afk ~= nil and "[" .. v.afk .. " секунд]" or "") or ""
                imgui.TextColoredRGB(color .. v.name .. "[" .. v.id .. "]" .. afk)
                imgui.PushStyleColor(imgui.Col.FrameBg, ImVec4(1.0, 1.0, 1.0, 0.35))
                if v.id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
                    local myHP = getCharHealth(PLAYER_PED)
                    local myARM = getCharArmour(PLAYER_PED)
                    imgui.SwitchContext()
                    imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(0.7, 0, 0, 1))
                    imgui.ProgressBar(myHP / 100, vec(24, 1.25))
                    imgui.PopStyleColor()
                    imgui.SameLine()
                    imgui.SwitchContext()
                    imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(0.9, 0.9, 0.9, 1))
                    imgui.ProgressBar(myARM / 100, vec(24, 1.25))
                    imgui.PopStyleColor()
                else
                    imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(0.7, 0, 0, 1))
                    imgui.ProgressBar(HP / 100, vec(24, 1.25))
                    imgui.PopStyleColor()
                    imgui.SameLine()
                    imgui.SwitchContext()
                    imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(0.9, 0.9, 0.9, 1))
                    imgui.ProgressBar(ARM / 100, vec(24, 1.25))
                    imgui.PopStyleColor()
                end
                imgui.PopStyleColor()
            end
            imgui.PopFont()
            imgui.End()
        end
    end

    if srp_ini.bools.hpcars then -- показывать ХП машин вокруг
        local carhandles = getcars() -- получаем все машины вокруг
        if carhandles ~= nil then -- если машина обнаружена
            for k, v in pairs(carhandles) do -- перебор всех машин в прорисовке
                if doesVehicleExist(v) and isCarOnScreen(v) and not sampIsDialogActive(-1) then -- если машина на экране и не открыт диалог
                    local idcar = getCarModel(v) -- получаем ид модельки
                    local myX, myY, myZ = getCharCoordinates(PLAYER_PED) -- получаем свои координаты
                    local cX, cY, cZ = getCarCoordinates(v) -- получаем координаты машины
                    local distance = math.ceil(math.sqrt(((myX - cX) ^ 2) + ((myY - cY) ^ 2) + ((myZ - cZ) ^ 2))) -- расстояние между мной и машиной
                    if isLineOfSightClear(myX, myY, myZ, cX, cY, cZ, true, false, false, true, false) and distance <= 20 then
                        -- если между мной и машиной нет стен (персонажи и машины не считаются за стены) и расстояние не более 20 то...
                        local cHP = getCarHealth(v) -- получаем хп машины
                        local cPosX, cPosY = convert3DCoordsToScreen(cX, cY, cZ) -- переводим 3Д координаты мира в координаты на экране
                        local col = cHP > 800 and 0xFF00FF00 or cHP > 500 and 0xFFFFFF00 or 0xFFFFFAFA -- получаем цвет текста в зависимости от ХП машины
                        local col = var.motos[idcar] ~= nil and isCarTireBurst(v, 1) and 0xFFFF0000 or col -- если колесо МОТОЦИКЛА пробито то цвет ХП всегда красный
                        local ctext = cHP
                        renderFontDrawText(fonts.times14, ctext,
                            cPosX - (renderGetFontDrawTextLength(fonts.times14, ctext, false) / 2), cPosY, col, false) -- рисуем текст
                    end
                end
            end
        end
    end

    if srp_ini.bools.chatinfo and sampIsChatInputActive() then -- раскладка, капс, символы под строкой чата
        local in1 = sampGetInputInfoPtr()
        local in1_1 = getStructElement(in1, 0x8, 4)
        local in2 = getStructElement( --[[int]] in1_1, --[[int]] 0x8, --[[int]] 4)
        local in3 = getStructElement( --[[int]] in1_1, --[[int]] 0xC, --[[int]] 4)
        local fib = in3 + 40
        local fib2 = in2 + 5
        local success = ffi.C.GetKeyboardLayoutNameA(keybbb.KeyboardLayoutName)
        local errorCode = ffi.C.GetLocaleInfoA(tonumber(ffi.string(keybbb.KeyboardLayoutName), 16), 0x00000002,
            keybbb.LocalInfo, 32)
        local localName = u8(ffi.string(keybbb.LocalInfo))
        local capsState = ffi.C.GetKeyState(20)
        imgui.SetNextWindowPos(imgui.ImVec2(fib2, fib))
        imgui.Begin('chatinfo', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.trebuc20)
        local a = sampGetChatInputText()
        local b = a:match("%/(%a+) .*")
        local c = (b == nil or sym[b] == nil) and sym[1] or sym[b]
        if sym.myid == -1 then
            sym.myid = #tostring(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
            sym.mynick = #sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        end
        local d = c - sym.myid - sym.mynick
        local e = #a > d and "{FF0000}" .. #a .. "" or #a
        imgui.TextColoredRGB("Раскладка: {ffffff}" .. localName .. "; CAPS: " .. getStrByState(capsState) ..
                                 ", Символы: " .. e .. "/" .. d .. ".")
        imgui.PopFont()
        imgui.End()
    end

    if srp_ini.bools.equest then -- ежедневные задания на экране
        imgui.SetNextWindowPos(vec(srp_ini.render.equestX, srp_ini.render.equestY), imgui.Cond.FirstUseEver)
        imgui.Begin('equest', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial20)
        if srp_ini.quest.updating ~= nil then
            local sec = os.difftime(srp_ini.quest.updating, os.time())
            if sec >= 0 then
                local mins = math.floor(sec / 60)
                local hours = math.floor(sec / 3600)
                hours = hours > 24 and hours - 24 or hours
                if math.fmod(sec, 60) >= 10 then
                    secs = math.fmod(sec, 60)
                end
                if math.fmod(sec, 60) < 10 then
                    secs = "0" .. math.fmod(sec, 60) .. ""
                end
                if hours >= 1 then
                    if math.fmod(mins, 60) >= 10 then
                        mins = math.fmod(mins, 60)
                    end
                    if math.fmod(mins, 60) < 10 then
                        mins = "0" .. math.fmod(mins, 60) .. ""
                    end
                    timer = hours .. ":" .. mins .. ":" .. secs
                else
                    timer = mins .. ":" .. secs
                end
                imgui.TextColoredRGB("{00FF00}Обновление заданий через: " .. timer .. "")
            else
                imgui.TextColoredRGB("{FF0000}Обновление заданий СЕЙЧАС")
            end
        end
        for k, v in pairs(srp_ini.task) do
            if not v then
                local inf = srp_ini.description[k] ~= nil and srp_ini.description[k] or 'Нет информации'
                local col = srp_ini.description[k] ~= nil and "{FCF803}" or "{FF0000}"
                imgui.TextColoredRGB(col .. k .. " - " .. inf)
            end
        end
        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.equestX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.equestY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.equestX = math.ceil(savePosX)
            srp_ini.render.equestY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end

    if srp_ini.bools.inventory then -- cодержимое инвентаря на экране
        imgui.SetNextWindowPos(vec(srp_ini.render.inventoryX, srp_ini.render.inventoryY), imgui.Cond.FirstUseEver)
        imgui.Begin('inventory', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial20)
        for item, status in pairs(srp_ini.inventoryItem) do
            local amount = tonumber(srp_ini.inventory[item])
            local name = var.items.NameFromIndex[item]
            if amount ~= nil and status then
                if item == "drugs" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 25 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "mats" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 50 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "keys" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 2 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "canister" then
                    if amount ~= nil and amount >= 1 then
                        col = "{00FF00}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "fish" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 50000 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "cookedfish" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 15 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "mushroom" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 50 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "repairkit" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 5 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "psychoheal" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 15 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "cookedmushroom" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 15 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "adrenaline" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 5 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "cork" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 2 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "balaclava" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 3 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "scrap" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 4 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "energy" then
                    if amount ~= nil and amount >= 1 then
                        col = "{00FF00}"
                    else
                        col = "{FF0000}"
                    end
                end
                if item == "robkit" then
                    if amount ~= nil and amount >= 1 then
                        col = amount > 2 and "{00FF00}" or "{FCF803}"
                    else
                        col = "{FF0000}"
                    end
                end
                imgui.TextColoredRGB(col .. name .. ": " ..
                                         (amount > 1 and srp_ini.inventory[item] or
                                             (amount == 1 and "Есть!" or (amount == 0 and "Нету!" or ""))))
            end
        end
        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.inventoryX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.inventoryY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.inventoryX = math.ceil(savePosX)
            srp_ini.render.inventoryY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end

    if srp_ini.bools.kd then -- КД ограбы и автоугона
        imgui.SetNextWindowPos(vec(srp_ini.render.robbingX, srp_ini.render.robbingY), imgui.Cond.FirstUseEver)
        imgui.Begin('robbing', _,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize +
                imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fonts.arial20)
        if ((os.time() - tonumber(srp_ini.values.cartheft)) / 60) < 15 then
            local sec = 15 * 60 - (os.time() - tonumber(srp_ini.values.cartheft))
            local mins = math.floor(sec / 60)
            if math.fmod(sec, 60) >= 10 then
                secs = math.fmod(sec, 60)
            end
            if math.fmod(sec, 60) < 10 then
                secs = "0" .. math.fmod(sec, 60) .. ""
            end
            imgui.TextColoredRGB("{00FF00}Угонять можно через: " .. mins .. ":" .. secs .. "")
        else
            local sec = 15 * 60 - (os.time() - tonumber(srp_ini.values.cartheft))
            if sec > -30 then
                imgui.TextColoredRGB("{FF0000}Угонять можно СЕЙЧАС")
            end
        end
        if ((os.time() - tonumber(srp_ini.values.robbing)) / 60) < 35 then
            local sec = 35 * 60 - (os.time() - tonumber(srp_ini.values.robbing))
            local mins = math.floor(sec / 60)
            if math.fmod(sec, 60) >= 10 then
                secs = math.fmod(sec, 60)
            end
            if math.fmod(sec, 60) < 10 then
                secs = "0" .. math.fmod(sec, 60) .. ""
            end
            imgui.TextColoredRGB("{00FF00}Грабить можно через: " .. mins .. ":" .. secs .. "")
        else
            local sec = 35 * 60 - (os.time() - tonumber(srp_ini.values.robbing))
            if sec > -30 then
                imgui.TextColoredRGB("{FF0000}Грабить можно СЕЙЧАС")
            end
        end
        imgui.PopFont()
        local newPos = imgui.GetWindowPos()
        local savePosX, savePosY = convertWindowScreenCoordsToGameScreenCoords(newPos.x, newPos.y)
        if (math.ceil(savePosX) ~= math.ceil(srp_ini.render.robbingX) or math.ceil(savePosY) ~=
            math.ceil(srp_ini.render.robbingY)) and imgui.IsRootWindowOrAnyChildFocused() and imgui.IsMouseDragging(0) and
            imgui.IsRootWindowOrAnyChildHovered() then
            srp_ini.render.robbingX = math.ceil(savePosX)
            srp_ini.render.robbingY = math.ceil(savePosY)
            inicfg.save(srp_ini, settings)
        end
        imgui.End()
    end
end

function toScreenY(gY)
    local x, y = convertGameScreenCoordsToWindowScreenCoords(0, gY)
    return y
end

function toScreenX(gX)
    local x, y = convertGameScreenCoordsToWindowScreenCoords(gX, 0)
    return x
end

function toScreen(gX, gY)
    local s = {}
    s.x, s.y = convertGameScreenCoordsToWindowScreenCoords(gX, gY)
    return s
end

function vec(gX, gY)
    local x, y = convertGameScreenCoordsToWindowScreenCoords(gX, gY)
    return imgui.ImVec2(x, y)
end
-------------------------------------------------------------------------[ФУНКЦИИ]-----------------------------------------------------------------------------------------
function ev.onServerMessage(col, text)
    if script.loaded then
        if col == strings.color.connected and text:match(strings.connected) then
            if var.need.reload then
                script.reload = true
                thisScript():reload()
            end
        end
        if col == strings.color.mechanic then
            if isCharInAnyCar(PLAYER_PED) then
                carHandle = storeCarCharIsInNoSave(PLAYER_PED)
                if getDriverOfCar(carHandle) == PLAYER_PED then
                    if srp_ini.bools.autorepair then -- починка у механика
                        if text:match(strings.acceptrepair) then
                            chatManager.addMessageToQueue("/ac repair")
                            return
                        end
                    end
                    if srp_ini.bools.autorefill then -- заправка у механика
                        local cost = tonumber(text:match(strings.acceptrefill))
                        local ncost = tonumber(srp_ini.values.autorefill)
                        if cost ~= nil and ncost ~= nil then
                            if cost <= ncost then
                                chatManager.addMessageToQueue("/ac refill")
                                return
                            else
                                script.sendMessage(
                                    "Транспорт не будет заправлен, так как цена выше лимита")
                            end
                        end
                    end
                end
            end
        end
        if col == strings.color.jfchat then
            if srp_ini.bools.jfcoloring then -- окраска ников в чате профсоюза
                local nick, stringid, rank, txt = text:match(strings.jfchat)
                local id = tonumber(stringid)
                if id ~= nil then
                    local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)) .. "}"
                    local clr = "{" .. ("%06x"):format(bit.band(bit.rshift(col, 8), 0xFFFFFF)) .. "}"
                    text = string.format(" %s%s[%d]%s<%s>: %s", clist, nick, id, clr, rank, txt)
                    return {col, text}
                end
            end
        end
        if indexof(col, strings.color.faction) then
            if srp_ini.bools.fcoloring then -- окраска ников в чате фракции
                local frank, fnick, fid, ftxt = text:match(strings.faction)
                if fid ~= nil then
                    local clr = "{" .. bit.tohex(bit.rshift(col, 8), 6) .. "}"
                    local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(fid), 0xFFFFFF)) .. "}"
                    text = string.format(" %s%s %s%s[%d]%s: %s", clr, frank, clist, fnick, fid, clr, ftxt)
                    return {col, text}
                end
            end
        end
        if col == strings.color.boost then
            if text:match(strings.boost) and var.is.boost then
                return false
            end
        end
        if col == strings.color.noboost then
            if text:match(strings.noboost) and var.is.boost then
                var.is.boost = false
                return false
            end
        end
        if col == strings.color.drugs then
            local amount = tonumber(text:match(strings.drugs))
            if amount ~= nil then
                var.is.withdrawal = false
                srp_ini.inventory.drugs = amount
                srp_ini.values.drugs = os.time()
            end
        end
        if col == strings.color.paint then
            if text:match(strings.painttime) then
                local paint = tonumber(text:match(strings.painttime))
                if paint ~= nil then
                    paint = os.time() + paint * 60
                    srp_ini.ivent.paintball = paint
                end
            end
            if text:match(strings.paintfalse1) or text:match(strings.paintfalse2) then
                srp_ini.ivent.paintball = false
            end
        end
        if col == strings.color.squid then
            if text:match(strings.squidtime) then
                local squid = tonumber(text:match(strings.squidtime))
                if squid ~= nil then
                    squid = os.time() + squid * 60
                end
                srp_ini.ivent.squid = squid
            end
            if text:match(strings.squidfalse1) or text:match(strings.squidfalse2) or text:match(strings.squidfalse3) then
                srp_ini.ivent.squid = false
            end
        end
        if col == strings.color.race then
            if text:match(strings.racetime) then
                local race = tonumber(text:match(strings.racetime))
                if race ~= nil then
                    race = os.time() + race * 60
                    srp_ini.ivent.race = race
                end
            end
            if text:match(strings.racefalse1) or text:match(strings.racefalse2) or text:match(strings.racefalse3) then
                srp_ini.ivent.race = false
            end
        end
        if col == strings.color.derby then
            if text:match(strings.derbytime) then
                local derby = tonumber(text:match(strings.derbytime))
                if derby ~= nil then
                    derby = os.time() + derby * 60
                end
                srp_ini.ivent.derby = derby
            end
            if text:match(strings.derbyfalse1) or text:match(strings.derbyfalse2) or text:match(strings.derbyfalse3) then
                srp_ini.ivent.derby = false
            end
        end
        if (text:match(strings.repair1) or text:match(strings.repair2) ~= nil or text:match(strings.repair3) ~= nil or
            text:match(strings.repair4) ~= nil) and CTaskArr[10][1] then
            CTaskArr[10][1] = false
        end
        if col == strings.color.quest and srp_ini.bools.equest then
            local fq, sq = text:match(strings.changequest)
            local equest = text:match(strings.donequest)
            if fq ~= nil and sq ~= nil then
                local firstquest = fq
                local secondquest = ''
                for w in string.gmatch(sq, "%S+") do
                    secondquest = secondquest == '' and w or secondquest .. ' ' .. w
                end
                for k, v in pairs(srp_ini.task) do
                    if u8:decode(k) == firstquest then
                        srp_ini.task[k] = nil
                        srp_ini.task[u8(secondquest)] = v
                        return
                    end
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
            if (fpassenger ~= nil and ftxt ~= nil and ftxt ~= "" and fpassenger == var.taxipassenger) or
                (spassenger ~= nil and stxt ~= nil and stxt ~= "" and spassenger == var.taxipassenger) then
                if isCharInAnyCar(PLAYER_PED) then
                    fcarHandle = storeCarCharIsInNoSave(PLAYER_PED)
                    if getDriverOfCar(fcarHandle) == PLAYER_PED then
                        if isCarTaxi(fcarHandle) then
                            var.taxipassenger = nil
                            CTaskTaxiClear()
                            table.insert(CTaskArr[1], 5)
                            table.insert(CTaskArr[2], os.time())
                            table.insert(CTaskArr[3], "")
                        end
                    end
                end
            end
            if srp_ini.bools.jfleader and spassenger ~= nil and stxt ~= nil and stxt ~= "" then
                if stxt:match(u8:decode "[ПпPp][РрRr][ОоOo][ФфFf]") or
                    stxt:match(u8:decode "[ИиIi][НнNn][ВвVv]") then
                    lua_thread.create(function()
                        var.offer.bool = true
                        script.sendMessage(string.format(
                            "%s[%d] возможно просится в профсоюз. Нажмите Y для согласия и N для отказа добавления",
                            spassenger, sid))
                        while var.offer.bool do
                            wait(0)
                        end
                        if var.offer.status then
                            cmd_jfadd(sid)
                        end
                    end)
                end
            end
        end
        if col == strings.color.taxi then
            if isCharInAnyCar(PLAYER_PED) then
                fcarHandle = storeCarCharIsInNoSave(PLAYER_PED)
                if getDriverOfCar(fcarHandle) == PLAYER_PED then
                    local passenger = text:match(strings.newpassenger)
                    if sampGetPlayerIdByNickname(passenger) then
                        var.taxipassenger = passenger
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
                                            if A_Index == 5 then
                                                break
                                            end
                                            local str = sampGetChatString(99 - A_Index)
                                            if str:match(strings.normalchat) then
                                                local nick, id, txt = str:match(strings.normalchat)
                                                local stxt, spassenger, sid = str:match(strings.sms)
                                                if (nick == passenger and id ~= nil and txt ~= nil) or
                                                    (nick == spassenger and sid ~= nil and stxt ~= nil) then
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
            if txt:match(u8:decode '[МмMm][ЕеEe][ТтTt][КкKk][АаAa]?') then
                lua_thread.create(function()
                    local A_Index = 0
                    while true do
                        if A_Index == 5 then
                            break
                        end
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
        if col == strings.color.rent and text:match(strings.rent) and var.rent ~= nil then
            script.sendMessage(string.format(
                "Вы арендовали транспортное средство за %d вирт", var.rent))
            chatManager.addMessageToQueue('/en')
            return false
        end
        if col == strings.color.minusbalaklava and text:match(strings.minusbalaklava) then
            local balaclava = tonumber(srp_ini.inventory.balaclava)
            if balaclava ~= nil and balaclava > 0 then
                srp_ini.inventory.balaclava = balaclava - 1
            end
        end
        if col == strings.color.minusscrap and text:match(strings.minusscrap) then
            local scrap = tonumber(srp_ini.inventory.scrap)
            if scrap ~= nil and scrap > 0 then
                srp_ini.inventory.scrap = scrap - 1
            end
        end
        if col == strings.color.canister and text:match(strings.canister) then
            srp_ini.inventory.canister = 1
        end
        if col == strings.color.fillcar and text:match(strings.fillcar) then
            srp_ini.inventory.canister = 0
        end
        if col == strings.color.intrunk and text:match(strings.intrunk) then
            local item, amount = text:match(strings.intrunk)
            item = var.items.IndexFromName[u8(item)]
            amount = tonumber(amount)
            if item ~= nil and amount ~= nil then
                if srp_ini.inventory[item] ~= nil then
                    srp_ini.inventory[item] = amount
                end
            end
        end
        if col == strings.color.me then
            local nick = text:match(strings.sellekey)
            if nick ~= nil then
                if nick == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                    srp_ini.inventory.keys = srp_ini.inventory.keys - 1
                end
            end
        end
        if col == strings.color.outtrunk and text:match(strings.outtrunk) then
            local item, amount = text:match(strings.outtrunk)
            item = var.items.IndexFromName[u8(item)]
            amount = tonumber(amount)
            if item ~= nil and amount ~= nil then
                srp_ini.inventory[item] = srp_ini.inventory[item] + amount
            end
        end
        if col == strings.color.shop24 and text:match(strings.shop24) then
            local item, amount = text:match(strings.shop24)
            item = var.items.IndexFromName[u8(item)]
            amount = tonumber(amount)
            if item ~= nil and amount ~= nil then
                srp_ini.inventory[item] = amount
            end
        end
        if col == strings.color.grib and text:match(strings.grib) then
            local amount = tonumber(text:match(strings.grib))
            if amount ~= nil then
                srp_ini.inventory.mushroom = amount
            end
        end
        if col == strings.color.fish and text:match(strings.fish) then
            var.satiety = nil
            local amount = tonumber(text:match(strings.fish))
            if amount ~= nil then
                srp_ini.inventory.cookedfish = amount
            end
        end
        if col == strings.color.fish and text:match(strings.cookfish) then
            local amount = tonumber(text:match(strings.cookfish))
            if amount ~= nil then
                srp_ini.inventory.cookedfish = amount
                srp_ini.inventory.fish = srp_ini.inventory.fish - 20000
            end
        end
        if col == strings.color.cookgrib and text:match(strings.cookgrib) then
            local sg, p, gg = text:match(strings.cookgrib)
            sg = tonumber(sg)
            p = tonumber(p)
            gg = tonumber(gg)
            if sg ~= nil and p ~= nil and gg ~= nil then
                srp_ini.inventory.mushroom = sg
                srp_ini.inventory.psychoheal = p
                srp_ini.inventory.cookedmushroom = gg
            end
        end
        if col == strings.color.me and text:match(strings.trash) then
            local nick, item = text:match(strings.trash)
            item = u8(item)
            item = var.items.IndexFromName[item]
            if nick ~= nil and item ~= nil then
                if nick == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                    srp_ini.inventory[item] = 0
                end
            end
        end
        if col == strings.color.adr and text:match(strings.adr) then
            local adr = tonumber(srp_ini.inventory.adrenaline)
            if adr ~= nil and adr > 0 then
                srp_ini.inventory.adrenaline = adr - 1
            end
        end
        if col == strings.color.gribeat and text:match(strings.gribeat) then
            local satiety, amount = text:match(strings.gribeat)
            satiety = tonumber(satiety)
            amount = tonumber(amount)
            if satiety ~= nil and amount ~= nil then
                var.satiety = satiety
                srp_ini.inventory.cookedmushroom = amount
            end
        end
        if col == strings.color.psycho and (text:match(strings.psycho) or text:match(strings.psychohungry)) then
            local satiety, amount = text:match(strings.psycho)
            if amount == nil then
                amount = text:match(strings.psychohungry)
            end
            satiety = tonumber(satiety)
            amount = tonumber(amount)
            if satiety ~= nil then
                var.satiety = satiety
            else
                var.satiety = 0
            end
            if srp_ini.bools.knockpsycho and not isCharInAnyCar(PLAYER_PED) then
                lua_thread.create(function()
                    wait(1)
                    sampSendChat(" ")
                end)
            end
            if amount ~= nil then
                srp_ini.inventory.psychoheal = amount
            end
        end
        if col == strings.color.armour and text:match(strings.armour) then
            var.satiety = 100
        end
        if col == strings.color.roul and text:match(strings.roul) then
            local item, amount = text:match(strings.roul)
            item = u8(item)
            item = var.items.IndexFromName[item]
            amount = tonumber(amount)
            if item ~= nil and amount ~= nil then
                srp_ini.inventory[item] = amount
            end
        end
        if col == strings.color.repair1 and text:match(strings.repair1) then
            local amount = tonumber(text:match(strings.repair1))
            if amount ~= nil then
                srp_ini.inventory.repairkit = amount
            end
        end
        if col == strings.color.repair2 and text:match(strings.repair2) then
            srp_ini.inventory.repairkit = 0
        end
        if col == strings.color.reward then
            if text:match(strings.reward) then
                local rewards = {
                    ["Психохил"] = "психохил",
                    ["Комплект «автомеханик»"] = "ремкомплект",
                    ["Адреналин"] = "адреналин",
                    ["Ключи от камеры"] = "ключ",
                    ["Набор для взлома"] = "взлом",
                    ["Защита от насильников"] = "насильник",
                    ["Готовые грибы"] = "готов",
                    ["Балаклава"] = "балаклав"
                }
                local list = string.split(text:match(strings.reward), "/")
                for _, l in ipairs(list) do
                    for k, v in pairs(rewards) do
                        local item = var.items.IndexFromName[k]
                        local amount, r = l:match("(%d+) (.*)")
                        amount = tonumber(amount)
                        if amount ~= nil and r:match(u8:decode(v)) then
                            srp_ini.inventory[item] = srp_ini.inventory[item] + amount
                        end
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
                var.is.robbing = false
                script.sendMessage("Дверь вскрыта ломом, пытаюсь зайти в дом")
                srp_ini.inventory.scrap = srp_ini.inventory.scrap - 1
                enterhouse()
                return false
            end
            if col == strings.color.open and text:match(strings.open) then
                var.is.robbing = false
                script.sendMessage("Дверь открыта без лома, пытаюсь зайти в дом")
                enterhouse()
                return false
            end
            if col == strings.color.put and text:match(strings.put) then
                local loaded, maxloaded = text:match(strings.put)
                loaded = tonumber(loaded)
                maxloaded = tonumber(maxloaded)
                if loaded ~= nil and maxloaded ~= nil then
                    if loaded < maxloaded then
                        script.sendMessage(string.format(
                            "Положил награбленное в фургон: %d/%d, пытаюсь зайти в дом",
                            loaded, maxloaded))
                        enterhouse()
                        return false
                    end
                end
            end
            if col == strings.color.rob and text:match(strings.rob) then
                var.is.robbing = true
                if srp_ini.inventory.balaclava == 0 then
                    script.sendMessage(
                        "У вас нету балаклав, срочно едьте покупайте в ближайшем 24/7")
                end
            end
        end
        if col == strings.color.donerob and text:match(strings.donerob) then
            var.is.robbing = false
            srp_ini.values.robbing = os.time()
        end
        if col == strings.color.donetheft and text:match(strings.donetheft) then
            srp_ini.values.cartheft = os.time()
        end
        if srp_ini.bools.withdrawal then
            if col == strings.color.stay and text:match(strings.stay) then
                if var.is.withdrawal then
                    usedrugs()
                end
            end
            if col == strings.color.wasAFK and text:match(strings.wasAFK) and var.is.withdrawal then
                usedrugs()
            end
            if col == strings.color.withdrawal and text:match(strings.withdrawal) then
                var.is.withdrawal = true
                usedrugs()
            end
        end
        if srp_ini.bools.spam then
            if col == strings.color.spam and text:match(strings.spam) then
                local smsid = text:match(strings.spam)
                chatManager.addMessageToQueue(string.format(
                    "/t %d СМС попало в спам, попробуй ещё раз написать через 30 сек",
                    smsid))
            end
        end
        if col == strings.color.noequest and text:match(strings.noequest) then
            var.is.equest = false
        end
        local slet = text:match(strings.slet)
        if slet ~= nil then
            srp_ini.values.house = slet:match("(%d%d%d%d%/%d%d%/%d%d %d%d%:%d%d)")
            whenhouse()
        end
        if col == strings.color.nohouse and text:match(strings.nohouse) then
            if srp_ini.bools.house then
                srp_ini.bools.house = false
                script.sendMessage(
                    "У вас отсутствует дом. Уведомления о слёте были отключены")
            end
        end
        if col == strings.color.accepttaxi then
            local who, whom = text:match(strings.accepttaxi)
            if who ~= nil and whom ~= nil then
                if who == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                    var.current.client = whom
                end
            end
        end
        if col == strings.color.full24 and text:match(strings.full24) then
            if not var.is.purchased then
                var.is.purchased = true
                return
            end
        end
        if indexof(col, strings.color.changenick) then
            local newnick = text:match(strings.changenick)
            if newnick ~= nil then
                lua_thread.create(function()
                    script.sendMessage("Обнаружена смена игрового ника!")
                    script.sendMessage(
                        "Скрипт переименовывает папку конфигурций согласно новому нику...")
                    local i = 0
                    while true do
                        if i == 20 then
                            break
                        end
                        local text = sampGetChatString(99 - i)

                        local oldnick = text:match(strings.changenickmsg .. newnick)
                        if oldnick ~= nil then
                            local folderPath = thisScript().directory .. "\\config\\SRPfunctions by Webb\\" .. server
                            for folder in lfs.dir(folderPath) do
                                local fullPath = folderPath .. "\\" .. folder
                                local isDirectory = lfs.attributes(fullPath, "mode") == "directory"

                                if isDirectory and folder ~= "." and folder ~= ".." then
                                    if folder == oldnick then
                                        local newFolderPath = folderPath .. "\\" .. newnick
                                        os.rename(fullPath, newFolderPath)
                                        os.remove(fullPath)
                                    elseif folder == newnick then
                                        local newFolderPath = folderPath .. "\\" .. oldnick
                                        os.rename(fullPath, newFolderPath)
                                        os.remove(fullPath)
                                    end
                                end
                            end
                            script.sendMessage("Папка успешно переименована.")
                            script.reload = true
                            thisScript():reload()
                            return
                        end
                        i = i + 1
                    end
                end)
                return false
            end
        end
        if srp_ini.bools.jfleader then
            if col == strings.color.jftry then
                if text:match(strings.jfnojob) then
                    lua_thread.create(function()
                        var.offer.bool = true
                        script.sendMessage(string.format(
                            "%s[%d] не устроен на необходимую работу. Нажмите Y для согласия и N для отказа отправки ему SMS",
                            var.jf.nick, var.jf.id))
                        while var.offer.bool do
                            wait(0)
                        end
                        if var.offer.status then
                            chatManager.addMessageToQueue(string.format(
                                "/t %d Устройся на работу \"%s\" в мэрии и отпиши мне ещё раз",
                                var.jf.id, srp_ini.values.jfjob))
                        end
                        return
                    end)
                end
                if text:match(strings.jfalready) then
                    lua_thread.create(function()
                        var.offer.bool = true
                        script.sendMessage(string.format(
                            "%s[%d] уже состоит в каком-то профсоюзе. Нажмите Y для согласия и N для отказа отправки ему SMS",
                            var.jf.nick, var.jf.id))
                        while var.offer.bool do
                            wait(0)
                        end
                        if var.offer.status then
                            chatManager.addMessageToQueue(string.format(
                                "/t %d Пропиши /jf dellme и отпиши мне ещё раз", var.jf.id))
                        end
                        return
                    end)
                end
            end
            if col == strings.color.jfdone then
                if text:match(strings.jfadded) then
                    chatManager.addMessageToQueue("/jf chat Игрок " .. var.jf.nick ..
                                                      (var.jf.id ~= nil and "[" .. var.jf.id .. "]" or "") ..
                                                      " успешно добавлен в профсоюз")
                    var.jf.nick = nil
                    var.jf.id = nil
                end
                if text:match(strings.jfdeleted) then
                    chatManager.addMessageToQueue("/jf chat Игрок " .. var.jf.nick ..
                                                      (var.jf.id ~= nil and "[" .. var.jf.id .. "]" or "") ..
                                                      " удален из профсоюза")
                    var.jf.nick = nil
                    var.jf.id = nil
                end
                if text:match(strings.jfmuted) then
                    chatManager.addMessageToQueue("/jf chat Игроку " .. var.jf.nick ..
                                                      (var.jf.id ~= nil and "[" .. var.jf.id .. "]" or "") ..
                                                      " был установлен мут на " .. var.jf.sec ..
                                                      " секунд")
                    var.jf.nick = nil
                    var.jf.id = nil
                    var.jf.sec = nil
                end
                if text:match(strings.jffined) then
                    chatManager.addMessageToQueue("/jf chat Игроку " .. var.jf.nick ..
                                                      (var.jf.id ~= nil and "[" .. var.jf.id .. "]" or "") ..
                                                      " был установлен штраф, " .. var.jf.fine ..
                                                      " вирт")
                    var.jf.nick = nil
                    var.jf.id = nil
                    var.jf.fine = nil
                end
            end
        end
        if srp_ini.bools.quitfromcops and col == strings.color.me then
            local copnick, mynick = text:match(strings.cuff)
            local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
            if sampGetPlayerIdByNickname(mynick) == myid then
                local copid = sampGetPlayerIdByNickname(copnick)
                local res, sid = sampGetPlayerSkin(copid)
                if res then
                    if var.copskins[sid] then
                        lua_thread.create(function()
                            sendEmptyPacket(PACKET_CONNECTION_LOST)
                            closeConnect()
                            wait(300)
                            script.sendMessage(string.format(
                                "Полицейский %s попытался надеть на вас наручники, соединение разорвано",
                                copnick:gsub("_", " ")))
                        end)
                    end
                end
            end
            local copnick, mynick = text:match(strings.frisk)
            local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
            if sampGetPlayerIdByNickname(mynick) == myid then
                local copid = sampGetPlayerIdByNickname(copnick)
                local res, sid = sampGetPlayerSkin(copid)
                if res then
                    if var.copskins[sid] then
                        lua_thread.create(function()
                            sendEmptyPacket(PACKET_CONNECTION_LOST)
                            closeConnect()
                            wait(300)
                            script.sendMessage(string.format(
                                "Полицейский %s попытался обыскать вас, соединение разорвано",
                                copnick:gsub("_", " ")))
                        end)
                    end
                end
            end
        end
        inicfg.save(srp_ini, settings)
    end
end

function ev.onShowDialog(dialogid, style, title, button1, button2, text)
    if script.loaded then
        if dialogid == dialogs.drugs.id and style == dialogs.drugs.style and title == dialogs.drugs.title then
            for v in text:gmatch("[^\n]+") do
                if v:match(dialogs.drugs.str) then
                    local faktor = tonumber(v:match(dialogs.drugs.str))
                    var.drugtimer = math.ceil(var.drugtimer * faktor)
                end
            end
            if var.is.boost then
                sampCloseCurrentDialogWithButton(0)
                var.is.boost = false
                return false
            end
        end
        if srp_ini.bools.equest then
            if dialogid == dialogs.quest.id and style == dialogs.quest.style and title:match(dialogs.quest.title) then
                local date = title:match(dialogs.quest.title)
                local datetime = {}
                datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min = string.match(date,
                    "(%d%d%d%d)%/(%d%d)%/(%d%d) (%d%d)%:(%d%d)")
                if datetime.year ~= nil and datetime.month ~= nil and datetime.day ~= nil and datetime.hour ~= nil and
                    datetime.min ~= nil then
                    datetime.hour = tostring(tonumber(datetime.hour) + tonumber(srp_ini.values.timezonedifference))
                    srp_ini.quest.updating = os.time(datetime)
                    srp_ini.task = {}
                    local list = string.split(text, "\n")
                    for k, v in ipairs(list) do
                        local n, s = v:match(dialogs.quest.str)
                        if n ~= nil and n ~= "" then
                            local name = u8(n):gsub("%.", "!")
                            srp_ini.task[name] = s == u8:decode "[Выполнено]" and true or false
                        end
                    end
                    if var.is.equest then
                        sampCloseCurrentDialogWithButton(0)
                        var.is.equest = false
                        return false
                    end
                end
            end
            if dialogid == dialogs.description.id and style == dialogs.description.style and title ==
                dialogs.description.title then
                local name, description
                local list = string.split(text, "\n")
                for k, v in ipairs(list) do
                    if v:match(dialogs.description.str1) then
                        name = list[k + 1]:match(dialogs.description.str3)
                        name = name:gsub("%.", "!")
                    end
                    if v:match(dialogs.description.str2) then
                        description = list[k + 1]:match(dialogs.description.str3)
                    end
                end
                if name ~= nil and description ~= nil then
                    srp_ini.description[u8(name)] = u8(description)
                end
            end
        end
        if dialogid == dialogs.inventory.id and style == dialogs.inventory.style and title == dialogs.inventory.title then
            for k, v in pairs(var.items.IndexFromName) do
                local item = u8:decode(k)
                if text:match(item) then
                    local amount = tonumber(text:match(item .. "%s(%d+) %/ %d+"))
                    srp_ini.inventory[v] = amount ~= nil and amount or 1
                end
            end
            inicfg.save(srp_ini, settings)
            if var.is.inventory then
                sampCloseCurrentDialogWithButton(0)
                var.is.inventory = false
                return false
            end
        end
        if dialogid == dialogs.login.id and style == dialogs.login.style and title:match(dialogs.login.title) and
            text:match(dialogs.login.str) then
            if srp_ini.bools.autologin then
                for i = 0, 20 do
                    local string = sampGetChatString(99 - i)
                    if string:match(strings.connected) then
                        if srp_ini.values.password == nil or srp_ini.values.password == '' then
                            script.sendMessage(
                                "Автологина не будет, пароль не задан в меню!")
                            return
                        end
                        sampSendDialogResponse(dialogid, 1, 0, srp_ini.values.password)
                        return false
                    end
                end
            end
        end
        if dialogid == dialogs.errorlogin.id and style == dialogs.errorlogin.style and
            title:match(dialogs.errorlogin.title) and text:match(dialogs.errorlogin.str) then
            if srp_ini.bools.autologin then
                script.sendMessage(
                    "Пароль в настройках задан неверно, исправьте ошибку!")
                srp_ini.bools.autologin = false
                srp_ini.values.password = ""
                buffer.password = imgui.ImBuffer(u8(srp_ini.values.password), 256)
                inicfg.save(srp_ini, settings)
                sampSendDialogResponse(dialogid, 1, 0, "")
                return false
            end
        end
        if srp_ini.bools.autorent then
            if indexof(dialogid, dialogs.autorent.id) and dialogs.autorent.style == 0 and
                title:match(dialogs.autorent.title) then
                local dialid = dialogid
                local cost = tonumber(text:match(dialogs.autorent.str))
                local ncost = tonumber(srp_ini.values.autorent)
                if ncost ~= nil and cost ~= nil then
                    if cost <= ncost then
                        var.rent = cost
                        sampSendDialogResponse(dialid, 1, 0, '')
                        return false
                    else
                        script.sendMessage(
                            "Транспорт не будет арендован, так как цена выше лимита")
                    end
                end
            end
        end
        if srp_ini.bools.rkt then
            if var.need.buy and dialogid == dialogs.shop.id and style == dialogs.shop.style and title ==
                dialogs.shop.title and button1 == dialogs.shop.button1 and button2 == dialogs.shop.button2 then
                local kit = tonumber(text:match(strings.repairkitshop))
                if kit ~= nil and not var.is.purchased then
                    if kit <= tonumber(srp_ini.values.repairkit) then
                        lua_thread.create(function()
                            wait(200)
                            sampSendDialogResponse(16, 1, 8, "")
                            sampCloseCurrentDialogWithButton(0)
                        end)
                        return false
                    else
                        script.sendMessage(
                            "Покупки ремкомплектов не будет, цена выше лимита. Если желаете закупить - измените лимит и перезайдите в 24/7")
                    end
                end
                var.need.buy = false
            end
        end
        if var.jf.checklist then
            if dialogid == dialogs.cmdjf.id and style == dialogs.cmdjf.style and title == dialogs.cmdjf.title then
                sampSendDialogResponse(dialogid, 1, 0, "")
                return false
            end
            if dialogid == dialogs.jflist.id and style == dialogs.jflist.style and title == dialogs.jflist.title then
                var.jf.combo = {}
                for v in text:gmatch("[^\n]+") do
                    local i, name, job = v:match("%[(%d+)%]%s+(%S+)%s+(%S+)")
                    if i ~= nil and name ~= nil and job ~= nil then
                        if name == srp_ini.values.jf then
                            buffer.jf = imgui.ImInt(tostring(i))
                        end
                        table.insert(var.jf.combo, name)
                        var.jf.list[name] = job
                    end
                end
                sampCloseCurrentDialogWithButton(0)
                var.jf.checklist = false
                var.need.jf = false
                return false
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
        if srp_ini.bools.quitfromcops and str == '~r~Freeze' and style == 3 then
            script.sendMessage(
                "Какой-то полицейский вас зафризил тэйзером, разрываю соединение...")
            sendEmptyPacket(PACKET_CONNECTION_LOST)
            closeConnect()
        end
    end
end

function ev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
    if script.loaded then
        lua_thread.create(function()
            local cost = tonumber(text:match(strings.gasstation))
            local ncost = tonumber(srp_ini.values.autofill)
            if ncost ~= nil and cost ~= nil then
                if cost <= ncost then
                    if srp_ini.bools.autocanister then
                        chatManager.addMessageToQueue("/get fuel")
                    end
                    if srp_ini.bools.autofill then
                        if isCharInAnyCar(PLAYER_PED) and getDriverOfCar(storeCarCharIsInNoSave(PLAYER_PED)) ==
                            PLAYER_PED then
                            wait(1300)
                            chatManager.addMessageToQueue("/fill")
                        end
                    end
                else
                    script.sendMessage(
                        "Покупки/заправки не будет, так как цена выше лимита")
                end
            end
        end)
    end
end

function ev.onPlayerQuit(id, reason)
    if script.loaded then
        if srp_ini.bools.quit and sampGetCharHandleBySampPlayerId(id) then
            local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)) .. "}"
            local reasons = {
                [0] = 'рестарт/краш',
                [1] = '/q',
                [2] = 'кик'
            }
            script.sendMessage(string.format(
                "Игрок %s%s[%d] {FFFAFA}вышел с игры. Причина: {FF0000}%s.", clist,
                sampGetPlayerNickname(id), id, reasons[reason]))
        end
    end
end

function ev.onPlayerChatBubble(playerId, color, distance, duration, message)
    if script.loaded then
        if srp_ini.bools.psycho and (message == u8:decode "Употребил психохил" or message ==
            u8:decode "Употребила психохил") then
            local clist = "{" .. ("%06x"):format(bit.band(sampGetPlayerColor(playerId), 0xFFFFFF)) .. "}"
            script.sendMessage(string.format("Игрок %s%s[%d] {FFFAFA}- употребил психохил", clist,
                sampGetPlayerNickname(playerId), playerId))
        end
        if srp_ini.bools.squad then
            local afk = tonumber(message:match(strings.afksec))
            if afk ~= nil then
                for k, v in ipairs(var.squad) do
                    if v.id == playerId then
                        var.squad[k].afk = afk
                    end
                end
            end
        end
    end
end

function ev.onSendTakeDamage(playerId)
    if playerId ~= 65535 then
        var.killerid = tonumber(playerId)
    end
end

function ev.onSendDeathNotification(reason, id)
    if tonumber(var.killerid) ~= nil then
        table.insert(CTaskArr[1], 2)
        table.insert(CTaskArr[2], os.time())
        table.insert(CTaskArr[3], var.killerid)
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
            if key ~= false then
                CTaskArr[2][key] = os.time() - 100
            end
        end
    end
end

function ev.onSetPlayerColor(id, color)
    if var.squadenable and var.squadIndex[id] then
        local r, g, b, a = explode_argb(color)
        local clist = string.format("%02x%02x%02x", r, g, b)
        var.squad[var.squadIndex[id]].clist = clist
    end
end

function ev.onShowTextDraw(id, data)
    if data.text:find("SQUAD") then
        var.squadenable = true
        var.td = id
        var.squad = {}
        var.squadIndex = {}
        local list = data.text:split("~n~")
        table.remove(list, 1)
        for k, v in ipairs(list) do
            local id = sampGetPlayerIdByNickname(v)
            if id then
                local clist = ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
                table.insert(var.squad, {
                    id = id,
                    name = v,
                    afk = 0,
                    clist = clist
                })
                var.squadIndex[id] = #var.squad
            end
        end
        return {id, data}
    end
end

function ev.onTextDrawSetString(id, text)
    if var.td == nil then
        if text:find("SQUAD") then
            var.squadenable = true
            var.td = id
        end
    end
    if id == var.td and text then
        var.squad = {}
        var.squadIndex = {}
        local list = text:split("~n~")
        table.remove(list, 1)
        for k, v in ipairs(list) do
            local id = sampGetPlayerIdByNickname(v)
            if id then
                local clist = ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
                table.insert(var.squad, {
                    id = id,
                    name = v,
                    afk = 0,
                    clist = clist
                })
                var.squadIndex[id] = #var.squad
            end
        end
    end
end

function usedrugs(arg)
    lua_thread.create(function()
        if srp_ini.bools.withdrawal and var.is.withdrawal and srp_ini.bools.withoutcops then
            for _, v in ipairs(getAllChars()) do
                if v ~= PLAYER_PED then
                    if var.copskins[getCharModel(v)] and sampGetPlayerIdByCharHandle(v) then
                        local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
                        local cX, cY, cZ = getCharCoordinates(v)
                        if math.ceil(math.sqrt(((myX - cX) ^ 2) + ((myY - cY) ^ 2) + ((myZ - cZ) ^ 2))) <= 20 and
                            isLineOfSightClear(myX, myY, myZ, cX, cY, cZ, true, false, false, true, false) then
                            script.sendMessage(
                                "Наркотики не будут употреблены, возле вас стоит полицейский!")
                            return
                        end
                    end
                end
            end
        end
        if tonumber(arg) == nil then
            chatManager.addMessageToQueue('/usedrugs')
        else
            chatManager.addMessageToQueue('/usedrugs ' .. arg)
        end
    end)
end

function checkDialog(dialog)
    if dialog == "boostinfo" then
        var.is.boost = true
    elseif dialog == "equest" then
        var.is.equest = true
    elseif dialog == "inventory" then
        var.is.inventory = true
    end
    chatManager.addMessageToQueue("/" .. dialog)
end

function getcars()
    local chandles = {}
    local tableIndex = 1
    local vehicles = getAllVehicles()
    local fcarhandle = isCharInAnyCar(PLAYER_PED) and storeCarCharIsInNoSave(PLAYER_PED) or 12
    for k, v in pairs(vehicles) do
        if doesVehicleExist(v) and v ~= fcarhandle then
            table.insert(chandles, tableIndex, v)
            tableIndex = tableIndex + 1
        end
    end

    if table.maxn(chandles) == 0 then
        return nil
    else
        return chandles
    end
end

function findsquad()
    for i = 0, 3000 do
        if sampTextdrawIsExists(i) and sampTextdrawGetString(i):match("SQUAD") then
            var.squadenable = true
            var.td = i
            var.squad = {}
            var.squadIndex = {}
            local list = sampTextdrawGetString(i):split("~n~")
            table.remove(list, 1)
            for k, v in ipairs(list) do
                if v == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                    var.current.nick = v
                end
                local id = sampGetPlayerIdByNickname(v)
                if id then
                    local clist = ("%06x"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
                    table.insert(var.squad, {
                        id = id,
                        name = v,
                        afk = 0,
                        clist = clist
                    })
                    var.squadIndex[id] = #var.squad
                end
            end
            break
        end
    end
end

function ev.onTextDrawHide(id)
    if id == var.td then
        var.squadenable = false
        var.squad = {}
        var.squadIndex = {}
    end
end

function isCarTaxi(vehicleHandle) -- взято из taximate.lua
    local result, id = sampGetVehicleIdByCarHandle(vehicleHandle)
    if result then
        for textId = 0, 2048 do
            if sampIs3dTextDefined(textId) then
                local string, _, _, _, _, _, _, _, vehicleId = sampGet3dTextInfoById(textId)
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

    if bool then
        return players
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
    local argb = b -- b
    argb = bit.bor(argb, bit.lshift(g, 8)) -- g
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
                local distance = math.ceil(math.sqrt(((myX - cX) ^ 2) + ((myY - cY) ^ 2) + ((myZ - cZ) ^ 2)))
                if (getCarHealth(car) == 300 or
                    (isCarTireBurst(car, 0) or isCarTireBurst(car, 1) or isCarTireBurst(car, 2) or
                        isCarTireBurst(car, 3) or isCarTireBurst(car, 4))) and distance <= 5 then
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
                local distance = math.ceil(math.sqrt(((myX - cX) ^ 2) + ((myY - cY) ^ 2) + ((myZ - cZ) ^ 2)))
                if (getCarHealth(car) > 300 and not isCarTireBurst(car, 0) and not isCarTireBurst(car, 1) and
                    not isCarTireBurst(car, 2) and not isCarTireBurst(car, 3) and not isCarTireBurst(car, 4)) or
                    distance > 5 then
                    local key = indexof(1, CTaskArr[1])
                    if key ~= false then
                        CTaskArr[2][key] = os.time() - 100
                    end
                end
            end
        end

        if var.current.client ~= nil then
            local players = getClosestPlayersId()
            if players ~= nil then
                if players[var.current.client] ~= nil then
                    local clientHandle = players[var.current.client]
                    if isCharInAnyCar(PLAYER_PED) then
                        fcarHandle = storeCarCharIsInNoSave(PLAYER_PED)
                        if getDriverOfCar(fcarHandle) == PLAYER_PED then
                            if isCarTaxi(fcarHandle) then
                                local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
                                local cX, cY, cZ = getCharCoordinates(clientHandle)
                                local distance = math.ceil(math.sqrt(
                                    ((myX - cX) ^ 2) + ((myY - cY) ^ 2) + ((myZ - cZ) ^ 2)))
                                if distance <= 20 then
                                    CTaskTaxiClear()
                                    var.current.clientRP = var.current.client:gsub("_", " ")
                                    table.insert(CTaskArr[1], 7)
                                    table.insert(CTaskArr[2], os.time())
                                    table.insert(CTaskArr[3], var.current.clientRP)
                                    var.current.client = nil
                                end
                            end
                        end
                    end
                end
            end
        end

        if isCharInAnyCar(PLAYER_PED) then -- репорт перевернуть тачку
            local car = storeCarCharIsInNoSave(PLAYER_PED)
            if isCarUpsidedown(car) then
                if getCarSpeed(car) < 1 and not CTaskArr[10][3] then
                    local model = getCarModel(car)
                    local carname = var.vehicles[model - 399]
                    table.insert(CTaskArr[1], 8)
                    table.insert(CTaskArr[2], os.time())
                    table.insert(CTaskArr[3], carname)
                    CTaskArr[10][3] = true
                end
            else
                if CTaskArr[10][3] then
                    CTaskArr[10][3] = false
                    local key = indexof(8, CTaskArr[1])
                    if key ~= false then
                        CTaskArr[2][key] = os.time() - 100
                    end
                end
            end
        else
            if CTaskArr[10][3] then
                CTaskArr[10][3] = false
                local key = indexof(8, CTaskArr[1])
                if key ~= false then
                    CTaskArr[2][key] = os.time() - 100
                end
            end
        end

        sortCarr() -- ### Очистка массива контекстной клавиши, назначение нового контекстного действия
    end
end

function setSquadPos()
    while true do
        wait(0)
        for i = 0, 3000 do
            if sampTextdrawIsExists(i) and sampTextdrawGetString(i):match("SQUAD") then
                if srp_ini.bools.squad then
                    sampTextdrawSetPos(i, 1488, 1488)
                else
                    sampTextdrawSetPos(i, 1, 172)
                end
            end
        end
    end
end

function ct()
    lua_thread.create(function()
        local key = CTaskArr["CurrentID"]
        if key == 0 then
            script.sendMessage("Событие не найдено")
            return
        end
        if isKeyDown(makeHotKey('context')[1]) then
            sortCarr()
            wait(300)
            if isKeyDown(makeHotKey('context')[1]) then
                goto done
            end
        end

        if CTaskArr[1][key] == 1 then
            chatManager.addMessageToQueue("/repairkit")
        end
        if CTaskArr[1][key] == 2 then
            local nick = sampGetPlayerNickname(CTaskArr[3][key]):gsub("_", " ")
            if nick ~= nil then
                chatManager.addMessageToQueue("/rep " .. CTaskArr[3][key] .. " DM, проследите за ним")
            else
                script.sendMessage("Игрок оффлайн")
            end
        end
        if CTaskArr[1][key] == 3 then
            CTaskMedCall(CTaskArr[3][key])
        end
        if CTaskArr[1][key] == 4 then
            chatManager.addMessageToQueue("Куда едем?")
        end
        if CTaskArr[1][key] == 5 then
            chatManager.addMessageToQueue("Хорошо, выезжаем")
        end
        if CTaskArr[1][key] == 6 then
            chatManager.addMessageToQueue("Удачи!")
        end
        if CTaskArr[1][key] == 7 then
            chatManager.addMessageToQueue("/s " .. CTaskArr[3][key] .. " садись в такси!")
        end
        if CTaskArr[1][key] == 8 then
            chatManager.addMessageToQueue("/aask Переверните " .. CTaskArr[3][key] .. " пожалуйста")
        end

        ::done::
        table.remove(CTaskArr[1], key)
        table.remove(CTaskArr[2], key)
        table.remove(CTaskArr[3], key)
        CTaskArr["CurrentID"] = 0
        while isKeyDown(0x5D) do
            wait(0)
        end
    end)
end

function onfoot()
    while true do
        wait(0)
        if isCharOnFoot(PLAYER_PED) then
            if var.need.hold then
                setGameKeyState(1, (isCharInWater(PLAYER_PED) or isKeyDown(vkeys.VK_RBUTTON)) and -128 or -256)
            end
        end
    end
end

function setclist()
    lua_thread.create(function()
        local res, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if not res then
            script.sendMessage("Не удалось узнать свой ID")
            return
        end
        local myclist = clists.numbers[sampGetPlayerColor(myid)]
        if myclist == nil then
            script.sendMessage("Не удалось узнать номер своего цвета")
            return
        end
        if myclist == 0 then
            if tonumber(srp_ini.values.clist) == 0 then
                script.sendMessage("У вас уже нулевой клист!")
                return
            end
            chatManager.addMessageToQueue("/clist " .. srp_ini.values.clist .. "")
            wait(1300)
            local newmyclist = clists.numbers[sampGetPlayerColor(myid)]
            if newmyclist == nil then
                script.sendMessage("Не удалось узнать номер своего цвета")
                return
            end
            if newmyclist ~= tonumber(srp_ini.values.clist) then
                script.sendMessage("Клист не был надет")
                return
            end
        else
            chatManager.addMessageToQueue("/clist 0")
            wait(1300)
            local newmyclist = clists.numbers[sampGetPlayerColor(myid)]
            if newmyclist == nil then
                script.sendMessage("Не удалось узнать номер своего цвета")
                return
            end
            if newmyclist ~= 0 then
                script.sendMessage("Клист не был снят")
                return
            end
        end
    end)
end

function eject()
    if isCharInAnyCar(PLAYER_PED) then
        lua_thread.create(function()
            local carhandle1 = storeCarCharIsInNoSave(PLAYER_PED)
            if isKeyDown(makeHotKey('eject')[1]) then
                wait(600)
                if isKeyDown(makeHotKey('eject')[1]) then
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
                                    script.sendMessage(string.format(
                                        "Не удалось выкинуть игрока %s[%d] - сейчас АФК!",
                                        nick, id))
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
                    if empty ~= 0 then
                        script.sendMessage("В бинде №" .. i ..
                                               (empty ~= 0 and " обнаружено пустых строк: " ..
                                                   empty or " обнаружена пустая строка"))
                    end
                    if kol == 0 then
                        script.sendMessage("В бинде №" .. i .. " отсутствуют строки")
                    end
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
                    if var.argument[bind] ~= nil then
                        str = str:gsub("@params@", u8(tostring(var.argument[bind])))
                    else
                        script.sendMessage("Аргумент команды бинда №" .. bind ..
                                               ' не задан!')
                    end
                end
            end
        end
    end
    if str:match("@param%d+@") then
        if bind ~= nil then
            if tonumber(bind) ~= nil then
                if binder_ini.list[bind] ~= nil then
                    if var.argument[bind] ~= nil then
                        local params = {}
                        for s in string.gmatch(var.argument[bind], "[^ ]+") do
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
    if str:match("@myid@") then
        str = str:gsub("@myid@", tostring(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
    end
    if str:match("@mynick@") then
        str = str:gsub("@mynick@", sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
    end
    if str:match("@myrpnick@") then
        str = str:gsub("@myrpnick@",
            sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "))
    end
    if str:match("@myname@") then
        str = str:gsub("@myname@",
            sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):match("(.*)%_.*"))
    end
    if str:match("@mysurname@") then
        str = str:gsub("@mysurname@",
            sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):match(".*%_(.*)"))
    end
    if str:match("@date@") then
        str = str:gsub("@date@", os.date("%d.%m.%Y"))
    end
    if str:match("@hour@") then
        str = str:gsub("@hour@", os.date("%H"))
    end
    if str:match("@min@") then
        str = str:gsub("@min@", os.date("%M"))
    end
    if str:match("@sec@") then
        str = str:gsub("@sec@", os.date("%S"))
    end
    if str:match("@myclist@") then
        str = str:gsub("@myclist@",
            tostring(clists.numbers[sampGetPlayerColor(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))]))
    end
    if str:match("@mainclist@") then
        str = str:gsub("@mainclist@", tostring(srp_ini.values.clist))
    end
    if str:match("@kv@") then
        str = str:gsub("@kv@", currentSector())
    end
    return str
end

function enterhouse()
    if getActiveInterior() == 0 then
        for _, v in pairs(getAllObjects()) do
            local _, tX, tY, tZ = getObjectCoordinates(v)
            local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
            local model = getObjectModel(v)
            if (model == 1272 or model == 19523) and
                math.ceil(math.sqrt(((myX - tX) ^ 2) + ((myY - tY) ^ 2) + ((myZ - tZ) ^ 2))) <= 3 then
                local carhandles = getcars() -- получаем все машины вокруг
                if carhandles ~= nil then -- если машина обнаружена
                    for k, v in pairs(carhandles) do -- перебор всех машин в прорисовке
                        if doesVehicleExist(v) then
                            local idcar = getCarModel(v) -- получаем ид модельки
                            local myX, myY, myZ = getCharCoordinates(PLAYER_PED) -- получаем свои координаты
                            local cX, cY, cZ = getCarCoordinates(v) -- получаем координаты машины
                            local distance =
                                math.ceil(math.sqrt(((myX - cX) ^ 2) + ((myY - cY) ^ 2) + ((myZ - cZ) ^ 2))) -- расстояние между мной и машиной
                            local cars = {
                                [482] = "Burrito",
                                [498] = "Boxville",
                                [609] = "Boxville"
                            } -- ид фургонов ограбы домов
                            if sampGetDialogCaption():match(u8:decode "Дом занят") then
                                sampCloseCurrentDialogWithButton(0)
                            end
                            if cars[idcar] ~= nil and distance <= 30 and var.is.robbing then
                                for _, l in pairs(getAllObjects()) do
                                    local _, bX, bY, bZ = getObjectCoordinates(l)
                                    local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
                                    local bmodel = getObjectModel(l)
                                    local distance = math.ceil(math.sqrt(
                                        ((myX - bX) ^ 2) + ((myY - bY) ^ 2) + ((myZ - bZ) ^ 2))) -- расстояние между мной и объектом
                                    if bmodel == 19801 and distance < 1.5 then -- если объект Балаклава и расстояние меньше 1.5 м
                                        script.sendMessage("Пытаюсь вскрыть дом")
                                        chatManager.addMessageToQueue("/rhouse")
                                        return
                                    end
                                end
                                if tonumber(srp_ini.inventory.balaclava) ~= nil then
                                    if tonumber(srp_ini.inventory.balaclava) > 0 then
                                        chatManager.addMessageToQueue("/robmask")
                                        return
                                    else
                                        script.sendMessage(
                                            'У вас нет балаклавы, если желаете вскрыть дом - /rhouse')
                                        return
                                    end
                                end
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
            if CTaskArr["CurrentID"] == k then
                CTaskArr["CurrentID"] = 0
            end
            if CTaskArr[1][k] == 1 then
                CTaskArr[10][1] = false
            end
            table.insert(arr, k)
        end
    end

    for k, v in ipairs(arr) do -- удаление устаревших ID
        wait(0)
        table.remove(CTaskArr[1], v)
        table.remove(CTaskArr[2], v)
        table.remove(CTaskArr[3], v)
        if CTaskArr["CurrentID"] >= v then
            CTaskArr["CurrentID"] = CTaskArr["CurrentID"] - 1
        end
    end

    -- выбор нового CurrentID
    if CTaskArr["CurrentID"] == 0 then
        local lastrarr = {}
        for k, v in ipairs(CTaskArr[1]) do
            wait(0)
            if v == 1 then
                CTaskArr["CurrentID"] = k
                break
            end
            if v == 2 and lastrarr[2] == nil then
                lastrarr[2] = k
            end
            if v == 3 and lastrarr[3] == nil then
                lastrarr[3] = k
            end
            if v == 4 and lastrarr[4] == nil then
                lastrarr[4] = k
            end
            if v == 5 and lastrarr[5] == nil then
                lastrarr[5] = k
            end
            if v == 6 and lastrarr[6] == nil then
                lastrarr[6] = k
            end
            if v == 7 and lastrarr[7] == nil then
                lastrarr[7] = k
            end
            if v == 8 and lastrarr[8] == nil then
                lastrarr[8] = k
            end
        end

        if CTaskArr["CurrentID"] == 0 then
            for k, v in pairs(lastrarr) do
                wait(0)
                CTaskArr["CurrentID"] = v
                break
            end
        end
    end

    if CTaskArr["CurrentID"] < 0 or CTaskArr[1][CTaskArr["CurrentID"]] == nil then
        CTaskArr["CurrentID"] = 0
    end
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

function cmd_flood(arg)
    var.is.flood = not var.is.flood
    if not var.is.flood then
        script.sendMessage("Флуд сообщением завершён")
        chatManager.initQueue()
        return
    end
    if arg ~= nil and arg ~= "" then
        script.sendMessage(string.format("Начинаю флудить сообщением: %s"), arg)
        lua_thread.create(function()
            while var.is.flood do
                wait(0)
                chatManager.addMessageToQueue(u8(arg))
            end
        end)
    end
end

function CTaskMedCall(hospital)
    local fc = u8:decode "Организации"
    local sc = u8:decode "Меню"
    lua_thread.create(function()
        wait(100)
        sampSendChat("/dir")
        while not sampIsDialogActive() do
            wait(0)
        end
        sampSendDialogResponse(sampGetCurrentDialogId(), 1, 2)
        while sampGetDialogCaption() ~= fc do
            wait(0)
        end
        wait(100)
        sampCloseCurrentDialogWithButton(1)
        while sampGetDialogCaption() ~= sc do
            wait(0)
        end
        local med = sampGetDialogText()
        sampCloseCurrentDialogWithButton(0)
        wait(100)
        sampCloseCurrentDialogWithButton(0)
        wait(100)
        sampCloseCurrentDialogWithButton(0)
        for v in med:gmatch('[^\n]+') do
            local n, fname, sname, id, numb, afk = v:match("%[(%d+)%] (%a+)_(%a+)%[(%d+)%]	(%d+)(.*)")
            if n ~= nil then
                wait(1300)
                sampSendChat(string.format(u8:decode "/t %d Нужен медик в %s", id, hospital))
            end
        end
    end)
end

function whenhouse()
    if srp_ini.values.house ~= nil then
        if srp_ini.values.house ~= 0 then
            local datetime = {}
            datetime.year, datetime.month, datetime.day, hour = srp_ini.values.house:match(
                "(%d%d%d%d)%/(%d%d)%/(%d%d) (%d%d%:%d%d)")
            script.sendMessage("Недвижимость слетит через " ..
                                   math.floor((os.difftime(os.time(datetime), os.time())) / 3600 / 24) .. " дней | " ..
                                   srp_ini.values.house)
        else
            script.sendMessage(
                "Дата слёта неизвестна, оплатите квартплату в банкомате")
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

function cmd_jfadd(sparams)
    if srp_ini.values.jf == nil or srp_ini.values.jf == "" then
        script.sendMessage("Вы не выбрали профсоюз, откройте /srp")
        return
    end
    if sparams == "" then
        script.sendMessage("Неверный параметр. Введите /jfadd [ID]")
        return
    end
    local id = tonumber(sparams)
    if id == nil or (id < 0 and id > 999) or not sampIsPlayerConnected(id) then
        script.sendMessage("Игрок оффлайн")
        return
    end
    local nick = sampGetPlayerNickname(id)
    var.jf.nick = nick
    var.jf.id = id
    chatManager.addMessageToQueue(string.format("/jf addmember %s %d", srp_ini.values.jf, id))
end

function cmd_jfdel(sparams)
    if srp_ini.values.jf == nil or srp_ini.values.jf == "" then
        script.sendMessage("Вы не выбрали профсоюз, откройте /srp")
        return
    end
    if sparams == "" then
        script.sendMessage("Неверный параметр. Введите /jfdel [ID/nick]")
        return
    end
    local id = tonumber(sparams)
    if id ~= nil then
        if (id < 0 and id > 999) or not sampIsPlayerConnected(id) then
            script.sendMessage("Игрок оффлайн")
            return
        end
    end
    local nick = id ~= nil and sampGetPlayerNickname(id) or sparams
    var.jf.nick = nick
    var.jf.id = id
    chatManager.addMessageToQueue(string.format("/jf dellmember %s %s", srp_ini.values.jf, nick))
end

function cmd_jfmute(sparams)
    if srp_ini.values.jf == nil or srp_ini.values.jf == "" then
        script.sendMessage("Вы не выбрали профсоюз, откройте /srp")
        return
    end
    if sparams == "" then
        script.sendMessage("Неверный параметр. Введите /jfmute [ID] [SEC]")
        return
    end
    local params = {}
    for v in string.gmatch(sparams, "[^%s]+") do
        table.insert(params, v)
    end
    local id = tonumber(params[1])
    if id == nil or (id < 0 and id > 999) or not sampIsPlayerConnected(id) then
        script.sendMessage("Игрок оффлайн")
        return
    end
    local nick = sampGetPlayerNickname(id)
    local sec = tonumber(params[2]) ~= nil and tonumber(params[2]) or 0
    var.jf.nick = nick
    var.jf.id = id
    var.jf.sec = sec
    chatManager.addMessageToQueue(string.format("/jf mute %s %s %d", srp_ini.values.jf, nick, sec))
end

function cmd_jffine(sparams)
    if srp_ini.values.jf == nil or srp_ini.values.jf == "" then
        script.sendMessage("Вы не выбрали профсоюз, откройте /srp")
        return
    end
    if sparams == "" then
        script.sendMessage("Неверный параметр. Введите /jffine [ID] [Сумма]")
        return
    end
    local params = {}
    for v in string.gmatch(sparams, "[^%s]+") do
        table.insert(params, v)
    end
    local id = tonumber(params[1])
    if id == nil or (id < 0 and id > 999) or not sampIsPlayerConnected(id) then
        script.sendMessage("Игрок оффлайн")
        return
    end
    local nick = sampGetPlayerNickname(id)
    local fine = tonumber(params[2]) ~= nil and tonumber(params[2]) or 0
    var.jf.nick = nick
    var.jf.id = id
    var.jf.fine = fine
    chatManager.addMessageToQueue(string.format("/jf fine %s %s %d", srp_ini.values.jf, nick, fine))
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
        [24] = "Я"
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * -1 + 3000) / 250)
    Y = u8:decode(KV[Y])
    local KVX = string.format("%s-%d", Y, X)
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
            message = ""
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
            if script.label[server][nick] ~= nil then
                if textlabel[i] == nil then
                    textlabel[i] = sampCreate3dText(u8:decode(script.label[server][nick].text),
                        tonumber(script.label[server][nick].color), 0.0, 0.0, 0.8, 15.0, false, i, -1)
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
        if doesVehicleExist(v) and v ~= fcarhandle then
            table.insert(chandles, tableIndex, v)
            tableIndex = tableIndex + 1
        end
    end

    if table.maxn(chandles) == 0 then
        return nil
    else
        return chandles
    end
end

function getStrByState(keyState)
    if keyState == 0 then
        return "{ff8533}OFF{ffffff}"
    end
    return "{85cf17}ON{ffffff}"
end

function indexof(var, arr)
    for k, v in ipairs(arr) do
        if v == var then
            return k
        end
    end
    return false
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
        if tonumber(v) ~= 0 then
            table.insert(rett, tonumber(v))
        end
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
                    if tonumber(v) ~= 0 then
                        table.insert(rett, tonumber(v))
                    end
                end
                return rett
            end
        end
    end
end

function imgui.Hotkey(name, numkey, width)
    imgui.BeginChild(name, vec(width, 13.25), true)
    imgui.PushItemWidth(toScreenX(width))

    local hstr = ""
    for _, v in ipairs(string.split(srp_ini.hotkey[numkey], ", ")) do
        if v ~= "0" then
            hstr = hstr == "" and tostring(vkeys.id_to_name(tonumber(v))) or "" .. hstr .. " + " ..
                       tostring(vkeys.id_to_name(tonumber(v))) .. ""
        end
    end
    hstr = (hstr == "" or hstr == "nil") and "Нет клавиши" or hstr

    imgui.Text(hstr)
    imgui.PopItemWidth()
    imgui.EndChild()
    if imgui.IsItemClicked() then
        lua_thread.create(function()
            local curkeys = ""
            local tbool = false
            while true do
                wait(0)
                if not tbool then
                    for k, v in pairs(vkeys) do
                        sv = tostring(v)
                        if isKeyDown(v) and
                            (v == vkeys.VK_MENU or v == vkeys.VK_CONTROL or v == vkeys.VK_SHIFT or v == vkeys.VK_LMENU or
                                v == vkeys.VK_RMENU or v == vkeys.VK_RCONTROL or v == vkeys.VK_LCONTROL or v ==
                                vkeys.VK_LSHIFT or v == vkeys.VK_RSHIFT) then
                            if v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT then
                                if not curkeys:find(sv) then
                                    curkeys = tostring(curkeys):len() == 0 and sv or curkeys .. " " .. sv
                                end
                            end
                        end
                    end

                    for k, v in pairs(vkeys) do
                        sv = tostring(v)
                        if isKeyDown(v) and
                            (v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT and v ~=
                                vkeys.VK_LMENU and v ~= vkeys.VK_RMENU and v ~= vkeys.VK_RCONTROL and v ~=
                                vkeys.VK_LCONTROL and v ~= vkeys.VK_LSHIFT and v ~= vkeys.VK_RSHIFT) then
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
                        if isKeyDown(v) and
                            (v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT and v ~=
                                vkeys.VK_LMENU and v ~= vkeys.VK_RMENU and v ~= vkeys.VK_RCONTROL and v ~=
                                vkeys.VK_LCONTROL and v ~= vkeys.VK_LSHIFT and v ~= vkeys.VK_RSHIFT) then
                            tbool2 = true
                            if not curkeys:find(sv) then
                                curkeys = tostring(curkeys):len() == 0 and sv or curkeys .. " " .. sv
                            end
                        end
                    end

                    if not tbool2 then
                        break
                    end
                end
            end

            local keys = "0"
            if tonumber(curkeys) == vkeys.VK_BACK then
                srp_ini.hotkey[numkey] = "0"
            else
                local tNames = string.split(curkeys, " ")
                for _, v in ipairs(tNames) do
                    local val = (tonumber(v) == 162 or tonumber(v) == 163) and 17 or
                                    (tonumber(v) == 160 or tonumber(v) == 161) and 16 or
                                    (tonumber(v) == 164 or tonumber(v) == 165) and 18 or tonumber(v)
                    keys = keys == "0" and val or "" .. keys .. ", " .. val .. ""
                end
            end

            srp_ini.hotkey[numkey] = keys
            inicfg.save(srp_ini, settings)
        end)
    end
end

function imgui.binderHotkey(name, numkey, width)
    local hstr = ""
    local b = decodeJson(binder_ini.list[numkey])
    for _, v in ipairs(string.split(b.hotkey, ", ")) do
        if v ~= "0" then
            hstr = hstr == "" and tostring(vkeys.id_to_name(tonumber(v))) or "" .. hstr .. " + " ..
                       tostring(vkeys.id_to_name(tonumber(v))) .. ""
        end
    end
    hstr = (hstr == "" or hstr == "nil") and "Нет клавиши" or hstr
    imgui.Button(hstr, vec(100 / 3, width))
    if imgui.IsItemClicked() then
        lua_thread.create(function()
            local curkeys = ""
            local tbool = false
            while true do
                wait(0)
                if not tbool then
                    for k, v in pairs(vkeys) do
                        sv = tostring(v)
                        if isKeyDown(v) and
                            (v == vkeys.VK_MENU or v == vkeys.VK_CONTROL or v == vkeys.VK_SHIFT or v == vkeys.VK_LMENU or
                                v == vkeys.VK_RMENU or v == vkeys.VK_RCONTROL or v == vkeys.VK_LCONTROL or v ==
                                vkeys.VK_LSHIFT or v == vkeys.VK_RSHIFT) then
                            if v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT then
                                if not curkeys:find(sv) then
                                    curkeys = tostring(curkeys):len() == 0 and sv or curkeys .. " " .. sv
                                end
                            end
                        end
                    end

                    for k, v in pairs(vkeys) do
                        sv = tostring(v)
                        if isKeyDown(v) and
                            (v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT and v ~=
                                vkeys.VK_LMENU and v ~= vkeys.VK_RMENU and v ~= vkeys.VK_RCONTROL and v ~=
                                vkeys.VK_LCONTROL and v ~= vkeys.VK_LSHIFT and v ~= vkeys.VK_RSHIFT) then
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
                        if isKeyDown(v) and
                            (v ~= vkeys.VK_MENU and v ~= vkeys.VK_CONTROL and v ~= vkeys.VK_SHIFT and v ~=
                                vkeys.VK_LMENU and v ~= vkeys.VK_RMENU and v ~= vkeys.VK_RCONTROL and v ~=
                                vkeys.VK_LCONTROL and v ~= vkeys.VK_LSHIFT and v ~= vkeys.VK_RSHIFT) then
                            tbool2 = true
                            if not curkeys:find(sv) then
                                curkeys = tostring(curkeys):len() == 0 and sv or curkeys .. " " .. sv
                            end
                        end
                    end

                    if not tbool2 then
                        break
                    end
                end
            end

            local keys = ""
            if tonumber(curkeys) == vkeys.VK_BACK then
                b.hotkey = "0"
            else
                local tNames = string.split(curkeys, " ")
                for _, v in ipairs(tNames) do
                    local val = (tonumber(v) == 162 or tonumber(v) == 163) and 17 or
                                    (tonumber(v) == 160 or tonumber(v) == 161) and 16 or
                                    (tonumber(v) == 164 or tonumber(v) == 165) and 18 or tonumber(v)
                    keys = keys == "" and val or "" .. keys .. ", " .. val .. ""
                end
            end
            b.hotkey = tostring(keys)
            binder_ini.list[numkey] = encodeJson(b)
            inicfg.save(binder_ini, binds)
        end)
    end
end

function imgui.closeAllSections()
    for name, section in pairs(menu) do
        if not section.sure then
            menu[name].bool.v = false
        end
    end
end

function imgui.section(e)
    if menu[e] ~= nil then
        menu[e].bool.v = true
        if menu[e].sure then
            for name, section in pairs(menu) do
                if name ~= e then
                    menu[name].bool.v = false
                end
            end
        else
            for name, section in pairs(menu) do
                if not section.sure then
                    if name ~= e then
                        menu[name].bool.v = false
                    end
                end
            end
        end
    end
end

function sendEmptyPacket(id)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, id)
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
end

function closeConnect()
    local bs = raknetNewBitStream()
    raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, bs)
    raknetDeleteBitStream(bs)
end

function script.checkUpdates() -- проверка обновлений
    lua_thread.create(function()
        local response = request("https://raw.githubusercontent.com/WebbLua/SRPfunctions/main/version.json")
        local data = decodeJson(response)
        if data == nil then
            script.sendMessage("Не удалось получить информацию про обновления")
            script.unload = true
            thisScript():unload()
            return
        end
        script.v.num = data.version
        script.v.date = data.date
        script.url = data.url
        if data.telegram then
            script.telegram = data.telegram
        end
        script.quest = data.quest
        script.label = decodeJson(request(data.label))
        script.upd.changes = data.changelog
        if script.quest then
            for k, v in pairs(script.quest) do
                srp_ini.description[k] = v
            end
            inicfg.save(srp_ini, settings)
        end
        script.upd.sort = {}
        if script.upd.changes then
            for k in pairs(script.upd.changes) do
                table.insert(script.upd.sort, tonumber(k))
            end
            table.sort(script.upd.sort, function(a, b)
                return a > b
            end)
        end
        if data.version > thisScript()['version_num'] then
            script.sendMessage(updating_prefix .. "Обнаружена новая версия скрипта от " ..
                                   data.date .. ", начинаю обновление...")
            script.updateScript()
            return true
        end
        script.checkedUpdates = true
    end)
end

function request(url) -- запрос по URL
    while not script.request.free do
        wait(0)
    end
    script.request.free = false
    local path = os.tmpname()
    while true do
        script.request.complete = false
        download_id = downloadUrlToFile(url, path, download_handler)
        while not script.request.complete do
            wait(0)
        end
        local file = io.open(path, "r")
        if file ~= nil then
            local text = file:read("*a")
            io.close(file)
            os.remove(path)
            script.request.free = true
            return text
        end
        os.remove(path)
    end
    return ""
end

function download_handler(id, status, p1, p2)
    if stop_downloading then
        stop_downloading = false
        download_id = nil
        return false -- прервать загрузку
    end

    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        script.request.complete = true
    end
end

function script.updateScript()
    script.update = true
    downloadUrlToFile(script.url, thisScript().path, function(_, status, _, _)
        if status == 6 then
            script.sendMessage(updating_prefix .. "Скрипт был обновлён!")
            if script.find("ML-AutoReboot") == nil then
                thisScript():reload()
            end
        end
    end)
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
        for i = 0, 3000 do
            if sampTextdrawIsExists(i) and sampTextdrawGetString(i):match("SQUAD") then
                sampTextdrawSetPos(i, 1, 172)
            end
        end
        if not script.reload then
            if not script.update then
                if not script.unload then
                    script.sendMessage(error_prefix ..
                                           "Скрипт крашнулся: отправьте файл moonloader\\moonloader.log разработчику в tg: " ..
                                           script.telegram.nick)
                else
                    script.sendMessage("Скрипт был выгружен")
                end
            else
                script.sendMessage(updating_prefix .. "Перезагружаюсь...")
            end
        else
            script.sendMessage("Перезагружаюсь...")
        end
    end
end