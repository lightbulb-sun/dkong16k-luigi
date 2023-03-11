incbin "dkong16k.col"


LUIGI_COLOR: equ 2

FREE_RAM: equ $72c0
FREE_ROM: equ $b700
CUR_PLAYER: equ $702b
NUM_PLAYERS: equ $702d
SPRITE_DATA_START: equ $aff5
SPRITE_DATA_END: equ $b01b
NUM_SPRITES: equ 13


myorg: macro addr
        seek    addr-$8000
        org     addr
endm


myorg $80ea
        call    injection

myorg FREE_ROM
injection:
        push    bc
        push    de
        push    hl

        ; copy original sprite data
        ld      hl, SPRITE_DATA_START
        ld      de, FREE_RAM
        ld      bc, SPRITE_DATA_END - SPRITE_DATA_START
        ldir

        ld      a, (NUM_PLAYERS)
        dec     a
        jr      z, .luigi
        ld      a, (CUR_PLAYER)
        and     a
        jr      z, .end
.luigi:
        ld      hl, FREE_RAM
        ld      a, LUIGI_COLOR
        ld      b, NUM_SPRITES
.loop:
        ld      (hl), a
        inc     hl
        inc     hl
        dec     b
        jr      nz, .loop
.end:
        pop     hl
        pop     de
        pop     bc
        ; replace original instruction
        jp      $8207


myorg $aff3
        dw      FREE_RAM
