
local _ToastCtrl = class(CtrlBase)

function _ToastCtrl:StartView()
    print("ToastCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Common, CommonViewNames.Toast, PANEL_TOP(), self.args)
end

function _ToastCtrl:ShowToast(str, delay)
    print("showToast " .. str)
    self.view:Show(str, delay)
end

return _ToastCtrl