local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

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
    end)
end

return _M