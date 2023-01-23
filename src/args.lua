
--- Retorna uma ast para uma lista de variáveis
---@param vars_list_string string
---@return table {[index] : [var_name]}
function Arg_var_list(vars_list_string)
  local vars = {}

  if vars_list_string == "" then
    return {}
  end
  
  if type(vars_list_string) == nil then
    Error("Erro em Arg_var_list: vars_list_string está vazio")
    return {}
  end
  
  if type(vars_list_string) ~= "string" then
    Error("Erro em Arg_var_list: vars_list_string não é uma string")
    return {}
  end
  
  for var in string.gmatch(vars_list_string, _Variable_def_pattern_) do
    table.insert(vars, var)
    vars_list_string = Pop_statement(vars_list_string, _Variable_def_pattern_)
  end
  
  if vars_list_string == nil then
    Error("Erro em Arg_var_list: Vars inválido")
    return {}
  end
  
  local var = string.match(vars_list_string, "^" .. _Variable_Last_def_pattern_ .. "$")

  if var == nil then
    Error("Erro em Arg_var_list: Vars inválido")
    return {}
  end

  table.insert(vars, var)

  return vars
end

--- Retorna uma ast para uma chamada de método
---@param var_name string
---@param method_name string
---@param params table {[index]: [param_name]}
---@return table {var_name: string, method_name: string, params: table}
function Arg_method_call(var_name, method_name, params)

  if var_name == nil or method_name == nil then
    Error("Erro em Arg_method_call: Parâmetro nulo informado")
    return {}
  end
  
  if type(params) ~= "table" then
    Error("Erro em Arg_method_call: Name não informado")
    return {}
  end

  return { var_name = var_name, method_name = method_name, params = params }
end

--- Retorna um ast para o acesso a uma variável
---@param var_name string
---@return table {var_name: [var_name]}
function Arg_var(var_name)

  if var_name == nil then
    Error("Erro em Arg_var: Name não informado")
    return {}
  end

  return { var_name = var_name }
end

--- Retorna um ast para o acesso a um atributo de um objeto
---@param var_name string
---@param attr_name string
---@return table {var_name: [var_name], attr_name: [attr_name]}
function Arg_attr(var_name, attr_name)

  if var_name == nil or attr_name == nil then
    Error("Erro em Arg_var: Parâmetro nulo informado")
    return {}
  end

  return { var_name = var_name, attr_name = attr_name }
end

--- Retorna um ast para a criação de um objeto
---@param class_name string
---@return table {class_name: [class_name]}
function Arg_obj_creation(class_name)

  if class_name == nil then
    Error("Erro em Arg_obj_creation: Class_name não informado")
    return {}
  end

  return { class_name = class_name }
end

--- Retorna um ast para um número
---@param value string
---@return table {value: [tonumber(value)]}
function Arg_number(value)
  
  if type(value) ~= "string" then
    Error("Erro em Arg_number: Number não é uma string")
    return {}
  end
  
  return { value = tonumber(value) }
end

--- Retorna um ast para uma operação binária entre variáveis
---@param first_var string
---@param second_var string
---@param operator string
---@return table {first_var: [first_var], second_var: [second_var], operator: [operator]}
function Arg_binary_operation(first_var, second_var, operator)

  if first_var == nil or second_var == nil or operator == nil then
    Error("Erro em Arg_bin: Parâmetro nulo informado")
    return {}
  end

  return { first_var = first_var, second_var = second_var, operator = operator }
end
