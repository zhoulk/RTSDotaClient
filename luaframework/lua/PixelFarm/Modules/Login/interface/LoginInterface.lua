local LoginLogic = require "PixelFarm.Modules.Login.Logic.LoginLogic"
local _M = class()

function _M:Login(accout,password,cb)
    LoginLogic:Login(accout,password,cb)
end

return _M