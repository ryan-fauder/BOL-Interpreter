--[[
	Trim(string)
	- Remove os espaços no início e no final da string
	- Remove os espaços extras entre palavras
]]
function Trim(string)
    return (string:match("^%s*(.-)%s*$"):gsub("%s+", " "))
end


--[[
	Tokenize(string)
	- Gera tokens de uma string, separando com base nos espaços
]]
function Tokenize(string)
    local tokens = {}
    for token in string.gmatch(string, "[^%s]+") do
        table.insert(tokens, token)
    end
    return tokens
end
