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

    local pattern, tokens, types, ast
    main_block_buffer = Pop_statement(main_block_buffer, "^" .. _Main_body_begin_pattern_)

    while true do
        if main_block_buffer == "" then
            break
        end

        for index, pattern_info in ipairs(Statements_patterns) do
            types, pattern = table.unpack(pattern_info)
            tokens = {main_block_buffer:match("^" .. pattern .. "\n")}
            if #tokens >= 1 then
                goto parsing
            end
        end

        Error("Erro em Main_interpreter: Sintaxe incorreta")

        ::parsing::
        -- ast = Parser_main_stmt({types, tokens})

        -- if not ast then
            -- Error("Erro em Main_interpreter: Sintaxe incorreta")
        -- end

        -- Eval_controller(ast)

        main_block_buffer = Pop_statement(main_block_buffer, pattern)
    end

end


function Method_interpreter(env, method_buffer)

end


function If_interpreter(env, if_buffer)

end


--- Testes
local main_block_buffer = [==[
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
]==]


local function main_interpreter_test()
    print("================================")
    print("Main block buffer:")
    print(main_block_buffer)
    print("================================")
    Main_interpreter(main_block_buffer)
end


main_interpreter_test()