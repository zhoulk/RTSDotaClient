local _ItemLogic = class()

-- 登录
-- cb(succeed, err, heros)

local ItemResponseFunc

function _ItemLogic:QueryItems(cb)
    if ItemResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("ItemResponse"), ItemResponseFunc) 
    end
    ItemResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[ItemLogic.QueryItems] response")

        local decode = protobuf.decode("msg.ItemResponse", data)

        print("[ItemLogic.QueryItems] response = " .. tabStr(decode))

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
    Event.AddListener(Protocal.KeyOf("ItemResponse"), ItemResponseFunc) 

    local heroParams = {
    }
    local code = protobuf.encode("msg.ItemRequest", heroParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("ItemRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

return _ItemLogic