local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("BattleArrCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.BattleArr, BattleArrViewNames.BattleArr, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
    CtrlManager:CloseCtrl(BattleArrCtrlNames.BattleArr)
end

function _M:AllOwnHeros(cb)
    StoreLogic:AllOwnHeros(function (heros)
        if cb then
            cb(heros)
        end
    end)
end

function _M:ShowHeroSelect()
    CtrlManager:OpenCtrl(MoudleNames.Hero, HeroCtrlNames.HeroSelect)
end

return _M