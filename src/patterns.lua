require "strings"

-- Basic patterns
local _number_patt_ = "[%%d]+"
local _name_patt_ = "[%%a]+"
local _class_attr_patt_ = "[%%a]+%%.[%%a]+"
local _method_call_patt_ = "[%%a]+%%.[%%a]+%%(.-%%)"
local _obj_creation_patt_ = "new[%%s]+[%%a]+"


-- Assignments
_Assignment_pattern_ = {
    var_case = {},
    attr_case = {}
}

local var_case_base = "^[%s]*[%a]+[%s]*=[%s]*{mask}[%s]*$"
local attr_case_base = "^[%s]*[%a]+%.[%a]+[%s]*=[%s]*{mask}[%s]*$"

_Assignment_pattern_.var_case = {
    ["number_arg"] = var_case_base:gsub("{mask}", _number_patt_),
    ["var_arg"] = var_case_base:gsub("{mask}", _name_patt_),
    ["attr_arg"] = var_case_base:gsub("{mask}", _class_attr_patt_),
    ["method_call_arg"] = var_case_base:gsub("{mask}", _method_call_patt_),
    ["obj_creation_arg"] = var_case_base:gsub("{mask}", _obj_creation_patt_)
}

_Assignment_pattern_.attr_case = {
    ["number_arg"] = attr_case_base:gsub("{mask}", _number_patt_),
    ["var_arg"] = attr_case_base:gsub("{mask}", _name_patt_),
    ["attr_arg"] = attr_case_base:gsub("{mask}", _class_attr_patt_),
    ["method_call_arg"] = attr_case_base:gsub("{mask}", _method_call_patt_),
    ["obj_creation_arg"] = attr_case_base:gsub("{mask}", _obj_creation_patt_)
}


-- Binary operations
_Bin_operation_pattern_ = {
    var_case = "[%s]*[%a]+[%s]*=[%s]*[%a]+[%s]*[%+%-%*%/][%s]*[%a]+[%s]*",
    attr_case = "[%s]*[%a]+%.[%a]+[%s]*=[%s]*[%a]+[%s]*[%+%-%*%/][%s]*[%a]+[%s]*"
}


-- Method call
_Method_call_pattern_ = "[%s]*[%a]+%.[%a]+%(.-%)[%s]*"


-- Ifs
-- _If_pattern_ = "^$"
-- _If_else_pattern_ = "^$"


-- Meta action
_Meta_action_pattern_ = "[%s]*[%a]+%.[%a]+%._[%a]+%([%s]*[%d]+[%s]*%)[%s]*:[^\n]*[%s]*"


-- Prototype
_Prototype_pattern_ = "[%s]*[%a]+%._prototype[%s]+=[%s]+[%a]+[%s]*"


-- Return
_Return_pattern_ = "[%s]*return[%s]+[%a]+[%s]*"
