
local _M = class(ViewBase)

function _M:OnCreate()
    print("SkillView oncreate  ~~~~~~~")
    self.skill = self.args[1]
    self.hero = self.args[2]

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.skillBlock = self:InitSkillBlock(self.transform, "center/image")
    self.infoBlock = self:InitInfoBlock(self.transform, "center/info")

    self:InitData()
end

function _M:InitData()
    if self.skill then
        self.skillBlock.nameText.text = self.skill.Name
        self.skillBlock.descText.text = self.skill.Desc
        self.skillBlock.heroNameText.text = ""
        if self.skill.Level < 1 then
            self.infoBlock.itemText.text = ""
            self.infoBlock.nextItemText.text = self.skill.LevelDesc[1]
        elseif self.skill.Level + 1 > #self.skill.LevelDesc then
            self.infoBlock.itemText.text = self.skill.LevelDesc[#self.skill.LevelDesc]
            self.infoBlock.nextItemText.text = ""
        else
            self.infoBlock.itemText.text = self.skill.LevelDesc[self.skill.Level]
            self.infoBlock.nextItemText.text = self.skill.LevelDesc[self.skill.Level + 1]
        end

        self.infoBlock.expendText.text = "消耗: 技能点(" .. self.hero.SkillPoint .. "/" .. "1)"
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

function _M:InitInfoBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.itemText = transform:Find("item"):GetComponent("Text")
    block.nextItemText = transform:Find("nextItem"):GetComponent("Text")
    block.expendText = transform:Find("expend"):GetComponent("Text")
    block.upgradeBtn = transform:Find("one").gameObject

    block.upgradeBtn:SetOnClick(function ()
        self:OnUpgradeClick()
    end)

    return block
end

function _M:OnUpgradeClick()
    if self.hero.SkillPoint >= 1 then
        self.iCtrl:UpgradeSkill(self.skill.SkillId, function (skill)
            self.hero.SkillPoint = self.hero.SkillPoint - 1
            self.skill = skill
            self:InitData()
        end)
    end
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M