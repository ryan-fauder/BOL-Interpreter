require "utils"
require "types"

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

local function types_numbervar_test()
  local number_var1 = NumberVar:new(nil, "VAR1", 12)
  local number_var2 = NumberVar:new(nil, "VAR2")
  number_var1:print()
  number_var2:print()
end


local function types_classvar_test()
  local class_var1 = ClassVar:new(nil, "OBJ1", class_table, class_table.methods)
  local class_var2 = ClassVar:new(nil, "OBJ2", class_table1, class_table1.methods)
  class_var2:set_attr("end1", {
      rua = "Rua 1",
      casa = "Casa 2"
  })

  class_var1:print()
  class_var2:print()
end

--types_numbervar_test()
--types_classvar_test()

