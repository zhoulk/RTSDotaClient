local _M = class(ViewBase)

function _M:OnCreate()
    print("GroupView oncreate  ~~~~~~~")
    self.group = self.args[1]

    self.btnsBlock = self:InitBtnsBlock(self.transform, "btns")
    self.infoBlock = self:InitInfoBlock(self.transform, "info")

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self:InitData()
end

function _M:InitData()
    self.infoBlock.nameText.text = self.group.GroupName
    self.infoBlock.levelText.text = "LV." .. self.group.GroupLevel
    self.infoBlock.expFontImage.fillAmount = self.group.ContriCurrent / self.group.ContriLevelUp
    self.infoBlock.expPercentText.text = self.group.ContriCurrent .. "/" .. self.group.ContriLevelUp
end

function _M:InitBtnsBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.memberBtn = transform:Find("members").gameObject

    block.memberBtn:SetOnClick(function ()
        self:OnMemberClick()
    end)

    return block
end

function _M:InitInfoBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.nameText = transform:Find("name"):GetComponent("Text")
    block.levelText = transform:Find("level"):GetComponent("Text")
    block.expFontImage = transform:Find("exp/font"):GetComponent("Image")
    block.expPercentText = transform:Find("exp/label"):GetComponent("Text")

    return block
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnMemberClick()
    self.iCtrl:ShowMember()
end

function _M:OnDestroy()

end

return _M