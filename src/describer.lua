require "patterns"
require "args"
require "reader"
require "utils"


-- Descritor
local Describer = {
    classes = {},
    main = nil
}


--- Retorna o descritor do programa
---@return table
function Get_describer()
    return Describer
end


--- Armazena o corpo da 'main' no descritor
---@param main_block table:<string>
function Describer:insert_main(main_block)
    Describer.main = { table.unpack(main_block, 2, #main_block - 1) }
end


--- Armazena uma classe do programa no descritor
---@param class_block table:<string> Tabela com o bloco de uma classe
function Describer:insert_class(class_block)

    local described_class_table = Describer:describe_class(class_block)

    Describer.classes[described_class_table.name] = described_class_table

end


--- Descreve uma classe a partir de uma tabela de strings e retorna a classe descrita
---@param class_block table:<string> Tabela com o bloco de uma classe
---@return table
function Describer:describe_class(class_block)

    local described_class_table = {
        name = nil,
        attr = {},
        methods = {}
    }

    local index = 1

    local name = class_block[index]:match(_Class_def_begin_pattern_)

    if not name then
        Error("Erro em Describer:set_class: Esperado nome de classe na linha:\n" .. class_block[index])
    end

    described_class_table.name = name

    index = index + 1

    local attrs_keyword, attrs = class_block[index]:match("^[%s]*([%l]+)[%s]+(.-)[%s]*$")

    if attrs_keyword ~= nil and attrs_keyword == "vars" then
        described_class_table.attr = Arg_var_list(attrs)

        index = index + 1

    elseif attrs_keyword == nil then
        Error("Erro em Describer:set_class: Esperado uma declaração de atributos ou início de método na linha:\n" ..
            class_block[index])
    end


    local method_block
    local class_block_size = #class_block

    local method_name = (class_block[index]:match(_Method_header_pattern_))

    while method_name ~= nil do
        method_block, index = Read_method_block(class_block, index)

        described_class_table.methods[method_name] = Describer:describe_method(method_block)

        if index > class_block_size then
            break
        end

        method_name = (class_block[index]:match(_Method_header_pattern_))
    end

    return described_class_table
end


--- Retorna uma classe descrita
---@param class_name string: Nome da classe procurada
---@return table
function Describer:get_class(class_name)
    return self.classes[class_name]
end


--- Função auxiliar que imprime uma método na saída padrão de forma indentada
---@param method_table table
local function method_dump(method_table)

    if method_table then
        local string_method_header = "  method " .. method_table.name .. "("

        if #method_table.params >= 1 then
            for i = 1, #method_table.params - 1 do
                string_method_header = string_method_header .. method_table.params[i] .. ", "
            end

            string_method_header = string_method_header .. method_table.params[#method_table.params]
        end

        string_method_header = string_method_header .. ")"

        print(string_method_header)

        if #method_table.vars >= 1 then
            local vars_string = "  vars "

            for i = 1, #method_table.vars - 1 do
                vars_string = vars_string .. method_table.vars[i] .. ", "
            end

            vars_string = vars_string .. method_table.vars[#method_table.vars]

            print(vars_string)

        end

        print("  begin")
        for i = 1, #method_table.body do
            print("    " .. method_table.body[i])
        end
        print("  end-method")

    end

end


--- Função que imprime uma classe na saída padrão de forma indentada
---@param class_name string
function Describer:class_dump(class_name)

    local class = Describer.classes[class_name]

    print("class " .. class.name)

    if #class.attr >= 1 then
        local vars_string = "  vars "

        for i = 1, #class.attr - 1 do
            vars_string = vars_string .. class.attr[i] .. ", "
        end

        vars_string = vars_string .. class.attr[#class.attr]

        print(vars_string)

    end

    print("")
    for key, method in pairs(class.methods) do
        method_dump(method)
        print("")
    end

    print("end-class")

end


--- Descreve um método e retorna ele
---@param method_block table:<string>
---@return table
function Describer:describe_method(method_block)

    local described_method_table = {
        name = nil,
        params = {},
        vars = {},
        body = {}
    }

    local i = 1

    local name, params = method_block[i]:match("^" .. _Method_header_pattern_ .. "$")


    described_method_table.name = name

    described_method_table.params = Arg_var_list(params)

    i = i + 1

    local vars = method_block[i]:match("^" .. _Variables_def_pattern_ .. "$")

    described_method_table.vars = {}
    
    if vars ~= nil then
        described_method_table.vars = Arg_var_list(vars)
        i = i + 1
    end

    if not method_block[i]:match(_Method_body_begin_pattern_) then
        Error("Erro em Describer:set_method: Esperado um 'begin' na função " .. "'" .. name .. "'")
    end

    i = i + 1

    local method_body = { table.unpack(method_block, i, #method_block - 1) }

    described_method_table.body = method_body

    return described_method_table
end


--- Retorna a tabela de um método
---@param class_name string
---@param method_name string
---@return table
function Describer:get_method(class_name, method_name)
    return self.classes[class_name].methods[method_name]
end


--- Função que transforma uma tabela de strings em uma única string com '\n' como separador
---@param string_table table:<string>
---@return string
function Describer:string_table_concat(string_table)

    local result_string

    if not string_table then
        Error("Tabela de string passada é nula.")
    end

    result_string = string_table[1]

    if #string_table > 1 then

        for i = 2, #string_table do
            result_string = result_string .. "\n" .. string_table[i]
        end
    end

    result_string = result_string .. "\n"

    return result_string

end
