function Parser_var_list(vars_string)
  local var_list = {}

  if (type(vars_string) == nil) then
    Error("Erro em Parser_var_list: Vars_string está vazio")
    return {}
  end

  if (type(vars_string) ~= "string") then
    Error("Erro em Parser_var_list: Vars_string não é uma string")
    return {}
  end

  for var in string.gmatch(vars_string, _Variable_def_pattern_) do
    table.insert(var_list, var)
    vars_string = Pop_statement(vars_string, _Variable_def_pattern_)
  end

  if (vars_string == nil) then
    Error("Erro em Parser_var_list: Vars inválido")
    return {}
  end

  local var = string.match(vars_string, "^" .. _Variable_Last_def_pattern_ .. "$")

  if (var == nil) then
    Error("Erro em Parser_var_list: Vars inválido")
    return {}
  end

  table.insert(var_list, var)

  return var_list
end

function Parser_arg_method_call(var_name, method_name, vars_list)
  if (var_name == nil) then
    Error("Erro em Parser_arg_method_call: Var_name não informado")
    return
  end
  if (method_name == nil) then
    Error("Erro em Parser_arg_method_call: Method_name não informado")
    return
  end
  if (type(vars_list) ~= "table") then
    Error("Erro em Parser_arg_method_call: Name não informado")
    return
  end
  return { var_name = var_name, method_name = method_name, params = vars_list }
end

function Parser_arg_var(name)
  if name == nil then
    Error("Erro em Parser_arg_var: Name não informado")
    return
  end
  return { var_name = name }
end
