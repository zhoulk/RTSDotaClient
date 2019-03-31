function playerStr(player)
    local str = ""
    if player then
        str = str .. "\n{UserId : " .. player.UserId
        str = str .. ", Name : " .. player.Name
        str = str .. ", BaseInfo : " .. baseInfoStr(player.BaseInfo)
        str = str .. "},"
    end
    return str
end

function baseInfoStr(baseInfo)
    local str = ""
    if baseInfo then
        str = str .. "{ Gold : " .. baseInfo.Gold
        str = str .. ", Diamond : " .. baseInfo.Diamond
        str = str .. ", Exp : " .. baseInfo.Exp
        str = str .. ", LevelUpExp : " .. baseInfo.LevelUpExp
        str = str .. ", Power : " .. baseInfo.Power
        str = str .. ", Level : " .. baseInfo.Level
        str = str .. "},"
    end
    return str
end

function heroStr(hero)
    local str = ""
    if hero then
        str = str .. "\n{Id : " .. hero.Id
        str = str .. ", HeroId : " .. hero.HeroId
        str = str .. ", PlayerId : " .. hero.PlayerId
        str = str .. ", IsSelect : " .. tostring(hero.IsSelect)
        str = str .. ", Pos : " .. hero.Pos
        str = str .. ", Name : " .. hero.Name
        str = str .. ", Level : " .. hero.Level
        str = str .. ", Exp : " .. hero.Exp
        str = str .. ", Type : " .. hero.Type
        str = str .. ", Strength : " .. hero.Strength .. "(+" .. hero.StrengthStep .. ")"
        str = str .. ", Agility : " .. hero.Agility .. "(+" .. hero.AgilityStep .. ")"
        str = str .. ", Intelligence : " .. hero.Intelligence .. "(+" .. hero.IntelligenceStep .. ")"
        str = str .. ", Armor : " .. hero.Armor
        str = str .. ", Attack : (" .. hero.AttackMin .. "~" .. hero.AttackMax .. ")"
        str = str .. ", Blood : " .. hero.Blood
        str = str .. ", SkillIds : " .. tabStr(hero.SkillIds)
        str = str .. "},"
    end
    return str
end