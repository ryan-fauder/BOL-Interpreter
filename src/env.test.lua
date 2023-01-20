require "utils"
require "types"
require "env"

class_table = {
  attr = {"name", "age"},
  methods = {
      ["setAge"] = {
          params = {"age"},
          vars = nil,
          body = {"self.age = age"}
      },
      ["getAge"] = {
          params = nil,
          vars = nil,
          body = {"io.print(self.age)", "return self.name"}
      },
      ["getName"] = {
          params = nil,
          vars = nil,
          body = {"io.print(self.name)", "return self.name"}
      }
  },
  _prototype = nil
}

class_table1 = {
attr = {"account", "address"},
methods = {
  ["setAge"] = {
      params = {"age"},
      vars = nil,
      body = {"self.age = age"}
  },
  ["getAge"] = {
      params = nil,
      vars = nil,
      body = {"io.print(self.age)", "return self.name"}
  },
  ["getName"] = {
      params = nil,
      vars = nil,
      body = {"io.print(self.name)", "return self.name"}
  }
},
_prototype = nil
}

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

env_test()
