
local _M = class(CtrlBase)

function _M:StartView()
    print("GroupMainCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Group, GroupViewNames.GroupMain, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
    CtrlManager:CloseCtrl(GroupCtrlNames.GroupMain)
end

function _M:ShowMember(group)
    CtrlManager:OpenCtrl(MoudleNames.Group, GroupCtrlNames.GroupMember, group)
end

return _M