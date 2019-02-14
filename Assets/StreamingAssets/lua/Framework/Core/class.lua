local _class = {}
---创建一个class模仿面向对象类
function class(super)
    local class_type = {}
    class_type.ctor = false
    class_type.super = super

    class_type.new = function(...)
        local obj = {}
        setmetatable(obj, { __index = _class[class_type] })
        do
            local create
            create = function(c, ...)
                if c.super then
                    create(c.super, ...)
                end
                if c.ctor then
                    c.ctor(obj, ...)
                end
            end

            create(class_type, ...)
        end
        return obj
    end

    class_type.Instance = function()
        if class_type.instance == nil then            
            class_type.instance = class_type.new()
        end
        return class_type.instance
    end

    local vtbl = {}
    _class[class_type] = vtbl

    setmetatable(class_type, {
        __index = function(t, k)
            return vtbl[k]
        end,
        __newindex = function(t, k, v)
            vtbl[k] = v
        end
    })

    if super then
        setmetatable(vtbl, { __index =         function(t, k)
            local ret = _class[super][k]
            vtbl[k] = ret
            return ret
        end
        })
    end


    return class_type
end