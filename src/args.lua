function Parser_arg_method_call(var_name, method_name, vars_list)
  if(var_name == nil) then
    Error("Erro em Parser_arg_var: Name não informado")
    return
  end
  if(method_name == nil) then
    Error("Erro em Parser_arg_var: Name não informado")
    return
  end
  if(type(vars_list)~= "table") then
    Error("Erro em Parser_arg_var: Name não informado")
    return
  end
  return {var_name = var_name, method_name = method_name, vars_list = vars_list}
end

function Parser_arg_var(name)
  if name == nil then
    Error("Erro em Parser_arg_var: Name não informado")
    return
  end
  return { var_name = name }
end
