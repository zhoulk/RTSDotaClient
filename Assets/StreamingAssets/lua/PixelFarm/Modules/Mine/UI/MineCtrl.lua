
local _M = class(CtrlBase)

function _M:StartView()
    print("MineCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Mine, MineViewNames.Mine, PANEL_MID(), self.args)
end

return _M