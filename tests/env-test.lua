require "utils"
require "types"
require "env"

Class_table = {
    attr = { "name", "age" },
    methods = {
        ["setAge"] = {
            params = { "age" },
            vars = nil,
            body = { "self.age = age" }
        },
        ["getAge"] = {
            params = nil,
            vars = nil,
            body = { "io.print(self.age)", "return self.name" }
        },
        ["getName"] = {
            params = nil,
            vars = nil,
            body = { "io.print(self.name)", "return self.name" }
        }
    },
    _prototype = nil
}

Class_table1 = {
    attr = { "account", "address" },
    methods = {
        ["setAge"] = {
            params = { "age" },
            vars = nil,
            body = { "self.age = age" }
        },
        ["getAge"] = {
            params = nil,
            vars = nil,
            body = { "io.print(self.age)", "return self.name" }
        },
        ["getName"] = {
            params = nil,
            vars = nil,
            body = { "io.print(self.name)", "return self.name" }
        }
    },
    _prototype = nil
}

local function Test_env()
    local number_var1 = NumberVar:new(nil, "VAR1", 12)
    local number_var2 = NumberVar:new(nil, "VAR2", 124)

    if (number_var1 == nil) then return end
    if (number_var2 == nil) then return end
    local env = Env:new()
    env:set_var(number_var1.name, number_var1)
    env:set_var(number_var2.name, number_var2)
    env:print()

    local class_var2 = ClassVar:new(nil, "VAR2", Class_table1, Class_table1.methods)
    if (class_var2 == nil) then return end
    env:set_var(class_var2.name, class_var2)
    env:print()
end

Test_env()
