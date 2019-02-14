
local _M = class(CtrlBase)

function _M:StartView()
    print("TrainCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Train, TrainViewNames.Train, PANEL_MID(), self.args)
end

return _M