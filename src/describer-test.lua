require "describer"

local test_method_table = {
    "method showid()",
      "begin",
      "self.id = 10",
      "io.print(self.id)",
      "return 0",
    "end-method"
}

local function test_set_method()
  local describer = Get_describer()

  describer:set_method()
  
end
