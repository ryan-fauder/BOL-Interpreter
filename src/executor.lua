-- Executor
require "utils"
require "patterns"
require "env"


--- Executor do corpo principal do programa
---@param main_block_buffer string
function Main_interpreter(main_block_buffer)
    if type(main_block_buffer) ~= "string" then
        Error("Erro em Main_interpreter: Tipo de main_block_buffer diferente de string")
    end

    local main_env = Env:new()
    local pattern, tokens, types, var_list_string, var_list, ast
    local control_flag = 0

    main_block_buffer = Pop_statement(main_block_buffer, "^" .. _Main_body_begin_pattern_)

    var_list_string = main_block_buffer:match("^" .. _Variables_def_pattern_ .. "\n")

    if var_list_string then
        -- var_list = Parser_vars_def({types="vars_def", tokens={var_list_string}})
        -- Eval_vars_def(main_env, var_list)
        main_block_buffer = Pop_statement(main_block_buffer, "^" .. _Variables_def_pattern_ .. "\n")
        control_flag = 1
    end

    while true do

        for index, pattern_info in ipairs(Statements_patterns) do
            types, pattern = table.unpack(pattern_info)
            tokens = {main_block_buffer:match("^" .. pattern .. "\n")}
            if #tokens >= 1 then
                goto parsing
            end
        end

        if main_block_buffer:match(_Main_body_end_pattern_) and control_flag == 1 then
            break
        end

        Error("Erro em Main_interpreter: Sintaxe incorreta")

        ::parsing::
        -- ast = Parser_main_stmt({types=types, tokens=tokens})

        -- if not ast then
        --     Error("Erro em Main_interpreter: Sintaxe incorreta")
        -- end

        -- Eval_controller(main_env, ast)
        control_flag = 1

        main_block_buffer = Pop_statement(main_block_buffer, pattern)
    end

end


function Method_interpreter(env, method_buffer)

end


function If_interpreter(env, if_buffer)

end


--- Testes
local main_block_buffer = [==[
begin
    vars one, two, three
    className.method()
    i = 10
    varA = varB
    a = b.c
    obj = new className
    temp = cls.met()

    cls.attr = 10
    cls.attr = varB
    cls.attr = b.c
    cls.attr = new className
    cls.attr = cls.met() 

    className.attribute = tempOne / tempTwo
    obj.met._replace(5): x = Class.Met()

    if a eq b then
        x = y
        className.method()
    else
        y = a + b  
        var._prototype = obj
    end-if

    if a eq b then
        x = y
        className.method()
        y = a + b  
        var._prototype = obj
    end-if

    if a eq b then
        x = y
        className.method()
    else
        y = a + b  
        var._prototype = obj
    end-if

    if a eq b then
        x = y
        className.method()
        y = a + b  
        var._prototype = obj
    end-if

    a = x * y
end
]==]


local function main_interpreter_test()
    -- print("================================")
    -- print("Main block buffer:")
    -- print(main_block_buffer)
    -- print("================================")
    Main_interpreter(main_block_buffer)
end


main_interpreter_test()