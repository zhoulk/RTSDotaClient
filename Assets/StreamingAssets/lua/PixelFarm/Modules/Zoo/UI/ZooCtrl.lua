
local _M = class(CtrlBase)

function _M:StartView()
    print("ZooCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Zoo, ZooViewNames.Zoo, PANEL_MID(), self.args)
end

return _M