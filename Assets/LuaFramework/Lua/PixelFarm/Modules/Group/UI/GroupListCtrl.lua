local GroupLogic = require "PixelFarm.Modules.Logic.GroupLogic"
local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("GroupListCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Group, GroupViewNames.GroupList, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(GroupCtrlNames.GroupList)
end

function _M:AllGroups(cb)
    StoreLogic:AllGroup(function (groups)
        if cb then
            cb(groups)
        end
    end, true)
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

function _M:ApplyGroup(groupId)
    GroupLogic:GroupApply(groupId, function(succeed, err)
        if succeed then
            toast("申请发送成功")
        else
            toast(err.msg)
        end
    end)
end

return _M