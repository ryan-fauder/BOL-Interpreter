require "patterns"
require "utils"
require "args"
require "utils"

function Parser_meta_action(lexer)
  if (lexer == nil) then
    Error("Erro em Parser_meta_action: Lexer vazio")
    return {}
  end

  if (lexer.types.type ~= "meta_action") then
    Error("Erro em Parser_meta_action: Lexer não é do tipo 'meta_action'")
    return {}
  end

  if (#lexer.tokens < 5) then
    Error("Erro em Parser_meta_action: Tokens não suficientes no Lexer")
    return {}
  end


  local ast = {}
  local var_name, method_name, line_number

  var_name = lexer.tokens[1]
  method_name = lexer.tokens[2]
  line_number = { line_number = lexer.tokens[4] }

  ast.type = lexer.types.type
  ast.arg = Parser_arg_method_call(var_name, method_name, line_number)
  ast.action_type = lexer.tokens[3] or {}
  ast.str_no_nl = nil
  ast.str_no_nl = lexer.tokens[5]

  return ast
end

function Parser_prototype(lexer)
  if (lexer == nil) then
    Error("Erro em Parser_prototype: Lexer vazio")
    return {}
  end

  if (lexer.types.type ~= "prototype") then
    Error("Erro em Parser_prototype: Lexer não é do tipo 'prototype'")
    return {}
  end

  if (#lexer.tokens < 2) then
    Error("Erro em Parser_prototype: Tokens não suficientes no Lexer")
    return {}
  end

  local ast = {}
  local lhs_name, rhs_name
  lhs_name = Parser_arg_var(lexer.tokens[1])
  rhs_name = Parser_arg_var(lexer.tokens[2])
  ast.type = lexer.types.type
  ast.lhs = lhs_name
  ast.rhs = rhs_name

  return ast
end

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
