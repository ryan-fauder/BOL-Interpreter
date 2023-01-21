require "env"
require "parser"
require "types"
require "utils"
require "eval"
require "parser-test"

function Test_eval_vars_def()
  local env = Env:new()

  local ast = Test_parser_vars_def()
  Eval_vars_def(env, ast)
  env:print()
end
Test_eval_vars_def()