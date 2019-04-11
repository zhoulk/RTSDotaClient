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

    block.gameObject:SetOnClick(function ()
        block.gameObject:SetActive(false)
    end)

    return block
end

function _M:OnCreateClick()
    self.createBlock.gameObject:SetActive(true)
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M