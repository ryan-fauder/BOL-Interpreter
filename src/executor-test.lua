require "executor"

local main_block_buffer = [==[
begin
    vars a, b, c
    a = 1
    b = 1
    if a eq b then
        a = 2
        io.print(a)
        a = 1
        io.print(a)
    end-if
end
]==]


local function main_interpreter_test()
    print("================================")
    print("Main block buffer:")
    print(main_block_buffer)
    print("================================")
    Main_interpreter(main_block_buffer)
end


main_interpreter_test()