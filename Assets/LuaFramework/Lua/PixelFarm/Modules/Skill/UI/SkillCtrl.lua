
local _M = class(CtrlBase)

function _M:StartView()
    print("SkillCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Skill, SkillViewNames.Skill, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(SkillCtrlNames.Skill)
end

return _M