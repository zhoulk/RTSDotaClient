
local _M = class(CtrlBase)

function _M:StartView()
    print("_TestCtrl startView ~~~~~~~")
    ViewManager:Start(self, MoudleNames.Test, TestViewNames.Test, PANEL_MID(), self.args)
end


return _M