local MapItem = require "PixelFarm.Modules.Map.Data.MapItem"
local _M = class()

function _M:LoadMap()
    local map = MapItem.new()
    map:Init()
    return map
end

return _M