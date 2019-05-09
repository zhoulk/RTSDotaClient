local _GroupLogic = class()

local GroupOwnResponseFunc
local GroupListResponseFunc
local GroupCreateResponseFunc
local GroupMembersResponseFunc
local GroupApplyMembersResponseFunc
local GroupOperResponseFunc
local GroupApplyResponseFunc

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

function _GroupLogic:GroupList(cb)

    if GroupListResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("GroupListResponse"), GroupListResponseFunc) 
    end
    GroupListResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[GroupLogic.GroupList] response")

        local decode = protobuf.decode("msg.GroupListResponse", data)

        print("[GroupLogic.GroupList] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.groups)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("GroupListResponse"), GroupListResponseFunc) 

    local requestParams = {
    }
    local code = protobuf.encode("msg.GroupListRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("GroupListRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _GroupLogic:GroupCreate(name, cb)

    if GroupCreateResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("GroupCreateResponse"), GroupCreateResponseFunc) 
    end
    GroupCreateResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[GroupLogic.GroupCreate] response")

        local decode = protobuf.decode("msg.GroupCreateResponse", data)

        print("[GroupLogic.GroupCreate] response = " .. tabStr(decode))

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
    Event.AddListener(Protocal.KeyOf("GroupCreateResponse"), GroupCreateResponseFunc) 

    local requestParams = {
        groupName = name
    }
    local code = protobuf.encode("msg.GroupCreateRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("GroupCreateRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _GroupLogic:GroupApply(groupId, cb)

    if GroupApplyResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("GroupApplyResponse"), GroupApplyResponseFunc) 
    end
    GroupApplyResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[GroupLogic.GroupApply] response")

        local decode = protobuf.decode("msg.GroupApplyResponse", data)

        print("[GroupLogic.GroupApply] response = " .. tabStr(decode))

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
    Event.AddListener(Protocal.KeyOf("GroupApplyResponse"), GroupApplyResponseFunc) 

    local requestParams = {
        groupId = groupId
    }
    local code = protobuf.encode("msg.GroupApplyRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("GroupApplyRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _GroupLogic:GroupMembers(gid, cb)

    if GroupMembersResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("GroupMembersResponse"), GroupMembersResponseFunc) 
    end
    GroupMembersResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[GroupLogic.GroupMembers] response")

        local decode = protobuf.decode("msg.GroupMembersResponse", data)

        print("[GroupLogic.GroupMembers] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.members)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("GroupMembersResponse"), GroupMembersResponseFunc) 

    local requestParams = {
        groupId = gid
    }
    local code = protobuf.encode("msg.GroupMembersRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("GroupMembersRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _GroupLogic:GroupApplyMembers(gid, cb)

    if GroupApplyMembersResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("GroupApplyMembersResponse"), GroupApplyMembersResponseFunc) 
    end
    GroupApplyMembersResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[GroupLogic.GroupApplyMembers] response")

        local decode = protobuf.decode("msg.GroupApplyMembersResponse", data)

        print("[GroupLogic.GroupApplyMembers] response = " .. tabStr(decode))

        if decode.code == "SUCCESS" then
            -- self:SaveUid(decode.uid)
            if cb then
                cb(true, nil, decode.members)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end
    Event.AddListener(Protocal.KeyOf("GroupApplyMembersResponse"), GroupApplyMembersResponseFunc) 

    local requestParams = {
        groupId = gid
    }
    local code = protobuf.encode("msg.GroupApplyMembersRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("GroupApplyMembersRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

function _GroupLogic:GroupOper(gid, oper, userId, cb)

    if GroupOperResponseFunc then
        Event.RemoveListener(Protocal.KeyOf("GroupOperResponse"), GroupOperResponseFunc) 
    end
    GroupOperResponseFunc = function(buffer)
        local data = buffer:ReadBuffer()

        print("[GroupLogic.GroupOper] response")

        local decode = protobuf.decode("msg.GroupOperResponse", data)

        print("[GroupLogic.GroupOper] response = " .. tabStr(decode))

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
    Event.AddListener(Protocal.KeyOf("GroupOperResponse"), GroupOperResponseFunc) 

    local requestParams = {
        groupId = gid,
        oper = oper,
        userId = userId
    }
    local code = protobuf.encode("msg.GroupOperRequest", requestParams)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("GroupOperRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

return _GroupLogic