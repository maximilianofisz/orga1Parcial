# n_sum(n) = sum_{i=0}^n i

# n_sum(n) = n + n_sum(n-1)
# n_sum(n) = n + n-1 + n_sum(n-2)
# n_sum(n) = n + n-1 + ... + 0

.text:

main:
    # Por convención, en RISC-V el stack pointer (sp) apunta al dato que está
    # en el tope de la pila, y la pila crece hacia direcciones más bajas.
    # Ripes inicializa por defecto el sp en la dirección 0x7FFFFFF0.

    # Llamamos a nuestra función recursiva con el argumento 5.
    # n_sum(5) = 1 + 2 + 3 + 4 + 5 = 15
    li a0, 5
    jal ra, n_sum

print:
    # Imprimimos el resultado en la consola de Ripes.
    # El resultado del llamado a la función lo tenemos en a0 por convención.
    # A su vez, el ecall (environment call) toma el valor a imprimir de a0.
    # Ya tenemos colocado el valor que queremos imprimir en el registro correcto.
    li a7, 1
    ecall

exit:
    # Este ecall frena el simulador.
    # Consideramos que nuestro programa termina acá.
    li a7, 10
    ecall

n_sum:
    # Entrypoint de la función n_sum.
    # Por convención, en a0 tenemos el primer (y en este caso único) argumento de la
    # función. Además en el registro ra (return address) tenemos la dirección a donde
    # retornar después de ejecutar la función.

    # Si a0 != 0, entonces tenemos que hacer el llamado recursivo.
    bnez a0, n_sum_recursive_call

n_sum_base_case:
    # Caso contrario estamos en el caso base: n_sum(0) = 0.
    # Como no vamos a hacer ningún llamado recursivo, no necesitamos usar la pila acá.
    # Podemos devolver 0 y terminar la invocación de esta función.
    # Por convención, el valor de retorno se coloca en a0. En el caso base tenemos que
    # retornar 0, y como ya vale que a0 == 0, no tenemos que hacer nada más.
    jalr x0, ra, 0

n_sum_recursive_call:
    # Para poder hacer llamados recursivos necesitamos ir guardando ("pusheando") en la
    # pila el ra y a0 de cada invocación de n_sum. De esta forma, cuando volvemos del
    # llamado recursivo podemos recuperar el ra (volvemos al lugar que nos invocó) y
    # también el a0 recibido para sumarlo al resultado que obtuvimos de la recursión.

    # Necesitamos mover el sp para hacer lugar en la pila para nuestros datos.
    # Por convención el sp siempre está alineado a 16 bytes. Por eso tenemos que
    # restarle al sp un múltiplo de 16, y restamos porque la pila crece hacia las
    # direcciones más bajas.
    # Como solo queremos guardar ra y a0 en la pila, y cada registro ocupa 4 bytes,
    # es suficiente con reservar 16 bytes en la pila. Nos sobran 8 bytes que no vamos a
    # usar pero hay que respetar la convención.

    # Movemos el sp y nos reservamos 16 bytes en la pila.
    addi sp, sp, -16

    # Guardamos ra y a0 en cualquier lugar dentro de esos 16 bytes, podemos elegir.
    # Esto lo hacemos jugando con el offset que le sumamos a sp. Lo más importante es
    # que no se pisen los datos entre si, recordemos que los registros ocupan 4 bytes.
    sw ra, 4(sp)
    sw a0, 0(sp)

    # Hacemos el llamado recursivo con el argumento a0 - 1.
    addi a0, a0, -1
    jal ra, n_sum

    # Acá volvimos del llamado recursivo. Recuperamos de la pila el valor original que
    # recibimos de a0. Lo guardamos en un registro temporal para después sumarlo al
    # resultado del llamado recursivo (que nos llegó en a0).
    lw t0, 0(sp)
    add a0, a0, t0

n_sum_return:
    # Primero restauramos desde la pila el ra, así volvemos a donde nos llamaron.
    lw ra, 4(sp)

    # Antes de irnos, nos tenemos que encargar de restaurar el sp a donde estaba
    # originalmente cuando entramos en la función. Esto podemos hacerlo fácil porque
    # nosotros sabemos exactamente cuánto le restamos al sp, así que acá simplemente
    # le sumamos esa misma magnitud.
    addi sp, sp, 16

    # Ahora sí, nos vamos. Quizás volvemos a otra invocación de n_sum si estamos en
    # algún lugar intermedio de la recursión. Pero si estamos en la primera invocación
    # entonces ya terminamos de calcular la suma y volvemos a main.
    jalr x0, ra, 0
