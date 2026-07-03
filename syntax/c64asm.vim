if exists("b:current_syntax")
  finish
endif

" Opcodes
syn keyword c64Opcode lda sta ldx stx ldy sty tax txa tay tya tsx txs pha pla php plp
syn keyword c64Opcode clc sec cli sei clv sev cld sed brk rti rts nop
syn keyword c64Opcode adc sbc cmp cpx cpy asl lsr rol ror and ora eor bit inc dec
syn keyword c64Opcode jmp jsr bcc bcs bne beq bpl bmi bvc bvs

" Comments and Numbers
syn match c64Comment ";.*$"
syn match c64Number  "\$[0-9a-fA-F]\+"
syn match c64Number  "#[0-9]\+"

hi def link c64Opcode  Keyword
hi def link c64Comment Comment
hi def link c64Number  Number

let b:current_syntax = "c64asm"
