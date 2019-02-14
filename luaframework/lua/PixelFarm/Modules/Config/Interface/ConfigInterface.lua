local _M = class()

-- 最大土地数量
function _M:MaxFarmLand()
    return 100
end

-- 所有植物
function _M:PlantList()
    local plants = {
        {name="小麦", unLockLevel = 1, cost = 1, growSeconds = 20},
        {name="玉米", unLockLevel = 3},
        {name="胡萝卜", unLockLevel = 5},
        {name="甘蔗", unLockLevel = 99},
        {name="棉花", unLockLevel = 99},
        {name="草莓", unLockLevel = 99},
        {name="西红柿", unLockLevel = 99},
        {name="松树", unLockLevel = 99},
        {name="土豆", unLockLevel = 99},
        {name="可可树", unLockLevel = 99},
        {name="橡胶树", unLockLevel = 99},
        {name="丝绸树", unLockLevel = 99},
        {name="辣椒", unLockLevel = 99},
        {name="水稻", unLockLevel = 99},
        {name="玫瑰", unLockLevel = 99},
        {name="茉莉", unLockLevel = 99},
        {name="咖啡树", unLockLevel = 99}
    }
    return plants
end

return _M