---Remove os espaços no início e no final da string
---Remove os espaços extras entre palavras
---@param string string
---@return string
function Trim(string)
    return (string:match("^%s*(.-)%s*$"):gsub("%s+", " "))
end


---Gera tokens de uma string, separando com base nos espaços
---@param string string
---@return table
function Tokenize(string)
    local tokens = {}
    for token in string:gmatch("[^%s]+") do
        table.insert(tokens, token)
    end
    return tokens
end
