---A partir de uma string contendo uma lista de nomes 
---separados por vírgula, retorna uma tabela contendo 
---cada nome
---@param name_list_str string
---@return table|nil
function Get_name_list(name_list_str)
    local tokens, name_list, name = {}, {}, nil

    tokens = Tokenize(name_list_str)

    for i = 1, #tokens do
        if i < #tokens then
            name = tokens[i]:match("^([%a]+),$")
        else
            name = tokens[i]:match("^([%a]+)$")
        end
        if not name then return nil end
        table.insert(name_list, name)
    end

    return name_list
end
