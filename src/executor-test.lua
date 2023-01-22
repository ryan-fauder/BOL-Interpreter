require "executor"

local main_block_buffer = [==[
begin
    vars a, b, c
    a = 1
    b = 1
    io.print(a)
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