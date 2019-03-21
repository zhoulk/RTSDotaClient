local _BattleLogic = class()

-- 登录
-- cb(succeed, err, heros)

local BattleGuanKaResponseFunc

function _BattleLogic:BattleGuanKa(guanKaId, cb)

    if BattleGuanKaResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("BattleGuanKaResponse"), BattleGuanKaResponseFunc) 
    end
    BattleGuanKaResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[BattleLogic.BattleGuanKa] response")

        local decode = protobuf.decode("msg.BattleGuanKaResponse", data)

        print("[BattleLogic.BattleGuanKa] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.guanka)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("BattleGuanKaResponse"), BattleGuanKaResponseFunc) 

    local requestParams = {
        guanKaId = guanKaId
    }
    local code = protobuf.encode("msg.BattleGuanKaRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("BattleGuanKaRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

return _BattleLogic