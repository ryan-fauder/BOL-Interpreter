--- Imprime uma mensagem de erro na tela e encerra o programa
---@param message string
function Error(message)
    print("[Programa encerrado]\n" .. message)
    os.exit()
end


--- Verifica se uma variável é do tipo especificado
---@param function_name string: Nome da função onde Check_type foi chamada
---@param variable any
---@param variable_name string
---@param type_name string
function Check_type(function_name, variable, variable_name, type_name)
    if type(variable) ~= type_name then
        Error("Erro em " .. function_name .. ": Tipo de '" .. variable_name .. "' inválido")
    end
end


--- Imprime cada chave e o valor correspondente de uma tabela
---@param table table
function Print_table(table)

    if table == nil then
        Error("Erro em Print_table: Paramêtro vazio")
        return
    elseif type(table) ~= "table" then
        Error("Erro em Print_table: Paramêtro não é um table")
        return
    end

    for i, v in pairs(table) do
        if v == nil then
            print(i, "nil")
        else
            print(i, v)
        end
    end
end


--- Remove os espaços no início e no final da string
--- Remove os espaços extras entre palavras
---@param string string
---@return string
function Trim(string)
    return (string:match("^%s*(.-)%s*$"):gsub("%s+", " "))
end


--- Recebe uma string contendo vários statements e retira
--- o primeiro deles, baseado no padrão informado
---@param statements_buffer string
---@param pattern string
---@return string
function Pop_statement(statements_buffer, pattern)
    return (statements_buffer:gsub(pattern, "", 1))
end


--- Limpa o conteúdo de uma tabela
---@param table table
function Clear_table(table)
    for i, v in pairs(table) do table[i] = nil end
end


--- Cria uma cópia de uma tabela
---@param src_table table
---@return table
function Deep_copy(copy, src_table)
    if type(src_table) ~= "table" then
        return src_table
    end

    for key, value in pairs(src_table) do
        copy[key] = Deep_copy({}, value)
    end

    return copy
end
