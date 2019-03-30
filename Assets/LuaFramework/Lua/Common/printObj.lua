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