-- Executor
require "utils"
require "patterns"
require "env"
require "eval"
require "parser"
require "args"


--- Executor do corpo principal do programa
---@param main_block_buffer string
function Main_interpreter(main_block_buffer)
    Check_type("Main_interpreter", main_block_buffer, "main_block_buffer", "string")

    local main_env = Env:new()
    local pattern, tokens, types, var_list_string, var_list, ast
    local control_flag = 0

    main_block_buffer = Pop_statement(main_block_buffer, "^" .. _Main_body_begin_pattern_)

    var_list_string = main_block_buffer:match("^" .. _Variables_def_pattern_ .. "\n")

    if var_list_string then
        var_list = Parser_vars_def({types={type="vars_def"}, tokens={var_list_string}})
        Eval_vars_def(main_env, var_list)
        main_block_buffer = Pop_statement(main_block_buffer, "^" .. _Variables_def_pattern_ .. "\n")
        control_flag = 1
    end

    while true do

        for index, pattern_info in ipairs(Statements_patterns) do
            types, pattern = table.unpack(pattern_info)
            tokens = { main_block_buffer:match("^" .. pattern .. "\n") }
            if #tokens >= 1 then
                goto parsing
            end
        end

        if main_block_buffer:match(_Main_body_end_pattern_) and control_flag == 1 then
            break
        end

        Error("Erro em Main_interpreter: Sintaxe incorreta")

        ::parsing::
        ast = Parser_main_stmt({types=types, tokens=tokens})

        Eval_controller(main_env, ast)
        control_flag = 1

        main_block_buffer = Pop_statement(main_block_buffer, pattern)
    end

end


function Method_interpreter(method_env, method_buffer)
    Check_type("Method_interpreter", method_env, "method_env", "table")
    Check_type("Method_interpreter", method_buffer, "method_buffer", "string")

    local pattern, tokens, types, ast, eval_return

    while true do
        for index, pattern_info in ipairs(Statements_patterns) do
            types, pattern = table.unpack(pattern_info)
            tokens = { method_buffer:match("^" .. pattern .. "\n") }
            if #tokens >= 1 then
                goto parsing
            end
        end

        Error("Erro em Method_interpreter: Sintaxe incorreta")

        ::parsing::
        ast = Parser_method_stmt({types=types, tokens=tokens})

        eval_return = Eval_controller(method_env, ast)

        if eval_return then
            return eval_return
        end

        method_buffer = Pop_statement(method_buffer, pattern)
    end

end


function If_interpreter(if_env, if_buffer)
    Check_type("If_interpreter", if_env, "if_env", "table")
    Check_type("If_interpreter", if_buffer, "if_buffer", "string")

    local pattern, tokens, types, ast, eval_return

    while true do
        for index, pattern_info in ipairs(Statements_patterns) do
            types, pattern = table.unpack(pattern_info)
            tokens = { if_buffer:match("^" .. pattern .. "\n") }
            if #tokens >= 1 then
                goto parsing
            end
        end

        Error("Erro em If_interpreter: Sintaxe incorreta")

        ::parsing::
        ast = Parser_if_stmt({types=types, tokens=tokens})

        eval_return = Eval_controller(if_env, ast)

        if eval_return then
            return eval_return
        end

        if_buffer = Pop_statement(if_buffer, pattern)
    end

end
