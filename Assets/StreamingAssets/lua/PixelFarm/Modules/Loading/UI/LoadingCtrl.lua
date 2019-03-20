local PlayerInterface = require "PixelFarm.Modules.PlayerInfo.Interface.PlayerInfoInterface"
local LoginInterface = require "PixelFarm.Modules.Login.Interface.LoginInterface"

local _LoadingCtrl = class(CtrlBase)

function _LoadingCtrl:StartView()
    print("LoadingCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Loading, LoadingViewNames.Loading, PANEL_HIGH(), self.args)
end

function _LoadingCtrl:ShowMainView()
    local player = PlayerInterface:CurrentPlayer()
    print(tabStr(player))
    CtrlManager:OpenCtrl(MoudleNames.Test, TestCtrlNames.Test)
    -- if player and player.uid and #player.uid > 0 then
    --     LoginInterface:Login(player.uid,"",function (succeed, err)
    --         if succeed then
    --             CtrlManager:OpenCtrl(MoudleNames.Test, TestCtrlNames.Test)
    --         else
    --             CtrlManager:OpenCtrl(MoudleNames.Login, LoginCtrlNames.Login)
    --         end
    --     end)
    -- else
    --     CtrlManager:OpenCtrl(MoudleNames.Login, LoginCtrlNames.Login)
    -- end
    CtrlManager:CloseCtrl(LoadingCtrlNames.Loading)
end

return _LoadingCtrl