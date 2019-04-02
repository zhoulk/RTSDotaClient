local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("BattleCtrl startView ~~~~~~~")

	ViewManager:Start(self, MoudleNames.Battle, BattleViewNames.Battle, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(BattleCtrlNames.Battle)
end

return _M