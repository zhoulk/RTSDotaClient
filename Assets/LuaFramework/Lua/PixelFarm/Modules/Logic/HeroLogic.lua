local _HeroLogic = class()

-- 登录
-- cb(succeed, err, heros)

local heroResponseFunc
local randomHeroResponseFunc
local heroOwnResponseFunc

function _HeroLogic:AllHero(cb)

    if heroResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("HeroResponse"), heroResponseFunc) 
    end
    heroResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[HeroLogic.AllHero] response")

        local decode = protobuf.decode("msg.HeroResponse", data)

        print("[HeroLogic.AllHero] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.heros)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("HeroResponse"), heroResponseFunc) 

    local heroParams = {
    }
    local code = protobuf.encode("msg.HeroRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("HeroRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _HeroLogic:RandomHero(level, cb)

    if randomHeroResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("HeroRandomResponse"), randomHeroResponseFunc) 
    end
    randomHeroResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[HeroLogic.RandomHero] response")

        local decode = protobuf.decode("msg.HeroRandomResponse", data)

        print("[HeroLogic.RandomHero] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("HeroRandomResponse"), randomHeroResponseFunc) 

    local heroParams = {
        Level = level
    }
    local code = protobuf.encode("msg.HeroRandomRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("HeroRandomRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _HeroLogic:AllOwnHero(cb)

    if heroOwnResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("HeroOwnResponse"), heroOwnResponseFunc) 
    end
    heroOwnResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[HeroLogic.AllOwnHero] response")

        local decode = protobuf.decode("msg.HeroOwnResponse", data)

        print("[HeroLogic.AllOwnHero] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.heros)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("HeroOwnResponse"), heroOwnResponseFunc) 

    local heroParams = {
    }
    local code = protobuf.encode("msg.HeroOwnRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("HeroOwnRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

return _HeroLogic