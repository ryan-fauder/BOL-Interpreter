--- Imprime uma mensagem de erro na tela e encerra o programa
---@param message string
function Error(message)
    print("[Programa encerrado]\n" .. message)
    os.exit()
end


--- Imprime cada chave e o valor correspondente de uma tabela
---@param table table
function Print_table(table)
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

function Pop_statement(statements, pattern)
    -- A função gsub substitui as ocorrências do
    -- padrão encontrado por uma string, nesse caso a string vazia, 
    -- o parâmetro 1 garante que isso só será feito para a 
    -- primeira ocorrência
    return (statements:gsub(pattern, "", 1))
end
