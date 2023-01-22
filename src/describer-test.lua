require "describer"
require "utils"

local test_class_table = {
  "class Pessoa",
    "vars num",
    "method calc(x)",
    "vars y, z",
    "begin",
      "y = x + self.num",
      "io.print(y)",
      "y = new Base",
      "return y",
    "end-method"
}

local test_method_table = {
    "method calc(x)",
    "vars y, z",
    "begin",
      "y = x + self.num",
      "io.print(y)",
      "y = new Base",
      "return y",
    "end-method"
}

local function test_set_class()
  local describer = Get_describer()

  local described_class_table = describer:set_class(test_class_table)

  Print_table(described_class_table.methods)

end

local function test_set_method()
  local describer = Get_describer()

  local described_method_table = describer:set_method(test_method_table)
  
  print(described_method_table.name)
  Print_table(described_method_table.params)
  Print_table(described_method_table.vars)
  Print_table(described_method_table.body)
  
end


test_set_class()
--test_set_method()