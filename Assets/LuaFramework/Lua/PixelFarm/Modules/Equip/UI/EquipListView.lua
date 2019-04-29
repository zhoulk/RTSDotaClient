
local _M = class(ViewBase)

function _M:OnCreate()
    print("EquipListView oncreate  ~~~~~~~")

    self.equipItemCache = {}

    self.backObj = self.transform:Find("backBtn").gameObject
    self.backObj:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.topBlock = self:InitTopBlock(self.transform, "top")
    self.equipListBlock = self:InitEquipListBlock(self.transform, "content/equipList")
    self.chipListBlock = self:InitChipListBlock(self.transform, "content/chipList")
    self.tabBlock = self:InitTabBlock(self.transform, "content/tabs")

    self:InitData()
end

function _M:InitData()
    self.iCtrl:AllOwnEquips(function (equips)
        self:UpdateEquipList(equips)
        self:OnClickTab(1)
    end)
    self.iCtrl:CurrentPlayer(function (player)
        if player then
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
        self.equipListBlock.gameObject:SetActive(true)
        self.chipListBlock.gameObject:SetActive(false)
    else
        self.equipListBlock.gameObject:SetActive(false)
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

function _M:InitEquipListBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.equipItem = transform:Find("item").gameObject
    block.equipList = transform:GetComponent("ScrollRect")
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
    table.insert(block.tabs, self:InitTab(transform, "equip", 1))
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

function _M:UpdateEquipList(equips)
    if equips then
        for i,equip in pairs(equips) do
            local equipItem
            if i <= #self.equipItemCache then
                equipItem = self.equipItemCache[i]
            else
                equipItem = {}
                local equipObj = newObject(self.equipListBlock.equipItem)
                equipObj.transform:SetParent(self.equipListBlock.equipList.content, false)
                equipObj.transform.localScale = Vector3(1,1,1)
    
                equipItem.obj = equipObj
                equipItem.levelText = equipObj.transform:Find("level"):GetComponent("Text")
                equipItem.nameText = equipObj.transform:Find("name"):GetComponent("Text")
                equipItem.statusText = equipObj.transform:Find("status"):GetComponent("Text")
                equipItem.attr1Text = equipObj.transform:Find("attr/attr1"):GetComponent("Text")
                equipItem.attr2Text = equipObj.transform:Find("attr/attr2"):GetComponent("Text")

                equipItem.btn = equipObj.transform:GetComponent("Button")

                table.insert(self.equipItemCache, equipItem)
            end

            equipItem.obj:SetActive(true)
            equipItem.data = equip
            equipItem.nameText.text = equip.Name
            -- equipItem.levelText.text = "LV." .. equip.Level
            equipItem.attr1Text.text = equip.Effect
            equipItem.attr2Text.text = ""
            equipItem.statusText.text = ""
            equipItem.btn.onClick:AddListener(function ()
                -- self:SelectHero(equipItem)
            end)
        end

        for i=#equips+1,#self.equipItemCache,1 do
            equipItem = self.equipItemCache[i]
            equipItem.obj:SetActive(false)
        end

        self.equipListBlock.totalText.text = #equips .. "/325"
    end
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M