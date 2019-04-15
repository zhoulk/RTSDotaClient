
local _M = class(ViewBase)

function _M:OnCreate()
    print("_TavernView oncreate  ~~~~~~~")

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.tavernBlock = self:InitTavernBlock(self.transform, "groups")

    self:InitData()
end

function _M:InitData()
    self.iCtrl:HeroLottery(function (lottery)
        self.tavernBlock.strength.timesText.text = "免费招募(" .. lottery.FreeGoodLottery .. "/" .. lottery.MaxFreeGoodLottery .. ")"
        self.tavernBlock.agility.timesText.text = "免费招募(" .. lottery.FreeBetterLottery .. "/" .. lottery.MaxFreeBetterLottery .. ")"
    end)
end

function _M:InitTavernBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    
    block.strength = self:InitGroup(transform, "strength", 1)
    block.agility = self:InitGroup(transform, "agility", 2)
    block.inteligent = self:InitGroup(transform, "inteligent", 3)

    return block
end

function _M:InitGroup(trans, path, level)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    
    block.timesText = transform:Find("times"):GetComponent("Text")
    block.jinWeiBtn = transform:Find("jinWeiBtn").gameObject
    block.tianZaiBtn = transform:Find("tianZaiBtn").gameObject

    block.jinWeiBtn:SetOnClick(function ()
        self:OnJinWeiClick(level)
    end)

    block.tianZaiBtn:SetOnClick(function ()
        self:OnTianZaiClick(level)
    end)

    return block
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnJinWeiClick(level)
    self.iCtrl:ShowTavernDetail(1, level)
end

function _M:OnTianZaiClick(level)
    self.iCtrl:ShowTavernDetail(2, level)
end

function _M:OnDestroy()
    
end

return _M