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
            table.insert(block_content, line)
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
        Error("Erro em Read_class_block: 'end-class' nao encontrado")
    end

    return class_block_content
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

    return main_block_content
end


--- Função de leitura de method_block
--- Lê a linhas do arquivo até "end-method", armazena as 
--- linhas em uma tabela e retorna a tabela
---@param file file* 
---@param line string
---@return table
function Read_method_block(file, line)
    local method_block_content = Read_block(file, line, _Method_end_pattern_)

    if not method_block_content then
        Error("Erro em Read_method_block: 'end-method' nao encontrado")
    end

    return method_block_content
end
