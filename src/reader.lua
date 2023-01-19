require "utils"
require "patterns"

--- Lê a próxima linha do arquivo
---@param file file*
---@return string
function Read_line(file)
    return file:read("*line")
end


--- Lê a linhas do arquivo até encontrar o padrão
--- especificado, armazena as linhas em uma tabela 
--- e retorna a tabela
---@param file file*
---@param line string
---@param stop_pattern string
---@return table|nil
function Read_block(file, line, stop_pattern)
    local block_content = {}

    while line do
        if not line:match(_Empty_line_pattern_) then
            table.insert(block_content, Trim(line))
        end

        if line:match(stop_pattern) then
            return block_content
        end

        line = Read_line(file)
    end

    return nil
end


--- Função de leitura de class_block
--- Lê a linhas do arquivo até "end-class", armazena as 
--- linhas em uma tabela e retorna a tabela
---@param file file*
---@param line string
---@return table
function Read_class_block(file, line)
    local class_block_content = Read_block(file, line, _Class_def_end_pattern_)

    if not class_block_content then
        Error("Erro em Read_class_block: 'end-class' não encontrado")
    end
    
    return class_block_content or {}
end


--- Função de leitura de main_block
--- Lê a linhas do arquivo até "end", armazena as 
--- linhas em uma tabela e retorna a tabela
---@param file file*
---@param line string
---@return table
function Read_main_block(file, line)
    local main_block_content = Read_block(file, line, _Main_body_end_pattern_)

    if not main_block_content then
        Error("Erro em Read_main_block: 'end' nao encontrado")
    end

    return main_block_content or {}
end


--- Recebe a tabela de linhas da classe e o índice do header de um método
--- O método é lido até "end-method"
--- Retorna uma tabela de linhas com o método e o índice depois de "end-method"
---@param class_block_content table
---@param index number
---@return table
---@return integer
function Read_method_block(class_block_content, index)
    local method_block_content = {}

    repeat
        table.insert(method_block_content, class_block_content[index])
        index = index + 1
    until class_block_content[index - 1]:match(_Method_end_pattern_)

    return method_block_content, index
end


--- Funções de teste

local function read_class_test()
    -- lua reader.lua program.bol
    require "files"
    local file = Get_file(arg[1])
    local line = Read_line(file)

    while line do
        if line:match(_Class_def_begin_pattern_) then
            local class_block = Read_class_block(file, line)
            print("\nClass Block:")
            Print_table(class_block)
        end
        line = Read_line(file)
    end

    print()
end


local function read_main_test()
    -- lua reader.lua program.bol
    require "files"
    local file = Get_file(arg[1])
    local line = Read_line(file)

    while line do
        if line:match(_Main_body_begin_pattern_) then
            local main_block = Read_main_block(file, line)
            print("\nMain Block:")
            Print_table(main_block)
        end
        line = Read_line(file)
    end

    print()
end


local function read_method_test()
    local method_block_content, next_index
    local class_block_content = {
        "class MyClass",
        "vars a, b, c",

        "method myMethodOne(x, y)",
        "vars i, j",
        "begin",
            "self.a = x + y",
            "i = 10",
            "return y",
        "end-method",

        "method myMethodTwo()",
        "begin",
            "self.a = 20",
        "end-method",
    }

    print("Class block:")
    Print_table(class_block_content)

    method_block_content, next_index = Read_method_block(class_block_content, 3)

    print("\nMethod 1:")
    Print_table(method_block_content)
    print("Next index = " .. next_index)

    method_block_content, next_index = Read_method_block(class_block_content, next_index)

    print("\nMethod 2:")
    Print_table(method_block_content)
    print("Next index = " .. next_index)

end


-- read_class_test()
-- read_main_test()
-- read_method_test()