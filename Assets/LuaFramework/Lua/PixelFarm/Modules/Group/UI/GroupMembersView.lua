local _M = class(ViewBase)

function _M:OnCreate()
    print("GroupMemberView oncreate  ~~~~~~~")
    self.group = self.args[1]
    self.memberItemCache = {}
    self.applyMemberItemCache = {}

    self.tabBlock = self:InitTabBlock(self.transform, "content/tabs")
    self.memberListBlock = self:InitMemberListBlock(self.transform, "content/memberList")
    self.applyMemberListBlock = self:InitApplyMemberListBlock(self.transform, "content/applyMemberList")

    self.bgObj = self.transform:Find("bg").gameObject
    self.bgObj:SetOnClick(function ()
        self:OnBackClick()
    end)

    self:InitData()
end

function _M:InitData()
    self.iCtrl:GroupMembers(self.group.GroupId, function (members)
        self.members = members
        self:RefreshMembers()

        self:OnClickTab(1)
    end)
    self.iCtrl:GroupApplyMembers(self.group.GroupId, function (members)
        self.applyMembers = members
        self:RefreshApplyMembers()

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
        self.memberListBlock.gameObject:SetActive(true)
        self.applyMemberListBlock.gameObject:SetActive(false)
    else
        self.memberListBlock.gameObject:SetActive(false)
        self.applyMemberListBlock.gameObject:SetActive(true)
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
                memberItem.levelText = memberObj.transform:Find("level"):GetComponent("Text")
                memberItem.offlineText = memberObj.transform:Find("offlineTime"):GetComponent("Text")
                memberItem.onlineObj = memberObj.transform:Find("online").gameObject
                memberItem.powerText = memberObj.transform:Find("power/label"):GetComponent("Text")
                memberItem.contriText = memberObj.transform:Find("contri/label"):GetComponent("Text")
                memberItem.contriTotalText = memberObj.transform:Find("contriTotal/label"):GetComponent("Text")
                memberItem.statusText = memberObj.transform:Find("status"):GetComponent("Text")
                memberItem.detailBtn = memberObj.transform:Find("detailBtn").gameObject

                table.insert(self.memberItemCache, memberItem)
            end

            memberItem.data = member
            memberItem.nameText.text = member.Name
            memberItem.levelText.text = "LV." .. member.Level
            if member.OffLineTime <= 0 then
                memberItem.onlineObj:SetActive(true)
                memberItem.offlineText.gameObject:SetActive(false)
            else
                memberItem.onlineObj:SetActive(false)
                memberItem.offlineText.text = member.OffLineTime .. "分钟前在线"
            end
            memberItem.powerText.text = member.Power
            memberItem.contriText.text = member.ContriToday
            memberItem.contriTotalText.text = member.ContriTotal
            if member.ContriToday <= 0 then
                memberItem.statusText.text = "今天还未捐献"
            else
                memberItem.statusText.text = "今日捐献" .. member.ContriToday
            end
        end

        for i=#self.members+1 ,#self.memberItemCache,1 do
            memberItem = self.memberItemCache[i]
            memberItem.obj:SetActive(false)
        end
    end
end

function _M:RefreshApplyMembers()
    if self.applyMembers then
        for i,member in pairs(self.applyMembers) do
            local memberItem = {}

            if i <= #self.applyMemberItemCache then
                memberItem = self.applyMemberItemCache[i]
            else
                local memberObj = newObject(self.applyMemberListBlock.memberItem)
                memberObj.transform:SetParent(self.applyMemberListBlock.memberList.content, false)
                memberObj.transform.localScale = Vector3(1,1,1)
                memberObj:SetActive(true)
    
                memberItem.obj = memberObj
                memberItem.nameText = memberObj.transform:Find("name"):GetComponent("Text")
                memberItem.levelText = memberObj.transform:Find("level"):GetComponent("Text")
                memberItem.powerText = memberObj.transform:Find("power/label"):GetComponent("Text")
                memberItem.agreeBtn = memberObj.transform:Find("agreeBtn"):GetComponent("Button")
                memberItem.adjustBtn = memberObj.transform:Find("adjustBtn"):GetComponent("Button")

                table.insert(self.applyMemberItemCache, memberItem)
            end

            memberItem.data = member
            memberItem.nameText.text = member.Name
            memberItem.levelText.text = "LV." .. member.Level
            memberItem.powerText.text = member.Power

            memberItem.agreeBtn.onClick:AddListener(function ()
                self:OnAgreeClick(member)
            end)
            memberItem.adjustBtn.onClick:AddListener(function ()
                self:OnRejectClick(member)
            end)
        end

        for i=#self.applyMembers+1 ,#self.applyMemberItemCache,1 do
            memberItem = self.applyMemberItemCache[i]
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

function _M:InitApplyMemberListBlock(trans, path)
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

function _M:OnAgreeClick(mem)
    self.iCtrl:GroupAgree(self.group.GroupId, mem.UserId, function ()
        self.iCtrl:GroupMembers(self.group.GroupId, function (members)
            self.members = members
            self:RefreshMembers()
        end)
        self.iCtrl:GroupApplyMembers(self.group.GroupId, function (members)
            self.applyMembers = members
            self:RefreshApplyMembers()
    
        end)
    end)
end

function _M:OnRejectClick(mem)
    self.iCtrl:GroupAgree(self.group.GroupId, mem.UserId, function ()
        self.iCtrl:GroupMembers(self.group.GroupId, function (members)
            self.members = members
            self:RefreshMembers()
        end)
        self.iCtrl:GroupApplyMembers(self.group.GroupId, function (members)
            self.applyMembers = members
            self:RefreshApplyMembers()
    
        end)
    end)
end

function _M:OnDestroy()

end

return _M