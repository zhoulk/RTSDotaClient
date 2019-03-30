local Player = require "PixelFarm.Modules.Data.Entry.Player"

local _StoreLogic = class()

function _StoreLogic:UpdateUid(uid)
    local player = self:CurrentPlayer()
    player.UserId = uid
    self:SavePlayer(player)
end

function _StoreLogic:CurrentPlayer()
    local player = self:LoadPlayer()
    if player == nil then
        player = Player.new()
        player:Init()
        self:SavePlayer(player)
    end
    return player
end

function _StoreLogic:SavePlayer(player)
    LocalDataManager:Save("local_Player", player)
end

function _StoreLogic:LoadPlayer()
    local key = "local_Player"
    local playerTab = LocalDataManager:Load(key)
    local player = Player.new()
    player:Init(playerTab)
    return player
end


return _StoreLogic