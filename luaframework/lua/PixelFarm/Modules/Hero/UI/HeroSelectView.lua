
local _M = class(ViewBase)

function _M:OnCreate()
    print("HeroSelectView oncreate  ~~~~~~~")
    self.heroItemCache = {}

    self.bgObj = self.transform:Find("bg").gameObject
    self.bgObj:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.heroListBlock = self:InitHeroListBlock(self.transform, "content/heros")

    self:InitData()
end

function _M:InitData()
    self.iCtrl:AllOwnHeros(function (heros)
        local unSelectHeros = {}
        for i,hero in pairs(heros) do
            if hero.Pos == 0 then
                table.insert(unSelectHeros, hero)
            end
        end

        self:UpdateHeroList(unSelectHeros)
    end)
end

function _M:InitHeroListBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.heroItem = transform:Find("item").gameObject
    block.heroList = transform:GetComponent("ScrollRect")

    return block
end

function _M:UpdateHeroList(heros)
    if heros then
        for i,hero in pairs(heros) do
            local heroItem = {}

            local heroObj = newObject(self.heroListBlock.heroItem)
            heroObj.transform:SetParent(self.heroListBlock.heroList.content, false)
            heroObj.transform.localScale = Vector3(1,1,1)
            heroObj:SetActive(true)

            heroItem.nameText = heroObj.transform:Find("bg/name"):GetComponent("Text")
            heroItem.selectBtn = heroObj.transform:Find("bg/selectBtn").gameObject

            heroItem.data = hero
            heroItem.nameText.text = hero.Name
            heroItem.selectBtn:SetOnClick(function ()
                self:SelectHero(heroItem)
            end)

            table.insert(self.heroItemCache, heroItem)
        end
    end
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:SelectHero(item)
    self.iCtrl:SelectHero(item)
end

function _M:OnDestroy()

end

return _M