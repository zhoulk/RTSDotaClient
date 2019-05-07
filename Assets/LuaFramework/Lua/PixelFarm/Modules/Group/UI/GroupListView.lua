local _M = class(ViewBase)

function _M:OnCreate()
    print("GroupListView oncreate  ~~~~~~~")

    self.groupListCache = {}

    self.bgObj = self.transform:Find("bg").gameObject
    self.contentBlock = self:InitContentBlock(self.transform, "content")
    self.createBlock = self:InitCreateBlock(self.transform, "create")

    self.bgObj:SetOnClick(function ()
        self:OnBackClick()
    end)

    self:InitData()
end

function _M:InitData()
    self.iCtrl:AllGroups(function (gps)
        self:UpdateGroupList(gps)
    end)
end

function _M:InitContentBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.searchBtn = transform:Find("search").gameObject
    block.createBtn = transform:Find("create").gameObject

    block.groupItem = transform:Find("groupList/item").gameObject
    block.groupList = transform:Find("groupList"):GetComponent("ScrollRect")

    block.createBtn:SetOnClick(function ()
        self:OnCreateClick()
    end)

    return block
end

function _M:InitCreateBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.nameInput = transform:Find("content/nameInput"):GetComponent("InputField")
    block.createBtn = transform:Find("content/create").gameObject

    block.gameObject:SetOnClick(function ()
        block.gameObject:SetActive(false)
    end)

    block.createBtn:SetOnClick(function ()
        self:OnCreateCreateClick()
    end)

    return block
end

function _M:UpdateGroupList(gps)
    if gps then
        for i,gp in pairs(gps) do
            local groupItem = {}

            if i <= #self.groupListCache then
                groupItem = self.groupListCache[i]
            else
                local groupObj = newObject(self.contentBlock.groupItem)
                groupObj.transform:SetParent(self.contentBlock.groupList.content, false)
                groupObj.transform.localScale = Vector3(1,1,1)
                groupObj:SetActive(true)
    
                groupItem.obj = groupObj
                groupItem.nameText = groupObj.transform:Find("name"):GetComponent("Text")
                groupItem.levelText = groupObj.transform:Find("level"):GetComponent("Text")
                groupItem.leaderText = groupObj.transform:Find("leader/label"):GetComponent("Text")
                groupItem.declarationText = groupObj.transform:Find("declaration/label"):GetComponent("Text")
                groupItem.membersText = groupObj.transform:Find("members/label"):GetComponent("Text")
                groupItem.applyBtn = groupObj.transform:Find("Button"):GetComponent("Button")

                table.insert(self.groupListCache, groupItem)
            end

            groupItem.data = gp
            groupItem.nameText.text = gp.GroupName
            groupItem.levelText.text = "LV." .. gp.GroupLevel
            groupItem.leaderText.text = gp.GroupLeader
            groupItem.declarationText.text = gp.GroupDeclaration
            groupItem.membersText.text = gp.MemberCnt .. "/" .. gp.MemberTotal

            groupItem.applyBtn.onClick:AddListener(function ()
                self:OnApplyClick(gp)
            end)
            
        end

        for i=#gps+1 ,#self.groupListCache,1 do
            groupItem = self.groupListCache[i]
            groupItem.obj:SetActive(false)
        end
    end
end

function _M:OnCreateClick()
    self.createBlock.gameObject:SetActive(true)
end

function _M:OnCreateCreateClick()
    if #self.createBlock.nameInput.text == 0 then
        toast("请输入军团名称")
    else
        self.iCtrl:CreateGroup(self.createBlock.nameInput.text)
    end
end

function _M:OnApplyClick(gp)
    print("OnApplyClick" .. gp.GroupId)
    self.iCtrl:ApplyGroup(gp.GroupId)
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M