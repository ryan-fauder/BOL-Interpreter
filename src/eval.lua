require "env"
require "describer"
require "types"

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

  local method_env = Env:new()
  
  local obj = env:getVar(obj_name)
  method_env:setVar("self", obj)

  --local method_buffer = describer:getMethodBuffer(obj.class.name, method_name)
  if(method_buffer == nil) then
    -- search in prototype
  end
  


  local return_value = Method_interpreter(method_env, method_buffer)

  return return_value
end
