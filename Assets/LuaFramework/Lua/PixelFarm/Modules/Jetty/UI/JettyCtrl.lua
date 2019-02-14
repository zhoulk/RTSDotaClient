
local _M = class(CtrlBase)

function _M:StartView()
    print("JettyCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Jetty, JettyViewNames.Jetty, PANEL_MID(), self.args)
end

return _M