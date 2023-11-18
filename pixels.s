.text:

# Inicializamos t1 con la dirección donde están guardados los pixeles.
la t1, pixels

# Cantidad de pixels.
li t3, 5

# Inicializamos el valor máximo de rojo en 0.
li t4, 0

loop:
    # while (t3-- > 0) {...}
    beqz t3, exit
    addi t3, t3, -1

    # Cargamos 1 byte que corresponde al pixel rojo.
    lb t2, 0(t1)

    # Aplicamos la máscara para quedarnos solo con el byte que nos interesa.
    # Esto es necesario si el valor cargado es >= 128, pues en complemento a 2
    # es un número negativo, y RISC-V realiza extensión de signo al byte cargado
    # para llenar el registro entero de 32 bits.
    andi t2, t2, 0xFF

    # Vemos si este valor de rojo es el nuevo máximo.
    blt t2, t4, not_max
    mv t4, t2

    not_max:
    # Avanzamos 3 bytes al siguiente pixel.
    addi t1, t1, 3

    j loop

exit:
    # Imprime el rojo máximo.
    mv a0, t4
    li a7, 34
    ecall

    # Termina el programa.
    li a0, 0
    li a7, 93
    ecall

.data:
pixels:
.byte 0x11, 0x22, 0x33 # RGB
.byte 0x44, 0x55, 0x66 # RGB
.byte 0x77, 0x88, 0x99 # RGB
.byte 0xAA, 0xBB, 0xCC # RGB
.byte 0xDD, 0xEE, 0xFF # RGB
