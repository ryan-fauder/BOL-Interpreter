require "utils"


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
