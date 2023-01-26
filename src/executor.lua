require "utils"
require "patterns"
require "env"
require "eval"
require "parser"
require "args"


--- Executor do corpo principal do programa
---@param main_env table: Ambiente de variáveis
---@param main_block_buffer string: Buffer do corpo principal
function Main_interpreter(main_env, main_block_buffer)
    Check_type("Main_interpreter", main_block_buffer, "main_block_buffer", "string")

    local pattern, tokens, types, var_list_string, var_list, ast
    local control_flag = 0

    main_block_buffer = Pop_statement(main_block_buffer, "^" .. _Main_body_begin_pattern_)

    var_list_string = main_block_buffer:match("^" .. _Variables_def_pattern_ .. "\n")

    if var_list_string then
        var_list = Parser_vars_def({ types={type="vars_def"}, tokens={var_list_string} })
        Eval_vars_def(main_env, var_list)
        main_block_buffer = Pop_statement(main_block_buffer, "^" .. _Variables_def_pattern_ .. "\n")
        control_flag = 1
    end

    while main_block_buffer ~= "" do
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

    while method_buffer ~= "" do
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

    while if_buffer ~= "" do
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


--- Realiza a execução de um bloco
--- O bloco pode ser um método ou um if/else
---@param env table: Ambiente de variáveis
---@param block_buffer string: Buffer do bloco
---@param parser_function function: Função parser (Parser_method_stmt | Parser_if_stmt)
---@return table|nil: Retorno de um statement "return <value>", caso exista
function Block_executor(env, block_buffer, parser_function)
    Check_type("Block_executor", env, "env", "table")
    Check_type("Block_executor", block_buffer, "block_buffer", "string")

    local pattern, tokens, types, ast, eval_return

    while block_buffer ~= "" do
        for index, pattern_info in ipairs(Statements_patterns) do
            types, pattern = table.unpack(pattern_info)

            -- Aplicação de regex no início do buffer
            tokens = { block_buffer:match("^" .. pattern .. "\n") }

            -- Match válido
            if #tokens >= 1 then
                -- Criação da abstract syntax tree
                ast = parser_function({types=types, tokens=tokens})

                eval_return = Eval_controller(env, ast)

                if eval_return then
                    return eval_return
                end

                break
            end
        end

        if #tokens < 1 then
            Error("Erro em Block_executor: Sintaxe incorreta")
        end

        -- Retirando o statement já analisado
        block_buffer = Pop_statement(block_buffer, pattern)
    end

end