local PlayerLogic = require "PixelFarm.Modules.PlayerInfo.Logic.PlayerInfoLogic"
local _M = class()

-- 当前用户信息
function _M:CurrentPlayer()
    return PlayerLogic:CurrentPlayer()
end

-- 更新用户 uid
function _M:UpdateUid(uid)
    PlayerLogic:UpdateUid(uid)
end

-- 更新角色 等级
function _M:UpdateLevel(lv)
    PlayerLogic:UpdateLevel(lv)
end

-- 更新角色 人口
function _M:UpdatePeople(p)
    PlayerLogic:UpdatePeople(p)
end

-- 更新角色 最大人口
function _M:UpdateMaxPeople(p)
    PlayerLogic:UpdateMaxPeople(p)
end

-- 检测金币是否够用
function _M:CheckCoin(num)
    return PlayerLogic:CheckCoin(num)
end

-- 更新 玩家 金币
function _M:UpdateCoin(coin)
    PlayerLogic:UpdateCoin(coin)
end

-- 更新 玩家 金币
function _M:UpdateOffsetCoin(offset)
    PlayerLogic:UpdateOffsetCoin(offset)
end

return _M