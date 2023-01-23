require "executor"

local main_block_buffer = [==[
begin
    vars a, b, c
    a = 1
    b = 10
    if a ne b then
        a = 2
        io.print(a)
        a = 100
        io.print(a)
    else
        a = 200
        io.print(b)
        c = a * b
    end-if
    io.print(a)
    io.print(c)
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