require "patterns"
require "utils"

function parser_io(lexer)
  -- body
end

function Parser_arg_var(name)
  if name == nil then
    Error("Erro em Parser_arg_var: Name não informado")
    return
  end
  return { var_name = name }
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
  
  if match then
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

parser_if_test()
