local CellItem = require "PixelFarm.Modules.Map.Data.CellItem"
local _M = class()

function _M:Init()
    self.mapSize = {
        w = 0,
        h = 0
    }
    self.cellRows = 40
    self.cellCols = 40
    self.mapIndex = {}

    self:InitMap()
end

function _M:InitMap()
    local w = 0
    local h = 0
    local cellW = 0;
    local cellH = 0
    for i=1,self.cellRows do
        self.mapIndex[i] = {}
        for j=1,self.cellCols do
            local cell = CellItem.new()
            cell:Init()
            cell.type = CellType.Grass
            self.mapIndex[i][j] = cell
            if i==1 then
                w = w + cell.cellSize.w
                cellW = cell.cellSize.w
            end
            if j==1 then
                h = h + cell.cellSize.h
                cellH = cell.cellSize.h
            end
        end
    end

    self.mapSize.w = w - cellW
    self.mapSize.h = h - cellH
end

return _M