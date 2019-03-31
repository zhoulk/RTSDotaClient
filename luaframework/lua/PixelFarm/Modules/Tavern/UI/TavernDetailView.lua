
local _M = class(ViewBase)

function _M:OnCreate()
    print("_TavernDetailView oncreate  ~~~~~~~")

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.herosBlock = self:InitHerosBlock(self.transform, "heros")
    self.btnsBlock = self:InitBtnsBlock(self.transform, "btns")

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
    block.moreBtn = transform:Find("more/buy").gameObject

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
    self.iCtrl:RandomHero(function (hero)
        self:ShowGainHero(hero)
    end)
end

function _M:OnMoreClick()
    print("OnMoreClick click")
    self.iCtrl:RandomHero(function (hero)
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