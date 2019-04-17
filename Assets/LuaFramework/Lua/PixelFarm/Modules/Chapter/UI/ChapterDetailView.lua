
local _M = class(ViewBase)

function _M:OnCreate()
    print("ChapterDetailView oncreate  ~~~~~~~")
    self.chapter = self.args[1]

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.guanKaBlock = self:InitGuanKaBlock(self.transform, "guanKas")
    self.detailBlock = self:InitDetailBlock(self.transform, "detail")

    self:InitData()
end

function _M:InitData()
   self.iCtrl:AllGuanKas(self.chapter.Id, function (guanKas)
       self:UpdateGuanKaList(guanKas)
   end)
end

function _M:InitGuanKaBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.guanKaItem = transform:Find("item").gameObject
    block.guanKaList = transform:GetComponent("ScrollRect")

    return block
end

function _M:InitDetailBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.nameText = transform:Find("content/name"):GetComponent("Text")
    block.timesText = transform:Find("content/times"):GetComponent("Text")
    block.starsText = transform:Find("content/stars"):GetComponent("Text")
    block.powerText = transform:Find("content/power/label"):GetComponent("Text")
    block.earnText = transform:Find("content/earn/label"):GetComponent("Text")
    block.items = self:InitItemsBlock(transform, "content/items")

    block.challengeBtn = transform:Find("content/challenge").gameObject

    block.challengeBtn:SetOnClick(function ()
        self:OnChallengeClick()
    end)
    
    block.gameObject:SetOnClick(function ()
        block.gameObject:SetActive(false)
    end)

    return block
end

function _M:InitItemsBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.item = transform:Find("item").gameObject
    block.list = transform:Find("list").gameObject
    
    return block
end

function _M:UpdateGuanKaList(guanKas)
    if guanKas then
        for i,gk in pairs(guanKas) do
            local gkObj = newObject(self.guanKaBlock.guanKaItem)
            gkObj.transform:SetParent(self.guanKaBlock.guanKaList.content, false)
            gkObj.transform.localScale = Vector3(1,1,1)
            gkObj:SetActive(true)

            gkObj.transform:Find("bg/name"):GetComponent("Text").text = gk.Name
            gkObj.transform:Find("bg/status"):GetComponent("Text").text = gk:StatusStr()

            gkObj.transform:GetComponent("Button").onClick:AddListener(function ()
                self:OnGuanKaClick(gk)
            end)
        end
    end
end

function _M:UpdateGuanKaDetail(gk)
    self.detailBlock.data = gk
    self.detailBlock.nameText.text = gk.Name
    self.detailBlock.timesText.text = "挑战次数：    " .. gk.Times .. "/" .. gk.TotalTimes
    self.detailBlock.starsText.text = "星  " .. gk.Star .. "/3"
    self.detailBlock.powerText.text = gk.Expend.Power
    self.detailBlock.earnText.text = "金币 " .. gk.Earn.Gold .. "   经验  " .. gk.Earn.PlayerExp
    for itemId in pairs(gk.Earn.ItemIds) do
        local itemObj = newObject(self.detailBlock.items.item)
        itemObj.transform:SetParent(self.detailBlock.items.list.transform, false)
        itemObj.transform.localScale = Vector3(1,1,1)
        itemObj:SetActive(true)

        itemObj.transform:Find("label"):GetComponent("Text").text = itemId
    end
end

function _M:OnGuanKaClick(gk)
    self:UpdateGuanKaDetail(gk)
    self.detailBlock.gameObject:SetActive(true)
end

function _M:OnChallengeClick()
    self.iCtrl:ShowBattle(self.detailBlock.data)
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M