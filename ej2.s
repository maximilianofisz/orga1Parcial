.text:

# inicializar programa
# Inicializamos t0 con la direccion de nuestro array fuente
la t0, src

# Inicializamos t1 con la direccion de nuestro array destino
la t1, dst

# Inicializamos t2 con la cantidad de operaciones restantes
li t2, 12

# recorrer arreglo y mover

loop:
# Chequeamos si nos quedan operaciones restantes, sino, salimos
beqz t2 imprimir

# Cargamos los elementos actuales de ambos arrays
lw a0, 0(t0)
lw a1, 0(t1)

# Calculamos el AND
and a1, a0, a1

# Reemplazamos en memoria con el nuevo valor del array de destino
sw a1, 0(t1) 

# Movemos el puntero de las direcciones de nuestros arrays a los proximos elementos
addi t0, t0, 4
addi t1, t1, 4

# Disminuimos la cantidad de operaciones restantes y volvemos a arrancar el loop
addi t2, t2, -1
j loop

imprimir:
    la t2, dst
    # Cantidad de datos.
    li t3, 12
loop_imprimir:
    beqz t3, exit
    addi t3, t3, -1
    lw t4, 0(t2)
    # Imprime el resultado
    mv a0, t4
    li a7, 34
    ecall
    addi t2, t2, 4

    j loop_imprimir
exit:
    # Termina el programa.
    li a0, 0
    li a7, 93
    ecall

.data:
src:
.word 0xffffffff, 0x95555555, 0xf4444444, 0xf1111111
.word 0xffffff00, 0xf5005555, 0x95444444, 0xf1113311
.word 0xff00ffff, 0xf5550055, 0xa4444433, 0xa1551111      
dst:
.word 0xf5005555, 0x95444444, 0xf1113311, 0xffffff00
.word 0xf1111111, 0xffffffff, 0x95555555, 0xf4444444
.word 0xa1551111, 0xff00ffff, 0xf5550055, 0xa4444433
