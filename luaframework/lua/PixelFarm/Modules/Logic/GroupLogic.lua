local _GroupLogic = class()

local GroupOwnResponseFunc
local GroupListResponseFunc
local GroupCreateResponseFunc
local GroupMembersResponseFunc

function _GroupLogic:GroupOwn(cb)

    if GroupOwnResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("GroupOwnResponse"), GroupOwnResponseFunc) 
    end
    GroupOwnResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[GroupLogic.GroupOwn] response")

        local decode = protobuf.decode("msg.GroupOwnResponse", data)

        print("[GroupLogic.GroupOwn] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.group)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("GroupOwnResponse"), GroupOwnResponseFunc) 

    local requestParams = {
    }
    local code = protobuf.encode("msg.GroupOwnRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("GroupOwnRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

return _GroupLogic