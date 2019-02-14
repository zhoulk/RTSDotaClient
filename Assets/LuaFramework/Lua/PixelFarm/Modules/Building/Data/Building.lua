local _M = class()

function _M:Init(tab)
    local _t = tab or {}
    -- 名称
    self.name = _t.name or ""
    -- 人口
    self.people = _t.people or 0
    -- 造价
    self.cost = _t.cost or 0
end

return _M