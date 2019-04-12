local GroupLogic = require "PixelFarm.Modules.Logic.GroupLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("GroupListCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Group, GroupViewNames.GroupList, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(GroupCtrlNames.GroupList)
end

function _M:CreateGroup(name)
    GroupLogic:GroupCreate(name, function (succeed, err, group)
        if succeed then
            CtrlManager:OpenCtrl(MoudleNames.Group, GroupCtrlNames.GroupMain, group)
            CtrlManager:CloseCtrl(GroupCtrlNames.GroupList)
            CtrlManager:CloseCtrl(MainCtrlNames.Main)
        else
            toast(err.msg)
        end
    end)
end

return _M