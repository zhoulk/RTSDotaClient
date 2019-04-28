
local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _LoginLogic = class()

-- 登录
-- cb(succeed, err)

local loginResponseFunc
local registeResponseFunc
local zoneResponseFunc

function _LoginLogic:Login(accout, password, cb)
    print("[LoginLogic.Login] account = " .. accout .. " password = " .. password)

    if loginResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("LoginResponse"), loginResponseFunc) 
    end
    loginResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[LoginLogic.Login] response")

        local decode = protobuf.decode("msg.LoginResponse", data)

        print("[LoginLogic.Login] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            self:SavePlayer(decode.player)
            if cb then
                cb(true, nil, decode.player)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
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

    if registeResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("RegisteResponse"), registeResponseFunc) 
    end
    registeResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[LoginLogic.Registe] response")

        local decode = protobuf.decode("msg.RegisteResponse", data)

        print("[LoginLogic.Registe] response = " .. tabStr(decode) .. type(decode))
        print(decode.code)
        print(decode.err.code)
        print(decode.err.msg)
        
        if decode.code == "SUCCESS" then
            self:SavePlayer(decode.player)
            if cb then
                cb(true, nil, decode.player)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
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

function _LoginLogic:AllZone(cb)

    if zoneResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("ZoneResponse"), zoneResponseFunc) 
    end
    zoneResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[LoginLogic.AllZone] response")

        local decode = protobuf.decode("msg.ZoneResponse", data)

        print("[LoginLogic.AllZone] response = " .. tabStr(decode) .. type(decode))
        print(decode.code)
        print(decode.err.code)
        print(decode.err.msg)
        
        if decode.code == "SUCCESS" then
            if cb then
                cb(true, nil, decode.zones)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("ZoneResponse"), zoneResponseFunc) 

    local params = {
    }
    local code = protobuf.encode("msg.ZoneRequest", params)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("ZoneRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)

    print("LoginLogic.AllZone request")
end

function _LoginLogic:SavePlayer(player)
    StoreLogic:SavePlayer(player)
end

return _LoginLogic