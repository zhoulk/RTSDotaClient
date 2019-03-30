local PlayerInterface = require "PixelFarm.Modules.PlayerInfo.Interface.PlayerInfoInterface"

local _M = class(CtrlBase)

function _M:StartView()
    print("_TavernCtrl startView ~~~~~~~")
    ViewManager:Start(self, MoudleNames.Tavern, TavernViewNames.Tavern, PANEL_MID(), self.args)
end

function _M:CurrentPlayer(cb)
    local player = PlayerInterface:CurrentPlayer()
    LoginLogic:Login(player.uid, "", function (succeed, err, player)
        if cb then
            cb(player)
        end
    end)
end

return _M