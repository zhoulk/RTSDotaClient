local Goods = require "PixelFarm.Modules.Storage.Data.Goods"

local _M = class()

function _M:GetGoodsList()
    local goodsList = {}
    local goods = Goods.new()
    goods.name = "小麦"
    goods.num = 100
    goodsList[1] = goods
    return goodsList
end

return _M