local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("ChallengeCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Challenge, ChallengeViewNames.Challenge, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(ChallengeCtrlNames.Challenge)
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
end

return _M