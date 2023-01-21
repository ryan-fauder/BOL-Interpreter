require "env"
require "describer"
require "types"

-- || GENERAL ||
-- eval_controller
-- eval_attr
-- eval_bin_arg

function Eval_attr(env, ast)
  local lhs_var, rhs_var
  local lhs = ast.lhs
  local rhs = ast.rhs

  if lhs.type == "var_case" then
    lhs_var = env:getVar(lhs.name)
  elseif lhs.type == "attr_case" then
    local var = env:getVar(lhs.var_name)
    lhs_var = var:get_attr(lhs.attr_name)
  end

-- a = b
-- 

  if rhs.type == "number_arg" then
    lhs_var = NumberVar:new(nil, lhs_var.name, rhs.arg.number)
  elseif rhs.type == "var_arg" then
    rhs_var = env:getVar(rhs.arg.var_name)
    lhs_var = Clone(rhs_var)
  elseif rhs.type == "attr_arg" then

  elseif rhs.type == "method_call_arg" then
    Eval_method_call()
  elseif rhs.type == "obj_creation_arg" then
    
  elseif rhs.type == "binary_operation_arg" then
    
  else
    Error("Erro em Parser_assign: Tipo de rhs não reconhecido")
    return {}
  end

end


function Eval_io_dump(env, ast)
  local var_name = ast.arg.params
  local var = env:getVar(var_name)

  if var.type ~= "Class" then
    Error("Erro em Eval_io_dump: Variável "..var_name.." não é um objeto de uma classe")
    return
  end

  Describer:class_dump(var.class.name)
end


function Eval_io_print(env, ast)
  local var_name = ast.arg.params
  local var = env:getVar(var_name)

  if var.type ~= "Number" then
    Error("Erro em Eval_io_print: Variável "..var_name.." é não númerico")
    return
  end

  print(var.value)
end


function Eval_meta_action(env, ast, method_table)
  local class_name = ast.arg.var_name
  local method_name = ast.arg.method_name
  local line_number = ast.arg.params.line_number
  local str_no_nl = ast.str_no_nl
  local action_type = ast.action_type

  -- local describer = Describer:get_describer()
  -- local method_table = describer:get_method(class_name, method_name)

  if line_number < 0 or line_number > #method_table + 1 then
    Error("Erro em Eval_meta_action: Número de linha inválido")
  end

  str_no_nl = Trim(str_no_nl)

  if action_type == "_insert" and str_no_nl ~= "" then
    if line_number == 0 then line_number = #method_table + 1 end
    table.insert(method_table, line_number, str_no_nl)

  elseif action_type == "_delete" and line_number > 0 and
          line_number <= #method_table then
    table.remove(method_table, line_number)

  elseif action_type == "_replace" and line_number > 0 and
          str_no_nl ~= "" and line_number <= #method_table then
    method_table[line_number] = str_no_nl

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


function Eval_vars_def(env, ast)
  local var = nil
  for index, var_name in ipairs(ast.var_list) do
    var = NumberVar:new(nil, var_name, 0)
    env:setVar(var_name, var)
  end   
end


function Eval_method_call(env, ast)
  -- local describer = Describer:getDescriber()

  local obj_name = ast.arg.var_name
  local method_name = ast.arg.method_name
  local params = ast.arg.params
  
  
  local object = env:getVar(obj_name)
  
  local method_table = object:get_method(method_name)
  if method_table == nil then
    Error("Erro em Eval_method_call: Método".. method_name .."não existente em " ..obj_name)
    return
  end

  local method_buffer = describer:get_buffer_from(method_table)
  
  local method_env = Env:new()
  method_env:setVar("self", object)
  Eval_vars_def(method_env, method_table.vars)
   
  if(#params ~= #method_table.vars) then
    Error("Erro em Eval_method_call: Quantidade inválida de parâmetros na chamada do método "..method_name)
    return
  end

  for index, var_name in ipairs(params) do
    local var = env:getVar(var_name)
    method_env:setVar(method_table.params[index], var)
  end


  local return_value = Method_interpreter(method_env, method_buffer)
  return return_value
end


function Eval_if(env, ast)
  local lhs = ast.arg.lhs
  local rhs = ast.arg.rhs
  local cmp = ast.cmp

  local condition_result = nil

  local lhs_var = env:getVar(lhs.var_name)
  local rhs_var = env:getVar(rhs.var_name)
  local cmp_functions = {
    eq = function(var1, var2) return (var1 == var2) end,
    ne = function(var1, var2) return (var1 ~= var2) end,
    gt = function(var1, var2) return (var1 > var2)  end,
    ge = function(var1, var2) return (var1 >= var2) end,
    lt = function(var1, var2) return (var1 < var2)  end,
    le = function(var1, var2) return (var1 <= var2) end
  }

  if lhs_var.type ~= "Number" or rhs_var.type ~= "Number" then
    Error("Erro em Eval_if: Comparação com valores não númericos")
    return
  end

  local cmp_function = cmp_functions[cmp]
  if(cmp_function == nil) then
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
