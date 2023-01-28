require "env"
require "parser"
require "types"
require "utils"
require "eval"
require "parser-test"
require "types-test"

local obj1 = ClassVar:new(nil, "person", Class_table1, Class_table1.methods)
local obj2 = ClassVar:new(nil, "account", Class_table2, Class_table2.methods)
local number_var1 = NumberVar:new(nil, "first", 12)
local number_var2 = NumberVar:new(nil, "second", 12)

if obj1 == nil then return end
if obj2 == nil then return end
if number_var1 == nil then return end
if number_var2 == nil then return end

local env = Env:new()
env:set_var(obj1.name, obj1)
env:set_var(obj2.name, obj2)
env:set_var(number_var1.name, number_var1)
env:set_var(number_var2.name, number_var2)


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
    Eval_meta_action(env, ast) -- method_table

    print("==== After ====")
    Print_table(method_table)
end

function Test_eval_binary_operation()
    local ast = Test_parser_assign()
    Print_table(ast.rhs)
    ast.rhs.arg.var_name = "VAR"
    local result = Eval_binary_operation(env, ast.rhs)
    if result == nil then return end
    Print_table(result)
end

function Test_eval_method_call()
    local ast = Test_parser_method_call()
    Eval_method_call(env, ast)
end

function Test_eval_if()
    local ast = Test_parser_if()
    Eval_if(env, ast)
end

-- Test_eval_method_call()
-- Test_eval_assign()
-- Test_eval_if()
-- Test_eval_binary_operation()
-- Test_eval_vars_def()
-- Test_eval_return()
-- Test_eval_meta_action()
