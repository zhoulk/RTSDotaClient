require "3rd.pbc.protobuf"

local _PBManager = class()

PBManager = _PBManager.Instance()

function _PBManager:Init()
    self:Registe("err.pb")

    self:Registe("login.pb")
end

function _PBManager:Registe(luaName)
    local path = Application.dataPath;

    local addr = io.open(path.."/LuaFramework/Lua/PixelFarm/PBLua/"..luaName, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)
end