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

function Test_parser_if()
  print("======= Test_parser_if =======")
  local types, current_pattern, match, ast
  types, current_pattern = table.unpack(Statements_patterns[5])
  print("IF TEST")
  match = { if_body:match("^" .. current_pattern .. "\n") }

  if #match >= 1 then
    ast = Parser_if({ types = types, tokens = match })
    Print_table(ast)
  end

  print("IF-ELSE TEST")
  match = { if_else_body:match("^" .. current_pattern .. "\n") }

  if match then
    ast = Parser_if({ types = types, tokens = match })
    Print_table(ast)
  else
    print("NO MATCH")
  end

  print("======= END: Test_parser_if =======")
  return ast
end

function Test_arg_var_list()
  print("======= Test_arg_var_list =======")
  local match, ast
  local vars_string = "vars a, b, c\n"

  match = { vars_string:match("^" .. _Variables_def_pattern_ .. "\n") }
  if #match >= 1 then
    ast = Arg_var_list(match[1])
    Print_table(ast)
  else
    print("NO MATCH")
  end
  
  print("======= END: Test_arg_var_list =======")
  return ast
end

function Test_parser_method_call()
  print("======= Test_parser_method_call =======")
  local match, types, pattern, ast

  local method_call_string = "variable.methodo(abedecadara, b, c)\n"
  local method_call_string = "io.print(var)\n"

  types, pattern = table.unpack(Statements_patterns[1])
  match = { method_call_string:match("^" .. pattern .. "\n") }

  if #match >= 1 then
    ast = Parser_method_call({ types = types, tokens = match })
    Print_table(ast)
  else
    print("NO MATCH")
  end
  
  print("======= END: Test_parser_method_call =======")
  return ast
end

function Test_parser_return()
  print("======= Test_parser_return =======")
  local match, types, pattern, ast

  local method_call_string = "return number\n"

  types, pattern = table.unpack(Statements_patterns[4])
  match = { method_call_string:match("^" .. pattern .. "\n") }

  if #match >= 1 then
    ast = Parser_return({ types = types, tokens = match })
    Print_table(ast)
  else
    print("NO MATCH")
  end
  
  print("======= END: Test_parser_return =======")
  return ast
end

function Test_parser_prototype()
  print("======= Test_parser_prototype =======")
  local match, types, pattern, ast

  local prototype_string = "account._prototype = person\n"

  types, pattern = table.unpack(Statements_patterns[3])
  match = { prototype_string:match("^" .. pattern .. "\n") }

  if #match >= 1 then
    ast = Parser_prototype({ types = types, tokens = match })
    Print_table(ast)
  else
    print("NO MATCH")
  end

  print("======= END: Test_parser_prototype =======")
  return ast
end

function Test_parser_meta_action()
  print("======= Test_parser_meta_action =======")
  local match, types, pattern, ast

  local meta_action_string = "class.getAge._replace(2):   Testing   \n"

  types, pattern = table.unpack(Statements_patterns[2])
  match = { meta_action_string:match("^" .. pattern .. "\n") }

  if #match >= 1 then
    ast = Parser_meta_action({ types = types, tokens = match })
    Print_table(ast)
  else
    print("NO MATCH")
  end
  print("======= END: Test_parser_meta_action =======")
  return ast
end

function Test_parser_vars_def()
  
  print("======= Test_parser_vars_def =======")
  local match, ast

  local vars_string = "vars a, b, c\n"

  match = { vars_string:match("^" .. _Variables_def_pattern_ .. "\n") }
  
  if #match >= 1 then
    ast = Parser_vars_def({types={type="vars_def"}, tokens=match})
    Print_table(ast)
  else
    print("NO MATCH")
  end
  
  print("======= END: Test_parser_vars_def =======")
  return ast
end

function Test_parser_assign()
  print("======= Test_parser_assign =======")
  local match
  local types, pattern, tokens, ast
  
  local vars_string = "var.att = 10\n"

  for index, pattern_info in ipairs(Statements_patterns) do
    types, pattern = table.unpack(pattern_info)
    tokens = {vars_string:match("^" .. pattern .. "\n")}
    if #tokens >= 1 then
      ast = Parser_assign({types=types, tokens=tokens})
      Print_table(ast)
    else
      print("NO MATCH")
    end
  end

  print("======= END - Test_parser_assign =======")
  return ast
end

-- Test_parser_assign()
-- Test_parser_vars_def()
-- Test_parser_if()
-- Test_parser_method_call()
-- Test_parser_prototype()
-- Test_parser_return()
-- Test_arg_var_list()
