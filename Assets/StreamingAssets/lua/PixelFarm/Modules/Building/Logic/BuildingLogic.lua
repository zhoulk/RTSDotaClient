local Building = require "PixelFarm.Modules.Building.Data.Building"

local _M = class()

function _M:GetBuildings()
    local buildings = {}

    local data = {
        {name="小屋"},{name="科德角式小屋"},{name="牧人小舍"},
        {name="海螺屋"},{name="别墅"},{name="农舍"},
        {name="三角顶小屋"},{name="折顶式小屋"},{name="匠心小栋"},
        {name="双层楼房"},{name="美式四角楼"},{name="一厅一室房"},
        {name="复式公寓"},{name="联排别墅"},{name="维多利亚联排别墅"},
        {name="花园式公寓"},{name="共管公寓"},{name="公寓大楼"},
        {name="合租房"},{name="带花园的高层"},{name="普通高层"},
    }

    for i,v in ipairs(data) do
        local building = Building.new()
        building.name = v.name
        buildings[i] = building 
    end

    return buildings
end

return _M