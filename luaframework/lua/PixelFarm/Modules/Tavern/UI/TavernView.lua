
local _M = class(ViewBase)

function _M:OnCreate()
    print("_TavernView oncreate  ~~~~~~~")

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.tavernBlock = self:InitTavernBlock(self.transform, "groups")
end

function _M:InitData()
    self.iCtrl:CurrentPlayer(function (player)
        if player then
            print(playerStr(player))
            self:UpdatePlayerUI(player)
        end
    end)
end

function _M:InitTavernBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    
    block.strength = self:InitGroup(transform, "strength")
    block.agility = self:InitGroup(transform, "agility")
    block.inteligent = self:InitGroup(transform, "inteligent")

    return block
end

function _M:InitGroup(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    
    block.timesText = transform:Find("times"):GetComponent("Text")
    block.jinWeiBtn = transform:Find("jinWeiBtn").gameObject
    block.tianZaiBtn = transform:Find("tianZaiBtn").gameObject

    block.jinWeiBtn:SetOnClick(function ()
        self:OnJinWeiClick()
    end)

    block.tianZaiBtn:SetOnClick(function ()
        self:OnTianZaiClick()
    end)

    return block
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnJinWeiClick()
    self.iCtrl:ShowTavernDetail()
end

function _M:OnTianZaiClick()
    self.iCtrl:ShowTavernDetail()
end

function _M:OnDestroy()
    
end

return _M