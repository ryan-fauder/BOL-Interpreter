require "describer"

local test_method_table = {
    "method calc(x)",
    "vars y",
    "begin",
      "y = x + self.num",
      "io.print(y)",
      "y = new Base",
      "return y",
    "end-method"
}

local function test_set_method()
  local describer = Get_describer()

  describer:set_method()
  
end
