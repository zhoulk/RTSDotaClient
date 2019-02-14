
local _M = class(CtrlBase)

function _M:StartView()
    print("FactoryCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Factory, FactoryViewNames.Factory, PANEL_MID(), self.args)
end

return _M