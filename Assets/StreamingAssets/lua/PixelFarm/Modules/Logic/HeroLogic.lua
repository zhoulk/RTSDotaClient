local _HeroLogic = class()

-- 登录
-- cb(succeed, err, heros)

local heroResponseFunc
local randomHeroResponseFunc
local heroOwnResponseFunc
local heroSelectResponseFunc
local heroUnSelectResponseFunc
local heroSkillsResponseFunc
local heroItemsResponseFunc
local heroLotteryResponseFunc

function _HeroLogic:HeroLottery(cb)

    if heroLotteryResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("HeroLotteryResponse"), heroLotteryResponseFunc) 
    end
    heroLotteryResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[HeroLogic.HeroLottery] response")

        local decode = protobuf.decode("msg.HeroLotteryResponse", data)

        print("[HeroLogic.HeroLottery] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            if cb then
                cb(true, nil, decode.heroLottery)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("HeroLotteryResponse"), heroLotteryResponseFunc) 

    local heroParams = {
    }
    local code = protobuf.encode("msg.HeroLotteryRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("HeroLotteryRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

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
                cb(true, nil, decode.hero)
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

function _HeroLogic:SelectHero(heroId, pos, cb)

    if heroSelectResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("HeroSelectResponse"), heroSelectResponseFunc) 
    end
    heroSelectResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[HeroLogic.SelectHero] response")

        local decode = protobuf.decode("msg.HeroSelectResponse", data)

        print("[HeroLogic.SelectHero] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.heroIds)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("HeroSelectResponse"), heroSelectResponseFunc) 

    local requestParams = {
        heroId = heroId,
        pos = pos
    }
    local code = protobuf.encode("msg.HeroSelectRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("HeroSelectRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _HeroLogic:UnSelectHero(heroId, cb)

    if heroUnSelectResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("HeroUnSelectResponse"), heroUnSelectResponseFunc) 
    end
    heroUnSelectResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[HeroLogic.UnSelectHero] response")

        local decode = protobuf.decode("msg.HeroUnSelectResponse", data)

        print("[HeroLogic.UnSelectHero] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.heroIds)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("HeroUnSelectResponse"), heroUnSelectResponseFunc) 

    local requestParams = {
        heroId = heroId
    }
    local code = protobuf.encode("msg.HeroUnSelectRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("HeroUnSelectRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _HeroLogic:HeroSkills(heroId, cb)
    if heroSkillsResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("HeroSkillsResponse"), heroSkillsResponseFunc) 
    end
    heroSkillsResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[HeroLogic.HeroSkills] response")

        local decode = protobuf.decode("msg.HeroSkillsResponse", data)

        print("[HeroLogic.HeroSkills] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.skills)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("HeroSkillsResponse"), heroSkillsResponseFunc) 

    local requestParams = {
        heroId = heroId
    }
    local code = protobuf.encode("msg.HeroSkillsRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("HeroSkillsRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _HeroLogic:HeroItems(heroId, cb)
    if heroItemsResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("HeroItemsResponse"), heroItemsResponseFunc) 
    end
    heroItemsResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[HeroLogic.HeroItems] response")

        local decode = protobuf.decode("msg.HeroItemsResponse", data)

        print("[HeroLogic.HeroItems] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.items)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("HeroItemsResponse"), heroItemsResponseFunc) 

    local requestParams = {
        heroId = heroId
    }
    local code = protobuf.encode("msg.HeroItemsRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("HeroItemsRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

return _HeroLogic