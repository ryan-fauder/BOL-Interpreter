require "utils"
require "types"

Env = {}

--- Cria um objeto Env
function Env:new()
    env = {vars = {}}
    setmetatable(env, self)
    self.__index = self
    return env
end


--- Define uma variável no ambiente
---@param name string
---@param var table
function Env:setVar(name, var)
    if name == nil then
        Error("Erro em Env_addVar: name não definido")
        return
    end
    self.vars[name] = var
end


--- Define uma variável no ambiente
---@param name string
function Env:getVar(name)
    if name == nil then
        Error("Erro em Env_getVar: name não definido")
        return
    end

    return self.vars[name]
end


--- Imprime um objeto Env
function Env:print()
    print("~ Env - vars: ~")
    for name,var in pairs(self.vars) do
        print("=>> "..name..":")
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
    
    local class_var2 = ClassVar:new(nil, "VAR2", class_table1, class_table1.methods)
    env:setVar(class_var2.name, class_var2)
    env:print()
end

--env_test()
