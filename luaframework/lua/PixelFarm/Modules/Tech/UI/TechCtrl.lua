
local _M = class(CtrlBase)

function _M:StartView()
    print("TechCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Tech, TechViewNames.Tech, PANEL_MID(), self.args)
end

return _M