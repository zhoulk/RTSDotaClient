
local _M = class(ViewBase)

function _M:OnCreate()
    print("SkillView oncreate  ~~~~~~~")
    self.skill = self.args[1]

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.skillBlock = self:InitSkillBlock(self.transform, "center/image")

    self:InitData()
end

function _M:InitData()
    print(skillStr(self.skill))
    if self.skill then
        self.skillBlock.nameText.text = self.skill.Name
        self.skillBlock.descText.text = self.skill.Desc

    end
end

function _M:InitSkillBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.nameText = transform:Find("name"):GetComponent("Text")
    block.heroNameText = transform:Find("heroName"):GetComponent("Text")
    block.descText = transform:Find("desc"):GetComponent("Text")

    return block
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M