local _MapLogic = class()

-- 登录
-- cb(succeed, err, heros)

local chapterResponseFunc
local guanKaResponseFunc

function _MapLogic:AllChapter(cb)

    if chapterResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("ChapterResponse"), chapterResponseFunc) 
    end
    chapterResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[MapLogic.AllChapter] response")

        local decode = protobuf.decode("msg.ChapterResponse", data)

        print("[MapLogic.AllChapter] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.chapters)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("ChapterResponse"), chapterResponseFunc) 

    local heroParams = {
    }
    local code = protobuf.encode("msg.ChapterRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("ChapterRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _MapLogic:AllGuanKa(cb)

    if guanKaResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("GuanKaResponse"), guanKaResponseFunc) 
    end
    guanKaResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[MapLogic.AllGuanKa] response")

        local decode = protobuf.decode("msg.GuanKaResponse", data)

        print("[MapLogic.AllGuanKa] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.guanKas)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("GuanKaResponse"), guanKaResponseFunc) 

    local heroParams = {
    }
    local code = protobuf.encode("msg.GuanKaRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("GuanKaRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

return _MapLogic