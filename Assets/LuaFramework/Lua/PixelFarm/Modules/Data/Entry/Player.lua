local _M = class()

function _M:Init(p)
    -- print("player init " .. tabStr(p))
    p = p or {}
    self.UserId = p.UserId or ""
    self.Name = p.Name or ""

    self.BaseInfo = {
        Gold = 0,
        Diamond = 0,
        Power = 0,
        Exp = 0,
        LevelUpExp = 0,
        Level = 0,
    }
    if p.BaseInfo ~= nil then
        self.BaseInfo.Gold = p.BaseInfo.Gold or 0
        self.BaseInfo.Diamond = p.BaseInfo.Diamond or 0
        self.BaseInfo.Power = p.BaseInfo.Power or 0
        self.BaseInfo.Exp = p.BaseInfo.Exp or 0
        self.BaseInfo.LevelUpExp = p.BaseInfo.LevelUpExp or 0
        self.BaseInfo.Level = p.BaseInfo.Level or 0
    end

    -- print("player init end")
end

return _M