require "utils"
require "strings"
require "patterns"


-- Vetor contendo os padrões (regexs)
local statements_patterns = {
    _Bin_operation_pattern_.var_case,
    _Bin_operation_pattern_.attr_case,
    _Method_call_pattern_,
    _Meta_action_pattern_,
    _Prototype_pattern_,
    _Return_pattern_,

    _If_pattern_,
    _If_else_pattern_,

    _Assignment_pattern_.var_case.number_arg,
    _Assignment_pattern_.var_case.var_arg,
    _Assignment_pattern_.var_case.attr_arg,
    _Assignment_pattern_.var_case.method_call_arg,
    _Assignment_pattern_.var_case.obj_creation_arg,

    _Assignment_pattern_.attr_case.number_arg,
    _Assignment_pattern_.attr_case.var_arg,
    _Assignment_pattern_.attr_case.attr_arg,
    _Assignment_pattern_.attr_case.method_call_arg,
    _Assignment_pattern_.attr_case.obj_creation_arg
}


---Recebe uma string contendo vários statements e retira
---o primeiro deles, baseado no padrão informado
---@param statements string
---@param pattern string
---@return string
local function pop_statement(statements, pattern)
    -- A função gsub substitui as ocorrências do
    -- padrão encontrado por uma string, nesse caso a string vazia, 
    -- o parâmetro 1 garante que isso só será feito para a 
    -- primeira ocorrência
    return (statements:gsub(pattern, "", 1))
end


---Analisa sintaticamente cada statement do method body
---e retorna uma tabela contendo cada um deles
---@param method_body_string string
---@return table
local function parse_method(method_body_string)
    local current_pattern, next_stmts, match
    local method_statements = {}

    if type(method_body_string) ~= "string" then
        Error("Invalid method body")
    end

    next_stmts = method_body_string

    while true do
        if next_stmts == "" then
            break
        end

        -- Testa o vetor de padrões
        for i = 1, #statements_patterns do
            current_pattern = statements_patterns[i]
            match = next_stmts:match("^" .. current_pattern .. "\n")
            if match then break end
        end

        if not match then
            Error("Syntax error")
        end

        table.insert(method_statements, Trim(match))

        next_stmts = pop_statement(next_stmts, current_pattern)
    end

    return method_statements
end


-- Main
local method_body = [==[
className.method()
    i = 10
    varA = varB
    a = b.c
    obj = new className
    temp = cls.met()

    cls.attr = 10
    cls.attr = varB
    cls.attr = b.c
    cls.attr = new className
    cls.attr = cls.met() 

    var._prototype = obj
    className.attribute = tempOne / tempTwo
    obj.met._replace(5): x = Class.Met()

    if a eq b then
        x = y
        className.method()
    else
        y = a + b  
        var._prototype = obj
    end-if

    a = x * y
    return x
]==]

local method_statements = parse_method(method_body)

print("Method Body:")
for k, v in ipairs(method_statements) do
    print(k, v)
end