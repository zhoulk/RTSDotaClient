local _M = class()

function _M:Init(h)
    h = h or {}
    self.Id = h.Id or 0
	self.Name = h.Name or ""
    self.Price = h.Price or 0
    self.Effect = h.Effect or ""
    self.Desc = h.Desc or ""
end

return _M