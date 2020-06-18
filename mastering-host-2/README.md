# Sujet 1 : Ecrire de l'assembleur
## Exo 1

```
org 100h

;init
mov al,A ; on met A dans le registre al d'un octet
mov bl,B ; pareil pour B dans bl

;or entre al et bl dans cl
or al,bl ; on fait un 'or' qui sera stocké dans al
mov cl,al ; on met le résultat dans cl
mov al,A ; on remet A dans al

;and entre al et bl dans dl
and al,bl
mov dl,al
mov al,A
    
;not de dl
not dl

;and entre cl et dl dans cl
and cl,dl

 
ret

A db 0b
B db 0b
```

## Exo 2

```
org 100h

;additionneur 1 bit

mov al,1b ;on met notre premiere valeur
mov bl,0b ;on met notre deuxieme valeur
mov cl,al ;on met al dans cl et dl pour faciliter la suite des opérations
mov dl,al

xor cl,bl ;cl prend la somme de al et bl
and dl,bl ;dl prend la retenue de al et bl

```

## Exo 3

```
org 100h

mov dx, texte ; on met notre texte dans dx
mov ah,09h ; on met 09h dans ah, qui servira pour l'interruption
int 21h ; on appelle l'interruption 21h. Comme il y a 09h dans ah, dx va être print dans la console

texte: db "Hello there$"
```

## Exo 4
```
org 100h

Init:
mov dl,48 ; on met '0' dans dl
mov ah,02h ; on prépare l'interruption en mettant 02h dans ah
mov bl,58 ; on prépare la fin de la boucle en mettant ':' dans bl
 
Boucle:
    inc dl ; on incrémente dl : '0' -> '1' -> '2' ...
    cmp dl,bl ; on compare dl a bl
    je Sortie ; si dl = ':' on va à sortie
    int 21h ; sinon on lance l'interruption
    jmp Boucle ; et on boucle
    
Sortie:
    mov dl,49 ; on met '1' dans dl
    int 21h ; on affiche
    mov dl,48 ; on met '0' dans dl
    int 21h ; on affiche
    ret
```