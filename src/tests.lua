require "utils"
require "strings"
require "patterns"


local statements_patterns = {
    _Bin_operation_pattern_.var_case,
    _Bin_operation_pattern_.attr_case,
    _Method_call_pattern_,
    _Meta_action_pattern_,
    _Prototype_pattern_,
    _Return_pattern_
}

---comment
---@param statement string
---@param pattern string
---@return string
local function next_statement(statement, pattern)
    return (statement:gsub(pattern, "", 1))
end


---comment
---@param method_body_string string
---@return table
local function parse_method(method_body_string)
    local current_pattern, next_stmts, match
    local method_statements = {}

    if type(method_body_string) ~= "string" then
        Error("Invalid method body")
    end

    next_stmts = method_body_string

    while true do
        if next_stmts == "" then
            break
        end

        for i = 1, #statements_patterns do
            current_pattern = statements_patterns[i]
            match = next_stmts:match("^" .. current_pattern .. "\n")
            if match then break end
        end

        if not match then
            Error("Syntax error")
        end

        table.insert(method_statements, Trim(match))

        next_stmts = next_statement(next_stmts, current_pattern)
    end

    return method_statements
end


-- Main
local method_body = [==[
    className.method()
    var._prototype = obj
    className.attribute = tempOne / tempTwo
    obj.met._replace(5): x = Class.Met()
    a = x * y
    return x
]==]


local method_statements = parse_method(method_body)

print("Method Body:")
for k, v in ipairs(method_statements) do
    print(k, v)
end