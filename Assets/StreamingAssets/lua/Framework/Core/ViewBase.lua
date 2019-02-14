
---创建一个ViewBase类
ViewBase = class()

-- 结构体
function ViewBase:ctor(bundleName, viewName, parent, ...)
    self.bundleName = bundleName
    self.viewName = viewName
    self.parent = parent
    self.isDeling = false -- 异步加载删除界面标记
    self.isHiding = false -- 隐藏界面
    self.args = {...} 
    self.OpenViewCallback = nil
    self.iCtrl = nil -- 控制器

    self.transform = nil
end

-- 刷新界面
function ViewBase:Refresh()
    ViewManager.Close()
    ViewManager.Open(self.viewName, unpack(self._args))
end

--更新界面信息
function ViewBase:UpdateInfo(...)
end

-- 查找调用class方法
function ViewBase:Func(funcName)
    return function(...)
        local func = self[funcName]
        if func then
            func(self, ...)
        else
            print(le("no func " .. self.viewName .. ":" .. funcName))
        end
    end
end

-- 从ab创建，加载prefab,
function ViewBase:Create()
    resMgr:LoadPrefab(self.bundleName .. "_prefab", {self.viewName},function (prefabs)
        if prefabs and prefabs[0] then
            local obj = newObject(prefabs[0])
            obj.transform:SetParent(self.parent.transform, false)
            obj.transform.localPosition = Vector3(0,0,0)
            obj.transform.localScale = Vector3(1,1,1)
            obj.name = tostring(self.viewName)

            self.transform = obj.transform
            self.gameObject = obj
            self:OnCreate(obj)
            if self.OpenViewCallback then self.OpenViewCallback(self.viewName) end
        end
    end)
end

function ViewBase:OnCreate(obj)
end

-- 可重载
function ViewBase:OnDestroy()
end

function ViewBase:OnDestroyFinish()
end

-- 非特殊情况，不可重载
function ViewBase:Destroy()
    self:ClearData()
end

function ViewBase:OnHide()
end
function ViewBase:OnShow()
end

function ViewBase:Hide()
    self.isHiding = true
    if self.gameObject then
        self.gameObject:SetActive(false)
    end
end

function ViewBase:Show()
    self.isHiding = false
    if self.gameObject then
        self.gameObject:SetActive(true)
    end
end

-- 结束要做的
function ViewBase:ClearData()
    self:OnDestroy()
    GameObject.Destroy(self.gameObject)
    self:OnDestroyFinish()
end
