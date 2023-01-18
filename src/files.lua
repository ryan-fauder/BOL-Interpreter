require "utils"

--- Verifica se o arquivo é válido, se ele existe e o abre para leitura
---@param file_name string
---@return file*
function Get_file(file_name)
    if type(file_name) ~= "string" then
        Error("Arquivo invalido")
    end

    local file = io.open(file_name, "r")

    if not file then
        Error("Arquivo inexistente")
    end

    return file
end


--- Lê a próxima linha do arquivo
---@param file file*
---@return string
function Read_line(file)
    return file:read("*line")
end
