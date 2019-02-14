
local PlayerInterface = require "PixelFarm.Modules.PlayerInfo.Interface.PlayerInfoInterface"

local _LoginLogic = class()

-- 登录
-- cb(succeed, err)
function _LoginLogic:Login(accout, password, cb)
    print("[LoginLogic.Login] account = " .. accout .. " password = " .. password)

    local loginResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[LoginLogic.Login] response")

        local decode = protobuf.decode("msg.LoginResponse", data)

        print("[LoginLogic.Login] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            self:SaveUid(decode.uid)
            if cb then
                cb(true)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end

        Event.RemoveListener(Protocal.KeyOf("LoginResponse"), loginResponseFunc)
    end
    Event.AddListener(Protocal.KeyOf("LoginResponse"), loginResponseFunc) 

    local login = {
        account = accout,
        password = password
    }
    local code = protobuf.encode("msg.LoginRequest", login)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("LoginRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _LoginLogic:Registe(accout, password, cb)
    print("[LoginLogic] Registe account = " .. accout .. " password = " .. password)

    local registeResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[LoginLogic.Registe] response")

        local decode = protobuf.decode("msg.RegisteResponse", data)

        print("[LoginLogic.Registe] response = " .. tabStr(decode) .. type(decode))
        print(decode.code)
        print(decode.err.code)
        print(decode.err.msg)
        
        if decode.code == "SUCCESS" then
            self:SaveUid(decode.uid)
            if cb then
                cb(true)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end

        Event.RemoveListener(Protocal.KeyOf("RegisteResponse"), registeResponseFunc) 
    end
    Event.AddListener(Protocal.KeyOf("RegisteResponse"), registeResponseFunc) 

    local registe = {
        account = accout,
        password = password
    }
    local code = protobuf.encode("msg.RegisteRequest", registe)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("RegisteRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _LoginLogic:SaveUid(uid)
    PlayerInterface:UpdateUid(uid)
end

return _LoginLogic