.text:

# inicializar programa
# Inicializamos t0 con la direccion de nuestro array
la t0, arr

# Inicializamos t1 con la longitud del array
li t1, 12

# Inicializamos t2 con la suma inicial de los impares
li t2, 0

# Inicializamos t3 con nuestro iterador
li t3, 0

# Inicializo algunas variables temporales
li t4, 0

# recorrer arreglo y acumular
loop:
sub t4, t1, t3

# Salimos si el iterador llego al final
beqz t4 exit
li t4, 0


## Sino, chequeamos si la posicion es impar y la sumamos
call es_par

# Si es_par, devolvio 0, sumamos a t2, nuestra suma, sino restart
bnez t5, restart
lw t6, 0(t0)
add t2, t2, t6

restart:
# Incrementamos la direccion al siguiente elemento y reiniciamos el loop
addi t0, t0, 4
addi t3, t3, 1
j loop


# Reutilizo la funcion es_par que usamos en clase (si devuelve 1, es par)
es_par:
mv t5, t3
andi t5, t5, 1
xori t5, t5, 1
ret


exit:
    # Imprime la suma
    mv a0, t2
    li a7, 34
    ecall

    # Termina el programa.
    li a0, 0
    li a7, 93
    ecall

.data:
arr:
.word	0xffffffff, 0x95555555, 0xf4444444, 0xf1111111
.word	0xffffff00, 0xf5005555, 0x95444444, 0xf1113311
.word	0xff00ffff, 0xf5550055, 0xa4444433, 0xa1551111  
