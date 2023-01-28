--- Testes
require "utils"
require "patterns"
require "reader"


function Test_read_class()
    print("========== Test_read_class ==========")
    -- lua reader.lua program.bol
    require "files"
    local file = Get_file(arg[1])
    local line = Read_line(file)

    while line do
        if line:match(_Class_def_begin_pattern_) then
            local class_block = Read_class_block(file, line)
            print("\nClass Block:")
            Print_table(class_block)
        end
        line = Read_line(file)
    end

    print()
end

function Test_read_main()
    print("========== Test_read_main ==========")
    -- lua reader.lua program.bol
    require "files"
    local file = Get_file(arg[1])
    local line = Read_line(file)

    while line do
        if line:match(_Main_body_begin_pattern_) then
            local main_block = Read_main_block(file, line)
            print("\nMain Block:")
            Print_table(main_block)
        end
        line = Read_line(file)
    end

    print()
end

function Test_read_method()
    print("========== Test_read_method ==========\n")

    local method_block_content, next_index
    local class_block_content = {
        "class MyClass",
        "vars a, b, c",

        "method myMethodOne(x, y)",
        "vars i, j",
        "begin",
        "self.a = x + y",
        "i = 10",
        "return y",
        "end-method",

        "method myMethodTwo()",
        "begin",
        "self.a = 20",
        "end-method",
    }

    print("Class block:")
    Print_table(class_block_content)

    method_block_content, next_index = Read_method_block(class_block_content, 3)

    print("\nMethod 1:")
    Print_table(method_block_content)
    print("Next index = " .. next_index)

    method_block_content, next_index = Read_method_block(class_block_content, next_index)

    print("\nMethod 2:")
    Print_table(method_block_content)
    print("Next index = " .. next_index)

end

-- Test_read_class()
-- Test_read_main()
Test_read_method()
