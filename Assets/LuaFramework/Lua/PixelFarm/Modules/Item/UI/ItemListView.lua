
local _M = class(ViewBase)

function _M:OnCreate()
    print("ItemListView oncreate  ~~~~~~~")

    self.ItemItemCache = {}

    self.backObj = self.transform:Find("backBtn").gameObject
    self.backObj:SetOnClick(function ()
        self:OnBackClick()
    end)

    -- self.topBlock = self:InitTopBlock(self.transform, "top")
    -- self.heroListBlock = self:InitHeroListBlock(self.transform, "content/heroList")
    -- self.chipListBlock = self:InitChipListBlock(self.transform, "content/chipList")
    -- self.tabBlock = self:InitTabBlock(self.transform, "content/tabs")

    -- self:InitData()
end

function _M:InitData()
    if #self.menuBlock.menus > 0 then
        self:OnMenuClick(self.menuBlock.menus[1])
    end
end

function _M:InitMenuBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.menus = {}
    block.menus[1] = self:InitOneMenuBlock(transform, "Viewport/Content/info")
    block.menus[2] = self:InitOneMenuBlock(transform, "Viewport/Content/upgrade")

    for i,menu in pairs(block.menus) do 
        menu.id = i
        if i == 1 then
            menu.target = self.infoBlock
        elseif i == 2 then
            menu.target = self.upgradeBlock
        end
        menu.gameObject:SetOnClick(function ()
            self:OnMenuClick(menu)
        end)
    end

    return block
end

function _M:InitOneMenuBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.gameObject = transform.gameObject
    block.selectObj = transform:Find("select").gameObject
    block.nameText = transform:Find("label"):GetComponent("Text")

    return block
end

function _M:InitInfoBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.gameObject = transform.gameObject

    return block
end

function _M:InitUpgradeBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.gameObject = transform.gameObject

    return block
end

function _M:OnMenuClick(m)
    for i,menu in pairs(self.menuBlock.menus) do 
        if menu.id == m.id then
            menu.selectObj:SetActive(true)
            menu.nameText.color = Color(251/255, 183/255, 6/255, 1)
            menu.target.gameObject:SetActive(true)
        else
            menu.selectObj:SetActive(false)
            menu.nameText.color = Color(128/255, 128/255, 128/255, 1)
            menu.target.gameObject:SetActive(false)
        end
    end
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M