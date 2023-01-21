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


--- comment
---@param name string
function Env:getVar(name)
    if name == nil then
        Error("Erro em Env_getVar: name não definido")
        return
    end

    return self.vars[name] or Error("Erro em Env_getVar: '" .. name .. "' não definida")
end


--- Imprime um objeto Env
function Env:print()
    print("~ Env - vars: ~")
    for name, var in pairs(self.vars) do
        print("=>> "..name..":")
        var:print()
    end
end