
local _M = class(CtrlBase)

function _M:StartView()
    print("EquipListCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Equip, EquipViewNames.EquipList, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(EquipCtrlNames.EquipList)
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
end

return _M