
local _M = class(ViewBase)

function _M:OnCreate()
    print("_MainView oncreate  ~~~~~~~")

    self.playerBlock = self:InitPlayerBlock(self.transform, "bg/top/player")
    self.powerBlock = self:InitPowerBlock(self.transform, "bg/top/power")
    self.coinBlock = self:InitCoinBlock(self.transform, "bg/top/coin")
    self.diamondBlock = self:InitDiamondBlock(self.transform, "bg/top/diamond")
    self.bagMenuBlock = self:InitBagMenuBlock(self.transform, "bg/bagMenu")

    self:InitBtns()
    self:InitData()
end

function _M:InitData()
    self.iCtrl:CurrentPlayer(function (player)
        if player then
            print(playerStr(player))
            self:UpdatePlayerUI(player)
        end
    end)
end

function _M:InitPlayerBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.headImage = transform:Find("head"):GetComponent("Image")
    block.nameText = transform:Find("name"):GetComponent("Text")
    block.powerText = transform:Find("power"):GetComponent("Text")
    block.lvText = transform:Find("level"):GetComponent("Text")
    block.expFontImage = transform:Find("exp/font"):GetComponent("Image")
    block.expPercentText = transform:Find("exp/percent"):GetComponent("Text")
    return block
end

function _M:InitBtns()
    self.tavernBtn = self.transform:Find("bg/center/tavernBtn").gameObject
    self.battleArrBtn = self.transform:Find("bg/bottom/battleArrBtn").gameObject
    self.heroBtn = self.transform:Find("bg/bottom/heroBtn").gameObject
    self.bagBtn = self.transform:Find("bg/bottom/bagBtn").gameObject
    self.groupBtn = self.transform:Find("bg/bottom/groupBtn").gameObject
    self.challengeBtn = self.transform:Find("bg/bottom/challengeBtn").gameObject
    self.chapterBtn = self.transform:Find("bg/bottom/chapterBtn").gameObject

    self.tavernBtn:SetOnClick(function ()
        self:OnTavernClick()
    end)
    self.battleArrBtn:SetOnClick(function ()
        self:OnBattleArrClick()
    end)
    self.heroBtn:SetOnClick(function ()
        self:OnHeroClick()
    end)
    self.bagBtn:SetOnClick(function ()
        self:OnBagClick()
    end)
    self.groupBtn:SetOnClick(function ()
        self:OnGroupClick()
    end)
    self.challengeBtn:SetOnClick(function ()
        self:OnChallengeClick()
    end)
    self.chapterBtn:SetOnClick(function ()
        self:OnChapterClick()
    end)
end

function _M:InitBagMenuBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.itemBtn = transform:Find("menu/item").gameObject
    block.equipBtn = transform:Find("menu/equip").gameObject

    block.gameObject:SetOnClick(function ()
        block.gameObject:SetActive(false)
    end)
    
    block.itemBtn:SetOnClick(function ()
        self:OnItemClick()
    end)

    block.equipBtn:SetOnClick(function ()
        self:OnEquipClick()
    end)

    return block
end

function _M:InitCoinBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.coinText = transform:Find("label"):GetComponent("Text")
    return block
end

function _M:InitPowerBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.powerText = transform:Find("label"):GetComponent("Text")
    return block
end

function _M:InitDiamondBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.diamondText = transform:Find("label"):GetComponent("Text")
    return block
end

function _M:UpdatePlayerUI(player)
    self.playerBlock.nameText.text = player.Name
    self.playerBlock.lvText.text = player.BaseInfo.Level .. "级"
    self.playerBlock.powerText.text = "战力 " .. 100

    local expPercent = player.BaseInfo.Exp / player.BaseInfo.LevelUpExp
    self.playerBlock.expFontImage.fillAmount = expPercent
    self.playerBlock.expPercentText.text = string.format("%.2f", expPercent * 100) .. "%"

    self.powerBlock.powerText.text = "体力 "..player.BaseInfo.Power
    self.coinBlock.coinText.text = "金币 "..player.BaseInfo.Gold
    self.diamondBlock.diamondText.text = "钻石 "..player.BaseInfo.Diamond
end

function _M:OnTavernClick()
    print("OnTavernClick click")
    self.iCtrl:ShowTavern()
end

function _M:OnBattleArrClick()
    print("OnBattleArrClick click")
    self.iCtrl:ShowBattleArr()
end

function _M:OnHeroClick()
    print("OnHeroClick click")
    self.iCtrl:ShowHeroList()
end

function _M:OnGroupClick()
    print("OnGroupClick click")
    self.iCtrl:ShowGroup()
end

function _M:OnBagClick()
    print("OnBagClick click")
    self.bagMenuBlock.gameObject:SetActive(true)
end

function _M:OnItemClick()
    print("OnItemClick click")
end

function _M:OnEquipClick()
    print("OnEquipClick click")
    self.iCtrl:ShowEquipList()
end

function _M:OnChallengeClick()
    print("OnChallengeClick click")
    self.iCtrl:ShowChallenge()
end

function _M:OnChapterClick()
    print("OnChapterClick click")
    self.iCtrl:ShowChapter()
end

function _M:OnDestroy()
    
end

return _M