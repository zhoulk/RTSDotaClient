local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"
local HeroLogic = require "PixelFarm.Modules.Logic.HeroLogic"

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

function _M:HeroSkills(heroId, cb)
    StoreLogic:HeroSkills(heroId, function (skills)
        if cb then
            cb(skills)
        end
    end)
end

function _M:ShowHeroSelect(pos, cb)
    local selectFunc = function (heroId)
        print("select heroId = " .. heroId)
        HeroLogic:SelectHero(heroId,pos, function (succeed, err, heroIds)
            if succeed then
                StoreLogic:AllOwnHeros(function (heros)
                    if cb then
                        cb()
                    end
                end, true)
            else
                toast(err.msg)
            end
        end)
    end
    CtrlManager:OpenCtrl(MoudleNames.Hero, HeroCtrlNames.HeroSelect, selectFunc)
end

function _M:ShowEquip(equip)
    CtrlManager:OpenCtrl(MoudleNames.Equip, EquipCtrlNames.Equip)
end

function _M:ShowSkill(skill)
    CtrlManager:OpenCtrl(MoudleNames.Skill, SkillCtrlNames.Skill, skill)
end

return _M