local _M = class()

function _M:Init()
    -- 植物
    self.plant = nil
    -- 种植时间
    self.startTime = 0
    -- 是否锁住
    self.isLock = true
    -- 是否成熟
    self.canGain = false
end

return _M