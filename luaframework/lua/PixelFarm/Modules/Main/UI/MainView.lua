
local _M = class(ViewBase)

function _M:OnCreate()
    print("_MainView oncreate  ~~~~~~~")

    self.playerBlock = self:InitPlayerBlock(self.transform, "bg/player")
    self.powerBlock = self:InitPowerBlock(self.transform, "bg/power")
    self.coinBlock = self:InitCoinBlock(self.transform, "bg/coin")
    self.diamondBlock = self:InitDiamondBlock(self.transform, "bg/diamond")

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
    self.tavernBtn = self.transform:Find("bg/tavernBtn").gameObject
    self.battleArrBtn = self.transform:Find("bg/battleArrBtn").gameObject
    self.heroBtn = self.transform:Find("bg/heroBtn").gameObject
    self.bagBtn = self.transform:Find("bg/bagBtn").gameObject
    self.groupBtn = self.transform:Find("bg/groupBtn").gameObject
    self.chapterBtn = self.transform:Find("bg/chapterBtn").gameObject

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
    self.chapterBtn:SetOnClick(function ()
        self:OnChapterClick()
    end)
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
    self.playerBlock.expPercentText.text = string.format("%.2f", expPercent) .. "%"

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
end

function _M:OnGroupClick()
    print("OnGroupClick click")
    self.iCtrl:ShowGroup()
end

function _M:OnBagClick()
    print("OnBagClick click")
end

function _M:OnChapterClick()
    print("OnChapterClick click")
    self.iCtrl:ShowChapter()
end

function _M:OnDestroy()
    
end

return _M