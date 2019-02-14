local Plant = require "PixelFarm.Modules.Farm.Data.Plant"
local Land = require "PixelFarm.Modules.Farm.Data.Land"
local Tool = require "PixelFarm.Modules.Farm.Data.Tool"
local PlayerInterface = require "PixelFarm.Modules.PlayerInfo.Interface.PlayerInfoInterface"
local ConfigInterface = require "PixelFarm.Modules.Config.Interface.ConfigInterface"

local _M = class()

-- 获取当前的土地列表
function _M:GetLandList()
    local player = PlayerInterface:CurrentPlayer()
    local landCount = player.people / 25
    local lands = {}
    for i=1,landCount do
        local land = Land.new() 
        land:Init()
        land.isLock = false
        lands[i] = land
    end
    return lands
end

-- 获取所有植物列表
function _M:GetPlantList()
    local plantConfigs = ConfigInterface:PlantList()
    local player = PlayerInterface:CurrentPlayer()

    local plants = {}
    for i,config in ipairs(plantConfigs) do
        local plant = Plant.new()
        plant:Init(config)
        if plant.unLockLevel <= player.level then
            plant.isLock = false
        end
        plants[i] = plant 
    end

    return plants
end

-- 获取工具列表
function _M:GetToolList()
    local tools = {}
    local tool = Tool.new() 
    tool:Init()
    tool.name = "镰刀"
    tool.type = ToolType.LianDao
    tools[1] = tool
    return tools
end

-- 操作结算
function _M:OperComplete(plant, grow, gain)
    local cost = -1 * plant.cost * grow
    PlayerInterface:UpdateOffsetCoin(cost)

    plant.growNum = plant.growNum + grow
    plant.gainNum = plant.gainNum - gain

    print("[FarmLogic.OperComplete] " .. tabStr(plant))
    self:SavePlant(plant)
end

-- 保存植物
function _M:SavePlant(plant)
    local plants = self:LoadPlants()
    local index = 0
    for i,v in ipairs(plants) do
        if v.name == plant.name then
            index = i
            break
        end
    end
    if index > 0 then
        plants[index] = plant
    end
    LocalDataManager:Save(MoudleNames.Farm .. "_Plants", plants)
end

-- 加载植物
function _M:LoadPlants()
    local plants = LocalDataManager:Load(MoudleNames.Farm .. "_Plants")
    if not plants then
        plants = {}

        local data = {
            {name="小麦", unLockLevel = 1, cost = 1},{name="玉米", unLockLevel = 3},{name="胡萝卜", unLockLevel = 5},
            {name="甘蔗", unLockLevel = 99},{name="棉花", unLockLevel = 99},{name="草莓", unLockLevel = 99},
            {name="西红柿", unLockLevel = 99},{name="松树", unLockLevel = 99},{name="土豆", unLockLevel = 99},
            {name="可可树", unLockLevel = 99},{name="橡胶树", unLockLevel = 99},{name="丝绸树", unLockLevel = 99},
            {name="辣椒", unLockLevel = 99},{name="水稻", unLockLevel = 99},{name="玫瑰", unLockLevel = 99},
            {name="茉莉", unLockLevel = 99},{name="咖啡树", unLockLevel = 99}
        }
    
        for i,v in ipairs(data) do
            local plant = Plant.new()
            plant:Init(v)

            plants[i] = plant 
        end

        LocalDataManager:Save(MoudleNames.Farm .. "_Plants", plants)
    end
    return plants
end

return _M