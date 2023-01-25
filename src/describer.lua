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


function Describer:insert_main(main_block)

  Describer.main = { table.unpack(main_block, 2, #main_block - 1) }

end


function Describer:insert_class(class_block)

  local described_class_table = Describer:describe_class(class_block)

  Describer.classes[described_class_table.name] = described_class_table

end


function Describer:describe_class(class_block)

  local described_class_table = {
    name = nil,
    attr = {},
    methods = {}
  }

  local index = 1

  local name = class_block[index]:match(_Class_def_begin_pattern_)

  if not name then
    Error("Erro em Describer:set_class: esperado nome de classe na linha:\n" .. class_block[index])
  end

  described_class_table.name = name

  index = index + 1 -- avança para a linha de atributos da classe ou começo de método

  local attrs_keyword, attrs = class_block[index]:match("^[%s]*([%l]+)[%s]+(.-)[%s]*$")
  
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

    described_class_table.methods[match] = Describer:describe_method(method_block)

    if index > class_block_size then
      break
    end

    match = class_block[index]:match("[%s]*method[%s]+([%a]+)%(.-%)[%s]*")
  end

  return described_class_table
end


--- func desc
---@param class_name string
function Describer:get_class(class_name)
  return self.classes[class_name]
end


local function method_dump(method_table)

  if method_table then
    local string_method_header = "  method " .. method_table.name .. "("
    
    if #method_table.params >= 1 then
      for i = 1, #method_table.params - 1 do
        string_method_header = string_method_header .. method_table.params[i] .. ", "
      end

      string_method_header = string_method_header .. method_table.params[#method_table.params]
    end

    string_method_header = string_method_header .. ")"

    print(string_method_header)

    if #method_table.vars >= 1 then
      local vars_string = "  vars "
  
      for i = 1, #method_table.vars - 1 do
        vars_string = vars_string .. method_table.vars[i] .. ", "
      end
  
      vars_string = vars_string .. method_table.vars[#method_table.vars]
  
      print(vars_string)
  
    end

    print("  begin")
    for i = 1, #method_table.body do
      print("    " .. method_table.body[i])
    end
    print("  end-method")

  end

end


function Describer:class_dump(class_name)

  local class = Describer.classes[class_name]

  print("class " .. class.name)

  if #class.attr >= 1 then
    local vars_string = "  vars "

    for i = 1, #class.attr - 1 do
      vars_string = vars_string .. class.attr[i] .. ", "
    end

    vars_string = vars_string .. class.attr[#class.attr]

    print(vars_string)

  end

  print("")
  for key, method in pairs(class.methods) do
    method_dump(method)
    print("")
  end

  print("end-class")

end


function Describer:describe_method(method_block)

  local described_method_table = {
    name = nil,
    params = {},
    vars = {},
    body = {}
  }

  local i = 1

  local name, params = method_block[i]:match("^[%s]*method[%s]+([%a]+)%((.-)%)[%s]*$")


  described_method_table.name = name

  described_method_table.params = Arg_var_list(params)

  i = i + 1 -- avança para a linha de vars ou begin, caso não tenha vars

  local vars_keyword, vars = method_block[i]:match("^[%s]*([%l]+)[%s]+(.-)[%s]*$")

  if vars_keyword ~= nil and (vars_keyword < "vars" or vars_keyword > "vars") then
    Error("Erro em Describer:set_method: Esperado 'vars', lido " .. "'" .. vars_keyword .. "'")
  elseif vars_keyword == "vars" then
    
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


function Describer:get_method(class_name, method_name)
  return self.classes[class_name].methods[method_name]
end

---Função que transforma uma tabela de strings em uma única string com '\n' como separador.
---@param string_table table <string>
---@return string
function Describer:string_table_to_string(string_table)

  local result_string

  if not string_table then
    Error("Tabela de string passada é nula.")
  end

  result_string = string_table[1]

  if #string_table > 1 then

    for i = 2, #string_table do
      result_string = result_string .. "\n" .. string_table[i]
    end
  end
  
  result_string = result_string .. "\n"
  
  return result_string
  
end