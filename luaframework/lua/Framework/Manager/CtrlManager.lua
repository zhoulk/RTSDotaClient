
local _CtrlManager = class()
CtrlManager = _CtrlManager.Instance()

local IsOpenning = false
local OpenningBean = nil -- 正在打开的界面
local OpenningTimer = nil -- 打开定时器
local OpenningCtrlName = nil --当前正在加载的界面
local OpenningOkCallBackList = {} -- 打开成功回调

function _CtrlManager:Init()
    self.aliveViewCtrls = {} -- 已经打开的ui
end

function _CtrlManager:OpenCtrl(moduleName, ctrlName, ...)
    local i, cName, viewCtrl = self:GetContainsCtrl(ctrlName)
    if viewCtrl then
        print('[CreateGameCtrl]已打开:' .. ctrlName)
        viewCtrl:UpdateInfo(...)
        return viewCtrl
    end

    local ctrlClass = require(AppName .. '/Modules/' .. moduleName .. '/' .. "UI" .. "/" .. ctrlName)
    local ctrlBean = {}
    if ctrlClass then
        viewCtrl = ctrlClass.new(ctrlName, ...)
        ctrlBean = {ctrlName, viewCtrl, isDeling = false}
        self.aliveViewCtrls[#self.aliveViewCtrls + 1] = ctrlBean
    end
    viewCtrl:StartView()
    return viewCtrl
end

-- 关闭ctrl，并清理数据
function _CtrlManager:CloseCtrl(ctrlName)
    local i, cName, viewCtrl = self:GetContainsCtrl(ctrlName)
    if viewCtrl then
        self:DestroyGameCtrl(self.aliveViewCtrls[i])
        self.aliveViewCtrls[i] = nil
    else
        print('[UI管理器]' .. tostring(ctrlName) .. '并没有打开！')
    end
    print('[RemoveGameCtrl]' .. tostring(ctrlName))
    -- 内存回收
    collectgarbage('collect')
end

-- 获取控制器
function _CtrlManager:GetCtrl(ctrlName)
    local i, cName, viewCtrl = self:GetContainsCtrl(ctrlName)
    return viewCtrl
end

-- 辅助删除
function _CtrlManager:DestroyGameCtrl(ctrlBean)
    if ctrlBean then
        ctrlBean.isDeling = true
        ctrlBean[2]:Destroy()
    end
end

-- 判断是否存在
function _CtrlManager:GetContainsCtrl(ctrlName)
    for i, v in pairs(self.aliveViewCtrls) do
        if v[1] == ctrlName then
            return i, v[1], v[2]
        end
    end
    return nil
end

