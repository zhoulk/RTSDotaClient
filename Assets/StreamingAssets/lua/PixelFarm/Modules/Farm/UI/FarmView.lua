
local _M = class(ViewBase)

function _M:Init()
    self.maxLand = 0
    self.landItemCache = {}
    self.landList = {}
    self.plantItemCache = {}
    self.plantList = {}
    self.toolItemCache = {}
    self.toolList = {}

    self.isDragPlantList = false
    self.isDragToolList = false
    self.timerCo = nil
end

function _M:OnCreate()
    print("FarmView oncreate  ~~~~~~~")
    self:Init()

    self.landBlock = self:InitLandBlock(self.transform, "content/landGrid")
    self.selectPlantBlock = self:InitSelectPlantBlcok(self.transform, "content/plantList")
    self.toolBlock = self:InitToolBlock(self.transform, "content/toolList")
    self.selectedObj = self.transform:Find("selectedObj")

    self:InitData()

    self:StartTimeCoroutine()
end

function _M:InitLandBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.landList = transform:GetComponent("ScrollRect")
    block.landItem = transform:Find("item").gameObject
    return block
end

function _M:InitSelectPlantBlcok(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.plantList = transform:GetComponent("ScrollRect")
    block.plantItem = transform:Find("item").gameObject

    block.transform.gameObject:SetOnClick(function ()
        self:HideSelectPlant()
    end)

    return block
end

function _M:InitToolBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.toolList = transform:GetComponent("ScrollRect")
    block.toolItem = transform:Find("item").gameObject

    block.transform.gameObject:SetOnClick(function ()
        self:HideTool()
    end)

    return block
end

function _M:InitData()
    self:InitLandData()
    self:InitSelectPlantData()
    self:InitToolData()
end

-- 初始化 土地数据
function _M:InitLandData()
    self.maxLand = self.iCtrl:GetTotalLand()

    for i=1,self.maxLand do
        local obj = newObject(self.landBlock.landItem)
        obj.transform:SetParent(self.landBlock.landList.content, false)
        obj.transform.localScale = Vector3(1,1,1)
        obj:SetActive(true)

        local btn = obj.transform:GetComponent("Button")
        local lockObj = obj.transform:Find("lock").gameObject
        local nameText = obj.transform:Find("name"):GetComponent("Text")

        local detailObj = obj.transform:Find("detail").gameObject
        local detail = {}
        detail.obj = detailObj
        detail.speedBtn = detailObj.transform:Find("speed").gameObject
        detail.percentImage = detailObj.transform:Find("progress/font"):GetComponent("Image")
        detail.timeText = detailObj.transform:Find("progress/time"):GetComponent("Text")
        detail.nameText = detailObj.transform:Find("name"):GetComponent("Text")

        local landItem = {}
        landItem.id = i
        landItem.obj = obj
        landItem.lockObj = lockObj
        landItem.nameText = nameText
        landItem.detail = detail
        self.landItemCache[i] = landItem

        btn.onClick:AddListener(function ()
            self:OnLandItemClick(landItem)
        end)
    end

    self.landList = self.iCtrl:GetLandList()
    for i,land in ipairs(self.landList) do
        self.landItemCache[i].data = land
        if not land.isLock then
            self.landItemCache[i].lockObj:SetActive(false)
        end
    end
end

-- 初始化选择植物
function _M:InitSelectPlantData()
    self.plantList = self.iCtrl:GetPlantList()
    for i,plant in ipairs(self.plantList) do
        local plantObj = newObject(self.selectPlantBlock.plantItem)
        plantObj.transform:SetParent(self.selectPlantBlock.plantList.content, false)
        plantObj.transform.localScale = Vector3(1,1,1)
        plantObj:SetActive(true)

        local canvasGroup = plantObj.transform:GetComponent("CanvasGroup")
        local nameText = plantObj.transform:Find("name"):GetComponent("Text")
        local lockObj = plantObj.transform:Find("lock").gameObject

        nameText.text = plant.name
        if not plant.isLock then
            lockObj:SetActive(false)
        end

        local plantItem = {}
        plantItem.id = i
        plantItem.obj = plantObj
        plantItem.canvasGroup = canvasGroup
        plantItem.nameText = nameText
        plantItem.lockObj = lockObj
        plantItem.data = plant
        self.plantItemCache[i] = plantItem

        plantObj:SetOnClick(function ()
            self:OnPlantItemClick(plantItem)
        end)
        plantObj:SetOnDragStart(function (obj, evt, go, args)
            print("drag start" .. evt.delta.x .. "," .. evt.delta.y)
            
            if math.abs( evt.delta.x ) > math.abs( evt.delta.y ) then
                self.isDragPlantList = true
                self.selectPlantBlock.plantList:OnBeginDrag(evt)
            else
                self.isDragPlantList = false

                self:DragStartPlant(plantItem)
            end
        end)
        plantObj:SetOnDragEnd(function (obj, evt, go, args)
            print("drag end")
            if self.isDragPlantList then
                self.selectPlantBlock.plantList:OnEndDrag(evt)
            else
                self:DragEndPlant(plantItem)
            end
        end)
        plantObj:SetOnDrag(function (obj, evt, go, delta, args)
            print("drag " .. evt.delta.x .. "," .. evt.delta.y)
            if self.isDragPlantList then
                self.selectPlantBlock.plantList:OnDrag(evt)
            else
                self:DragPlant(plantItem, evt)
            end
        end)
    end
end

-- 初始化 工具数据
function _M:InitToolData()
    self.toolList = self.iCtrl:GetToolList()
    for i,tool in ipairs(self.toolList) do
        local toolObj = newObject(self.toolBlock.toolItem)
        toolObj.transform:SetParent(self.toolBlock.toolList.content, false)
        toolObj.transform.localScale = Vector3(1,1,1)
        toolObj:SetActive(true)

        local canvasGroup = toolObj.transform:GetComponent("CanvasGroup")
        local nameText = toolObj.transform:Find("name"):GetComponent("Text")
        nameText.text = tool.name

        local toolItem = {}
        toolItem.id = i
        toolItem.canvasGroup = canvasGroup
        toolItem.obj = toolObj
        toolItem.data = tool
        self.toolItemCache[i] = toolItem

        toolObj:SetOnClick(function ()
            self:OnToolItemClick(toolItem)
        end)

        toolObj:SetOnDragStart(function (obj, evt, go, args)
            print("drag start" .. evt.delta.x .. "," .. evt.delta.y)
            
            if math.abs( evt.delta.x ) > math.abs( evt.delta.y ) then
                self.isDragToolList = true
                self.toolBlock.tooList:OnBeginDrag(evt)
            else
                self.isDragToolList = false

                self:DragStartTool(toolItem)
            end
        end)
        toolObj:SetOnDragEnd(function (obj, evt, go, args)
            print("drag end")
            if self.isDragToolList then
                self.toolBlock.toolList:OnEndDrag(evt)
            else
                self:DragEndTool(toolItem)
            end
        end)
        toolObj:SetOnDrag(function (obj, evt, go, delta, args)
            print("drag " .. evt.delta.x .. "," .. evt.delta.y)
            if self.isDragToolList then
                self.toolBlock.toolList:OnDrag(evt)
            else
                self:DragTool(toolItem, evt)
            end
        end)
    end
end

-- 拖动一个植物开始
function _M:DragStartPlant(plantItem)
    if plantItem.data and not plantItem.data.isLock then
        local selectObj = newObject(plantItem.obj)
        selectObj.transform:SetParent(self.selectedObj.transform, false)
        selectObj.transform.localScale = Vector3(1,1,1)

        local selectItem = {}
        selectItem.origionPlantItem = plantItem
        selectItem.obj = selectObj
        selectItem.data = plantItem.data 
        self.selectPlantBlock.selectItem = selectItem
        self.selectPlantBlock.selectItem.obj.transform.position = plantItem.obj.transform.position

        -- 先生成新的，在隐藏
        plantItem.canvasGroup.alpha = 0
    end
end

-- 拖拽植物结束
function _M:DragEndPlant(plantItem)
    if self.selectPlantBlock.selectItem then
        if self.selectPlantBlock.transform.gameObject.activeSelf then
            -- 没产生种植， 恢复显示
            self.selectPlantBlock.selectItem.origionPlantItem.canvasGroup.alpha = 1
        end
        -- 销毁克隆出来的选中物体
        GameObject.Destroy(self.selectPlantBlock.selectItem.obj)
        self.selectPlantBlock.selectItem = nil

        self:HideSelectPlant()
    end
end

-- 拖拽一个植物
function _M:DragPlant(plantItem, evt)
    if self.selectPlantBlock.selectItem then
        local nextPos = self.selectPlantBlock.selectItem.obj.transform.position + Vector3(evt.delta.x, evt.delta.y, 0)
        self.selectPlantBlock.selectItem.obj.transform.position = nextPos

        self:DragOverLand()
    end
end

-- 拖拽植物经过一块空地
function _M:DragOverLand()
    for i,landItem in ipairs(self.landItemCache) do
        local landObj = landItem.obj
        local land = landItem.data

        local selectPlandPos = self.selectPlantBlock.selectItem.obj.transform.position
        local landPos = landObj.transform.position
        local landSize = landObj.transform:GetComponent("RectTransform").sizeDelta
        -- 一块解锁的空地
        if land and not land.isLock and not land.plant then
            if math.abs( selectPlandPos.x - landPos.x ) < landSize.x and 
                math.abs( selectPlandPos.y - landPos.y ) < landSize.y then
                    land.plant = self.selectPlantBlock.selectItem.data
                    land.startTime = os.time()
                    landItem.nameText.text = land.plant.name

                    -- 此处隐藏会导致选种植物卡住 因为移动监测的物体被隐藏了
                    -- self:HideSelectPlant()
                end
        end
    end
end

-- 拖动一个工具开始
function _M:DragStartTool(toolItem)
    if toolItem.data and not toolItem.data.isLock then
        local selectObj = newObject(toolItem.obj)
        selectObj.transform:SetParent(self.selectedObj.transform, false)
        selectObj.transform.localScale = Vector3(1,1,1)

        local selectItem = {}
        selectItem.origionToolItem = toolItem
        selectItem.obj = selectObj
        selectItem.data = toolItem.data 
        self.toolBlock.selectItem = selectItem
        self.toolBlock.selectItem.obj.transform.position = toolItem.obj.transform.position

        -- 先生成新的，在隐藏
        toolItem.canvasGroup.alpha = 0
    end
end

-- 拖拽工具结束
function _M:DragEndTool(toolItem)
    if self.toolBlock.selectItem then
        if self.toolBlock.transform.gameObject.activeSelf then
            -- 没产生种植， 恢复显示
            self.toolBlock.selectItem.origionToolItem.canvasGroup.alpha = 1
        end
        -- 销毁克隆出来的选中物体
        GameObject.Destroy(self.toolBlock.selectItem.obj)
        self.toolBlock.selectItem = nil

        self:HideTool()
    end
end

-- 拖拽一个工具
function _M:DragTool(toolItem, evt)
    if self.toolBlock.selectItem then
        local nextPos = self.toolBlock.selectItem.obj.transform.position + Vector3(evt.delta.x, evt.delta.y, 0)
        self.toolBlock.selectItem.obj.transform.position = nextPos

        self:DragToolOverLand()
    end
end

-- 拖拽植物经过一块空地
function _M:DragOverLand()
    for i,landItem in ipairs(self.landItemCache) do
        local landObj = landItem.obj
        local land = landItem.data

        local selectPlandPos = self.selectPlantBlock.selectItem.obj.transform.position
        local landPos = landObj.transform.position
        local landSize = landObj.transform:GetComponent("RectTransform").sizeDelta
        -- 一块解锁的空地
        if land and not land.isLock and not land.plant then
            if math.abs( selectPlandPos.x - landPos.x ) < landSize.x and 
                math.abs( selectPlandPos.y - landPos.y ) < landSize.y then
                    land.plant = self.selectPlantBlock.selectItem.data
                    land.startTime = os.time()
                    landItem.nameText.text = land.plant.name

                    -- 此处隐藏会导致选种植物卡住 因为移动监测的物体被隐藏了
                    -- self:HideSelectPlant()
                end
        end
    end
end

function _M:DragToolOverLand()
    for i,landItem in ipairs(self.landItemCache) do
        local landObj = landItem.obj
        local land = landItem.data

        local selectToolPos = self.toolBlock.selectItem.obj.transform.position
        local landPos = landObj.transform.position
        local landSize = landObj.transform:GetComponent("RectTransform").sizeDelta
        -- 一块解锁的空地
        if land and not land.isLock and land.canGain then
            if math.abs( selectToolPos.x - landPos.x ) < landSize.x and 
                math.abs( selectToolPos.y - landPos.y ) < landSize.y then
                    -- 收货
                    -- land.plant
                    land.startTime = 0
                    landItem.nameText.text = ""
                    landItem.data.plant = nil
                    landItem.data.canGain = false
                    landItem.data.startTime = 0
                end
        end
    end
end

-- 点击一块田地
function _M:OnLandItemClick(landItem)
    print(landItem.id)

    self:HideSelectPlant()
    self:HideTool()
    
    -- 隐藏详情
    for i,landItem in ipairs(self.landItemCache) do
        local landDetailObj = landItem.detail.obj
        if landDetailObj and landDetailObj.activeSelf then
            landDetailObj:SetActive(false)
        end
    end

    if landItem.data and not landItem.data.isLock then
        if landItem.data.plant then
            local land = landItem.data
            local plant = land.plant

            local landSeconds = os.time() - land.startTime
            local growSeconds = landSeconds
            if growSeconds > plant.growSeconds then
                -- 已经成熟
                self:ShowTool()
            else
                -- 显示详情
                            
                local leftSeconds = plant.growSeconds - growSeconds

                landItem.detail.percentImage.fillAmount = growSeconds / plant.growSeconds
                local minites = math.modf( leftSeconds / 60 )  -- 取整数
                local seconds = math.fmod( leftSeconds, 60 )    -- 取余数
                landItem.detail.timeText.text = minites .. "分" .. seconds .. "秒"
                landItem.detail.nameText.text = plant.name
                landItem.detail.obj:SetActive(true)
            end           
        else
            self:ShowSelectPlant()
        end
    else
        -- 请解锁
    end
end

-- 点击一个物种
function _M:OnPlantItemClick(plantItem)
    print(plantItem.id)
    if plantItem.data and not plantItem.data.isLock then

    else
        -- 请解锁
    end
end

-- 
function _M:OnToolItemClick(toolItem)
    
end

-- 播种变化
function _M:OnGrowSliderChanged()
    local curValue = self.operBlock.growSlider.value
    self.operBlock.growNumText.text = math.floor(curValue) .. " / " .. self.maxLand

    local plant = self.operBlock.data
    local offset = math.floor(curValue) - plant.growNum
    local totalCost = -1 * offset * plant.cost
    local isEnough = self.iCtrl:CheckCoin(totalCost)
    if not isEnough then
        Toast("金币不足")
    else
        self.operBlock.grow = offset
    end
end

--
function _M:ShowTool()
    self.toolBlock.transform.gameObject:SetActive(true)
end

function _M:HideTool()
    self.toolBlock.transform.gameObject:SetActive(false)
end

-- 显示植物选择界面
function _M:ShowSelectPlant()
    self.selectPlantBlock.transform.gameObject:SetActive(true)
end

-- 关闭植物选择页面
function _M:HideSelectPlant()
    if self.selectPlantBlock.transform.gameObject.activeSelf then
        self.selectPlantBlock.transform.gameObject:SetActive(false)
    end
end

-- 开启定时器
function _M:StartTimeCoroutine()
    -- print("StartTimeCoroutine")
    self.timerCo = coroutine.start(function ()
        repeat
            coroutine.wait(1)
            self:OnTimeChanged()
        until(false)
    end)
end

function _M:OnTimeChanged()
    -- 计算是否有成熟的
    for i,landItem in ipairs(self.landItemCache) do
        local landObj = landItem.obj
        local land = landItem.data
        if landItem.data and not landItem.data.isLock then
            if landItem.data.plant and not landItem.data.canGain then
                local land = landItem.data
                local plant = land.plant
    
                local landSeconds = os.time() - land.startTime
                local growSeconds = landSeconds
                if growSeconds > plant.growSeconds then
                    -- 已经成熟
                    land.canGain = true
                    landItem.nameText.text = landItem.nameText.text .. "(成熟)"
                end
            end
        end
    end
end

function _M:OnDestroy()
    if self.timerCo then
        coroutine.stop(self.timerCo)
        self.timerCo = nil
    end
end

return _M