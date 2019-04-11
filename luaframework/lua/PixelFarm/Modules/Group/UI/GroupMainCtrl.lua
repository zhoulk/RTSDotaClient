
local _M = class(CtrlBase)

function _M:StartView()
    print("GroupMainCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Group, GroupViewNames.GroupMain, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(GroupCtrlNames.GroupMain)
end

return _M