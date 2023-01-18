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

local var_case_base = "[%s]*[%a]+[%s]*=[%s]*{mask}[%s]*"
local attr_case_base = "[%s]*[%a]+%.[%a]+[%s]*=[%s]*{mask}[%s]*"

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


-- If-then
_If_pattern_ = "[%s]*if[%s]+[%a]+[%s]+[%l][%l][%s]+[%a]+[%s]+then[%s]*\n.-\n[%s]*end%-if[%s]*"


-- If-then-else
_If_else_pattern_ = "[%s]*if[%s]+[%a]+[%s]+[%l][%l][%s]+[%a]+[%s]+then[%s]*\n.-\n[%s]*else[%s]*\n.-\n[%s]*end%-if[%s]*"


-- Meta action
_Meta_action_pattern_ = "[%s]*[%a]+%.[%a]+%._[%a]+%([%s]*[%d]+[%s]*%)[%s]*:[^\n]*[%s]*"


-- Prototype
_Prototype_pattern_ = "[%s]*[%a]+%._prototype[%s]+=[%s]+[%a]+[%s]*"


-- Return
_Return_pattern_ = "[%s]*return[%s]+[%a]+[%s]*"


-- Vetor contendo os padrões de statements (regexs)
Statements_patterns = {
    _Bin_operation_pattern_.var_case,
    _Bin_operation_pattern_.attr_case,
    _Method_call_pattern_,
    _Meta_action_pattern_,
    _Prototype_pattern_,
    _Return_pattern_,

    _If_pattern_,
    _If_else_pattern_,

    _Assignment_pattern_.var_case.number_arg,
    _Assignment_pattern_.var_case.var_arg,
    _Assignment_pattern_.var_case.attr_arg,
    _Assignment_pattern_.var_case.method_call_arg,
    _Assignment_pattern_.var_case.obj_creation_arg,

    _Assignment_pattern_.attr_case.number_arg,
    _Assignment_pattern_.attr_case.var_arg,
    _Assignment_pattern_.attr_case.attr_arg,
    _Assignment_pattern_.attr_case.method_call_arg,
    _Assignment_pattern_.attr_case.obj_creation_arg
}


-- Class definition
_Class_def_begin_pattern_ = "^[%s]*class[%s]+([%a]+)[%s]*$"
_Class_def_end_pattern_ = "^[%s]*end%-class[%s]*$"


-- Main body
_Main_body_begin_pattern_ = "^[%s]*begin[%s]*$"
_Main_body_end_pattern_ = "^[%s]*end[%s]*$"


-- Method header
_Method_header_pattern_ = "^[%s]*method[%s]+[%a]+%(.-%)[%s]*$"
_Method_end_pattern_ = "^[%s]*end%-method[%s]*$"


-- Variables definition
_Variables_def_pattern_ = "^[%s]*vars[%s]+.-[%s]*$"


-- Empty line
_Empty_line_pattern_ = "^[%s]*$"