
local _M = class(CtrlBase)

function _M:StartView()
    print("GroupListCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Group, GroupViewNames.GroupList, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(GroupCtrlNames.GroupList)
end

return _M