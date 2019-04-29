local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("EquipListCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Equip, EquipViewNames.EquipList, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(EquipCtrlNames.EquipList)
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
end

function _M:AllOwnEquips(cb)
    local player = StoreLogic:CurrentPlayer()
    StoreLogic:AllOwnEquips(player.UserId, function (equips)
        if cb then
            cb(equips)
        end
    end, true)
end

function _M:CurrentPlayer(cb)
    local player = StoreLogic:CurrentPlayer()
    if cb then
        cb(player)
    end
end

return _M