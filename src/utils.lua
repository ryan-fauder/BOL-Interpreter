--- Imprime uma mensagem de erro na tela e encerra o programa
---@param message string
function Error(message)
    print("[Programa encerrado]\n" .. message)
    os.exit()
end


function Check_type(function_name, variable, variable_name, type_name)
    if type(variable) ~= type_name then
        Error("Erro em " .. function_name  .. ": Tipo de '" .. variable_name .. "' inválido")
    end
end


--- Imprime cada chave e o valor correspondente de uma tabela
---@param table table
function Print_table(table)

    if (table == nil) then
        Error("Erro em Print_table: Paramêtro vazio")
        return
    end
    if (type(table) ~= "table") then
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


---Remove os espaços no início e no final da string
---Remove os espaços extras entre palavras
---@param string string
---@return string
function Trim(string)
    return (string:match("^%s*(.-)%s*$"):gsub("%s+", " "))
end


---Recebe uma string contendo vários statements e retira
---o primeiro deles, baseado no padrão informado
---@param statements_buffer string
---@param pattern string
---@return string
function Pop_statement(statements_buffer, pattern)
    return (statements_buffer:gsub(pattern, "", 1))
end