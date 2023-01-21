function Arg_var_list(vars_string)
  local var_list = {}
  if (type(vars_string) == nil) then
    Error("Erro em Arg_var_list: Vars_string está vazio")
    return {}
  end
  
  if (type(vars_string) ~= "string") then
    Error("Erro em Arg_var_list: Vars_string não é uma string")
    return {}
  end
  
  for var in string.gmatch(vars_string, _Variable_def_pattern_) do
    table.insert(var_list, var)
    vars_string = Pop_statement(vars_string, _Variable_def_pattern_)
  end
  
  if (vars_string == nil) then
    Error("Erro em Arg_var_list: Vars inválido")
    return {}
  end

  local var = string.match(vars_string, "^" .. _Variable_Last_def_pattern_ .. "$")

  if (var == nil) then
    Error("Erro em Arg_var_list: Vars inválido")
    return {}
  end

  table.insert(var_list, var)

  return var_list
end


function Arg_method_call(var_name, method_name, params)
  if (var_name == nil) then
    Error("Erro em Arg_method_call: Var_name não informado")
    return
  end
  if (method_name == nil) then
    Error("Erro em Arg_method_call: Method_name não informado")
    return
  end
  if (type(params) ~= "table") then
    Error("Erro em Arg_method_call: Name não informado")
    return
  end
  return { var_name = var_name, method_name = method_name, params = params }
end


function Arg_var(name)
  if name == nil then
    Error("Erro em Arg_var: Name não informado")
    return
  end
  return { var_name = name }
end


function Arg_attr(var_name, attr_name)
  if var_name == nil or attr_name == nil then
    Error("Erro em Arg_var: Parâmetro nulo informado")
    return
  end
  return { var_name = var_name, attr_name = attr_name }
end


function Arg_obj_creation(class_name)
  if class_name == nil then
    Error("Erro em Arg_obj_creation: Class_name não informado")
    return
  end
  return { class_name = class_name }
end


function Arg_number(number)
  if number == nil then
    Error("Erro em Arg_number: Number não informado")
    return
  end
  return { value = number }
end


function Arg_binary_operation(first_var, second_var, operator)
  if first_var == nil or second_var == nil or operator == nil then
    Error("Erro em Arg_bin: Parâmetro nulo informado")
    return
  end

  return { first_var = first_var, second_var = second_var, operator = operator }
end
