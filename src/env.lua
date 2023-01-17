require "utils"
require "types"

Env = {}

function Env:new()
    env = {vars = {}}
    setmetatable(env, self)
    self.__index = self
    return env
end

function Env:setVar(name, var)
    if (name == nil) then
        Error("Erro em Env_addVar: name não definido")
    end
    self.vars[name] = var
    self.vars[name]:print()
end

function Env:getVar(name)
    if (name == nil) then
        Error("Erro em Env_addVar: name não definido")
    end

    return self.vars[name]
end

function Env:print()
    print("Env - vars: ")
    for name,var in pairs(self.vars) do
        print(name..":")
        var:print()
    end
end

local function env_test()
    local number_var1 = NumberVar:new(nil, "VAR1", 12)
    local number_var2 = NumberVar:new(nil, "VAR2", 124)
    
    local env = Env:new(nil)
    env:setVar(number_var1.name, number_var1)
    env:setVar(number_var2.name, number_var2)
    env:print()
    
    local number_var3 = NumberVar:new(nil, "VAR2", 500)
    env:setVar(number_var3.name, number_var3)
    env:print()
end

env_test()
