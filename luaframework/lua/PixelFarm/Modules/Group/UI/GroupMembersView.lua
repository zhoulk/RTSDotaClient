local _M = class(ViewBase)

function _M:OnCreate()
    print("GroupMemberView oncreate  ~~~~~~~")
    self.group = self.args[1]
    self.memberItemCache = {}

    self.tabBlock = self:InitTabBlock(self.transform, "content/tabs")
    self.memberListBlock = self:InitMemberListBlock(self.transform, "content/memberList")

    self.bgObj = self.transform:Find("bg").gameObject
    self.bgObj:SetOnClick(function ()
        self:OnBackClick()
    end)

    self:InitData()
end

function _M:InitData()
    self.iCtrl:GroupMembers(self.group.GroupId, function (members)
        self.members = members
        self:OnClickTab(1)
    end)
end

function _M:OnClickTab(index)
    for i,tab in pairs(self.tabBlock.tabs) do
        if i==index then
            tab.selectObj:SetActive(true)
        else
            tab.selectObj:SetActive(false)
        end
    end

    if index == 1 then
        self:RefreshMembers()
    else

    end
end

function _M:RefreshMembers()
    if self.members then
        for i,member in pairs(self.members) do
            local memberItem = {}

            if i <= #self.memberItemCache then
                memberItem = self.memberItemCache[i]
            else
                local memberObj = newObject(self.memberListBlock.memberItem)
                memberObj.transform:SetParent(self.memberListBlock.memberList.content, false)
                memberObj.transform.localScale = Vector3(1,1,1)
                memberObj:SetActive(true)
    
                memberItem.obj = memberObj
                memberItem.nameText = memberObj.transform:Find("name"):GetComponent("Text")

                table.insert(self.memberItemCache, memberItem)
            end

            memberItem.data = member
            memberItem.nameText.text = member.Name
        end

        for i=#self.members+1 ,#self.memberItemCache,1 do
            memberItem = self.memberItemCache[i]
            memberItem.obj:SetActive(false)
        end
    end
end

function _M:InitTabBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.tabs = {}
    table.insert(block.tabs, self:InitTab(transform, "members", 1))
    table.insert(block.tabs, self:InitTab(transform, "apply", 2))

    return block
end

function _M:InitTab(trans, path, index)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.selectObj = transform:Find("select").gameObject

    block.gameObject:SetOnClick(function ()
        self:OnClickTab(index)
    end)

    return block
end

function _M:InitMemberListBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.memberItem = transform:Find("item").gameObject
    block.memberList = transform:GetComponent("ScrollRect")

    return block
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M