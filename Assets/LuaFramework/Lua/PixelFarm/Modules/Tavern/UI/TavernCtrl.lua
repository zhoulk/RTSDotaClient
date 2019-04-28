local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"
local HeroLogic = require "PixelFarm.Modules.Logic.HeroLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("_TavernCtrl startView ~~~~~~~")
    ViewManager:Start(self, MoudleNames.Tavern, TavernViewNames.Tavern, PANEL_MID(), self.args)
end

function _M:Close()
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
    CtrlManager:CloseCtrl(TavernCtrlNames.Tavern)
end

function _M:CurrentPlayer(cb)
    local player = StoreLogic:CurrentPlayer()
end

function _M:ShowTavernDetail(camp, level)
    CtrlManager:OpenCtrl(MoudleNames.Tavern, TavernCtrlNames.TavernDetail, camp, level)
    CtrlManager:CloseCtrl(TavernCtrlNames.Tavern)
end

function _M:HeroLottery(cb)
    HeroLogic:HeroLottery(function(succeed, err, heroLottery)
        if succeed then
            if cb then
                cb(heroLottery)
            end
        else
            toast(err.msg)
        end
    end)
end

return _M