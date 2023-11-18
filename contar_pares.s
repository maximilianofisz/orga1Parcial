.text:
main:
    la a0, numeros
    lw a1, longitud
    call contar_pares
    li a7, 1
    ecall # Imprime el resultado.

exit:
    # Este ecall frena el simulador.
    # Consideramos que nuestro programa termina acá.
    li a7, 10
    ecall

contar_pares:
    # Preservamos los argumentos para no perderlos cuando
    # llamamos a es_par.
    mv s0, a0 # Dirección del array.
    mv s1, a1 # Cantidad de elementos restantes.
    mv s2, ra # Return address.
    mv s3, x0 # Inicializamos el contador de pares.

loop:
    # while (s1-- > 0) {...}
    beqz s1, return
    addi s1, s1, -1

    # Cargamos el próximo elemento a revisar si es par.
    lw a0, 0(s0)
    call es_par

    # En a0 tenemos el resultado de es_par.
    # Como vale 1 si es par, 0 caso contrario, podemos sumarlo
    # directamente al contador.
    add s3, s3, a0

    # Incrementamos la dirección al siguiente elemento.
    addi s0, s0, 4

    j loop

return:
    mv a0, s3 # Colocamos el resultado en el registro de retorno.
    mv ra, s2
    ret

es_par:
    # a0 = 12 = 1100
    # a0 & 1 = 1100 & 0001 = 0000
    # a0 ^ 1 = 0000 ^ 0001 = 0001

    # a0 = 13 = 1101
    # a0 & 1 = 1101 & 0001 = 0001
    # a0 ^ 1 = 0001 ^ 0001 = 0000

    andi a0, a0, 1
    xori a0, a0, 1
    ret

.data:
numeros: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
longitud: .word 10
