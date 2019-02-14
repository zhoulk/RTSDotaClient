require "Common.protocal"

local _NetManager = class()

NetManager = _NetManager.Instance()

function _NetManager:Init()
    Protocal.Registe(100, "LoginRequest")
    Protocal.Registe(101, "LoginResponse")
    Protocal.Registe(102, "RegisteRequest")
    Protocal.Registe(103, "RegisteResponse")
end
