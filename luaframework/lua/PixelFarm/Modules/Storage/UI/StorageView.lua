require "PixelFarm.Modules.Storage.Data.Goods"

local _M = class(ViewBase)

function _M:Init()
    self.menuItemCache = {}
    self.goodsItemCache = {}
    self.goodsData = {}

    self.menuNormalColor = Color(0.7, 0.7, 0.7, 1)
    self.menuSelectedColor = Color(1,1,1,1)
end

function _M:OnCreate()
    print("StorageView oncreate  ~~~~~~~")
    self:Init()

    self.topBlock = self:InitTopBlock(self.transform, "content/top")
    self.menuBlock = self:InitMenuBlock(self.transform, "content/menuList")
    self.goodsBlock = self:InitGoodsBlock(self.transform, "content/storage")
    self.bottomBlock = self:InitBottomBlock(self.transform, "content/bottom")

    self:InitData()
    self:SelectMenu(self.menuItemCache[1])
end

function _M:InitData()
    self:InitMenuData()
    self:InitGoodsData()
end

function _M:InitMenuData()
    local menuData = {
        {title = "全部", type = GoodsType.None},
        {title = "植物", type = GoodsType.Plant}, 
        {title = "动物", type = GoodsType.Animal}, 
        {title = "海岛", type = GoodsType.Jetty}, 
        {title = "建筑", type = GoodsType.Building}, 
        {title = "金属", type = GoodsType.Material}
    }
    for i,v in ipairs(menuData) do
        local menuObj = newObject(self.menuBlock.menuItem)
        menuObj.transform:SetParent(self.menuBlock.menuList.content, false)
        menuObj.transform.localPosition = Vector3.zero
        menuObj.transform.localScale = Vector3.one
        menuObj:SetActive(true)

        local bgImage = menuObj.transform:Find("bg"):GetComponent("Image")
        local nameText = menuObj.transform:Find("text"):GetComponent("Text")

        nameText.text = v.title

        local menuItem = {}
        menuItem.id = i
        menuItem.obj = menuObj
        menuItem.bgImage = bgImage
        menuItem.data = v
        self.menuItemCache[i] = menuItem

        menuObj:SetOnClick(function ()
            self:SelectMenu(menuItem)
        end)
    end
end

function _M:InitGoodsData()
    self.goodsData = self.iCtrl:GetGoodsList()

    local currentVolume = 0
    for i,goods in ipairs(self.goodsData) do
        local goodsObj = newObject(self.goodsBlock.goodsItem)
        goodsObj.transform:SetParent(self.goodsBlock.goodsList.content, false)
        goodsObj.transform.localPosition = Vector3.zero
        goodsObj.transform.localScale = Vector3.one
        goodsObj:SetActive(true)

        local bgImage = goodsObj.transform:Find("bg"):GetComponent("Image")
        local nameText = goodsObj.transform:Find("bg/name"):GetComponent("Text")
        local numText = goodsObj.transform:Find("bg/num"):GetComponent("Text")

        nameText.text = goods.name
        numText.text = goods.num

        currentVolume = currentVolume + goods.num

        local goodsItem = {}
        goodsItem.id = i
        goodsItem.obj = goodsObj
        goodsItem.nameText = nameText
        goodsItem.numText = numText
        goodsItem.data = goods
        self.goodsItemCache[i] = goodsItem

        goodsObj:SetOnClick(function ()
            self:OnGoodsClick(goodsItem)
        end)
    end

    self.bottomBlock.volumeText.text = currentVolume .. "/" .. "500"
end

function _M:InitTopBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.backBtn = transform:Find("backBtn").gameObject

    block.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    return block
end

function _M:InitMenuBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.menuList = transform:GetComponent("ScrollRect")
    block.menuItem = transform:Find("item").gameObject

    return block
end

function _M:InitGoodsBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.goodsList = transform:GetComponent("ScrollRect")
    block.goodsItem = transform:Find("item").gameObject

    local itemDetail = self:InitItemDetail(transform, "itemDetail")
    block.itemDetail = itemDetail

    block.goodsList.gameObject:SetOnClick(function ()
        block.itemDetail.obj:SetActive(false)
    end)

    return block
end

function _M:InitItemDetail(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.obj = transform.gameObject
    block.titleText = transform:Find("title/text"):GetComponent("Text")
    block.descText = transform:Find("desc"):GetComponent("Text")
    block.icon = transform:Find("center/Image"):GetComponent("Image")
    block.minusBtn = transform:Find("center/minus").gameObject
    block.plusBtn = transform:Find("center/plus").gameObject
    block.numText = transform:Find("center/num"):GetComponent("Text")
    block.goldNumText = transform:Find("gold/num"):GetComponent("Text")
    block.sellBtn = transform:Find("sellBtn").gameObject
    return block
end

function _M:InitBottomBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.volumeText = transform:Find("volume/text"):GetComponent("Text")
    block.upgradeBtn = transform:Find("upgrade").gameObject

    return block
end

function _M:SelectMenu(menuItem)
    for i,item in ipairs(self.menuItemCache) do
        if menuItem.id == item.id then
            item.bgImage.color = self.menuSelectedColor
        else
            item.bgImage.color = self.menuNormalColor
        end
    end
end

function _M:OnGoodsClick(goodsItem)

    local itemSize = goodsItem.obj.transform:GetComponent("RectTransform").sizeDelta
    local detailSize = self.goodsBlock.itemDetail.obj:GetComponent("RectTransform").sizeDelta
    if goodsItem.obj.transform.position.x < Screen.width * 0.5 then
        local pos = Vector3(goodsItem.obj.transform.position.x + itemSize.x * 0.5 + detailSize.x * 0.5, goodsItem.obj.transform.position.y, 0)
        self.goodsBlock.itemDetail.obj.transform.position = pos
    else
        local pos = Vector3(goodsItem.obj.transform.position.x - itemSize.x * 0.5 - detailSize.x * 0.5, goodsItem.obj.transform.position.y, 0)
        self.goodsBlock.itemDetail.obj.transform.position = pos
    end
    self:ShowItemDetail(self.goodsBlock.itemDetail, goodsItem.data)
    self.goodsBlock.itemDetail.obj:SetActive(true)
end

function _M:ShowItemDetail(item, data)
    item.titleText.text = data.name
    item.descText.text = data.desc
    item.numText.text = data.num / 2
    item.goldNumText.text = data.num / 2 * data.price
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()
    
end

return _M