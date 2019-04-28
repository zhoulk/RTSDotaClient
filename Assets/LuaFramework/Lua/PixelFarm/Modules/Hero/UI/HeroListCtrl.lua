local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("HeroListCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Hero, HeroViewNames.HeroList, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(HeroCtrlNames.HeroList)
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
end

function _M:AllOwnHeros(cb)
    local player = StoreLogic:CurrentPlayer()
    StoreLogic:AllOwnHeros(player.UserId, function (heros)
        if cb then
            cb(heros)
        end
    end, true)
end

function _M:CurrentPlayer(cb)
    local player = StoreLogic:CurrentPlayer()
    if cb then
        cb(player)
    end
end

return _M