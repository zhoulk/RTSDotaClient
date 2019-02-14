local json = require "cjson"

-- table 转 字符串
function tabStr(data)
	return json.encode(data)
end

-- 字符串 转 table
function strTab(str)
	return json.decode(str)
end

-- 是否包含key
function isTableContainsKey(key, tab)
    for k,v in ipairs(tab) do
      if k == key then
          return true
      end
    end
    return false
end

-- 是否包含value
function isTableContainsValue(value, tab)
    for k,v in ipairs(tab) do
      if v == value then
          return true
      end
    end
    return false
end

--输出日志--
function log(str)
    Util.Log(str);
end

--错误日志--
function logError(str) 
	Util.LogError(str);
end

--警告日志--
function logWarn(str) 
	Util.LogWarning(str);
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end