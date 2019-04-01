local _M = class()

function _M:Init(s)
    s = s or {}
    self.Id = s.Id or 0
	self.Name = s.Name or ""
	self.Level = s.Level or 0
	self.Type = s.Type or 0
	self.Desc = s.Desc or ""
	self.IsOpen = s.IsOpen or false
	self.HeroId = s.HeroId or ""
	self.SkillId = s.SkillId or ""
	self.LevelDesc = s.LevelDesc or {}
end

-- SkillTypeActive  int32 = 1
-- SkillTypePassive int32 = 2
function _M:TypeStr()
    return skillTypeStr(self.Type)
end

function killTypeStr(type)
    local m = {"主动技能","被动技能"}
    type = type or 0
    if type < 1 or type > 2 then
        return ""
    end
    return m[type]
end

return _M