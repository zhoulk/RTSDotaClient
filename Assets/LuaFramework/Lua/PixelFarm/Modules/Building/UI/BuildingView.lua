
local _M = class(ViewBase)

function _M:OnCreate()
    print("BuildingView oncreate  ~~~~~~~")

    self.buildingBlock = self:InitBuildingBlock(self.transform, "buildings")

    self:InitData()
end

function _M:InitBuildingBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.landParent = transform.gameObject
    block.landItem = transform:Find("item").gameObject
    return block
end

function _M:InitData()
    local buildingData = self.iCtrl:GetBuildings()
    for _,building in ipairs(buildingData) do
        local obj = newObject(self.buildingBlock.landItem)
        obj.transform:SetParent(self.buildingBlock.landParent.transform, false)
        obj.transform.localScale = Vector3(1,1,1)
        obj:SetActive(true)
        local nameText = obj.transform:Find("name"):GetComponent("Text")
        nameText.text = building.name
    end
end

function _M:OnDestroy()
    
end

return _M