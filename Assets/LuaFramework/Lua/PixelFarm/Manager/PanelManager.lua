
PanelManager = class()

function PANEL(panelName)
    return PanelManager.Instance().panelDic[panelName]
end

function PANEL_LOW()
    return PANEL(UIPanelNames.Low)
end
function PANEL_MID()
    return PANEL(UIPanelNames.Mid)
end
function PANEL_HIGH()
    return PANEL(UIPanelNames.High)
end
function PANEL_TOP()
    return PANEL(UIPanelNames.Top)
end

function PanelManager:Init(cb)
    self.UICanvas = find("Canvas")
    self.panelDic = {}

    resMgr:LoadPrefab(MoudleNames.Common .. "_prefab", {"Panel"},function (prefabs)
        if prefabs and prefabs[0] then

            for _,v in pairs(UIPanelOrder) do
                print(v)
                local obj = newObject(prefabs[0])
                obj.transform:SetParent(self.UICanvas.transform, false)
                obj.transform.localPosition = Vector3(0,0,0)
                obj.transform.localScale = Vector3(1,1,1)
                obj.name = v .. "Panel"

                self.panelDic[v] = obj
            end
            
            if cb then cb() end
        end
    end)
end
