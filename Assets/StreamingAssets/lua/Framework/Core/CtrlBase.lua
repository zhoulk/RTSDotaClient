
CtrlBase = class()

-- 类的默认构造
function CtrlBase:ctor(ctrlName, ...)
    self.AutoDestroy = true
    self.ctrlName = ctrlName
    self.args = {...}
    self:Start()
    self.isDeling = false -- 是否已经删除
end

-- 创建成功后加载
function CtrlBase:Start()
    
end

function CtrlBase:UpdateInfo(...)
	if self.view then
		self.view:UpdateInfo(...)
	end	
end

-- 打开界面
function CtrlBase:StartView()
    
end

-- 销毁控制器回调 -- 非特殊情况，不可重载
function CtrlBase:Destroy()
    -- print("[CtrlBase.Destroy]")
    self.isDeling = true
    if self.view then
        -- print("[Destroy]"..le(self.view.isDeling).."|"..le(self.view.viewName))
        self.view:Destroy()
        self.view.isDeling = true
		self.view = nil
	end
    self:OnDestroy()
end

function CtrlBase:Hide()
    if self.view then
        self.view:Hide()
	end
end

function CtrlBase:Show()
    if self.view then
        self.view:Show()
	end
end

function CtrlBase:IsActive()
    local res = false
    if self.view then
        res = not self.view.isHiding
    end
    return res
end

function CtrlBase:OnDestroy()
	
end
