
local _M = class(ViewBase)

function _M:OnCreate()
    print("HeroListView oncreate  ~~~~~~~")
    self.heroItemCache = {}

    self.backObj = self.transform:Find("backBtn").gameObject
    self.backObj:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.topBlock = self:InitTopBlock(self.transform, "top")
    self.heroListBlock = self:InitHeroListBlock(self.transform, "content/heroList")
    self.chipListBlock = self:InitChipListBlock(self.transform, "content/chipList")
    self.tabBlock = self:InitTabBlock(self.transform, "content/tabs")

    self:InitData()
end

function _M:InitData()
    self.iCtrl:AllOwnHeros(function (heros)
        self:UpdateHeroList(heros)

        self:OnClickTab(1)
    end)
    self.iCtrl:CurrentPlayer(function (player)
        if player then
            print(playerStr(player))
            self:UpdateTopUI(player)
        end
    end)
end

function _M:OnClickTab(index)
    for i,tab in pairs(self.tabBlock.tabs) do
        if i==index then
            tab.selectObj:SetActive(true)
        else
            tab.selectObj:SetActive(false)
        end
    end

    if index == 1 then
        self.heroListBlock.gameObject:SetActive(true)
        self.chipListBlock.gameObject:SetActive(false)
    else
        self.heroListBlock.gameObject:SetActive(false)
        self.chipListBlock.gameObject:SetActive(true)
    end
end

function _M:InitTopBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.powerText = transform:Find("power/label"):GetComponent("Text")
    block.goldText = transform:Find("coin/label"):GetComponent("Text")
    block.diamondText = transform:Find("diamond/label"):GetComponent("Text")

    return block
end

function _M:InitHeroListBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.heroItem = transform:Find("item").gameObject
    block.heroList = transform:GetComponent("ScrollRect")
    block.totalText = transform:Find("total/num/label"):GetComponent("Text")

    return block
end

function _M:InitChipListBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.chipItem = transform:Find("item").gameObject
    block.chipList = transform:GetComponent("ScrollRect")

    return block
end

function _M:InitTabBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.tabs = {}
    table.insert(block.tabs, self:InitTab(transform, "hero", 1))
    table.insert(block.tabs, self:InitTab(transform, "chip", 2))

    return block
end

function _M:InitTab(trans, path, index)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.selectObj = transform:Find("select").gameObject

    block.gameObject:SetOnClick(function ()
        self:OnClickTab(index)
    end)

    return block
end

function _M:UpdateTopUI(player)
    self.topBlock.powerText.text = "体力 "..player.BaseInfo.Power
    self.topBlock.goldText.text = "金币 "..player.BaseInfo.Gold
    self.topBlock.diamondText.text = "钻石 "..player.BaseInfo.Diamond
end

function _M:UpdateHeroList(heros)
    if heros then
        for i,hero in pairs(heros) do
            local heroItem
            if i <= #self.heroItemCache then
                heroItem = self.heroItemCache[i]
            else
                heroItem = {}
                local heroObj = newObject(self.heroListBlock.heroItem)
                heroObj.transform:SetParent(self.heroListBlock.heroList.content, false)
                heroObj.transform.localScale = Vector3(1,1,1)
    
                heroItem.obj = heroObj
                heroItem.levelText = heroObj.transform:Find("level"):GetComponent("Text")
                heroItem.typeText = heroObj.transform:Find("type"):GetComponent("Text")
                heroItem.nameText = heroObj.transform:Find("name"):GetComponent("Text")
                heroItem.statusObj = heroObj.transform:Find("status").gameObject
                heroItem.statusText = heroObj.transform:Find("status/label"):GetComponent("Text")

                heroItem.btn = heroObj.transform:GetComponent("Button")

                table.insert(self.heroItemCache, heroItem)
            end

            heroItem.obj:SetActive(true)
            heroItem.data = hero
            heroItem.nameText.text = hero.Name
            heroItem.typeText.text = heroTypeStr(hero.Type)
            heroItem.levelText.text = "LV." .. hero.Level
            if hero.Pos ~= 0 then
                heroItem.statusText.text = "已上阵"
                heroItem.statusObj:SetActive(true)
            else
                heroItem.statusObj:SetActive(false)
            end
            heroItem.statusText.text = hero.Po
            heroItem.btn.onClick:AddListener(function ()
                self:SelectHero(heroItem)
            end)
        end
        for i=#heros+1,#self.heroItemCache,1 do
            heroItem = self.heroItemCache[i]
            heroItem.obj:SetActive(false)
        end

        self.heroListBlock.totalText.text = #heros .. "/200"
    end
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:SelectHero(item)
    
end

function _M:OnDestroy()

end

return _M