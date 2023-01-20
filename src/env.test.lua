require "utils"
require "types"
require "env"
require "types.test"

local function env_test()
  local number_var1 = NumberVar:new(nil, "VAR1", 12)
  local number_var2 = NumberVar:new(nil, "VAR2", 124)
  
  local env = Env:new(nil)
  env:setVar(number_var1.name, number_var1)
  env:setVar(number_var2.name, number_var2)
  env:print()
  
  local class_var2 = ClassVar:new(nil, "VAR2", class_table1, class_table1.methods)
  env:setVar(class_var2.name, class_var2)
  env:print()
end

--env_test()
