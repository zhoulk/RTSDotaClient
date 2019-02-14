local _M = class()

CellType = {
    Land = 1,
    Grass = 2
}

function _M:Init()
    self.cellSize = {
        w = 64,
        h = 64
    }
    self.type = CellType.Land
end

return _M