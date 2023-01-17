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

NumberVar = {}

function NumberVar:new(object, name, value)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    
    if (type(value) ~= "number") then
        Error("Erro em Create_number_var: value não é um Number")
    end
    if (name == nil or value == nil) then
        Error("Erro em Create_number_var: name ou value não definido")
    end

    object.name = name
    object.value = value
    object.type = "Number"
    
    return object
end

function NumberVar:print()
    print( "Name: "..self.name.." = { Type: "..self.type..", Value: "..self.value .. "}")
end


ClassVar = {}
function ClassVar:new(object, name, class_table, methods_table)
    object = object or {}
    setmetatable(object, self)
    self.__index = self

    object.name = name
    object.class = class_table
    object.methods = methods_table
    object.type = "Class"

    -- Vazios:
    object.attr = {}
    object._prototype = nil
    return object
end

function ClassVar:set_attr(name, value)
    self.attr[name] = value
end

function ClassVar:print()
    print("Name: "..self.name.." = {\n Type: "..self.type..",\n Attr: {")
    Print_table(self.attr)
    print(" }")
    print("}\n")
end


local function types_numbervar_test()
    number_var1 = NumberVar:new(nil, "VAR1", 12)
    number_var2 = NumberVar:new(nil, "VAR2", 124)
    number_var1:print()
    number_var2:print()
end

local function types_classvar_test()
    class_var1 = ClassVar:new(nil, "OBJ1", class_table, class_table.methods)
    class_var2 = ClassVar:new(nil, "OBJ2", class_table, class_table.methods)
    class_var2:set_attr("end1", {rua = "Rua 1",casa = "Casa 2"})
    
    class_var1:print()
    class_var2:print()
end

types_numbervar_test()
types_classvar_test()
