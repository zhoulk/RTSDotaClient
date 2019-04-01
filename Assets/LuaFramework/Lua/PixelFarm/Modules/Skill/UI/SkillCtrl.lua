local SkillLogic = require "PixelFarm.Modules.Logic.SkillLogic"
local Skill = require "PixelFarm.Modules.Data.Entry.Skill"
local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("SkillCtrl startView ~~~~~~~")
    self.hero = self.args[2]

	ViewManager:Start(self, MoudleNames.Skill, SkillViewNames.Skill, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(SkillCtrlNames.Skill)
end

function _M:UpgradeSkill(skillId, cb)
    SkillLogic:UpgradeSkill(skillId, function (succeed, err, skill)
        if succeed then
            local player = StoreLogic:CurrentPlayer()
            StoreLogic:AllOwnHeros(player.UserId, function ()
                StoreLogic:HeroSkills(self.hero.HeroId, function ()
                    if cb then
                        local sk = Skill.new()
                        sk:Init(skill)
                        cb(sk)
                    end
                end, true)
            end, true)
        else
            toast(err.msg)
        end
    end)
end

return _M