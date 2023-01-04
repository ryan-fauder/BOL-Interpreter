--[[
	Get_file(file_name)
	- Verifica se o arquivo é válido, se ele existe e o abre para leitura
]]
function Get_file(file_name)
    if type(file_name) ~= "string" then error("Arquivo invalido") end
    local file = io.open(file_name, "r")
    if file then return file else error("Arquivo inexistente") end
end


--[[
	Read_line(file)
	- Lê a próxima linha do arquivo
]]
function Read_line(file)
    return file:read("*line")
end
