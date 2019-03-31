local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("HeroSelectCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Hero, HeroViewNames.HeroSelect, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(HeroCtrlNames.HeroSelect)
end

function _M:AllOwnHeros(cb)
    StoreLogic:AllOwnHeros(function (heros)
        if cb then
            cb(heros)
        end
    end)
end

return _M