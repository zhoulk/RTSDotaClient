
local _M = class(ViewBase)

function _M:OnCreate()
    print("_TavernView oncreate  ~~~~~~~")

    -- self.playerBlock = self:InitPlayerBlock(self.transform, "bg/player")
    -- self.powerBlock = self:InitPowerBlock(self.transform, "bg/power")
    -- self.coinBlock = self:InitCoinBlock(self.transform, "bg/coin")
    -- self.diamondBlock = self:InitDiamondBlock(self.transform, "bg/diamond")

    -- self:InitBtns()
    -- self:InitData()
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

function _M:OnDestroy()
    
end

return _M