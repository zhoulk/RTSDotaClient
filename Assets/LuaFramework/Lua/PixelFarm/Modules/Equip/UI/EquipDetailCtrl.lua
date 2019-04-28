
local _M = class(CtrlBase)

function _M:StartView()
    print("EquipDetailCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Equip, EquipViewNames.EquipDetail, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(EquipCtrlNames.EquipDetail)
end

return _M