local _M = class()

function _M:Init(c)
    c = c or {}
    self.GroupId = c.GroupId or ""
	self.GroupName = c.GroupName or ""
    self.GroupLeader = c.GroupLeader or ""
	self.GroupDeclaration = c.GroupDeclaration or ""
	self.MemberCnt = c.MemberCnt or 0
	self.MemberTotal = c.MemberTotal or 0
	self.GroupLevel = c.GroupLevel or 0
	self.ContriCurrent = c.ContriCurrent or 0
	self.ContriLevelUp = c.ContriLevelUp or 0
end

return _M