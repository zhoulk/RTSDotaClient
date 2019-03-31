local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"
local HeroLogic = require "PixelFarm.Modules.Logic.HeroLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("_TavernDetailCtrl startView ~~~~~~~")
    ViewManager:Start(self, MoudleNames.Tavern, TavernViewNames.TavernDetail, PANEL_MID(), self.args)
end

function _M:Close()
    CtrlManager:OpenCtrl(MoudleNames.Tavern, TavernCtrlNames.Tavern)
    CtrlManager:CloseCtrl(TavernCtrlNames.TavernDetail)
end

function _M:AllHeros(cb)
    StoreLogic:AllHeros(function (heros)
        if cb then
            cb(heros)
        end
    end)
end

function _M:RandomHero(cb)
    HeroLogic:RandomHero("GOOD", function (succeed, err, hero)
        if succeed then
            if cb then
                cb(hero)
            end
        else
            toast(err.msg)
        end
    end)
end

function _M:ShowHeroDetail()
    -- CtrlManager:OpenCtrl(MoudleNames.Tavern, TavernCtrlNames.TavernDetail)
    -- CtrlManager:CloseCtrl(TavernCtrlNames.Tavern)
end

return _M