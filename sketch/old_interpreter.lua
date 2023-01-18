require "files"
require "strings"
require "utils"
require "patterns"


---Interpreta as declarações de variáveis do tipo "vars a, b, c"
---@param tokens table
---@return table|nil
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


---Interpreta o conteúdo de uma classe
---@param class_name string
---@param line string
---@return boolean
local function class_interpreter(class_name, line)
    -- local tokens, variables = {}, nil
    local class_flag, vars_flag = 0, 0
    line = Read_line(File)

    while line do
        -- Temporário (para visualização)
        print("[class]\t", Trim(line))
   
        if line:match(_Method_header_pattern_) then
            -- Verificar:
            -- formato "method <name>()" ou "method <name>([<name-list>])"
            -- begin
            -- <method-body>
            -- end-method
            class_flag, vars_flag = 1, 1

        elseif line:match(_Variables_def_pattern_) and vars_flag == 0 then
            -- variables = variables_interpreter(tokens)
            -- if not variables then return false end

            -- Temporário (para visualização)
            -- for k, v in ipairs(variables) do
            --     print("[var]\t", k, v)
            -- end

            class_flag, vars_flag = 1, 1

        elseif line:match(_Class_def_end_pattern_) and class_flag == 1 then
            return true
        end

        line = Read_line(File)
    end

end


---Interpreta o conteúdo do corpo principal do programa
---@param line string
---@return boolean
local function main_body_interpreter(line)
    local tokens = {}

    ::loop::
    while true do
        line = Read_line(File)
        if not line then return false end

        print("[main-body]", Trim(line))

        tokens = Tokenize(line)
        if #tokens == 0 then goto loop end

        if tokens[1] == "end" then return true end
    end

end


---Função que inicia a interpretação do programa
local function program_interpreter()
    File = Get_file(arg[1])
    local line = Read_line(File)

    while line do
        -- Temporário (para visualização)
        print("[prog]\t", Trim(line))

        local class_name = line:match(_Class_def_begin_pattern_)

        if class_name then
            class_interpreter(class_name, line)

        elseif line:match(_Main_body_begin_pattern_) then
            main_body_interpreter(line)
        end

        line = Read_line(File)
    end

    File:close()
end


---Main
program_interpreter()