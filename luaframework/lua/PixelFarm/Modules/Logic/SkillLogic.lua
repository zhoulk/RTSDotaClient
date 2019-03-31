local _SkillLogic = class()

-- 登录
-- cb(succeed, err, heros)

local skillResponseFunc
local skillUpgradeFunc

function _SkillLogic:AllSkill(cb)

    if skillResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("SkillResponse"), skillResponseFunc) 
    end
    skillResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[SkillLogic.AllSkill] response")

        local decode = protobuf.decode("msg.SkillResponse", data)

        print("[SkillLogic.AllSkill] response = " .. tabStr(decode))

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
    Event.AddListener(Protocal.KeyOf("SkillResponse"), skillResponseFunc) 

    local heroParams = {
    }
    local code = protobuf.encode("msg.SkillRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("SkillRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _SkillLogic:UpgradeSkill(skillId, cb)

    if skillUpgradeFunc then
        Event.RemoveListener(Protocal.KeyOf("SkillUpgradeResponse"), skillUpgradeFunc) 
    end
    skillUpgradeFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[SkillLogic.SkillUpgrade] response")

        local decode = protobuf.decode("msg.SkillUpgradeResponse", data)

        print("[SkillLogic.SkillUpgrade] response = " .. tabStr(decode))

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
    Event.AddListener(Protocal.KeyOf("SkillUpgradeResponse"), skillUpgradeFunc) 

    local heroParams = {
        skillId = skillId
    }
    local code = protobuf.encode("msg.SkillUpgradeRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("SkillUpgradeRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end


return _SkillLogic