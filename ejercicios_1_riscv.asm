.text:

# inicializar programa
# Inicializamos t0 con la direccion de nuestro array
la t0, arr

# Inicializamos t1 con la longitud del array
li t1, 12

# Inicializamos t2 con la suma inicial de los impares
li t2, x0

# Inicializamos t3 con nuestro iterador
li t3, x0

# Inicializo algunas variables temporales
li t4, x0

# recorrer arreglo y acumular
loop:
sub t4, t1, t3

# Salimos si el iterador llego al final
beqz t4 exit
li t4, x0


## Sino, chequeamos si la posicion es impar y la sumamos
lw a0, t3
call es_par

# Si es_par, devolvio 0, sumamos a t2, nuestra suma, sino restart
bnez a0 restart
add t2, t2, t0

restart:
# Incrementamos la direccion al siguiente elemento y reiniciamos el loop
addi t0, 4
addi t1, 1
j loop


# Reutilizo la funcion es_par que usamos en clase (si devuelve 1, es par)
es_par:
andi a0, a0, 1
xori a0, a0, 1
ret


exit:
    # Imprime la suma
    mv a0, t4
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
