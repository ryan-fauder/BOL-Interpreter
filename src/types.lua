require "utils"

class_table = {
    attr = {"name", "age"},
    methods = {
        ["setAge"] = {
            params = {"age"},
            vars = nil,
            body = {"self.age = age"}
        },
        ["getAge"] = {
            params = nil,
            vars = nil,
            body = {"io.print(self.age)", "return self.name"}
        },
        ["getName"] = {
            params = nil,
            vars = nil,
            body = {"io.print(self.name)", "return self.name"}
        }
    },
    _prototype = nil
}


class_table1 = {
    attr = {"account", "address"},
    methods = {
        ["setAge"] = {
            params = {"age"},
            vars = nil,
            body = {"self.age = age"}
        },
        ["getAge"] = {
            params = nil,
            vars = nil,
            body = {"io.print(self.age)", "return self.name"}
        },
        ["getName"] = {
            params = nil,
            vars = nil,
            body = {"io.print(self.name)", "return self.name"}
        }
    },
    _prototype = nil
}


NumberVar = {}

--- Cria um objeto NumberVar 
---@param object table
---@param name string
---@param value number
function NumberVar:new(object, name, value)
    object = object or {}
    setmetatable(object, self)
    self.__index = self

    value = value or 0

    if (type(value) ~= "number") then
        Error("Erro em Create_number_var: value não é um Number")
        return
    end
    if (name == nil or value == nil) then
        Error("Erro em Create_number_var: name ou value não definido")
        return
    end

    object.name = name
    object.value = value
    object.type = "Number"

    return object
end


---@description Imprime um NumberVar
function NumberVar:print()
    print("Name: " .. self.name .. " = { Type: " .. self.type .. ", Value: " .. self.value .. "}")
end


ClassVar = {}

--- Cria um objeto ClassVar
---@param object table
---@param name string
---@param class_table table
---@param methods_table table
function ClassVar:new(object, name, class_table, methods_table)
    object = object or {}
    setmetatable(object, self)
    self.__index = self

    if (class_table == nil) then
        Error("Erro em ClassVar.new: class não definida")
        return
    end

    local attr = {}

    for index, name in pairs(class_table.attr) do
        attr[name] = 0
    end

    if (attr == {}) then
        attr = nil
    end

    object.name = name
    object.class = class_table
    object.methods = methods_table
    object.type = "Class"

    -- Vazios:
    object.attr = attr or nil
    object._prototype = nil
    return object
end


--- Define um atributo em um objeto ClassVar
---@param name string
---@param value string
function ClassVar:set_attr(name, value)
    self.attr[name] = value
end


--- Imprime um objeto de ClassVar
function ClassVar:print()
    print("Name: " .. self.name .. " = {\n Type: " .. self.type .. ",\n Attr: {")
    Print_table(self.attr)
    print(" }\n Methods: {")
    Print_table(self.methods)
    print(" }")
    print("}\n")
end


local function types_numbervar_test()
    local number_var1 = NumberVar:new(nil, "VAR1", 12)
    local number_var2 = NumberVar:new(nil, "VAR2")
    number_var1:print()
    number_var2:print()
end


local function types_classvar_test()
    local class_var1 = ClassVar:new(nil, "OBJ1", class_table, class_table.methods)
    local class_var2 = ClassVar:new(nil, "OBJ2", class_table1, class_table1.methods)
    class_var2:set_attr("end1", {
        rua = "Rua 1",
        casa = "Casa 2"
    })

    class_var1:print()
    class_var2:print()
end

--types_numbervar_test()
--types_classvar_test()
