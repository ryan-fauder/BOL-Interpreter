require "patterns"
require "reader"
require "executor"


---Função que inicia a interpretação do programa
local function main()
    local file = Get_file(arg[1])
    local line = Read_line(file)

    while line do
        if line:match(_Class_def_begin_pattern_) then
            local class_block = Read_class_block(file, line)
            -- Describe_class(class_block)
        elseif line:match(_Main_body_begin_pattern_) then
            local main_block = Read_main_block(file, line)
            -- Main_interpreter(main_block)
        end
        line = Read_line(file)
    end

    file:close()
end


-- Início da interpretação do programa
main()