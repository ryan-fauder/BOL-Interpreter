require "patterns"
require "utils"
require "args"
require "utils"

function Parser_return(lexer)
  if (lexer == nil) then
    Error("Erro em Parser_return: Lexer vazio")
    return {}
  end

  if (lexer.types.type ~= "return") then
    Error("Erro em Parser_return: Lexer não é do tipo 'return'")
    return {}
  end

  if (#lexer.tokens < 1) then
    Error("Erro em Parser_return: Tokens não suficientes no Lexer")
    return {}
  end

  local ast = {}
  ast.type = lexer.types.type
  ast.arg = Parser_arg_var(lexer.tokens[1])

  return ast
end

function Parser_method_call(lexer)
  if (lexer == nil) then
    Error("Erro em Parser_method_call: Lexer vazio")
    return {}
  end

  if (lexer.types.type ~= "method_call") then
    Error("Erro em Parser_method_call: Lexer não é do tipo 'method_call'")
    return {}
  end

  if (#lexer.tokens < 3) then
    Error("Erro em Parser_method_call: Tokens não suficientes no Lexer")
    return {}
  end

  local ast = {}
  local var_name, method_name, vars_list
  var_name = lexer.tokens[1]
  method_name = lexer.tokens[2]
  vars_list = Parser_var_list(lexer.tokens[3])
  ast.type = lexer.types.type
  ast.arg = Parser_arg_method_call(var_name, method_name, vars_list)

  return ast
end

--- func desc
---@param lexer table
---@return table
function Parser_if(lexer)
  if (lexer == nil) then
    Error("Erro em Parser_if: Lexer vazio")
    return {}
  end

  if (lexer.types.type ~= "if") then
    Error("Erro em Parser_if: Lexer não é do tipo 'if'")
    return {}
  end

  if (#lexer.tokens < 4) then
    Error("Erro em Parser_if: Tokens não suficientes no Lexer")
    return {}
  end

  local if_block
  local ast = {}
  ast.type = lexer.types.type
  ast.lhs = Parser_arg_var(lexer.tokens[1]) or {}
  ast.rhs = Parser_arg_var(lexer.tokens[3]) or {}
  ast.cmp = lexer.tokens[2] or {}
  if_block = lexer.tokens[4] or {}


  if (if_block == nil) then
    Error("Erro em Parser_if: Lexer não possui o if_block")
    return {}
  end

  -- Checar se é um if-block ou um if-else-block
  local blocks = { if_block:match(_Else_pattern_) }
  if #blocks == 2 then
    -- É um bloco if-else-block
    ast.if_block = blocks[1]
    ast.else_block = blocks[2]
  else
    ast.if_block = if_block
  end

  return ast
end

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
  types, pattern = table.unpack(Statements_patterns[1])
  match = { method_call_string:match("^" .. pattern .. "\n") }
  Print_table(match)
  if #match >= 1 then
    local ast = Parser_method_call({ types = types, tokens = match })
    Print_table(ast)
    Print_table(ast.arg)
    Print_table(ast.arg.vars_list)
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

parser_return_test()
