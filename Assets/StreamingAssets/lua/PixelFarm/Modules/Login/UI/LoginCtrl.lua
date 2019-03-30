local LoginLogic = require "PixelFarm.Modules.Logic.LoginLogic"
local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _LoginCtrl = class(CtrlBase)

function _LoginCtrl:StartView()
    print("_LoginCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Login, LoginViewNames.Login, PANEL_MID(), self.args)
end

function _LoginCtrl:Login(accout, password)
    LoginLogic:Login(accout,password,function (succeed, err)
        if succeed then
            CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
            CtrlManager:CloseCtrl(LoginCtrlNames.Login)
        else
            toast(err.msg)
        end
    end)
end

function _LoginCtrl:Registe(accout, password)
    LoginLogic:Registe(accout,password,function (succeed, err)
        if succeed then
            CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
            CtrlManager:CloseCtrl(LoginCtrlNames.Login)
        else
            toast(err.msg)
        end
    end)
end

function _LoginCtrl:AllZones(cb)
    LoginLogic:AllZone(function(succeed, err, zones)
        if succeed then
            if cb ~= nil then
                cb(zones)
            end
        else
            toast("获取服务器列表失败，请检查网络！")
        end
    end)
end

function _LoginCtrl:CurrentUser()
    local player = StoreLogic:CurrentPlayer()
    return player
end

return _LoginCtrl