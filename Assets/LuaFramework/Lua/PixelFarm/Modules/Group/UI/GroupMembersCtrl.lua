local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"
local GroupLogic = require "PixelFarm.Modules.Logic.GroupLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("GroupMemberCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Group, GroupViewNames.GroupMember, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(GroupCtrlNames.GroupMember)
end

function _M:GroupMembers(groupId, cb)
    StoreLogic:GroupMembers(groupId, function (members)
        if cb then
            cb(members)
        end
    end, true)
end

function _M:GroupApplyMembers(groupId, cb)
    StoreLogic:GroupApplyMembers(groupId, function (members)
        if cb then
            cb(members)
        end
    end, true)
end

function _M:GroupAgree(groupId, userId, cb)
    GroupLogic:GroupOper(groupId, 1, userId, function (succeed, err)
        if succeed then
            if cb then
                cb()
            end
        else
            toast(err.msg)
        end
    end)
end

function _M:GroupReject(groupId, userId, cb)
    GroupLogic:GroupOper(groupId, 2, userId, function (succeed, err)
        if succeed then
            if cb then
                cb()
            end
        else
            toast(err.msg)
        end
    end)
end

return _M