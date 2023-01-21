require "env"
require "parser"
require "types"
require "utils"
require "eval"
require "parser-test"
require "types-test"

local obj1 = ClassVar:new(nil, "person", Class_table1, Class_table1.methods)
local obj2 = ClassVar:new(nil, "account", Class_table2, Class_table2.methods)
local number_var1 = NumberVar:new(nil, "number", 124)

local env = Env:new()
env:setVar(obj1.name, obj1)
env:setVar(obj2.name, obj2)
env:setVar(number_var1.name, number_var1)


function Test_eval_vars_def()
  local ast = Test_parser_vars_def()
  Eval_vars_def(env, ast)
  env:print()
end


function Test_eval_prototype()
  local ast = Test_parser_prototype()
  Eval_prototype(env, ast)
  env:print()
end


function Test_eval_return()
  local ast = Test_parser_return()
  local value = Eval_return(env, ast)
  Print_table(value)
end


function Test_eval_meta_action()
  local method_table = Class_table1.methods.getAge.body
  print("==== Before ====")
  Print_table(method_table)

  local ast = Test_parser_meta_action()
  Eval_meta_action(env, ast, method_table)

  print("==== After ====")
  Print_table(method_table)
end


-- Test_eval_vars_def()
-- Test_eval_return()
Test_eval_meta_action()