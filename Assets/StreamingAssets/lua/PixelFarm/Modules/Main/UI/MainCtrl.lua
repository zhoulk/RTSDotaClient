local PlayerInterface = require "PixelFarm.Modules.PlayerInfo.Interface.PlayerInfoInterface"

local _M = class(CtrlBase)

function _M:StartView()
    print("_MainCtrl startView ~~~~~~~")
    ViewManager:Start(self, MoudleNames.Main, MainViewNames.Main, PANEL_MID(), self.args)
    
    self.ctrlCache = {}

    Event.AddListener(EventType.CoinChanged, function (arg1, arg2)
        self:OnCoinChanged(arg1, arg2)
    end)
end

function _M:CurrentPlayer()
    return PlayerInterface:CurrentPlayer()
end

function _M:ShowTownCenter()
    self:OpenCtrl(MoudleNames.Town, TownCtrlNames.Town)
end

function _M:ShowBuilding()
    self:OpenCtrl(MoudleNames.Building, BuildingCtrlNames.Building)
end

function _M:ShowFarm()
    self:OpenCtrl(MoudleNames.Farm, FarmCtrlNames.Farm)
end

function _M:ShowFactory()
    CtrlManager:OpenCtrl(MoudleNames.Factory, FactoryCtrlNames.Factory)
end

function _M:ShowTech()
    CtrlManager:OpenCtrl(MoudleNames.Tech, TechCtrlNames.Tech)
end

function _M:ShowJetty()
    CtrlManager:OpenCtrl(MoudleNames.Jetty, JettyCtrlNames.Jetty)
end

function _M:ShowMine()
    CtrlManager:OpenCtrl(MoudleNames.Mine, MineCtrlNames.Mine)
end

function _M:ShowZoo()
    CtrlManager:OpenCtrl(MoudleNames.Zoo, ZooCtrlNames.Zoo)
end

function _M:ShowAirport()
    CtrlManager:OpenCtrl(MoudleNames.Airport, AirportCtrlNames.Airport)
end

function _M:ShowTrain()
    CtrlManager:OpenCtrl(MoudleNames.Train, TrainCtrlNames.Train)
end

function _M:OnCoinChanged(arg1, arg2)
    local player = self:CurrentPlayer()
    player.coin = arg2
    self.view:UpdateCoinUI(player)
end

function _M:OpenCtrl(moduleName, ctrlName)
    local key = moduleName .. "-" .. ctrlName
    if not isTableContainsKey(key, self.ctrlCache) then
        local ctrl = CtrlManager:OpenCtrl(moduleName, ctrlName)
        self.ctrlCache[key] = ctrl
    end
    for _,ctrl in pairs(self.ctrlCache) do
        if ctrl.ctrlName == ctrlName then
            ctrl:Show()
        else
            ctrl:Hide()
        end
    end
end

return _M