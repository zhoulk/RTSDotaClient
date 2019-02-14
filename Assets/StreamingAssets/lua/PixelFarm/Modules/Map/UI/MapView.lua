
local _M = class(ViewBase)

function _M:OnCreate()
    print("_MapView oncreate  ~~~~~~~")

    self.mapRoot = self.transform:Find("cells/Viewport/Content").gameObject
    self.mapCell = self.transform:Find("cells/cell").gameObject

    self:InitMap()
end

function _M:InitMap()
    local map = self.iCtrl:LoadMap()
    print(tabStr(map))

    local wCount = map.mapIndex
    local hCount = map.mapIndex

    for j,row in ipairs(map.mapIndex) do
        for i,cell in ipairs(row) do
            local cellObj = newObject(self.mapCell)
            cellObj.transform:SetParent(self.mapRoot.transform, false)
            cellObj.transform.localScale = Vector3(1,1,1)

            cellW = cell.cellSize.w
            cellH = cell.cellSize.h

            local x = (i-1)*cell.cellSize.w - map.mapSize.w * 0.5

            local y = math.floor((j-1)/2)*cell.cellSize.h - map.mapSize.h * 0.25
            if j%2 == 1 then
                x = x - cell.cellSize.w * 0.5
                y = y + cell.cellSize.h * 0.5
            end

            cellObj.transform.localPosition = Vector3(x, y, 0)
            if cell.type == CellType.Land then
                cellObj.transform:Find("grass").gameObject:SetActive(false)
                cellObj.transform:Find("land").gameObject:SetActive(true)
            elseif cell.type == CellType.Grass then
                cellObj.transform:Find("grass").gameObject:SetActive(true)
                cellObj.transform:Find("land").gameObject:SetActive(false)
            end
            cellObj:SetActive(true)

            cellObj:GetComponent("Button").onClick:AddListener(function ()
                self:OnClickCell(cell)
            end)
        end
    end

    self.mapRoot:GetComponent("RectTransform").sizeDelta = Vector2(map.mapSize.w, map.mapSize.h * 0.5)
end

function _M:OnClickCell(cell)
    print(tabStr(cell))
end

function _M:OnDestroy()
    
end

return _M