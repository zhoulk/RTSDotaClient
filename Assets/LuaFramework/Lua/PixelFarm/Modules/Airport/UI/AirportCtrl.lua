
local _M = class(CtrlBase)

function _M:StartView()
    print("AirportCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Airport, AirportViewNames.Airport, PANEL_MID(), self.args)
end

return _M