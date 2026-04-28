            LDR  R0, =MemoryWord    
            BL   DecMemWord     ; Result = DecMemWord (&MemoryWord);
DecMemWord  PROC {R1-R3}
            SUB  SP, #4         ; word MemWord;

            LDR  R4, [R0]
            STR  R4, [SP,#4]    ; MemWord = *Pointer;

            LDR  R4, [SP,#4]
            SUBS R4, R4, #1
            STR  R4, [SP,#4]    ; MemWord = MemWord - 1;

            LDR  R4, [SP,#4]
            STR  R4, [R0]       ; *Pointer = MemWord;

            POP {R0}            ; return MemWord;

            BX LR
            ENDP
