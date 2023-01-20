require "patterns"
require "utils"
require "args"
require "utils"
require "parser"

local if_else_body = [==[
  if a eq b then
      x = y
      className.method()
  else
      y = a + b  
      var._prototype = obj
  end-if
]==]

local if_body = [==[
  if a eq b then
      x = y
      className.method()
      y = a + b  
      var._prototype = obj
  end-if
]==]

local function parser_if_test()
  local types, current_pattern, match
  types, current_pattern = table.unpack(Statements_patterns[5])
  print("IF TEST")
  match = { if_body:match("^" .. current_pattern .. "\n") }

  if #match >= 1 then
    local ast = Parser_if({ types = types, tokens = match })
    Print_table(ast)
  end

  print("IF-ELSE TEST")
  match = { if_else_body:match("^" .. current_pattern .. "\n") }
  if match then
    local ast = Parser_if({ types = types, tokens = match })
    Print_table(ast)
  end
end

local function parser_var_list_test()
  local match
  local vars_string = "vars a, b, c\n"
  match = { vars_string:match("^" .. _Variables_def_pattern_ .. "\n") }
  Print_table(match)
  if #match >= 1 then
    local ast = Parser_var_list(match[1])
    Print_table(ast)
  end
end

local function parser_method_call_test()
  local match, types, pattern
  local method_call_string = "variable.methodo(abedecadara, b, c)\n"
  local method_call_string = "io.print(var)\n"
  types, pattern = table.unpack(Statements_patterns[1])
  match = { method_call_string:match("^" .. pattern .. "\n") }
  Print_table(match)
  if #match >= 1 then
    local ast = Parser_method_call({ types = types, tokens = match })
    Print_table(ast)
    Print_table(ast.arg)
    Print_table(ast.arg.params)
  end
end

local function parser_return_test()
  local match, types, pattern
  local method_call_string = "return x\n"
  types, pattern = table.unpack(Statements_patterns[4])
  match = { method_call_string:match("^" .. pattern .. "\n") }
  Print_table(match)
  if #match >= 1 then
    local ast = Parser_return({ types = types, tokens = match })
    Print_table(ast)
    Print_table(ast.arg)
  end

end

local function parser_prototype_test()
  local match, types, pattern
  local prototype_string = "obj._prototype =   object\n"
  types, pattern = table.unpack(Statements_patterns[3])
  match = { prototype_string:match("^" .. pattern .. "\n") }
  Print_table(match)
  if #match >= 1 then
    local ast = Parser_prototype({ types = types, tokens = match })
    Print_table(ast)
    Print_table(ast.rhs)
    Print_table(ast.lhs)
  end
end

local function parser_meta_action_test()
  local match, types, pattern
  local meta_action_string = "variable.methodo._delete(1):\n"
  types, pattern = table.unpack(Statements_patterns[2])
  match = { meta_action_string:match("^" .. pattern .. "\n") }
  Print_table(match)
  if #match >= 1 then
    local ast = Parser_meta_action({ types = types, tokens = match })
    Print_table(ast)
    Print_table(ast.arg)
    Print_table(ast.arg.params)
  end
end

-- parser_meta_action_test()
-- parser_if_test()
-- parser_method_call_test()
-- parser_prototype_test()
-- parser_return_test()
-- parser_var_list_test()
