local _M = class()

GoodsType = {
    None = 0,
    -- 植物
    Plant = 1,
    -- 动物
    Animal = 2,
    -- 海岛
    Jetty = 3,
    -- 建筑
    Building = 4,
    -- 金属
    Material = 5
}

function _M:Init()
    -- id
    self.id = 0
    -- 名称
    self.name = ""
    -- 数量
    self.num = 0
    -- 类型
    self.type = GoodsType.None
end

return _M