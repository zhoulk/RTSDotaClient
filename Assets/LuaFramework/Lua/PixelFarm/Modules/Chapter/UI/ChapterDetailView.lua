
local _M = class(ViewBase)

function _M:OnCreate()
    print("ChapterDetailView oncreate  ~~~~~~~")
    self.chapter = self.args[1]

    self.guanKaCache = {}
    self.itemCache = {}

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.guanKaBlock = self:InitGuanKaBlock(self.transform, "guanKas")
    self.detailBlock = self:InitDetailBlock(self.transform, "detail")
    self.starsBlock = self:InitStarsBlock(self.transform, "stars")

    self:InitData()
end

function _M:InitData()
   self.iCtrl:AllGuanKas(self.chapter.Id, function (guanKas)
       self:UpdateGuanKaList(guanKas)
   end)

   self:UpdateStars()

   self.iCtrl:ListenGuanKaUpdate(function (gks)
       for _, item in pairs(self.guanKaCache) do
            for _, gk in pairs(gks) do
                if item.data ~= nil and item.data.Id == gk.Id then
                    self:UpdateGuanKaItem(item, gk)
                end
            end
       end

       for _, gk in pairs(gks) do
            if self.detailBlock.data ~= nil and self.detailBlock.data.Id == gk.Id then
                self:UpdateGuanKaDetail(gk)
            end
        end
   end)

   self.iCtrl:ListenChapterUpdate(function (chapter)
       if chapter then
        self.chapter = chapter
        self:UpdateStars()
       end
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

function _M:InitStarsBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.progressFontImage = transform:Find("progress/font"):GetComponent("Image")
    block.gift1Obj = transform:Find("gift1").gameObject
    block.gift1Image = transform:Find("gift1"):GetComponent("Image")
    block.gift1Text = transform:Find("gift1/label"):GetComponent("Text")
    block.gift2Obj = transform:Find("gift2").gameObject
    block.gift2Image = transform:Find("gift2"):GetComponent("Image")
    block.gift2Text = transform:Find("gift2/label"):GetComponent("Text")
    block.gift3Obj = transform:Find("gift3").gameObject
    block.gift3Image = transform:Find("gift3"):GetComponent("Image")
    block.gift3Text = transform:Find("gift3/label"):GetComponent("Text")
    block.totalText = transform:Find("total"):GetComponent("Text")

    return block
end

function _M:UpdateGuanKaList(guanKas)
    if guanKas then
        for i,gk in pairs(guanKas) do
            local item = {}
            if i <= #self.guanKaCache then
                item = self.guanKaCache[i]
            else
                local gkObj = newObject(self.guanKaBlock.guanKaItem)
                gkObj.transform:SetParent(self.guanKaBlock.guanKaList.content, false)
                gkObj.transform.localScale = Vector3(1,1,1)

                item.obj = gkObj
                item.nameText = gkObj.transform:Find("bg/name"):GetComponent("Text")
                item.starText = gkObj.transform:Find("bg/star"):GetComponent("Text")
                item.statusText = gkObj.transform:Find("bg/status"):GetComponent("Text")
                item.btn = gkObj.transform:GetComponent("Button")
                table.insert(self.guanKaCache, item)
            end

            self:UpdateGuanKaItem(item, gk)
        end

        for i=#guanKas + 1,#self.guanKaCache,1 do
            local item = self.guanKaCache[i]
            item.obj:SetActive(false)
            item.data = nil
        end
    end
end

function _M:UpdateGuanKaItem(item, gk)
    item.obj:SetActive(true)
    item.nameText.text = gk.Name
    item.starText.text = "星  " .. gk.Star .. "/3"
    item.statusText.text = guanKaStatusStr(gk.Status)
    item.data = gk

    if guanKaCanEnter(gk.Status) then
        item.btn.onClick:AddListener(function ()
            self:OnGuanKaClick(gk)
        end)
    else
        item.btn.onClick:RemoveAllListeners()
    end
end

function _M:UpdateGuanKaDetail(gk)
    self.detailBlock.data = gk
    self.detailBlock.nameText.text = gk.Name
    self.detailBlock.timesText.text = "挑战次数：    " .. gk.Times .. "/" .. gk.TotalTimes
    self.detailBlock.starsText.text = "星  " .. gk.Star .. "/3"
    self.detailBlock.powerText.text = gk.Expend.Power
    self.detailBlock.earnText.text = "金币 " .. gk.Earn.Gold .. "   经验  " .. gk.Earn.PlayerExp

    self.iCtrl:FindItems(gk.Earn.ItemIds, function (items)
        for i, itemItem in pairs(items) do
            print("UpdateGuanKaDetail    " .. tabStr(itemItem))
            local item = {}
            if i <= #self.itemCache then
                item = self.itemCache[i]
            else
                local itemObj = newObject(self.detailBlock.items.item)
                itemObj.transform:SetParent(self.detailBlock.items.list.transform, false)
                itemObj.transform.localScale = Vector3(1,1,1)
                item.obj = itemObj
                item.nameText = itemObj.transform:Find("label"):GetComponent("Text")
                table.insert(self.itemCache, item)
            end
            
            item.obj:SetActive(true)
            item.nameText.text = itemItem.Name
        end

        for i=#gk.Earn.ItemIds + 1,#self.itemCache,1 do
            local item = self.itemCache[i]
            item.obj:SetActive(false)
        end
    end)
end

function _M:UpdateStars()
    self.starsBlock.progressFontImage.fillAmount = self.chapter.Star / (self.chapter.GuanKaNum * 3)
    self.starsBlock.totalText.text = "星 " .. self.chapter.Star .. "/" .. (self.chapter.GuanKaNum * 3)
    self.starsBlock.gift1Text.text = self.chapter.GuanKaNum .. "星"
    self.starsBlock.gift2Text.text = self.chapter.GuanKaNum*2 .. "星"
    self.starsBlock.gift3Text.text = self.chapter.GuanKaNum*3 .. "星"
    if self.chapter.Star >= self.chapter.GuanKaNum then
        self.starsBlock.gift1Image.color = Color(1, 1, 1, 1)
        self.starsBlock.gift1Obj:SetOnClick(function ()
            
        end)
    else
        self.starsBlock.gift1Image.color = Color(0.5, 0.5, 0.5, 1)
    end
    if self.chapter.Star >= self.chapter.GuanKaNum*2 then
        self.starsBlock.gift2Image.color = Color(1, 1, 1, 1)
        self.starsBlock.gift2Obj:SetOnClick(function ()
            
        end)
    else
        self.starsBlock.gift2Image.color = Color(0.5, 0.5, 0.5, 1)
    end
    if self.chapter.Star >= self.chapter.GuanKaNum*3 then
        self.starsBlock.gift3Image.color = Color(1, 1, 1, 1)
        self.starsBlock.gift3Obj:SetOnClick(function ()
            
        end)
    else
        self.starsBlock.gift3Image.color = Color(0.5, 0.5, 0.5, 1)
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
    self.iCtrl:RemoveGuanKaListen()
    self.iCtrl:RemoveChapterListen()
end

return _M