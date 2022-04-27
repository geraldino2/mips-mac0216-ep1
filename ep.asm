# Gabriel Caiaffa Floriano Mendonça - 11838669
# Gabriel Geraldino de Souza - 12543885

.data
  margem_erro: .float 0.0001
  mat: .space 16
  float_zero: .float 0.0
  float_um: .float 1
  float_menos_um: .float -1
  float_dois : .float 2
  newline: .asciiz "\n"

.text
  # Lê através do sistema as coordenadas do vetor e o ângulo. Carrega floats `imediatos`. Chama a função rotaciona. Encerra.
  # f1 recebe x, f2 recebe y, f10 recebe angulo, f4 recebe a margem de erro (10e-4), f20 recebe 2.0, f23 recebe 0.0, f9 recebe
  #1.0, f14 recebe -1.0
  la $s0, mat
  li $v0,6
  syscall
  mov.s $f1,$f0 #x
  li $v0,6
  syscall
  mov.s $f2,$f0 #y
  li $v0,6
  syscall
  mov.s $f10,$f0 #angulo
  lwc1 $f4, margem_erro #10-4
  lwc1 $f20, float_dois # float 2.0
  lwc1 $f23, float_zero # float 0 #
  lwc1 $f9, float_um # float 1
  lwc1 $f14, float_menos_um # float -1
  jal rotaciona
  li $v0,10 #sysexit
  syscall

seno:
  mov.s $f13,$f10 # guardaremos o seno no registrador $f13
  mov.s $f19,$f14 # guardando o valor do sinal das parcelas
  mov.s $f30,$f9 # f30 receberá o número de que será feito o fatorial
  mov.s $f15,$f9 # guarda o denominador da parcela em f15
  mov.s $f7,$f10 # colocando a parcela inicial que ficará no registrador $f7

parcela_seno: # calculando a segunda parcela a partir da primeira
  mul.s $f7,$f7,$f10 # \
  mul.s $f7,$f7,$f10 # guarda f7^2 em f7
  mov.s $f27,$f7 # guarda o valor do numerador
  add.s $f16,$f30,$f20 # soma 2 ao número fatorial do denominador da parcela anterior e guarda em f16
  add.s $f17,$f30,$f9 # soma 1 ao número fatorial do denominador da parcela anterior e guarda em f16
  mul.s $f15,$f15,$f16 # atualiza o fatorial do termo atual baseado no termo anterior e guarda em f15
  mul.s $f15,$f15,$f17 # atualiza o fatorial do termo atual baseado no termo anterior e guarda em f15
  div.s $f7,$f7,$f15 # monta a parcela com numerador/denominador e guarda em f7
  add.s $f30,$f30,$f20 # atualiza o número que será feito fatorial na próxima parcela e guarda em f30
  abs.s $f31,$f7 # salva o módulo de f7 em f31
  c.lt.s $f31,$f4 # se f31 estiver abaixo da margem de erro, a condição é verdadeira
  bc1t return_seno # se a condição for verdadeira, pula até a função return_seno
  mul.s $f7,$f7,$f19 # atualiza o valor do seno em f7 com seu sinal
  mul.s $f19,$f19,$f14 # inverte o sinal em f19
  add.s $f13,$f13,$f7 # soma a parcela do seno ao seno total
  mov.s $f7,$f27 # guarda o valor do numerador da parcela anterior
  j parcela_seno # recursão
  
return_seno:
  # Zera registradores utilizados que não sejam o retorno da função. Retorna para onde foi chamado.
  mov.s $f7,$f23
  mov.s $f15,$f23
  mov.s $f16,$f23
  mov.s $f17,$f23
  mov.s $f19,$f23
  mov.s $f27,$f23
  mov.s $f30,$f23
  mov.s $f31,$f23
  jr $ra

cosseno:
  mov.s $f29,$f9 # guardaremos o cosseno no registrador $f29
  mov.s $f19,$f14 # guardando o valor do sinal das parcelas
  mov.s $f30,$f12 # f30 receberá o número de que será feito o fatorial
  mov.s $f15,$f9 # guarda o denominador da parcela em f15
  mov.s $f7,$f9 # colocando a parcela inicial que ficará no registrador $f7

parcela_cosseno: # calculando a segunda parcela a partir da primeira
  mul.s $f7,$f7,$f10 # \
  mul.s $f7,$f7,$f10 # guarda f7^2 em f7
  mov.s $f27,$f7 # guarda o valor do numerador
  add.s $f16,$f30,$f20 # soma 2 ao número fatorial do denominador da parcela anterior e guarda em f16
  add.s $f17,$f30,$f9 # soma 1 ao número fatorial do denominador da parcela anterior e guarda em f16
  mul.s $f15,$f15,$f16 # atualiza o fatorial do termo atual baseado no termo anterior e guarda em f15
  mul.s $f15,$f15,$f17 # atualiza o fatorial do termo atual baseado no termo anterior e guarda em f15
  div.s $f7,$f7,$f15 # monta a parcela com numerador/denominador e guarda em f7
  add.s $f30,$f30,$f20 # atualiza o número que será feito fatorial na próxima parcela e guarda em f30
  abs.s $f31,$f7 # salva o módulo de f7 em f31
  c.lt.s $f31,$f4 # se f31 estiver abaixo da margem de erro, a condição é verdadeira
  bc1t return_cosseno # se a condição for verdadeira, pula até a função return_cosseno
  mul.s $f7,$f7,$f19 # atualiza o valor do cosseno em f7 com seu sinal
  mul.s $f19,$f19,$f14 # inverte o sinal em f19
  add.s $f29,$f29,$f7 # soma a parcela do cosseno ao cosseno total
  mov.s $f7,$f27 # guarda o valor do numerador da parcela anterior
  abs.s $f7,$f7 # guarda o módulo de f7 em f7 para filtrar números negativos
  j parcela_cosseno # recursão
  
return_cosseno:
  # Zera registradores utilizados que não sejam o retorno da função. Retorna para onde foi chamado.
  mov.s $f7,$f23
  mov.s $f15,$f23
  mov.s $f16,$f23
  mov.s $f17,$f23
  mov.s $f19,$f23
  mov.s $f27,$f23
  mov.s $f30,$f23
  mov.s $f31,$f23
  jr $ra
  
aloca_elemento:
  move $t1, $s1 # i ´e o indice da linha que queremos acessar
  sll $t1, $t1, 1 # i * nCols(2)
  add $t1, $t1,$s2 # j ´e o indice da coluna que queremos acessar
  sll $t1, $t1, 2 # offset = indice do vetor * tamanho de um int (4)
  add $t1, $t1, $s0 # posic~ao da c´elula = offset + posi¸c~ao da matriz
  s.s $f25,($t1)
  jr $ra

gera_matriz:
  move $s5,$ra # guarda o $ra em $s5 para retornar
  # chama as funções seno e cosseno
  jal seno
  jal cosseno
  # guarda cosseno em matriz[0][0]
  li $s1,0
  li $s2,0
  mov.s $f25,$f29
  jal aloca_elemento
  # guarda cosseno em matriz[1][1]
  li $s1,1
  li $s2,1
  jal aloca_elemento
  # guarda seno em matriz[1][0]
  li $s2,0
  mov.s $f25,$f13
  jal aloca_elemento
  # guarda -seno em matriz[0][1]
  li $s1,0
  li $s2,1
  mul.s $f25,$f25,$f14
  jal aloca_elemento
  jr $s5 # retorna

multiplica_matriz:
  # guarda 0.0 em f7 e f8
  mov.s $f7,$f23
  mov.s $f8,$f23
  l.s $f31,($s0) # guarda cos em f31
  mul.s $f31,$f31,$f1 # guarda x*cos em f31
  add.s $f7,$f7,$f31 # guarda x*cos em f7
  l.s $f31,4($s0) # guarda -sen em f31
  mul.s $f31,$f2,$f31 # guarda y*-sen em f31
  add.s $f7,$f7,$f31 # soma y*-sen a f7
  l.s $f31,8($s0) # guarda sen em f31
  mul.s $f31,$f31,$f1 # guarda x*sen em f31
  add.s $f8,$f8,$f31 # soma x*sen a f8
  l.s $f31,12($s0) # guarda cos em f31
  mul.s $f31,$f31,$f2 # guarda y*cos em f31
  add.s $f8,$f8,$f31 # soma y*cos a f8
  # zera os registradores
  mov.s $f31,$f23
  mov.s $f12,$f7
  jr $ra

rotaciona:
  # Chama as funções gera_matriz e multiplica_matriz. Printa os valores da matriz. Retorna a onde foi chamado.
  move $s6,$ra
  jal gera_matriz
  jal multiplica_matriz
  li $v0,2
  syscall
  li $v0, 4
  la $a0, newline
  syscall
  mov.s $f12,$f8
  li $v0,2
  syscall
  jr $s6
