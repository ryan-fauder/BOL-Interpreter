require "utils"
require "types"


Env = {}

--- Cria um objeto Env
function Env:new()
    local env = { vars = {} }
    setmetatable(env, self)
    self.__index = self
    return env
end


--- Define uma variável no ambiente
---@param name string
---@param var table
function Env:set_var(name, var)
    if name == nil then
        Error("Erro em Env:set_var: name não definido")
        return
    end
    self.vars[name] = var
end


--- Retorna uma variável do ambiente
---@param name string
---@return table
function Env:get_var(name)
    if name == nil then
        Error("Erro em Env:get_var: name não definido")
        return {}
    end

    return self.vars[name] or Error("Erro em Env:get_var: '" .. name .. "' não definida") or {}
end


--- Imprime um objeto Env
function Env:print()
    print("~ Env - vars: ~")
    for name, var in pairs(self.vars) do
        print("=>> " .. name .. ":")
        var:print()
    end
end
