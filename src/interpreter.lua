require "files"
require "strings"


--[[
	error(message)
	- Imprime uma mensagem de erro na tela e encerra o programa
]]
local function error(message)
    print("[Programa encerrado]\nCausa: " .. message)
    os.exit()
end


--[[
	variables_interpreter(tokens)
	- Interpreta as declarações de variáveis do tipo "vars a, b, c"
]]
local function variables_interpreter(tokens)
	-- Provavelmente a função terá outro nome, como attr_def_interpreter
    local variables, var = {}, nil

    for i = 2, #tokens - 1 do
        var = tokens[i]:match("^([%a]+),$")
        if not var then return nil end
        table.insert(variables, var)
    end

    var = tokens[#tokens]:match("^([%a]+)$")
    if not var then return nil end
    table.insert(variables, var)

    return variables
end


--[[
	class_interpreter(class_name, line)
	- Interpreta o conteúdo de uma classe
]]
local function class_interpreter(class_name, line)
    local tokens, variables = {}, nil
    local class_flag, vars_flag = 0, 0

    ::loop::
    while true do
        line = Read_line(File)
        if not line then return false end

        -- Temporário (para visualização)
        print("[class]\t", Trim(line))

        tokens = Tokenize(line)
        if #tokens == 0 then goto loop end

        if (tokens[1] == "method") then
            -- Verificar:
            -- formato "method <name>()" ou "method <name>([<name-list>])"
            -- begin
            -- <method-body>
            -- end-method
            class_flag, vars_flag = 1, 1
            goto loop -- Após as verificações
        end

        if (tokens[1] == "vars" and vars_flag == 0) then
            variables = variables_interpreter(tokens)
            if not variables then return false end

            -- Temporário (para visualização)
            for k, v in ipairs(variables) do
                print("[var]\t", k, v)
            end

            class_flag, vars_flag = 1, 1
            goto loop
        end

        if (tokens[1] == "end-class" and class_flag == 1) then
            if #tokens == 1 then return true
            else return false end
        end

        return false
    end
end


--[[
	main_body_interpreter(line)
	- Interpreta o conteúdo do trecho principal do programa
]]
local function main_body_interpreter(line)
    local tokens = {}

    ::loop::
    while true do
        line = Read_line(File)
        if not line then return false end

        print("[main-body]", Trim(line))

        tokens = Tokenize(line)
        if #tokens == 0 then goto loop end

        if (tokens[1] == "end") then return true end
    end
end


--[[
	program_interpreter()
	- Função que inicia a interpretação geral do programa
]]
local function program_interpreter()
    File = Get_file(arg[1])
    local tokens = {}

    ::loop::
    while true do
        local line = Read_line(File)
        if not line then break end

        -- Temporário (para visualização)
        print("[prog]\t", Trim(line))

        tokens = Tokenize(line)
        if #tokens == 0 then goto loop end

        if (tokens[1] == "class" and #tokens == 2) then
            local class_name = string.match(tokens[2], "^[%a]+$")
            if not class_name then error("Nome de classe invalido") end
            if class_interpreter(class_name, line) then goto loop
            else error("Erro na classe") end
        end

        if (tokens[1] == "begin" and #tokens == 1) then
            if main_body_interpreter(line) then goto loop
            else error("Erro no corpo principal") end
        end

        error("Erro na sintaxe")
    end

    File:close()
end


-- Main
program_interpreter()
