require "patterns"

local Describer = {
  classes = {},
  main = nil
}


function Get_describer()
  return Describer
end


function Describer:set_class(class_block)
  local class_table = {
    attr = {},
    methods = {
        ["method_name"] = {},
        ["method_name1"] = {},
        ["method_name2"] = {},
    },
    _prototype = nil
  }
  local index = 1
  local match = { class_block[index]:match("[%s]*method[%s]+([%a]+)%(.-%)[%s]*") }

  if #match > 1 then
    local method_block, index = Read_method_block(class_block, index)
    self.set_method(method_block)
  end
end


function Describer:get_class()
  
end


function Describer:set_method(method_block)
  local method_table = {
    name = nil,
    params = nil,
    vars = nil,
    body = {}
  }

  local i = 1
  local name, params = method_block[i]:match("[%s]*method[%s]+([%a]+)%((.-)%)[%s]*")
  i = i + 1
  
  method_table.name = name
  method_table.params = Arg_var_list(params)
  return method_table
end


function Describer:get_method()
    
end