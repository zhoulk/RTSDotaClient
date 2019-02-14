local _M = class()

-- 工具类型
ToolType = {
    LianDao = 1
}

function _M:Init()
    -- 名字
    self.name = ""
    -- 类型
    self.type = ToolType.LianDao
    -- 是否解锁
    self.isLock = false
end

return _M