-- =================================================================================== --
--- Arquivo que contém todas as expressões regulares (regex) utilizadas no projeto
-- =================================================================================== --

-- =================================================================================== --
--- Padrões básicos (auxiliares)
local _number_patt_ = "([+-]?[%%d]+)"
local _name_patt_ = "([%%a]+)"
local _class_attr_patt_ = "([%%a]+)%%.([%%a]+)"
local _method_call_patt_ = "([%%a]+)%%.([%%a]+)%%((.-)%%)"
local _obj_creation_patt_ = "new[%%s]+([%%a]+)"
local _bin_operation_patt_ = "([%%a]+)[%%s]*([%%+%%-%%*%%/])[%%s]*([%%a]+)"
-- =================================================================================== --

-- Class definition
_Class_def_begin_pattern_ = "[%s]*class[%s]+([%a]+)[%s]*"
_Class_def_end_pattern_ = "[%s]*end%-class[%s]*"


-- Main body
_Main_body_begin_pattern_ = "[%s]*begin[%s]*"
_Main_body_end_pattern_ = "[%s]*end[%s]*"


-- Method header
-- _Method_header_pattern_ = "[%s]*method[%s]+[%a]+%(.-%)[%s]*"
_Method_header_pattern_ = "[%s]*method[%s]+([%a]+)%((.-)%)[%s]*"
_Method_body_begin_pattern_ = "[%s]*begin[%s]*"
_Method_body_end_pattern_ = "[%s]*end%-method[%s]*"


-- Variables definition
_Variables_def_pattern_ = "[%s]*vars[%s]+(.-)[%s]*"
_Variable_def_pattern_ = "[%s]*([%a]+),[%s]*"
_Variable_last_def_pattern_ = "[%s]*[%a]+[%s]*"


-- Empty line
_Empty_line_pattern_ = "^[%s]*$"

-- =================================================================================== --
--- Padrões de linhas de instrução (statements)

-- Assignments
_Assignment_pattern_ = {
    var_case = {}, -- <name>        = <arg>
    attr_case = {} -- <name>.<name> = <arg>
}

local var_case_base = "[%s]*([%a]+)[%s]*=[%s]*{mask}[%s]*"
local attr_case_base = "[%s]*([%a]+)%.([%a]+)[%s]*=[%s]*{mask}[%s]*"


_Assignment_pattern_.var_case = {
    number_arg        = var_case_base:gsub("{mask}", _number_patt_),        -- <name> = <number>
    var_arg           = var_case_base:gsub("{mask}", _name_patt_),          -- <name> = <name>
    attr_arg          = var_case_base:gsub("{mask}", _class_attr_patt_),    -- <name> = <name>.<name>
    method_call_arg   = var_case_base:gsub("{mask}", _method_call_patt_),   -- <name> = <method-call>
    obj_creation_arg  = var_case_base:gsub("{mask}", _obj_creation_patt_),  -- <name> = <obj-creation>
    bin_operation_arg = var_case_base:gsub("{mask}", _bin_operation_patt_)  -- <name> = <arg-bin> <op> <arg-bin>
}

_Assignment_pattern_.attr_case = {
    number_arg        = attr_case_base:gsub("{mask}", _number_patt_),       -- <name>.<name> = <number>
    var_arg           = attr_case_base:gsub("{mask}", _name_patt_),         -- <name>.<name> = <name>
    attr_arg          = attr_case_base:gsub("{mask}", _class_attr_patt_),   -- <name>.<name> = <name>.<name>
    method_call_arg   = attr_case_base:gsub("{mask}", _method_call_patt_),  -- <name>.<name> = <method-call>
    obj_creation_arg  = attr_case_base:gsub("{mask}", _obj_creation_patt_), -- <name>.<name> = <obj-creation>
    bin_operation_arg = attr_case_base:gsub("{mask}", _bin_operation_patt_) -- <name>.<name> = <arg-bin> <op> <arg-bin>
}


-- Method call
_Method_call_pattern_ = "[%s]*([%a]+)%.([%a]+)%((.-)%)[%s]*"


-- If-then
_If_pattern_ = "[%s]*if[%s]+([%a]+)[%s]+([%l][%l])[%s]+([%a]+)[%s]+then[%s]*\n(.-\n)[%s]*end%-if[%s]*"


-- If-then-else
_If_else_pattern_ = "[%s]*if[%s]+[%a]+[%s]+[%l][%l][%s]+[%a]+[%s]+then[%s]*\n.-\n[%s]*else[%s]*\n.-\n[%s]*end%-if[%s]*"
_Else_pattern_ = "(.-\n)[%s]*else[%s]*\n(.*)"


-- Meta action
_Meta_action_pattern_ = "[%s]*([%a]+)%.([%a]+)%.(_[%a]+)%([%s]*([%d]+)[%s]*%)[%s]*:([^\n]*)[%s]*"


-- Prototype
_Prototype_pattern_ = "[%s]*([%a]+)%._prototype[%s]+=[%s]+([%a]+)[%s]*"


-- Return
_Return_pattern_ = "[%s]*return[%s]+([%a]+)[%s]*"

-- =================================================================================== --
--- Vetor contendo os padrões de statements

Statements_patterns = {
    { { type = "method_call" },
        _Method_call_pattern_ },

    { { type = "meta_action" },
        _Meta_action_pattern_ },

    { { type = "prototype" },
        _Prototype_pattern_ },

    { { type = "return" },
        _Return_pattern_ },

    { { type = "if" },
        _If_pattern_ },


    -- Assignments (variable case)
    { { type = "assignment", lhs = "var_arg", rhs = "number_arg" },
        _Assignment_pattern_.var_case.number_arg },

    { { type = "assignment", lhs = "var_arg", rhs = "var_arg" },
        _Assignment_pattern_.var_case.var_arg },

    { { type = "assignment", lhs = "var_arg", rhs = "attr_arg" },
        _Assignment_pattern_.var_case.attr_arg },

    { { type = "assignment", lhs = "var_arg", rhs = "method_call_arg" },
        _Assignment_pattern_.var_case.method_call_arg },

    { { type = "assignment", lhs = "var_arg", rhs = "obj_creation_arg" },
        _Assignment_pattern_.var_case.obj_creation_arg },

    { { type = "assignment", lhs = "var_arg", rhs = "binary_operation_arg" },
        _Assignment_pattern_.var_case.bin_operation_arg },

    -- Assignments (attribute case)
    { { type = "assignment", lhs = "attr_arg", rhs = "number_arg" },
        _Assignment_pattern_.attr_case.number_arg },

    { { type = "assignment", lhs = "attr_arg", rhs = "var_arg" },
        _Assignment_pattern_.attr_case.var_arg },

    { { type = "assignment", lhs = "attr_arg", rhs = "attr_arg" },
        _Assignment_pattern_.attr_case.attr_arg },

    { { type = "assignment", lhs = "attr_arg", rhs = "method_call_arg" },
        _Assignment_pattern_.attr_case.method_call_arg },

    { { type = "assignment", lhs = "attr_arg", rhs = "obj_creation_arg" },
        _Assignment_pattern_.attr_case.obj_creation_arg },

    { { type = "assignment", lhs = "attr_arg", rhs = "binary_operation_arg" },
        _Assignment_pattern_.attr_case.bin_operation_arg }

}
