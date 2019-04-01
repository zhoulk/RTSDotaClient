local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

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
    LoginLogic:Login(player.uid, "", function (succeed, err, player)
        if cb then
            cb(player)
        end
    end)
end

function _M:ShowTavernDetail()
    CtrlManager:OpenCtrl(MoudleNames.Tavern, TavernCtrlNames.TavernDetail)
    CtrlManager:CloseCtrl(TavernCtrlNames.Tavern)
end

return _M