require "patterns"
require "args"

require "utils"

local Describer = {
  classes = {},
  main = nil
}


function Get_describer()
  return Describer
end


function Describer:set_class(class_block)
  local described_class_table = {
    attr = {},
    methods = {},
    _prototype = nil
  }

  local method_block
  local index = 1
  local match = class_block[index]:match("[%s]*method[%s]+([%a]+)%(.-%)[%s]*")

  while match do
    method_block, index = Read_method_block(class_block, index)

    table.insert(described_class_table.methods, match, self.set_method(method_block))
    
    match = class_block[index]:match("[%s]*method[%s]+([%a]+)%(.-%)[%s]*")
  end

  return described_class_table
end


function Describer:get_class()
  
end


function Describer:set_method(method_block)

  local described_method_table = {
    name = nil,
    params = nil,
    vars = nil,
    body = {}
  }

  local i = 1

  local name, params = method_block[i]:match("^[%s]*method[%s]+([%a]+)%((.-)%)[%s]*$") -- verificar se é necessário mudar essa regex em "patterns", incluído '^' e '$'

  described_method_table.name = name

  described_method_table.params = Arg_var_list(params)

  i = i + 1 -- avança para a linha de vars ou begin, caso não tenha vars

  local vars_keyword, vars = method_block[i]:match("^[%s]*([%l]+)[%s]+(.-)[%s]*$") -- verificar se é necessário mudar essa regex em "patterns", incluído '^' e '$'

  if vars_keyword ~= nil and vars_keyword < "vars" or vars_keyword > "vars" then
    Error("Erro em Describer:set_method: Esperado 'vars', lido " .. "'" .. vars_keyword .. "'")
  else
    described_method_table.vars = Arg_var_list(vars)

    i = i + 1 -- avança para a linha do begin
  end

  if not method_block[i]:match(_Method_body_begin_pattern_) then
    Error("Erro em Describer:set_method: Esperado um 'begin' na funcao " .. "'" .. name .. "'")
  end

  i = i + 1 -- avança para a primeira linha do method-body

  local method_body = { table.unpack(method_block, i, #method_block - 1) }

  described_method_table.body = method_body

  return described_method_table
end


function Describer:get_method()
  
end