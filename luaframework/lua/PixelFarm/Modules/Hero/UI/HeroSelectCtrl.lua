local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("HeroSelectCtrl startView ~~~~~~~")
    self.selectFunc = self.args[1]

	ViewManager:Start(self, MoudleNames.Hero, HeroViewNames.HeroSelect, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(HeroCtrlNames.HeroSelect)
end

function _M:AllOwnHeros(cb)
    local player = StoreLogic:CurrentPlayer()
    StoreLogic:AllOwnHeros(player.UserId, function (heros)
        if cb then
            cb(heros)
        end
    end)
end

function _M:SelectHero(item)
    CtrlManager:CloseCtrl(HeroCtrlNames.HeroSelect)

    if self.selectFunc then
        self.selectFunc(item.data.HeroId)
    end
end

return _M