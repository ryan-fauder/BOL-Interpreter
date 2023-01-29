require "env"
require "describer"
require "types"
require "math"


--- Aplica uma declaração de variáveis conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table:
---- type: string
---- var_list: Arg_var_list
function Eval_vars_def(env, ast)
    local var = nil
    for index, var_name in ipairs(ast.var_list) do
        var = NumberVar:new(nil, var_name, 0)
        env:set_var(var_name, var)
    end
end


--- Aplica o método io.dump conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
--- ast:
---- arg: Arg_method_call {params}
function Eval_io_dump(env, ast)
    local var_name = ast.arg.params[1]
    local var = env:get_var(var_name)
    local describer = Get_describer()
    if var.type ~= "Class" then
        Error("Erro em Eval_io_dump: Variável " .. var_name .. " não é um objeto de uma classe")
        return
    end

    describer:class_dump(var.class.name)
end


--- Aplica o método io.print conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
--- ast:
---- arg: Arg_method_call {params}
function Eval_io_print(env, ast)
    local var_name = ast.arg.params[1]
    local var = env:get_var(var_name)
    if var.type ~= "Number" then
        Error("Erro em Eval_io_print: Variável " .. var_name .. " é não númerico")
        return
    end

    print(var.value)
end


--- Aplica uma chamada de método conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
---@return table|nil
--- ast:
---- type: string
---- arg: Arg_method_call {var_name, method_name, params: Arg_var_list}
function Eval_method_call(env, ast)
    local describer = Get_describer()

    local obj_name = ast.arg.var_name
    local method_name = ast.arg.method_name
    local params = ast.arg.params

    if obj_name == "io" then
        if method_name == "print" and #params == 1 then
            Eval_io_print(env, ast)
        elseif method_name == "dump" and #params == 1 then
            Eval_io_dump(env, ast)
        else
            Error("Error em Eval_method_call: Sintaxe inválida em método do objeto io")
        end
        return
    end

    local object = env:get_var(obj_name)

    local method_table = object:get_method(method_name)
    if method_table == nil then
        Error("Erro em Eval_method_call: Método" .. method_name .. "não existente em " .. obj_name)
        return
    end

    local method_buffer = describer:string_table_concat(method_table.body)

    local method_env = Env:new()
    method_env:set_var("self", object)

    if method_table.vars == nil then
        method_table.vars = {}
    end

    Eval_vars_def(method_env, { var_list = method_table.vars })

    if #params ~= #method_table.params then
        Error("Erro em Eval_method_call: Quantidade inválida de parâmetros na chamada do método " .. method_name)
        return
    end

    for index, var_name in ipairs(params) do
        local var = env:get_var(var_name)
        local param = var:copy(var_name)
        method_env:set_var(method_table.params[index], param)
    end

    local return_value = Block_executor(method_env, method_buffer, "method_executor", Parser_method_stmt)

    return return_value
end


--- Aplica uma operação binária conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
---@return table|nil
--- ast:
---- arg: {var_name, first_var, second_var, operator}
function Eval_binary_operation(env, ast)
    local first_var_name = ast.arg.first_var
    local second_var_name = ast.arg.second_var
    local operator = ast.arg.operator
    local operations_functions = {
        ["+"] = function(var1, var2) return (var1 + var2) end,
        ["-"] = function(var1, var2) return (var1 - var2) end,
        ["/"] = function(var1, var2)
            if var2 == 0 then
                Error("Erro em Eval_binary_operation: Divisão por zero")
            end
            return (var1 / var2)
        end,
        ["*"] = function(var1, var2) return (var1 * var2) end
    }

    local first_var = env:get_var(first_var_name)
    local second_var = env:get_var(second_var_name)

    if first_var.type ~= "Number" or second_var.type ~= "Number" then
        Error("Erro em Eval_binary_operation: Operação com valores não númericos")
        return
    end

    local operation_function = operations_functions[operator]

    if operation_function == nil then
        Error("Erro em Eval_binary_operation: Tipo de operação inválida")
        return
    end

    local result = math.floor(operation_function(first_var.value, second_var.value))
    local var = NumberVar:new(nil, ast.arg.var_name, result)

    return var
end


--- Aplica uma criação de objeto conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
---@return table|nil
function Eval_obj_creation(env, ast)
    local describer = Get_describer()
    local class_table = describer:get_class(ast.arg.class_name)
    return ClassVar:new(nil, ast.arg.var_name, class_table, class_table.methods)
end


--- Aplica uma declaração de variáveis conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
---@return table|nil: NumberVar or ClassVar
--- ast:
---- arg: Arg_Number | Arg_Var | Arg_Attr | Arg_Obj_Creation | Arg_Method_Call | Arg_Binary_Operation
function Eval_arg(env, ast)
    local arg = ast.arg
    local arg_var

    if ast.type == "number_arg" then
        local var_name = "Number var"
        arg_var = NumberVar:new(nil, var_name, arg.value)

    elseif ast.type == "var_arg" then
        arg_var = env:get_var(arg.var_name)

    elseif ast.type == "attr_arg" then
        local temp_var = env:get_var(arg.var_name)
        if temp_var.type ~= "Class" then
            Error("Erro em Eval_arg: Variável '" .. temp_var.name .. "' com atributo não é uma classe")
            return
        end
        arg_var = temp_var:find_attr(arg.attr_name)
        if arg_var == nil then
            Error("Erro em Eval_arg: Atributo '" ..
                arg.attr_name .. "' não existe em '" .. arg.var_name .. "'")
            return
        end

    elseif ast.type == "method_call_arg" then
        arg_var = Eval_method_call(env, ast)
        if arg_var == nil then
            Error("Erro em Eval_arg: Retorno de método vazio")
            return
        end

    elseif ast.type == "obj_creation_arg" then
        ast.arg.var_name = arg.class_name .. " object"
        arg_var = Eval_obj_creation(env, ast)

    elseif ast.type == "binary_operation_arg" then
        ast.arg.var_name = "Binary var"
        arg_var = Eval_binary_operation(env, ast)

    else
        Error("Erro em Eval_arg: Tipo de arg não reconhecido")
        return {}
    end

    return arg_var
end



--- Aplica uma atribuição conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table:
---- type: string
---- lhs: {type: string, arg: Arg_var | Arg_attr }
---- rhs: {type: string, arg: Arg_Number | Arg_Var | Arg_Attr | Arg_Obj_Creation | Arg_Method_Call}
function Eval_assign(env, ast)
    local lhs = ast.lhs
    local rhs = ast.rhs
    local lhs_var = Eval_arg(env, lhs)
    local rhs_var_copy = Eval_arg(env, rhs)

    if lhs_var == nil or rhs_var_copy == nil then
        Error("Error em Eval_assign: Alguma variável de atribuição não foi reconhecida")
        return
    end

    local rhs_var = rhs_var_copy:copy(lhs_var.name)
    rhs_var.name = lhs_var.name

    if rhs.type == "attr_arg" then
        local attr = rhs.arg.attr_name
        rhs_var = rhs_var.attr[attr]
    end

    if lhs.type == "var_arg" then
        env:set_var(lhs.arg.var_name, rhs_var)
    elseif lhs.type == "attr_arg" then
        lhs_var:set_attr(lhs.arg.attr_name, rhs_var)
    end

end


--- Aplica uma meta-ação conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table:
---- type: string
---- action_type: string
---- str_no_nl: string
---- arg: Arg_Method_Call {var_name, method_name, params: line_number}
function Eval_meta_action(env, ast)
    local class_name = ast.arg.var_name
    local method_name = ast.arg.method_name
    local line_number = ast.arg.params.line_number
    local str_no_nl = ast.str_no_nl
    local action_type = ast.action_type

    local describer = Get_describer()
    local method_table = describer:get_method(class_name, method_name)
    local method_body_table = method_table.body

    if line_number < 0 or line_number > #method_body_table + 1 then
        Error("Erro em Eval_meta_action: Número de linha inválido")
    end

    str_no_nl = Trim(str_no_nl)

    if action_type == "_insert" and str_no_nl ~= "" then
        if line_number == 0
            then line_number = #method_body_table + 1
        end
        table.insert(method_body_table, line_number, str_no_nl)

    elseif action_type == "_delete" and line_number > 0 and
        line_number <= #method_body_table and str_no_nl == "" then
        table.remove(method_body_table, line_number)

    elseif action_type == "_replace" and line_number > 0 and
        str_no_nl ~= "" and line_number <= #method_body_table then
        method_body_table[line_number] = str_no_nl

    else
        Error("Erro em Eval_meta_action: Meta-ação inválida")
    end

end


--- Aplica um retorno conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
---@return table
function Eval_return(env, ast)
    local var_name = ast.arg.var_name
    local return_value = env:get_var(var_name)
    return return_value
end


--- Aplica uma declaração de variáveis conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
--- Ast:
---- { type: string, lhs: Arg_var {var_name}. rhs: Arg_var {var_name}}
function Eval_prototype(env, ast)
    local lhs_obj_name = ast.lhs.var_name
    local rhs_obj_name = ast.rhs.var_name

    if lhs_obj_name == rhs_obj_name then
        Error("Erro em Eval_prototype: Objeto não pode referenciar a si próprio")
    end

    local lhs_obj = env:get_var(lhs_obj_name)
    local rhs_obj = env:get_var(rhs_obj_name)

    lhs_obj._prototype = rhs_obj
end


--- Aplica um if ou if-else conforme a AST (Abstract Syntax Tree)
---@param env table
---@param ast table
---@return table|nil
--- ast:
---- type: string
---- lhs: Arg_var
---- rhs: Arg_var
---- cmp: string
---- if_block: string
---- else_block: string
function Eval_if(env, ast)
    local lhs = ast.lhs
    local rhs = ast.rhs
    local cmp = ast.cmp

    local condition_result = nil

    local lhs_var = env:get_var(lhs.var_name)
    local rhs_var = env:get_var(rhs.var_name)
    local cmp_functions = {
        eq = function(var1, var2) return (var1 == var2) end,
        ne = function(var1, var2) return (var1 ~= var2) end,
        gt = function(var1, var2) return (var1 > var2) end,
        ge = function(var1, var2) return (var1 >= var2) end,
        lt = function(var1, var2) return (var1 < var2) end,
        le = function(var1, var2) return (var1 <= var2) end
    }

    if lhs_var.type ~= "Number" or rhs_var.type ~= "Number" then
        Error("Erro em Eval_if: Comparação com valores não númericos")
        return
    end

    local cmp_function = cmp_functions[cmp]
    if (cmp_function == nil) then
        Error("Erro em Eval_if: Tipo de comparação inválida")
        return
    end

    condition_result = cmp_function(lhs_var.value, rhs_var.value)

    local if_buffer = ast.if_block
    local else_buffer = ast.else_block

    if condition_result == true and if_buffer ~= nil then
        return Block_executor(env, if_buffer, "if_executor", Parser_if_stmt)
    elseif else_buffer ~= nil then
        return Block_executor(env, else_buffer, "if_executor", Parser_if_stmt)
    end

end


--- Seleciona o Eval de acordo com o tipo da AST (Abstract Syntax Tree)
---@param env table
---@param ast table
---@return table|nil
function Eval_controller(env, ast)
    local statement_type = ast.type

    if statement_type == "method_call" then
        Eval_method_call(env, ast)
    elseif statement_type == "assignment" then
        Eval_assign(env, ast)
    elseif statement_type == "meta_action" then
        Eval_meta_action(env, ast)
    elseif statement_type == "prototype" then
        Eval_prototype(env, ast)
    elseif statement_type == "return" then
        return Eval_return(env, ast)
    elseif statement_type == "if" then
        return Eval_if(env, ast)
    elseif statement_type == "vars_def" then
        Eval_vars_def(env, ast)
    else
        Error("Erro em Eval_controller: Declaração com sintaxe incorreta")
    end

end
