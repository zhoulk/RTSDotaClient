
AppName = "PixelFarm"

App = {
    serverIp = "127.0.0.1",
    serverPort = 7000
}

-- 模块名称
MoudleNames = {
    Common = "Common",
    Loading = "Loading",
    Main = "Main",
    Login = "Login",
    Map = "Map",
    Farm = "Farm",
    Factory = "Factory",
    Tech = "Tech",
    Jetty = "Jetty",
    Mine = "Mine",
    Zoo = "Zoo",
    Airport = "Airport",
    Train = "Train",
    PlayerInfo = "PlayerInfo",
    Building = "Building",
    Storage = "Storage",
    Town = "Town",

    Test = "Test"
}

-- UI层级
UIPanelNames = {
    Low = "Low",
    Mid = "Mid",
    High = "High",
    Top = "Top"
}

UIPanelOrder = {UIPanelNames.Low, UIPanelNames.Mid, UIPanelNames.High, UIPanelNames.Top}

require "PixelFarm/Modules/Loading/LoadingDefine"
require "PixelFarm/Modules/Main/MainDefine"
require "PixelFarm/Modules/Login/LoginDefine"
require "PixelFarm/Modules/Map/MapDefine"
require "PixelFarm/Modules/Farm/FarmDefine"
require "PixelFarm/Modules/Tech/TechDefine"
require "PixelFarm/Modules/Factory/FactoryDefine"
require "PixelFarm/Modules/Jetty/JettyDefine"
require "PixelFarm/Modules/Mine/MineDefine"
require "PixelFarm/Modules/Zoo/ZooDefine"
require "PixelFarm/Modules/Airport/AirportDefine"
require "PixelFarm/Modules/Train/TrainDefine"
require "PixelFarm/Modules/Building/BuildingDefine"
require "PixelFarm/Modules/Storage/StorageDefine"
require "PixelFarm/Modules/Town/TownDefine"
require "PixelFarm/Modules/Common/CommonDefine"
require "PixelFarm/Modules/Test/TestDefine"

require "PixelFarm.EventDefine"