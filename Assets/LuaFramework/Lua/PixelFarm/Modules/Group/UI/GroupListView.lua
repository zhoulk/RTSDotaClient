local _M = class(ViewBase)

function _M:OnCreate()
    print("GroupListView oncreate  ~~~~~~~")

    self.bgObj = self.transform:Find("bg").gameObject
    self.contentBlock = self:InitContentBlock(self.transform, "content")
    self.createBlock = self:InitCreateBlock(self.transform, "create")

    self.bgObj:SetOnClick(function ()
        self:OnBackClick()
    end)

end

function _M:InitContentBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.createBtn = transform:Find("create").gameObject

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

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M