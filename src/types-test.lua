require "utils"
require "types"

Class_table1 = {
    name = "Person",
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

Class_table2 = {
    name = "Account", 
    attr = {"account", "address"},
    methods = {
        ["setAddress"] = {
            params = {"age"},
            vars = nil,
            body = {"self.age = age"}
        },
        ["getAddress"] = {
            params = nil,
            vars = nil,
            body = {"io.print(self.age)", "return self.name"}
        },
        ["getAccount"] = {
            params = nil,
            vars = nil,
            body = {"io.print(self.name)", "return self.name"}
        }
    },
    _prototype = nil
}

local function Test_types_numbervar()
  local number_var1 = NumberVar:new(nil, "VAR1", 12)
  local number_var2 = NumberVar:new(nil, "VAR2")
  number_var1:print()
  number_var2:print()
end


local function Test_types_classvar()
  local class_var1 = ClassVar:new(nil, "OBJ1", Class_table1, Class_table1.methods)
  local class_var2 = ClassVar:new(nil, "OBJ2", Class_table2, Class_table2.methods)
  class_var2:set_attr("address", {
      rua = "Rua 1",
      casa = "Casa 2"
  })
  
  class_var1._prototype = class_var2
  
  class_var1:print()
  class_var2:print()
  local attr = class_var1:get_attr("no_attr")
  print(attr)
  local attr = class_var2:get_attr("no_attr_and_proto")
  print(attr)
  local attr = class_var2:get_attr("address")
  Print_table(attr)
  local attr = class_var1:get_attr("address")
  Print_table(attr)
  
  local method = class_var1:get_method("getAddress")
  Print_table(method)

end


-- Test_types_numbervar()
-- Test_types_classvar()

