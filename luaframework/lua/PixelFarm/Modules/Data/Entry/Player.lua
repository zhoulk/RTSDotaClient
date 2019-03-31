local _M = class()

function _M:Init(p)
    p = p or {}
    self.UserId = p.UserId or ""
    self.Account = p.Account or ""
    self.Name = p.Name or ""
    self.BaseInfo = p.BaseInfo or {}
end

return _M