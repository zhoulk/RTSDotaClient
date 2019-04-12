
local _M = class(CtrlBase)

function _M:StartView()
    print("GroupMemberCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Group, GroupViewNames.GroupMember, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(GroupCtrlNames.GroupMember)
end

return _M