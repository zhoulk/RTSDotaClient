
local _M = class(ViewBase)

function _M:OnCreate()
    print("_TavernDetailView oncreate  ~~~~~~~")
    self.camp = self.args[1]
    self.level = self.args[2]

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.herosBlock = self:InitHerosBlock(self.transform, "heros")
    self.btnsBlock = self:InitBtnsBlock(self.transform, "btns")
    self.tipsText = self.transform:Find("tips"):GetComponent("Text")

    self.gainBlock = self:InitGainBlock(self.transform, "gain")

    self:InitData()
end

function _M:InitData()
    self.iCtrl:AllHeros(function (heros)
        if heros then
            for i,hero in pairs(heros) do
                print(heroStr(hero))
            end
            self:UpdateHerosUI(heros)
        end
    end)

    self.iCtrl:HeroLottery(function (lottery)
        if self.level == 1 then
            self.tipsText.text = "在抽取" .. lottery.NeedGoodLotteryCnt - lottery.GoodLotteryCnt .. "可获得3星英雄"
            self:UpdateGoodLotteryInfo(lottery)
        elseif self.level == 2 then
            self.tipsText.text = "在抽取" .. lottery.NeedBetterLotteryCnt - lottery.BetterLotteryCnt .. "可获得5星英雄"
            self:UpdateBetterLotteryInfo(lottery)
        end
    end)
end

function _M:UpdateGoodLotteryInfo(lottery)
    if lottery.FreeGoodLottery == 0 then
        self.btnsBlock.oneTipText.text = "金币 10000"
    else
        if lottery.NextGoodLotteryStamp <= os.time() then
            self.btnsBlock.oneTipText.text = "本次免费"
        else
            local seconds = lottery.NextGoodLotteryStamp - os.time()
            local str = ""
            if seconds >= 60 then
                str = str .. seconds/60 .. "分"
            else
                str = str .. seconds .. "秒"
            end
            self.btnsBlock.oneTipText.text =  str .. "后免费"
        end
    end
    self.btnsBlock.moreTipText.text = "9折 金币 9000"
end

function _M:UpdateBetterLotteryInfo(lottery)
    if lottery.FreeBetterLottery == 0 then
        self.btnsBlock.oneTipText.text = "钻石 200"
    else
        if lottery.NextBetterLotteryStamp <= os.time() then
            self.btnsBlock.oneTipText.text = "本次免费"
        else
            local seconds = lottery.NextBetterLotteryStamp - os.time()
            local str = ""

            local t1,t2 = math.modf(seconds/3600)
            str = str .. t1 .. "小时"

            if seconds >= 3600 then
                local t1,t2 = math.modf(seconds/3600)
                str = str .. t1 .. "小时"
                seconds = seconds - seconds/3600 * 3600
            elseif seconds >= 60 then
                str = str .. seconds/60 .. "分"
                seconds = seconds - seconds/60 * 60
            else
                str = str .. seconds .. "秒"
            end
            self.btnsBlock.oneTipText.text =  str .. "后免费"
        end
    end
    self.btnsBlock.moreTipText.text = "9折 钻石 1800"
end

function _M:InitHerosBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    
    block.heroItem = transform:Find("item").gameObject
    block.heroList = transform:GetComponent("ScrollRect")
    return block
end

function _M:InitBtnsBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    
    block.oneBtn = transform:Find("one/buy").gameObject
    block.oneTipText = transform:Find("one/tips"):GetComponent("Text")
    block.moreBtn = transform:Find("more/buy").gameObject
    block.moreTipText = transform:Find("more/tips"):GetComponent("Text")

    block.oneBtn:SetOnClick(function ()
        self:OnOneClick()
    end)
    block.moreBtn:SetOnClick(function ()
        self:OnMoreClick()
    end)

    return block
end

function _M:InitGainBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.typeText = transform:Find("item/type"):GetComponent("Text")
    block.nameText = transform:Find("item/name"):GetComponent("Text")
    block.confirmBtn = transform:Find("confirm").gameObject

    block.confirmBtn:SetOnClick(function ()
        block.gameObject:SetActive(false)
    end)
    
    return block
end

function _M:UpdateHerosUI(heros)
    for i,hero in pairs(heros) do
        local heroObj = newObject(self.herosBlock.heroItem)
        heroObj.transform:SetParent(self.herosBlock.heroList.content, false)
        heroObj.transform.localScale = Vector3(1,1,1)
        heroObj:SetActive(true)

        heroObj.transform:Find("type"):GetComponent("Text").text = self:FormatHeroType(hero)
        heroObj.transform:Find("name"):GetComponent("Text").text = hero.Name
    end
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnOneClick()
    print("OnOneClick click")
    self.iCtrl:RandomHero(self.camp, self.level, function (hero)
        self:ShowGainHero(hero)
    end)
end

function _M:OnMoreClick()
    print("OnMoreClick click")
    self.iCtrl:RandomHero(self.camp, self.level, function (hero)
        self:ShowGainHero(hero)
    end)
end

function _M:ShowGainHero(hero)
    print(heroStr(hero))
    self.gainBlock.typeText.text = self:FormatHeroType(hero)
    self.gainBlock.nameText.text = hero.Name
    self.gainBlock.gameObject:SetActive(true)
end

function _M:FormatHeroType(hero)
    local str = heroTypeStr(hero.Type)
    local strArr = {}
    local len = string.len( str )
    local s = ""
    for i=1,len,3 do
        s = s .. string.sub( str, i, i+2) .. "\n"
    end
    return s
end

function _M:OnDestroy()
    
end

return _M