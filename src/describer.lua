require "patterns"
require "args"
require "reader"

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
    name = nil,
    attr = {},
    methods = {},
    _prototype = nil
  }

  local index = 1

  local name = class_block[index]:match(_Class_def_begin_pattern_)

  if not name then
    Error("Erro em Describer:set_class: esperado nome de classe na linha:\n" .. class_block[index])
  end

  described_class_table.name = name

  index = index + 1 -- avança para a linha de atributos da classe ou começo de método

  local attrs_keyword, attrs = class_block[index]:match("^[%s]*([%l]+)[%s]+(.-)[%s]*$")
  print(attrs_keyword, attrs)
  if attrs_keyword ~= nil and attrs_keyword == "vars" then
    described_class_table.attr = Arg_var_list(attrs)

    index = index + 1 -- avança para a linha do method

  elseif attrs_keyword == nil then
    Error("Erro em Describer:set_class: Esperado uma declaração de atributos ou início de método na linha:\n" .. class_block[index])
  end

  -- Seção de leitura dos métodos da classe
  local method_block
  local class_block_size = #class_block

  local match = class_block[index]:match("[%s]*method[%s]+([%a]+)%(.-%)[%s]*")

  while match do
    method_block, index = Read_method_block(class_block, index)

    described_class_table.methods[match] = Describer:set_method(method_block)

    if index > class_block_size then
      break
    end

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

  local name, params = method_block[i]:match("^[%s]*method[%s]+([%a]+)%((.-)%)[%s]*$")

  described_method_table.name = name

  described_method_table.params = Arg_var_list(params)

  i = i + 1 -- avança para a linha de vars ou begin, caso não tenha vars

  local vars_keyword, vars = method_block[i]:match("^[%s]*([%l]+)[%s]+(.-)[%s]*$")

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