local LoginLogic = require "PixelFarm.Modules.Login.Logic.LoginLogic"

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
            CtrlManager:GetCtrl(CommonCtrlNames.Toast):ShowToast(err.msg)
        end
    end)
end

function _LoginCtrl:Registe(accout, password)
    LoginLogic:Registe(accout,password,function (succeed, err)
        if succeed then
            CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
            CtrlManager:CloseCtrl(LoginCtrlNames.Login)
        else
            CtrlManager:GetCtrl(CommonCtrlNames.Toast):ShowToast(err.msg)
        end
    end)
end

return _LoginCtrl