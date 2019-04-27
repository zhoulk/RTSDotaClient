local _M = class()

function _M:Init(h)
    h = h or {}
    self.Id = h.Id or 0
	self.Name = h.Name or ""
	self.Level = h.Level or 0
	self.Type = h.Type or 0
	self.Strength = h.Strength or 0
	self.StrengthStep = h.StrengthStep or 0
	self.Agility = h.Agility or 0
	self.AgilityStep = h.AgilityStep or 0
	self.Intelligence = h.Intelligence or 0
	self.IntelligenceStep = h.IntelligenceStep or 0
	self.Armor = h.Armor or 0
	self.AttackMin = h.AttackMin or 0
	self.AttackMax = h.AttackMax or 0
	self.Blood = h.Blood or 0
	self.MaxBlood = h.MaxBlood or 0
	self.MP = h.MP or 0
	self.MaxMP = h.MaxMP or 0
	self.SkillIds = h.SkillIds or {}
	self.HeroId = h.HeroId or ""
	self.PlayerId = h.PlayerId or ""
	self.IsSelect = h.IsSelect or false
	self.Pos = h.Pos or 0
	self.SkillPoint = h.SkillPoint or 0
	self.Exp = h.Exp or 0
	self.LevelUpExp = h.LevelUpExp or 1

	-- print("Hero Init " .. h.Name)
end

-- HeroTypeStrength     int32 = 1
-- HeroTypeAgility      int32 = 2
-- HeroTypeIntelligence int32 = 3
function _M:TypeStr()
    return heroTypeStr(self.Type)
end

function heroTypeStr(type)
    local m = {"力量","敏捷","智力"}
    type = type or 0
    if type < 1 or type > 3 then
        return ""
    end
    return m[type]
end

return _M