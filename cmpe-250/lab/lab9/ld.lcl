SECTIONS {
    reset 0x0 :
    {
        *(RESET)
    }
    prog_once 0xc0 :
    {
        *(prog_once)
    }
    start (ADDR(prog_once) + SIZEOF(prog_once)) :
    {
        *(start)
    }
    const (ADDR(start) + SIZEOF(start)) :
    {
        *(const)
    }
    keys 0x400 :
    {
        *(keys)
    }
    code (ADDR(keys) + SIZEOF(keys)) :
    {
        *(main)
    }
    stack 0x1ffffc00 :
    {
        *(stack)
    }
    data (ADDR(stack) + SIZEOF(stack)) :
    {
        *(var)
    }
}
