local _M = class(CtrlBase)

function _M:StartView()
    print("BattleArrCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.BattleArr, BattleArrViewNames.BattleArr, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
    CtrlManager:CloseCtrl(BattleArrCtrlNames.BattleArr)
end

return _M