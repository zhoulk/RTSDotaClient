local _M = class()

function _M:Init(g)
    g = g or {}
    self.Id = g.Id or 0
	self.Name = g.Name or ""
    self.IsOpen = g.IsOpen or false
    self.ChapterId = g.ChapterId
	self.Star = g.Star or 0
    self.Status = g.Status or 1
	self.Times = g.Times or 0
    self.TotalTimes = g.TotalTimes or 0
    
    self.Expend = {}
    if g.Expend then
        self.Expend.Power = g.Expend.Power or 0
    else
        self.Expend.Power = 0
    end

    self.Earn = {}
    if g.Earn then
        self.Earn.PlayerExp = g.Earn.PlayerExp or 0
        self.Earn.Gold = g.Earn.Gold or 0
        if g.Earn.ItemIds then
            self.Earn.ItemIds = {}
            for _, itemId in pairs(g.Earn.ItemIds) do
                table.insert(self.Earn.ItemIds, tonumber(itemId))
            end
        else
            self.Earn.ItemIds = {}
        end
    else
        self.Earn.PlayerExp = 0
        self.Earn.Gold = 0
        self.Earn.ItemIds = {}
    end
end

function _M:StatusStr()
    return guanKaStatusStr(self.Status)
end

-- ChapterStatusLock    int32 = 1
-- ChapterStatusNormal  int32 = 2
-- ChapterStatusCleared int32 = 3
function guanKaStatusStr(type)
    local m = {"未解锁", "未通关", "通关"}
    type = type or 0
    if type < 1 or type > 3 then
        return ""
    end
    return m[type]
end

function guanKaCanEnter(type)
    if type == 2 or type == 3 then
        return true
    else
        return false
    end
end

return _M