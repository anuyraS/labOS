	.file	"main.c"
	.text                                                # Начало текста программы
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Cannot read all the data"                   # Сообщение об ошибке чтения данных
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"(SUBPROCESS) Fibonacci number %ld is %ld\n" # Формат строки для вывода результата
	.text
	.p2align 4
	.globl	run_fib                                      # Определеение глобальной функции
	.type	run_fib, @function
run_fib:
.LFB22:
	.cfi_startproc
	pushq	%rbx                                         # Сохранить регистр rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp                                    # Выделить место в стеке
	.cfi_def_cfa_offset 48
	movl	4+p(%rip), %edi                              # Загрузить дескриптор файла
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	$0, 8(%rsp)
	call	close@PLT                                    # Закрыть файл
	movl	p(%rip), %edi
	leaq	8(%rsp), %rsi
	movl	$8, %edx
	call	read@PLT                                     # Читать из файла
	movl	p(%rip), %edi
	movq	%rax, %rbx
	call	close@PLT                                    # Закрыть файл
	cmpq	$8, %rbx  
	jne	.L6                                          # Если прочитано не 8 байт, перейти к ошибке
	movq	8(%rsp), %rdi
	call	fibonacci@PLT                                # Вычислить число Фибоначчи
	movq	8(%rsp), %rsi
	leaq	.LC1(%rip), %rdi
	movq	%rax, %rdx
	movq	%rax, 16(%rsp)
	xorl	%eax, %eax
	call	printf@PLT                                   # Вывести результат
	movl	o(%rip), %edi
	call	close@PLT                                    # Закрыть файл
	movl	4+o(%rip), %edi
	leaq	16(%rsp), %rsi
	movl	$8, %edx
	call	write@PLT                                    # Записать результат
	movl	4+o(%rip), %edi
	call	close@PLT                                    # Закрыть файл
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L7
	addq	$32, %rsp                                    # Восстановаить стек
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx                                         # Восстановаить rbx
	.cfi_def_cfa_offset 8
	ret
.L6:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	puts@PLT                                     # Вывести сообщение об ошибке
	movl	$1, %edi
	call	_exit@PLT                                    # Завершить процесс
.L7:
	call	__stack_chk_fail@PLT                         # Ошибка стека
	.cfi_endproc
.LFE22:
	.size	run_fib, .-run_fib
	.section	.rodata.str1.1
.LC2:
	.string	"Hello, World!"                              # Приветсвенное сообщение
	.section	.rodata.str1.8
	.align 8
.LC3:
	.string	"Fibonacci number %ld is %ld. (Taken from child process)\n" # Формат строки для вывода результата из дочернего процесса
	.section	.rodata.str1.1
.LC4:
	.string	"A Child process killed."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB23:
	.cfi_startproc
	pushq	%rbp                                         # Сохранить регистр rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	.LC2(%rip), %rdi 
	pushq	%rbx                                         # Сохранить регистр rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp                                    # Выделить место в стеке
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	call	puts@PLT                                     # Вывести приветственное сообщение
	leaq	p(%rip), %rdi
	call	pipe@PLT                                     # Создать pipe
	leaq	o(%rip), %rdi
	call	pipe@PLT                                     # Создать второй pipe
	call	fork@PLT                                     # Создать дочерний процесс
	testl	%eax, %eax
	jne	.L9                                          # Если в родительском процессе, перейти к метке .L9
	xorl	%eax, %eax
	call	run_fib                                      # Вызвать функцию вычисления Фибоначчи
.L10:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L13
	addq	$24, %rsp                                    # Восстановить стек
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	xorl	%eax, %eax
	popq	%rbx                                         # Восстановаить rbx
	.cfi_def_cfa_offset 16
	popq	%rbp                                         # Восстановаить rbp
	.cfi_def_cfa_offset 8
	ret
.L9:
	.cfi_restore_state
	movl	p(%rip), %edi
	movl	%eax, %ebx
	movq	%rsp, %rbp
	call	close@PLT                                    # Закрыть pipe
	movl	4+p(%rip), %edi
	movl	$8, %edx
	leaq	n(%rip), %rsi
	call	write@PLT                                    # Записать в pipe
	movl	4+p(%rip), %edi
	call	close@PLT                                    # Закрыть pipe
	movl	4+o(%rip), %edi
	call	close@PLT                                    # Закрыть второй pipe
	movl	o(%rip), %edi
	movq	%rbp, %rsi
	movl	$8, %edx
	call	read@PLT                                     # Читать из pipe
	movl	o(%rip), %edi
	call	close@PLT                                    # Закрыть второй pipe
	movq	(%rsp), %rdx
	movq	n(%rip), %rsi
	xorl	%eax, %eax
	leaq	.LC3(%rip), %rdi
	call	printf@PLT                                   # Вывести результат
	movl	%ebx, %edi
	xorl	%edx, %edx
	movq	%rbp, %rsi
	call	waitpid@PLT                                  # Ожидать завершения дочернего процесса
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	jmp	.L10
.L13:
	call	__stack_chk_fail@PLT                         # Ошибка стека
	.cfi_endproc
.LFE23:
	.size	main, .-main
	.globl	n
	.data
	.align 8
	.type	n, @object
	.size	n, 8
n:
	.quad	12                                           # Исходное число для вычисления Фибоначчи
	.globl	o
	.bss
	.align 8
	.type	o, @object
	.size	o, 8
o:
	.zero	8                                            # Зарезервированное место
	.globl	p
	.align 8
	.type	p, @object
	.size	p, 8
p:
	.zero	8                                            # Зарезервированное место
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
