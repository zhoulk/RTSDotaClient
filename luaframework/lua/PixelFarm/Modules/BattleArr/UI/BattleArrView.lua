
local _M = class(ViewBase)

function _M:OnCreate()
    print("BattleArrView oncreate  ~~~~~~~")
    self.posItemCache = {}

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.posListBlock = self:InitPosListBlock(self.transform, "posList")
    self.heroBlock = self:InitHeroBlock(self.transform, "hero")

    self:InitData()
end

function _M:InitData()
    self.iCtrl:AllOwnHeros(function (heros)
        local selectHeros = {}
        for i,hero in pairs(heros) do
            if hero.Pos > 0 then
                table.insert(selectHeros, hero)
            end
        end

        self:UpdatePosList(selectHeros)
        if #self.posItemCache == 0 then
            self:UpdateHero()
        else
            self:SelectPos(1)
        end
    end)
end

function _M:InitPosListBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.posItem = transform:Find("item").gameObject
    block.posList = transform:GetComponent("ScrollRect")

    for i=1,5,1 do
        local posItem = {}

        local posObj = newObject(block.posItem)
        posObj.transform:SetParent(block.posList.content, false)
        posObj.transform.localScale = Vector3(1,1,1)
        posObj:SetActive(true)

        posItem.nameText = posObj.transform:Find("head/label"):GetComponent("Text")
        posItem.selectObj = posObj.transform:Find("select").gameObject
        posItem.selectObj:SetActive(false)

        posObj:SetOnClick(function ()
            self:SelectPos(i)
        end)

        table.insert(self.posItemCache, posItem)
    end

    return block
end

function _M:InitHeroBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.roleObj = transform:Find("role").gameObject
    block.roleImage = transform:Find("role"):GetComponent("Image")
    block.roleTipObj = transform:Find("role/label").gameObject
    block.nameText = transform:Find("name"):GetComponent("Text")

    return block
end

function _M:UpdatePosList(heros)
    if heros then
        table.sort(heros, function (a, b)
            return a.Pos < b.Pos
        end)

        for i,hero in pairs(heros) do
            local posItem = self.posItemCache[hero.Pos]
            posItem.data = hero
            posItem.nameText.text = hero.Name
        end
    end
end

function _M:UpdateHero(hero)
    if hero then
        self.heroBlock.nameText.text = hero.Name
        self.heroBlock.roleTipObj:SetActive(false)
        self.heroBlock.roleObj:SetOnClick(function ()
            
        end)
    else
        self.heroBlock.roleTipObj:SetActive(true)
        self.heroBlock.roleObj:SetOnClick(function ()
            self.iCtrl:ShowHeroSelect()
        end)
    end
end

function _M:SelectPos(pos)
    print("select Pos " .. pos)
    for i, posItem in pairs(self.posItemCache) do
        if i == pos then
            posItem.selectObj:SetActive(true)
            self:UpdateHero(posItem.data)
        else
            posItem.selectObj:SetActive(false)
        end
    end
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M