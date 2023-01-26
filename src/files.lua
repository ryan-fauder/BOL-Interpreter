require "utils"

--- Verifica se o arquivo é válido, se ele existe e o abre para leitura
---@param file_name string: Nome do arquivo
---@return file*: Arquivo
function Get_file(file_name)
    if type(file_name) ~= "string" then
        Error("Erro em Get_file: Nome do arquivo diferente de string")
    end

    local file = io.open(file_name, "r")

    if not file then
        Error("Erro em Get_file: Arquivo inexistente")
    end

    return file or {}
end
