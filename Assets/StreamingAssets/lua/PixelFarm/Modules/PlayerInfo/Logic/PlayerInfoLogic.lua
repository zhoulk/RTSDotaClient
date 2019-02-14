local Player = require "PixelFarm.Modules.PlayerInfo.Data.Player"

local _M = class()

function _M:CurrentPlayer()
    local player = self:LoadPlayer()
    if player == nil then
        player = Player.new()
        player:Init()
        self:SavePlayer(player)
    end
    return player
end

function _M:UpdateUid(uid)
    local player = self:CurrentPlayer()
    player.uid = uid
    self:SavePlayer(player)
end

function _M:UpdateLevel(lv)
    local player = self:CurrentPlayer()
    player.level = lv
    self:SavePlayer(player)
end

function _M:UpdatePeople(p)
    local player = self:CurrentPlayer()
    player.people = p
    self:SavePlayer(player)
end

function _M:UpdateMaxPeople(p)
    local player = self:CurrentPlayer()
    player.maxPeople = p
    self:SavePlayer(player)
end

function _M:UpdateCoin(coin)
    local player = self:CurrentPlayer()
    player.coin = coin
    self:SavePlayer(player)
end

function _M:UpdateOffsetCoin(offset)
    local player = self:CurrentPlayer()
    player.coin = player.coin + offset
    self:SavePlayer(player)
end

function _M:CheckCoin(num)
    local player = self:CurrentPlayer()
    if player.coin + num >= 0 then
        -- 更新金币显示
        Event.Brocast(EventType.CoinChanged, player.coin, player.coin + num)
        return true
    else
        return false
    end
end

function _M:SavePlayer(player)
    LocalDataManager:Save(MoudleNames.PlayerInfo .. "_Player", player)
end

function _M:LoadPlayer()
    local key = MoudleNames.PlayerInfo .. "_Player"
    local playerTab = LocalDataManager:Load(key)
    local player = Player.new()
    player:Init(playerTab)
    return player
end

return _M