local _M = class()

function _M:Init(c)
    c = c or {}
    self.UserId = c.UserId or ""
	self.Name = c.Name or ""
    self.Level = c.Level or 1
	self.Power = c.Power or 0
	self.ContriToday = c.ContriToday or 0
	self.ContriTotal = c.ContriTotal or 0
	self.Job = c.Job or 0
	self.OffLineTime = c.OffLineTime or 0
end

return _M