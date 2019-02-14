local _M = class()

function _M:Init(tab)
    local _t = tab or {}
    -- 角色id
    self.uid = _t.uid or ""
    -- 角色等级
    self.level = _t.level or 1
    -- 角色昵称
    self.nickName = _t.nickName or ""
    -- 经验值
    self.exp = _t.exp or 0
    -- 升级需要的经验值
    self.levelUpExp = _t.levelUpExp or 0
    -- 人口
    self.people = _t.people or 75
    -- 可以达到的人口
    self.maxPeople = _t.maxPeople or 0

    -- 金币
    self.coin = _t.coin or 0
    -- 绿钞
    self.lvChao = _t.lvChao or 0
    -- 宝石
    self.baoShi = _t.baoShi or 0
end

return _M