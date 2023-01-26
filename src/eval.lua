require "env"
require "describer"
require "types"
require "math"


function Eval_vars_def(env, ast)
  local var = nil
  for index, var_name in ipairs(ast.var_list) do
    var = NumberVar:new(nil, var_name, 0)
    env:setVar(var_name, var)
  end
end


function Eval_io_dump(env, ast)
  local var_name = ast.arg.params[1]
  local var = env:getVar(var_name)
  local describer = Get_describer()
  if var.type ~= "Class" then
    Error("Erro em Eval_io_dump: Variável " .. var_name .. " não é um objeto de uma classe")
    return
  end

  describer:class_dump(var.class.name)
end


function Eval_io_print(env, ast)
  local var_name = ast.arg.params[1]
  local var = env:getVar(var_name)
  if var.type ~= "Number" then
    Error("Erro em Eval_io_print: Variável " .. var_name .. " é não númerico")
    return
  end

  print(var.value)
end


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

  local object = env:getVar(obj_name)

  local method_table = object:get_method(method_name)
  if method_table == nil then
    Error("Erro em Eval_method_call: Método" .. method_name .. "não existente em " .. obj_name)
    return
  end

  local method_buffer = describer:string_table_to_string(method_table.body)
  
  local method_env = Env:new()
  method_env:setVar("self", object)

  if(method_table.vars == nil) then
    method_table.vars = {}
  end

  Eval_vars_def(method_env, {var_list = method_table.vars})

  if #params ~= #method_table.params then
    Error("Erro em Eval_method_call: Quantidade inválida de parâmetros na chamada do método " .. method_name)
    return
  end

  for index, var_name in ipairs(params) do
    local var = env:getVar(var_name)
    method_env:setVar(method_table.params[index], var)
  end
  local return_value = Method_interpreter(method_env, method_buffer)
  return return_value
end


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

  local first_var = env:getVar(first_var_name)
  local second_var = env:getVar(second_var_name)

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


function Eval_obj_creation(env, ast)
  local describer = Get_describer()
  local class_table = describer:get_class(ast.arg.class_name)
  return ClassVar:new(nil, ast.arg.obj_name, class_table, class_table.methods)
end


function Eval_assign(env, ast)
  local lhs_var, rhs_var
  local lhs = ast.lhs
  local rhs = ast.rhs

  local var = env:getVar(lhs.arg.var_name)
  if lhs.type == "var_case" then
    lhs_var = var
  elseif lhs.type == "attr_case" then
    lhs_var = var:get_attr(lhs.arg.attr_name)
    if lhs_var == nil then
      Error("Erro em Parser_assign: Atributo '"..lhs.arg.attr_name .."' não existe em '" .. lhs.arg.var_name .. "'")
      return
    end
  end

  if rhs.type == "number_arg" then
    rhs_var = NumberVar:new(nil, lhs_var.name, rhs.arg.value)

  elseif rhs.type == "var_arg" then
    local temp_var = env:getVar(rhs.arg.var_name)
    rhs_var = temp_var:copy(lhs_var.name)

  elseif rhs.type == "attr_arg" then
    local temp_var = env:getVar(rhs.arg.var_name)
    local rhs_attr = temp_var:get_attr(rhs.arg.attr_name)

    if rhs_attr == nil then
      Error("Erro em Parser_assign: Atributo '"..rhs.arg.attr_name .."' não existe em '" .. rhs.arg.var_name .. "'")
      return
    end

    rhs_var = rhs_attr:copy(lhs_var.name)

  elseif rhs.type == "method_call_arg" then
    local temp_var = Eval_method_call(env, ast.rhs)
    if temp_var == nil then
      Error("Erro em Parser_assign: Retorno de método vazio")
      return
    end
    rhs_var = temp_var:copy(lhs_var.name)

  elseif rhs.type == "obj_creation_arg" then
    ast.rhs.arg.obj_name = lhs_var.name
    rhs_var = Eval_obj_creation(env, ast.rhs)

  elseif rhs.type == "binary_operation_arg" then
    ast.rhs.arg.var_name = lhs_var.name
    rhs_var = Eval_binary_operation(env, ast.rhs)
  else
    Error("Erro em Parser_assign: Tipo de rhs não reconhecido")
    return {}
  end
  
  if lhs.type == "var_case" then
    env:setVar(lhs_var.name, rhs_var)
  elseif lhs.type == "attr_case" then
    var:set_attr(lhs.arg.attr_name, rhs_var)
  end

end


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
    if line_number == 0 then line_number = #method_body_table + 1 end
    table.insert(method_body_table, line_number, str_no_nl)

  elseif action_type == "_delete" and line_number > 0 and
      line_number <= #method_body_table then
    table.remove(method_body_table, line_number)

  elseif action_type == "_replace" and line_number > 0 and
      str_no_nl ~= "" and line_number <= #method_body_table then
        method_body_table[line_number] = str_no_nl

  else
    Error("Erro em Eval_meta_action: Meta-ação inválida")
  end

end


function Eval_return(env, ast)
  local var_name = ast.arg.var_name
  local return_value = env:getVar(var_name)
  return return_value
end


function Eval_prototype(env, ast)
  local lhs_obj_name = ast.lhs.var_name
  local rhs_obj_name = ast.rhs.var_name

  if lhs_obj_name == rhs_obj_name then
    Error("Erro em Eval_prototype: Objeto não pode referenciar a si próprio")
  end

  local lhs_obj = env:getVar(lhs_obj_name)
  local rhs_obj = env:getVar(rhs_obj_name)

  lhs_obj._prototype = rhs_obj
end


function Eval_if(env, ast)
  local lhs = ast.lhs
  local rhs = ast.rhs
  local cmp = ast.cmp

  local condition_result = nil

  local lhs_var = env:getVar(lhs.var_name)
  local rhs_var = env:getVar(rhs.var_name)
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
    return If_interpreter(env, if_buffer)
  elseif else_buffer ~= nil then
    return If_interpreter(env, else_buffer)
  end

end


function Eval_controller(env, ast)
  local statement_type = ast.type
  if statement_type == "method_call" then
    return Eval_method_call(env, ast)
  elseif statement_type == "assignment" then
    return Eval_assign(env, ast)
  elseif statement_type == "meta_action" then
    return Eval_meta_action(env, ast)
  elseif statement_type == "prototype" then
    return Eval_prototype(env, ast)
  elseif statement_type == "return" then
    return Eval_return(env, ast)
  elseif statement_type == "if" then
    return Eval_if(env, ast)
  elseif statement_type == "vars_def" then
    return Eval_vars_def(env, ast)
  else
    Error("Erro em Eval_controller: Declaração com sintaxe incorreta")
  end

end
