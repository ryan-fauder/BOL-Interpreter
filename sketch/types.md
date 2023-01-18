
function Create_number_var(name, value)
    if (type(value) ~= "number") then
        Error("Erro em Create_number_var: value não é um Number")
    end
    if (name == nil or value == nil) then
        Error("Erro em Create_number_var: name ou value não definido")
    end

    local number_var = {}
    number_var.name = name
    number_var.value = value
    number_var.type = "Number"

    return number_var
end

function Create_class_var(name, class_table, methods_table)
    if (name == nil or class_table == nil) then
        Error("Erro em Create_class_var: name ou class não definido")
    end

    local attr = {}

    -- for k,v in pairs(class_table.attr) do
    --   attr[v] = nil
    -- end

    -- if(attr == {}) then attr = nil end

    local class_var = {}
    class_var.name = name
    class_var.class = class_table
    class_var.methods = methods_table
    class_var.type = "Class"

    -- Vazios:
    class_var.attr = attr
    class_var._prototype = nil

    return class_var
end

function Set_attr(var, name, value)
    if (name == nil or class_table == nil) then
        Error("Erro em Create_class_var: name ou class não definido")
    end
    var.attr[name] = value
end

function Get_attr(var, name)
    return var.attr[name]
end



local function types_test()
    local number_var1 = Create_number_var("VAR1", 12)
    local number_var4 = Create_number_var("VAR1", 124)
    Print_table(number_var1)
    Print_table(number_var4)
    local class_var1 = Create_class_var("OBJ1", class_table, class_table.methods)
    print("")
    Print_table(class_var1)
    Set_attr(class_var1, "end1", {
        rua = "Rua 1",
        casa = "Casa 2"
    })
    Print_table(class_var1.attr.end1)

    local class_var2 = Class_var:new(nil, "OBJ1", class_table, class_table.methods)
    print("")
    class_var2:set_attr("end1", {
        rua = "Rua 1",
        casa = "Casa 2"
    })
    Print_table(class_var2.attr.end1)
end
