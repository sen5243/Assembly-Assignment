;------------ ASSIGNMENT-------------;
;         R&B TICKETING SYSTEM        ;
;--------------------------------------;
.MODEL SMALL
.STACK 64

.DATA
;------Data Definition-------;
 ;--Messages --;                  
 
 LOGIN     DB  "BEFORE PROCEED TO THE NEXT SESSION, PLEASE LOGIN USING YOUR USERNAME AND PASSWORD.",0DH,0AH,"$"  
 LOGIN2    DB  "THE USERNAME AND PASSWORD CAN BE VIEW IN THE REPORT.",0DH,0AH,"$"
 
 UNAME     DB  "ADMIN" 
 UPASS     DB  "PASSWORD123" 
 
 INAME     DB  99 DUP("*")
 IPASS     DB  99 DUP("*")
 
 CNAME     DW  0  ;HOW MANY USERNAME CHARACTER INPUTTED
 CPASS     DW  0  ;HOW MANY PASSWORD CHARACTER INPUTTED
 
 UMSG      DB  0DH,0AH,"USERNAME: $"
 PMSG      DB  "PASSWORD: $"
 
 SUCMSG    DB  0DH,0AH,0DH,0AH,"LOGIN SUCESSFULLY$" 
 INVMSG    DB  0DH,0AH,0DH,0AH,"INVALID LOGIN,PLEASE TRY AGAIN.$"
 
 DECO1     DB  0DH,0AH,"                 ---------------------------------------$"
 STARTMSG  DB  0DH,0AH,"                | WELCOME TO R&B Train Ticketing System |$"     
        
 DECO2     DB  0DH,0AH,"-----------------------------------------------------------------------$"
 OPTION1   DB  0DH,0AH,"|      1. ALOR SETAR,KEDAH ->  PENANG SENTRAL, PENANG (RM16/PAX)       |$" 
 OPTION2   DB  0DH,0AH,"|      2. ALOR SETAR,KEDAH ->  KL SENTRAL, KUALA LUMPUR (RM18/PAX)     |$" 
 OPTION3   DB  0DH,0AH,"|      3. ALOR SETAR,KEDAH ->  JB SENTRAL, JOHOR BAHRU (RM20/PAX)      |$"
 
 DESMSG DB 0DH,0AH,0DH,0AH,"DESTINATION CHOSEN : $"        
 

 DES1  DB  "ALOR SETAR,KEDAH -> PENANG SENTRAL,PENANG (RM16/PAX)$"
 DES2  DB  "ALOR SETAR,KEDAH ->  KL SENTRAL, KUALA LUMPUR (RM20/PAX)$"
 DES3  DB  "ALOR SETAR,KEDAH ->  JB SENTRAL, JOHOR BAHRU (RM26/PAX)$"
 SELECTDES DB ?
 SELECTMSG DB  0DH,0AH,"PLEASE SELECT YOUR DESTINATION (0 TO EXIT) : $"
 
 ;INPUT STORED
 
 DESINPUT  DB  ?    ;DESTINATION INPUT
 OPTION    DB  "0","1","2","3"     ;OPTION RANGE 
 
 ;TICKET PURCHASING MESSAGE
 BOOKMSG   DB  0DH,0AH,"Please Enter The Quantity of Each Cateories Below To Be Purchased.$"   
 BOOKMSG2  DB  0DH,0AH,"(EACH CATEGORY SHOULD NOT BE EXCEED 14 TICKETS)$"
 BOOKMSG3  DB  0DH,0AH,"(ADD A 0 IN FRONT FOR SINGLE DIGIT INPUT)$"
    
 NORMSG    DB  0DH,0AH,"Normal Tickets                        : $"  
 STUMSG    DB  0DH,0AH,"Students Tickets (10% DISCOUNT)       : $"
 SCMSG     DB  0DH,0AH,"Senior Citizens Tickets (20% DISCOUNT): $" 
 TICMSG    DB  0DH,0AH,"TOTAL TICKETS PURCHASED               : $" 
 NORSUMMSG DB  0DH,0AH,"TOTAL NORMAL TICKETS PRICE            : RM$"
 STUSUMMSG DB  0DH,0AH,"TOTAL STUDENT TICKETS PRICE           : RM$"  
 SCSUMMSG  DB  0DH,0AH,"TOTAL S/C TICKETS PRICE               : RM$"
 DISMSG    DB 0DH,0AH,"DISCOUNT PRICE                        : RM$"  
 SUMMSG    DB 0DH,0AH,"TOTAL PRICE                           : RM$"
 CHAMSG    DB 0DH,0AH,"TOTAL CHANGES                         : RM$"
 
 DISMSG1   DB  0DH,0AH,0DH,0AH,"YOU HAVE PURCHASE > 10 TICKETS, 15% DISCOUNT WILL BE AWARDED TO YOU", 0DH,0AH,"$" 
 DISMSG2   DB 0DH,0AH,0DH,0AH,"YOU HAVE PURCHASE > 6 TICKETS, 10% DISCOUNT WILL BE AWARDED TO YOU", 0DH,0AH,"$"       
       
 ;PRICE
 PRICE1    DB  16,1,6
 PRICE2    DB  18,1,8
 PRICE3    DB  20,2,0 
 PRICE     DB  ?,?,?   ;STORED PRICE VALUE BASED ON OPTION
 
 ;CONFIRMATION
 CONFIRM   DB 0DH,0AH,0DH,0AH,"ARE YOU CONFIRM THAT THE ABOVE PURCHASE INFORMATION ARE CORRECT?$"
 CONFIRM2  DB 0DH,0AH,0DH,0AH,"PRESS 0 FOR RETURNING TO MAIN MENU$"
 CONFIRM3  DB 0DH,0AH,"PRESS 1 TO PROCEED TO PAYMENT SESSION : $"                                                                                                              
                                                                                                              
 RETMSG    DB 0DH,0AH,0DH,0AH,"REDIRECTING TO THE MAIN MENU....$"
 RETMSG2   DB 0DH,0AH,0DH,0AH,"NO TICKETS PURCHASED,REDIRECTING TO THE MAIN MENU....$"
 RETMSG3   DB 0DH,0AH,"PRESS ANY KEY TO PROCEED.$"
 

 ;TICKET QUANTITY
 
 NORTIC  DB 0,0,0   ;NORTIC[1] = 1ST OF NORTIC, NORTIC[2] = 2ND OF NORTIC
 
 STUTIC  DB 0,0,0   ;STUTIC[1] = 1ST OF STUTIC, STUTIC[2] = 2ND OF STUTIC

 SCTIC   DB 0,0,0   ;SCTIC[1] = 1ST OF SCTIC, STUTIC[2] = 2ND OF SCTIC
 
 
 TICSUM  DW 0        ;TOTAL TICKET PURCHASED
 T1      DB 0        ;1ST DIGIT OF TICKET PURCHASED
 T2      DB 0        ;2ND DIGIT OF TICKET PURCHASED
 
 NORSAVE DW 0        ;SAVE NORSUM[0] VALUE BEFORE MAKING ANY CHANGES
 NORSUM  DW 0,0,0,0,0
 NSUM    DB 0,0,0,0,0;5 DIGITS OF NORSUM
 
 STUSAVE DW 0        ;SAVE STUSUM[0] VALUE BEFORE MAKING ANY CHANGES
 STUSUM  DW 0,0,0,0,0
 SSUM    DB 0,0,0,0,0;5 DIGITS OF STUSUM
 
 SCSAVE DW 0         ;SAVE SCSUM[0] VALUE BEFORE MAKING ANY CHANGES
 SCSUM  DW 0,0,0,0,0
 CSUM   DB 0,0,0,0,0 ;5 DIGITS OF SCSUM
 
 TSUMSAVE DW 0       ;SAVE TSUM[0] VALUE BEFORE MAKING ANY CHANGES            
 TSUM   DW 0,0,0,0,0 ;TOTAL TICKETS PRICE
 SUM    DB 0,0,0,0,0 ;5 DIGITS OF TOTAL TICKETS PRICE
 
 DISSUMSAVE DW 0        ;SAVE DISSUM[0] VALUE BEFORE MAKING ANY CHANGES 
 DISSUM    DW 0,0,0,0,0 ;DISCOUNT PRICE
 DIS       DB 0,0,0,0,0 ;5 DIGITS OF DISCOUNT PRICE
 
 ;PAYMENT
 
 PAYMSG    DB 0DH,0AH,0DH,0AH,"PLEASE ENTER YOUR PAYMENT AMOUNT NOT EXCEEDING RM653 (NO FLOATING POINT NUMBER WILL BE ACCEPTED) :RM $"
 PAY       DW 0      ;PAYMENT AMOUNT
 PAYINPUT  DB 0,0,0
 
 PAY1      DW 0
 PAY2      DW 0
 PAY3      DW 0
 
 CHANGESSAVE DW 0       
 CHANGES   DW 0,0,0,0,0
 CHANGES2  DB 0,0,0,0,0
 
 ;ERROR MESSAGES
 MSG1      DB  0DH,0AH,0DH,0AH,"THE DESTINATION OPTION SHOULD BE IN THE RANGE OF 0 TO 3. PLEASE TRY AGAIN.",0DH,0AH,"$"
 MSG2      DB  0DH,0AH,0DH,0AH,"THE QUANTITY INPUT FOR EACH DIGIT SHOULD BE IN THE RANGE 0 TO 9.PLEASE TRY AGAIN",0DH,0AH,"$"
 MSG3      DB  0DH,0AH,0DH,0AH,"THE QUANTITY INPUT FOR EACH CATEGORY SHOULD NOT BE EXCEEDING 14 TICKETS.PLEASE TRY AGAIN.",0DH,0AH,"$"
 MSG4      DB  0DH,0AH,0DH,0AH,"THE CONFIRMATION INPUT SHOULD BE ONLY 0 OR 1.PLEASE TRY AGAIN.",0DH,0AH,"$" 
 MSG5      DB  0DH,0AH,0DH,0AH,"THE PAYMENT INPUT SHOULD BE IN THE RANGE 0 TO 9.PLEASE TRY AGAIN $" 
 MSG6      DB  0DH,0AH,0DH,0AH,"THE PAYMENT INPUT FOR EACH DIGIT SHOULD BE IN THE RANGE 0 TO 9.PLEASE TRY AGAIN",0DH,0AH,"$"
 MSG7      DB  0DH,0AH,0DH,0AH,"INSUFFICIENT PAYMENT,PLEASE TRY AGAIN.",0DH,0AH,"$"  
 MSG8      DB  0DH,0AH,0DH,0AH,"PAYMENT MORE THAN RM653 IS NOT ACCEPTED. PLEASE TRY AGAIN.",0DH,0AH,"$"
 
 ;ENDING MESSAGE
 THXMSG    DB  0DH,0AH,0DH,0AH,"PAYMENT DONE SUCESSFULLY, PRESS ANY BUTTON TO START A NEW SESSION.",0DH,0AH,"$" 
 ENDMSG    DB  0DH,0AH,"THANKS FOR USING OUR SERVICE. HOPE TO SEE YOU AGAIN.$"
 
 ;--End of Messages --;
 
;---END OF DATA DEFINITION---; 
.CODE 

newline MACRO
    MOV AH,02H
    MOV DL,0DH
    INT 21H
    
    MOV DL,0AH
    INT 21H
ENDM

clear MACRO
   MOV AH, 06H 
   MOV AL, 00H ;RESET AL FOR PREVENTING SOME WEIRD BEHAVIOUR AFTER READING THE INPUT WHILE CLEAR SCREEN
   MOV BH, 07H
   MOV CX, 0000H 
   MOV DX,204FH
   INT 10H 
         
   MOV AH,02H
   MOV BH,00
   MOV DX,0000H
   INT 10H;CLEAR SCREEN
ENDM   

display MACRO MSG
   MOV AH,09H
   LEA DX,MSG
   INT 21H  
ENDM


MAIN PROC
        MOV     AX,@DATA
        MOV     DS,AX


    
        ;------Start Of Codes-----;
 ;DISPLAY LOGIN MESSAGE
 
    display LOGIN
    display LOGIN2     
 
 
 
 AGAIN:
    ;--- Read Username
    display UMSG
    
    MOV SI, 0
 
    READNAME:
        MOV AH, 01H
        INT 21H
        MOV INAME[SI], AL  
        
        CMP AL,08H     ;IF USER PRESS DELETE
        JE  DELETENAME
         
        CMP AL,0DH     ;IF USER PRESS ENTER
        JE  ENTERNAME
        JNE INCREASENAME 
        
   DELETENAME:            ;DELETE CHAR
        
        
        CMP SI,0     ;CHECK IF USER DELETE WITHOUT WRITING ANYTHINGS
        JZ  SPACE1
        JNZ DELETEN 
    
    SPACE1:
        MOV AH,02H
        MOV DL, 20h     
        INT 21H        ;PRINT SPACE  
        JMP READNAME
    
   DELETEN:        
        MOV AH,02H
        MOV DL, 20h     
        INT 21H        ;PRINT SPACE
        MOV DL,08H
        INT 21H        ;PRINT BACKSPACE
        
        DEC SI  
        MOV CNAME,SI   ;DECREASE CNAME
        JMP READNAME   ;READ NEXT CHAR AFTER DECREASING THE REGISTERS
        
    INCREASENAME: 
            
        INC SI    
        
        MOV CNAME,SI   ;INCREASE AND UPDATE CNAME
        JMP READNAME   ;READ NEXT CHAR
         
    ENTERNAME:             ;PROCEED TO NEXT SESSION
        JMP PASS
        
    ;--- Read USER PASSWORD   
 PASS:
    display PMSG
    
    MOV CX, 11
    MOV SI, 0 
    
    
    
    READPASS:
        MOV AH, 01H    ;READ PASSWORD
        INT 21H   
        
        MOV IPASS[SI], AL  
        
        CMP AL,08H     ;IF USER PRESS DELETE
        JE  DELETEPASS
         
        CMP AL,0DH     ;IF USER PRESS ENTER
        JE  ENTERPASS
        JNE INCREASEPASS ;PROCEED TO NEXT SESSION 
        
        
   DELETEPASS:            ;DELETE CHAR
        
        CMP SI,0     ;CHECK IF USER DELETE WITHOUT WRITING ANYTHINGS
        JZ  SPACE2
        JNZ DELETEP  
        
   SPACE2: ;IF USER DELETE WITHOUT WRITING ANYTHINGS
        MOV AH,02H
        MOV DL, 20h     
        INT 21H        ;PRINT SPACE  
        JMP READPASS
    
   DELETEP:  ;DELETE INPUT CHAR 
   
        MOV AH,02H
        MOV DL, 20H     
        INT 21H        ;PRINT SPACE 
        MOV DL,08H
        INT 21H        ;PRINT BACKSPACE
           
        DEC SI  
        MOV CPASS,SI   ;DECREASE CPASS
        JMP READPASS   ;READ NEXT CHAR AFTER DECREASING THE REGISTERS
        
  INCREASEPASS: ;INC SI WHILE INPUT CHAR
  
        MOV AH,02H 
        MOV DL,08H
        INT 21H        ;PRINT BACKSPACE
        MOV DL, "*"     
        INT 21H        ;PRINT ASTERICK WHILE INPUTING PASSWORD
      
        INC SI    
        
        MOV CPASS,SI   ;INCREASE AND UPDATE CPASS
        JMP READPASS   ;READ NEXT CHAR
         
   ENTERPASS:             ;PROCEED TO NEXT SESSION
        JMP VALIDATE

;--- 2. Validation
    ;--- validate Username
  VALIDATE:
  
        MOV SI,CNAME
         
        CMP SI, 5      ;CHECK IF USER INPUT 5 CHARACTERS
        JNE ERROR      ;GO TO ERROR MESSAGE
        
        MOV SI, 0      ;RESET SI FOR NEXT VALIDATION
    
  VNAME:
        CMP SI, 5               
        JE  RESETSI            ; IF All elements IS checked
        
        MOV AL, INAME[SI]
        CMP UNAME[SI], AL
        JE  NEXTNAME
        JNE ERROR
        
NEXTNAME:
        INC SI
        JMP VNAME
        
 RESETSI:
        
        MOV SI,CPASS 
        
        CMP SI, 11 ; CHECK IF USER INPUT 11 CHARACTERS
        JNE ERROR  ; GO TO ERROR MSG
        
        MOV SI, 0  ;RESET SI FOR NEXT VALIDATION
    
        ;--- Validate PASSWORD
  VPASS:
         CMP SI, 11
         JE  ACCESS
            
         MOV AL, IPASS[SI]
         CMP UPASS[SI], AL
         JNE ERROR
         JE NEXTPASS
        
NEXTPASS:
         INC SI
         JMP VPASS
        
        
        ;--- 3. Output Display
  ERROR:
         display INVMSG
         JMP AGAIN

  ACCESS:
        display SUCMSG

  START:      
        ;DISPLAY STARTING MSG AFTER LOGIN SUCESS     
        display DECO1  
        display STARTMSG  
        display DECO1 
     
        newline 
        
        ;DISPLAY DESTINATION OPTION
        display DECO2
        display OPTION1
        display DECO2    
        display OPTION2
        display DECO2
        display OPTION3
        display DECO2  
        
        newline
        
  L1: ;DISPLAY USER INPUT   
        display SELECTMSG
        
        MOV AH,01H         ;READ DESTINATION INPUT
        INT 21H

        CMP AL,OPTION[0]    ;COMPARE IF USER INPUT = 0 
        MOV CX,3
        MOV SI,0            ;PREPARE FOR NEXT LOOP
        
        JE  TERMINATE             ;END PROGRAM WITH ENDING MESSAGE
        JNE TEST1  
        
 TERMINATE:
        CALL ENDING       
 TEST1: 
        CMP AL,OPTION[1]    ;COMPARE IF USER INPUT = 1
        JE  L2
        JNE TEST2
 
 TEST2: 
        CMP AL,OPTION[2]    ;COMPARE IF USER INPUT = 2
        JE  L3
        JNE TEST3
        
 TEST3: CMP AL,OPTION[3]    ;COMPARE IF USER INPUT = 3
        JE  L4
        JNE ERROR1          ;IF NOT IN THE RANGE 0 TO 3
        
        
 ERROR1:;DISPLAY ERROR MESSAGE IF THE DESTINAION OPTION NOT IN RANGE
        newline
        display MSG1 
        newline
        
        JMP L1


 L2:;USER CHOOSE 1
    
     MOV AL,PRICE1[SI] ;STORE PRICE VALUE FOR DESTINATION 1
     MOV PRICE[SI],AL
     
     INC SI
     LOOP L2    
     
     display DESMSG
     display DES1
     
     CALL BOOK          ;JUMP TO TICKET PURCHASING SESSION
     

 
 L3: ;USER CHOOSE 2
 
     MOV AL,PRICE2[SI] ;STORE PRICE VALUE FOR DESTINATION 2
     MOV PRICE[SI],AL
     
     INC SI
     LOOP L3   
     
     
     display DESMSG
     display DES2
     
     CALL BOOK    ;TO TICKET PURCHASING SESSION
     
 L4:;USER CHOOSE 3
 
     MOV AL,PRICE3[SI] ;STORE PRICE VALUE FOR DESTINATION 3
     MOV PRICE[SI],AL  
     
     INC SI
     LOOP L4           
     
     display DESMSG
     display DES3
     
     CALL BOOK   ;TO TICKET PURCHASING SESSION
     
 
BOOK:  
     
    newline     
 
 ;SHOW MESSAGE    
     display BOOKMSG
     display BOOKMSG2
     display BOOKMSG3
     
     newline
     
V1:     
     display NORMSG
     
;1ST DIGIT INPUT FOR NORTIC
     
     MOV AH,01H
     INT 21H ;Wait for user input and store in N1
     MOV NORTIC[1],AL
     
     
;2ND DIGIT INPUT FOR NORTIC
   
     MOV AH,01H
     INT 21H ;Wait for user input and store in AL
     MOV NORTIC[2],AL
     
     MOV CX,2
     MOV SI,1 
     
VAL1:;VALIDATE 2 INPUT BY LOOPING

     CMP NORTIC[SI],30H
     JB  ERROR2
     
     CMP NORTIC[SI],39H
     JA  ERROR2
     
     INC SI
     LOOP VAL1

VTEST:  ;TEST IF VALID
     CMP SI,3
     JE  CONV1  ;JMP TO CONVERTION
     

ERROR2:

     display MSG2
     
     JMP V1 ;BACK TO V1

CONV1:    
     ;convert ASCII input to DIGIT and save in NORTIC[1]
     SUB NORTIC[1], 30H  ;NORTIC[1] = NORTIC[1] - 30H

     XOR AX, AX   ;CLEAR AX
     MOV BL, 10
     MOV AL, NORTIC[1]
     MUL BL      ; AX = AL * BL = 1 * 10 = 10
     MOV NORTIC[1], AL  ; NORTIC[1] = 10d
          
    ;convert ASCII input to DIGIT and save in NORTIC[2]
     SUB NORTIC[2],30H  ;NORTIC[2]= NORTIC[2] - 30H

     ;combine 2 digits input into NORTIC[0]
     MOV AL,NORTIC[1]   ;AL = 10d
     ADD AL,NORTIC[2]   ;AL = 15d
     MOV NORTIC[0],AL  ;NORTIC[0] = 15d
     
     CMP NORTIC[0],14 ; IF TICKET INPUT > 14
     JA  QERROR1
     JBE ADD1
                      ; IF TICKET INPUT < 14
QERROR1:
     display MSG3
     JMP V1
     
ADD1:     
     MOV AX,TICSUM
     ADD AL,NORTIC[0]
     MOV TICSUM,AX  ;ADD TOTAL TICKET QUANTITY                



;STUDENT TICKETS INPUT

V2:                   
     ;DISPLAY STUDENT MESSAGE
     display STUMSG  
     
     MOV AH,01H
     INT 21H ;Wait for user input and store in STUTIC[1]
     MOV STUTIC[1],AL
     
     MOV AH,01H
     INT 21H ;Wait for user input and store in STUTIC[2]
     MOV STUTIC[2],AL
     
     MOV CX,2
     MOV SI,1 
     
VAL2:;VALIDATE 2 INPUT BY LOOPING

     CMP STUTIC[SI],30H
     JB  ERROR3
     
     CMP STUTIC[SI],39H
     JA  ERROR3
     
     INC SI
     LOOP VAL2

VTEST2:   ; IF VALID
     CMP SI,3
     JE  CONV2
     

ERROR3:  ; ERROR MESSAGE

     display MSG2
     
     JMP V2  ;BACK TO V2

CONV2:      
     ;Convert ASCII input to digit and save in S1

     SUB STUTIC[1], 30H  ;AL = AL-30H

     XOR AX, AX   ;CLEAR AX
     MOV BL, 10
     MOV AL, STUTIC[1]
     MUL BL      ; AX = AL * BL = 1 * 10 = 10
     MOV STUTIC[1], AL  ; S1 = 10d

    ;convert ASCII input to DIGIT and save in S2
     SUB STUTIC[2],30H  ;AL= AL-30H

     ;combine 2 digits input into STUTIC
     MOV AL, STUTIC[1]   ;AL = 10d
     ADD AL, STUTIC[2]   ;AL = 15d
     MOV STUTIC[0],AL  ;STUTIC = 15d
     
     CMP STUTIC[0],14 ; IF TICKET INPUT > 14
     JA  QERROR2
     JBE ADD2         ; IF TICKET INPUT < 14

QERROR2: ; DISPLAY ERROR MESSAGE
     display MSG3
     JMP V2
     
ADD2:     
     MOV AX,TICSUM
     ADD AL,STUTIC[0]
     MOV TICSUM,AX  ;ADD TOTAL TICKET QUANTITY       

;S/C TICKETS INPUT
     
V3:     ;DISPLAY SC MESSAGE
     display SCMSG
     
     MOV AH,01H
     INT 21H ;Wait for user input and store in SCTIC[1]
     MOV SCTIC[1],AL
     
     MOV AH,01H
     INT 21H ;Wait for user input and store in SCTIC[2] 
     MOV SCTIC[2],AL
     
     MOV CX,2
     MOV SI,1 
     
VAL3:;VALIDATE 2 INPUT BY LOOPING

     CMP SCTIC[SI],30H
     JB  ERROR4
     
     CMP SCTIC[SI],39H
     JA  ERROR4
     
     INC SI
     LOOP VAL3

VTEST3:  ;IF VALID
     CMP SI,3
     JE  CONV3   ;JMP TO CONVERTION
     

ERROR4: ;IF TICKET INPUT CONTAIN NON-DIGIT INPUT

     display MSG2
     
     JMP V3   ;BACK TO V3

CONV3:  
     ;Convert ASCII input to digit and save in SC1

     SUB SCTIC[1], 30H  ;AL = AL-30H

     XOR AX, AX   ;CLEAR AX
     MOV BL, 10
     MOV AL, SCTIC[1]
     MUL BL      ; AX = AL * BL = 1 * 10 = 10
     MOV SCTIC[1], AL  ; S1 = 10d   
     
    ;convert ASCII input to DIGIT and save in SC2
     SUB SCTIC[2],30H  ;AL= AL-30H

     ;combine 2 digits input into SCTIC
     MOV AL,SCTIC[1]   ;AL = 10d
     ADD AL,SCTIC[2]   ;AL = 15d
     MOV SCTIC[0],AL  ;SCTIC = 15d
     
     CMP SCTIC[0],14 ; IF TICKET INPUT > 14
     JA  QERROR3
     JBE ADD3        ;IF TICKET INPUT <= 14

QERROR3: ;DISPLAY ERROR MESSAGE
     display MSG3
     
     JMP V3  ; BACK TO SC TICKET INPUT
     
ADD3:     
     
     MOV AX,TICSUM
     ADD AL,SCTIC[0]
     MOV TICSUM,AX  ;ADD TOTAL TICKET QUANTITY 
       
CHECKTSUM:  ;CHECK TOTAL TICKET SUM

     CMP TICSUM,0 ;CHECK IF TOTAL TICKET PURCHASED = 0
     JE  TORETURN2
     JNE SUMTIC 
       
TORETURN2:
    CALL RETURN2
     ;DISPLAY TOTAL PURCHASE TICKETS     

SUMTIC:     
     ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
     XOR      AX, AX           ; CLEAR AX
     MOV      BL, 10           ; DIVISOR (10)
     MOV      AX, TICSUM        ; DIVIEND (105)
     DIV      BL               ; AX = AL/BL

     ;SAVE RESULT OF DIVISION
     MOV      T1, AL      ;QUOTIENT
     MOV      T2, AH      ;REMAINDER 
     
     ;DISPLAY TOTAL TICKET PURCHASED
     newline
     
     display TICMSG
     
     ADD T1,30H
     ADD T2,30H
     
     MOV AH,02H
     MOV DL,T1
     INT 21H
     
     MOV AH,02H
     MOV DL,T2
     INT 21H   
     
    ;CALCULATE TOTAL NORMAL TICKETS PRICE  (NORTIC * PRICE)
    
    XOR AX,AX
    MOV AL,NORTIC[0]
    MUL PRICE[0]
    MOV NORSUM[0],AX
    MOV NORSAVE,AX ;SAVE NORSUM[0] VALUE
    
    CMP NORSUM[0],100 
    JB  L5
    JNB TEST4    

L5: ;FOR PRICE BELOW 100
    XOR AX,AX
    MOV AX,NORSUM[0]
    MOV BX,10 
    MUL BX    ;MAKE IT TO 3 DIGITS FOR FOMATTING PURPOSE
    MOV NORSUM[0],AX
    MOV NORSAVE,AX   ;UPDATE NORSAVE
    JMP CON2
    
    
TEST4:

    CMP NORSUM[0],1000
    JB  L6
    JNB TEST5

L6:
    XOR AX,AX
    MOV AX,NORSUM[0]
    MOV BX,10 
    MUL BX
    MOV NORSUM[0],AX 
    MOV NORSAVE,AX
    JMP CON1

TEST5:
    JMP CON1
    
    
CON1:  ;FOR PRICE > RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, NORSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AX/BX

    ;SAVE RESULT OF DIVISION
    MOV      NORSUM[1], AX      ;QUOTIENT = AX
    MOV      NSUM[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, NORSUM[1]    ; DIVIEND (10)
    DIV      BX               ; AX = AX/BX

    ;SAVE RESULT OF DIVISION
    MOV      NORSUM[2], AX      ;QUOTIENT = AX
    MOV      NSUM[1], DL      ;REMAINDER = DX  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, NORSUM[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AX/BL
    
    ;SAVE RESULT OF DIVISION  ;SINCE THE NORSUM ALR < 3 DIGITS WE CAN USE AL AH INSTEAD OF DX AX
    MOV      NSUM[3], AL      ;QUOTIENT = AL
    MOV      NSUM[2], AH      ;REMAINDER = AH   
    
    JMP NOR

CON2: ; IF THE NORMAL PRICE < RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, NORSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AX/BX

    ;SAVE RESULT OF DIVISION
    MOV      NORSUM[1], AX      ;QUOTIENT = AX
    MOV      NSUM[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, NORSUM[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AX/BL

    
    ;SAVE RESULT OF DIVISION  ;SINCE THE NORSUM ALR < 3 DIGITS WE CAN USE AL AH INSTEAD OF DX AX
    MOV      NSUM[2], AL      ;QUOTIENT = AL
    MOV      NSUM[1], AH      ;REMAINDER = AH
    
    JMP NOR2
    
    
     
NOR:;DISPLAY TOTAL NORMAL PRICE > RM100
    MOV AH,09H
    LEA DX,NORSUMMSG
    INT 21H
    
    ;CONVERT DIGIT TO ASCII
    
    ADD NSUM[4],30H
    ADD NSUM[0],30H 
    ADD NSUM[1],30H
    ADD NSUM[2],30H 
    ADD NSUM[3],30H     
    
    MOV AH,02H  
    
    MOV DL,NSUM[3]
    INT 21H
    
    MOV DL,NSUM[2]
    INT 21H

    MOV DL,NSUM[1]
    INT 21H
           
    MOV DL,"."
    INT 21H
    
    MOV DL,NSUM[0]
    INT 21H 
    
    MOV DL,NSUM[4];EXTRA 0 FOR DISPLAY PURPOSE
    INT 21H
    
    JMP SPRICE

NOR2:;DISPLAY TOTAL NORMAL PRICE < RM100
    MOV AH,09H
    LEA DX,NORSUMMSG
    INT 21H
    
    ;CONVERT DIGIT TO ASCII
    
    ADD NSUM[0],30H 
    ADD NSUM[1],30H
    ADD NSUM[2],30H 
    ADD NSUM[3],30H     
    
    MOV AH,02H  
    
    MOV DL,NSUM[2]
    INT 21H
    
    MOV DL,NSUM[1]
    INT 21H
    
    MOV DL,"."
    INT 21H
    
    MOV DL,NSUM[0]
    INT 21H
    
    MOV DL,NSUM[3];EXTRA 0 FOR DISPLAY PURPOSE
    INT 21H 
    
    JMP SPRICE 
      
SPRICE:
    
    ;CALCULATE TOTAL STUDENT TICKETS PRICE  (STUTIC * PRICE * 0.9)
    
    XOR AX,AX
    MOV AL,STUTIC
    MUL PRICE[0]
    MOV STUSUM[0],AX
      
    
    XOR AX,AX 
    MOV AX,STUSUM[0]
    MOV BX,9       ;10% DISCOUNT
    MUL BX  
    
    MOV STUSUM[0],AX
    MOV STUSAVE,AX   
    
    CMP STUSUM[0],1000 ;CHECK IF THE PRICE > RM100 (SINCE MUL 9, THE VALUE WILL BE DEFINITELY > 100 SO WE USE 1000 TO COMPARE)
    JB  SCON2
    JNB SCON1
    
    
SCON1: ;FOR PRICE > RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, STUSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AX/BX

    ;SAVE RESULT OF DIVISION
    MOV      STUSUM[1], AX      ;QUOTIENT = AX
    MOV      SSUM[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, STUSUM[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AX/BL

    ;SAVE RESULT OF DIVISION
    MOV      SSUM[2], AL      ;QUOTIENT = AL
    MOV      SSUM[1], AH      ;REMAINDER = AH  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, SSUM[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      SSUM[3], AL      ;QUOTIENT = AL
    MOV      SSUM[2], AH      ;REMAINDER = AH
 
    
    JMP STU

SCON2: ; IF THE PRICE < RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, STUSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AX/BX

    ;SAVE RESULT OF DIVISION
    MOV      STUSUM[1], AX      ;QUOTIENT = AX
    MOV      SSUM[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, STUSUM[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AX/BL

    ;SAVE RESULT OF DIVISION
    MOV      SSUM[2], AL      ;QUOTIENT = AL
    MOV      SSUM[1], AH      ;REMAINDER = AH  

    
    JMP STU2  
     
STU:;DISPLAY TOTAL NORMAL PRICE > RM100
    display STUSUMMSG
    
    ;CONVERT DIGIT TO ASCII
    
    
    ADD SSUM[0],30H 
    ADD SSUM[1],30H
    ADD SSUM[2],30H 
    ADD SSUM[3],30H
    ADD SSUM[4],30H     
    
    MOV AH,02H  
    
    
    MOV DL,SSUM[3]
    INT 21H
    
    MOV DL,SSUM[2]
    INT 21H
    
    
    MOV DL,SSUM[1]
    INT 21H
    
    MOV DL,"."
    INT 21H
    
    MOV DL,SSUM[0]
    INT 21H
    
    MOV DL,SSUM[4]
    INT 21H  
    
    JMP SCPRICE
    

STU2:;DISPLAY TOTAL NORMAL PRICE < RM100
    display STUSUMMSG
    
    ;CONVERT DIGIT TO ASCII
    
    ADD SSUM[0],30H 
    ADD SSUM[1],30H
    ADD SSUM[2],30H 
    ADD SSUM[3],30H     
    
    MOV AH,02H  
        
    MOV DL,SSUM[2]
    INT 21H
    
    MOV DL,SSUM[1]
    INT 21H 
    
    MOV DL,"."
    INT 21H
    
    MOV DL,SSUM[0]
    INT 21H 
    
    MOV DL,SSUM[3] ;EXTRA 0 FOR DISPLAY PURPOSE
    INT 21H
    
    JMP SCPRICE

SCPRICE:  
    
    ;CALCULATE TOTAL STUDENT TICKETS PRICE  (STUTIC * PRICE * 0.9)
    
    XOR AX,AX
    MOV AL,SCTIC
    MUL PRICE[0]
    MOV SCSUM[0],AX
    
    
    XOR AX,AX 
    MOV AX,SCSUM[0]
    MOV BX,8       ;20% DISCOUNT
    MUL BX  
     
    MOV SCSUM[0],AX
    MOV SCSAVE,AX    
    
    CMP SCSUM[0],1000 ;CHECK IF THE PRICE > RM100 (SINCE MUL 8, THE VALUE WILL BE DEFINITELY > 100 SO WE USE 1000 TO COMPARE)
    JB  SCCON2
    JNB SCCON1
    
    
SCCON1:  ;FOR PRICE > RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, SCSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      SCSUM[1], AX      ;QUOTIENT = AX
    MOV      CSUM[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, SCSUM[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      CSUM[2], AL      ;QUOTIENT = AX
    MOV      CSUM[1], AH      ;REMAINDER = DX  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, CSUM[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      CSUM[3], AL      ;QUOTIENT = AL
    MOV      CSUM[2], AH      ;REMAINDER = AH
 
    
    JMP SE1

SCCON2: ; IF THE PRICE < RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, SCSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AX/BX

    ;SAVE RESULT OF DIVISION
    MOV      SCSUM[1], AX      ;QUOTIENT = AX
    MOV      CSUM[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, SCSUM[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AX/BL

    ;SAVE RESULT OF DIVISION
    MOV      CSUM[2], AL      ;QUOTIENT = AL
    MOV      CSUM[1], AH      ;REMAINDER = AH  

    
    JMP SE2
    
    
     
SE1:;DISPLAY TOTAL SC PRICE > RM100
    display SCSUMMSG
    
    ;CONVERT DIGIT TO ASCII
    
    
    ADD CSUM[0],30H 
    ADD CSUM[1],30H
    ADD CSUM[2],30H 
    ADD CSUM[3],30H
    ADD CSUM[4],30H     
    
    MOV AH,02H  
    
    
    MOV DL,CSUM[3]
    INT 21H
    
    MOV DL,CSUM[2]
    INT 21H
    
    
    MOV DL,CSUM[1]
    INT 21H
    
    MOV DL,"."
    INT 21H
    
    MOV DL,CSUM[0]
    INT 21H
    
    MOV DL,CSUM[4]
    INT 21H  
 
    
    JMP SUMPRICE
    

SE2:;DISPLAY TOTAL SC PRICE < RM100
    display SCSUMMSG
    
    ;CONVERT DIGIT TO ASCII
    
    ADD CSUM[0],30H 
    ADD CSUM[1],30H
    ADD CSUM[2],30H 
    ADD CSUM[3],30H     
    
    MOV AH,02H  
        
    MOV DL,CSUM[2]
    INT 21H
    
    MOV DL,CSUM[1]
    INT 21H 
    
    MOV DL,"."
    INT 21H
    
    MOV DL,CSUM[0]
    INT 21H 
    
    MOV DL,CSUM[3] ;EXTRA 0 FOR DISPLAY PURPOSE
    INT 21H
    
    JMP SUMPRICE     


SUMPRICE:  ;CALCULATE TOTAL PRICE     
    
    MOV AX,NORSAVE
    ADD AX,STUSAVE
    ADD AX,SCSAVE
    MOV TSUM[0],AX
    MOV TSUMSAVE,AX
       
    CMP TICSUM,10   ;CHECK IF TICKETS > 10
    JAE DIS1
    
    CMP TICSUM,6   ;CHECK IF TICKETS > 6
    JAE DIS2
    JB  DIS3 

DIS1: ;FOR TICKETS > 10

    XOR AX,AX
    XOR DX,DX 
    MOV AX,TSUM[0] 
    
    MOV BX,15  ;15% DISCOUNT
    MUL BX
    
    MOV BX,10  ;DIVIDE 10 IN ORDER TO PERFORM CALCULATION
    DIV BX
    
    MOV DISSUM[0],AX  ;SAVE DISCOUNT VALUE
    MOV DISSUMSAVE,AX 
    
    XOR AX,AX
    MOV BX,10
    MOV AX,TSUM[0]
    MUL BX
    MOV TSUM[0],AX
    
    MOV AX,TSUM[0]
    SUB AX,DISSUM[0] ;CALCULATE TOTAL PRICE AFTER DISCOUNT
      
    MOV TSUM[0],AX
    MOV TSUMSAVE,AX    ;SAVE TOTAL PRICE VALUE
    
    MOV AH,09H
    LEA DX,DISMSG1
    INT 21H
    JMP DISPRICE     ;JMP TO FORMAT PRICE

DIS2:    ;FOR TICKETS > 6
    XOR AX,AX
    XOR DX,DX 
    MOV AX,TSUM[0] 
    
    MOV BX,10  ;10% DISCOUNT
    MUL BX
    
    MOV BX,10  
    DIV BX
    
    MOV DISSUM[0],AX   ;SAVE DISCOUNT VALUE
    MOV DISSUMSAVE,AX 
       
    XOR AX,AX
    MOV BX,10
    MOV AX,TSUM[0]
    MUL BX
    MOV TSUM[0],AX
    
    MOV AX,TSUM[0]
    SUB AX,DISSUM[0]   ;CALCULATE TOTAL PRICE AFTER DISCOUNT
      
    MOV TSUM[0],AX
    MOV TSUMSAVE,AX   ;SAVE TOTAL PRICE VALUE
    
    MOV AH,09H
    LEA DX,DISMSG2
    INT 21H
    JMP DISPRICE    ;JMP TO FORMAT PRICE
    
      
DIS3: 

    JMP DISPRICE  ;JMP TO FORMAT PRICE
    

DISPRICE:;FORMAT DISCOUNT PRICE 

    CMP DISSUM[0],1000 ;CHECK IF THE PRICE > 10
    JB  DISCON2
    JNB DISCON1

DISCON1:  ; FOR TOTAL PRICE > RM10
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX           ; CLEAR DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, DISSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AX/BX

    ;SAVE RESULT OF DIVISION
    MOV      DISSUM[1], AX      ;QUOTIENT = AX
    MOV      DIS[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX     
    XOR      DX, DX           ; CLEAR DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, DISSUM[1]    ; DIVIEND (10)
    DIV      BX               ; AX = AX/BX

    ;SAVE RESULT OF DIVISION
    MOV      DISSUM[2], AX      ;QUOTIENT = AX
    MOV      DIS[1], DL      ;REMAINDER = DX  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, DISSUM[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AX/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      DIS[3], AL      ;QUOTIENT = AL
    MOV      DIS[2], AH      ;REMAINDER = AH
   
    ;DIVISION (SINCE THE SSUM ALR < 3 DIGITS WE CAN USE AL AH INSTEAD OF DX AX
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, DIS[3]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION  ;SINCE THE SSUM ALR < 3 DIGITS WE CAN USE AL AH INSTEAD OF DX AX
    MOV      DIS[4], AL      ;QUOTIENT = AL
    MOV      DIS[3], AH      ;REMAINDER = AH   
    

    JMP DISCOUNT

DISCON2: ; FOR TOTAL PRICE < RM10
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, DISSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      DISSUM[1], AX      ;QUOTIENT = AX
    MOV      DIS[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, DISSUM[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      DIS[2], AL      ;QUOTIENT = AL
    MOV      DIS[1], AH      ;REMAINDER = AH  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, DIS[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      DIS[3], AL      ;QUOTIENT = AL
    MOV      DIS[2], AH      ;REMAINDER = AH
    
    JMP DISCOUNT2
        
DISCOUNT:;DISPLAY DISCOUNT PRICE > RM10   

    CMP DISSUMSAVE ,10000 ;CHECK IF THE PRICE > RM100
    JNB DISCOUNT3
    
    MOV AH,09H
    LEA DX,DISMSG
    INT 21H
    
    ;CONVERT DIGIT TO ASCII
    
    
    ADD DIS[0],30H 
    ADD DIS[1],30H
    ADD DIS[2],30H 
    ADD DIS[3],30H    
    
    MOV AH,02H  
    
    MOV DL,DIS[3]
    INT 21H
    
    MOV DL,DIS[2]
    INT 21H
    
    MOV DL,"."
    INT 21H
    
    MOV DL,DIS[1]
    INT 21H
    
    MOV DL,DIS[0]
    INT 21H  
    
    JMP TPRICE
    

DISCOUNT2:;DISPLAY DISCOUNT PRICE < RM10
    display DISMSG
    
    ;CONVERT DIGIT TO ASCII
    
    ADD DIS[0],30H 
    ADD DIS[1],30H
    ADD DIS[2],30H      
    
    MOV AH,02H  
    
    
    MOV DL,DIS[2]
    INT 21H 
    
    MOV DL,"."
    INT 21H
    
    MOV DL,DIS[1]
    INT 21H  
    
    MOV DL,DIS[0]   ;EXTRA 0 FOR DISPLAY PURPOSE
    INT 21H 
    
    JMP TPRICE 

DISCOUNT3:;DISPLAY DISCOUNT PRICE > RM100
    display DISMSG
    
    ;CONVERT DIGIT TO ASCII
    
    
    ADD DIS[0],30H 
    ADD DIS[1],30H
    ADD DIS[2],30H 
    ADD DIS[3],30H
    ADD DIS[4],30H    
    
    MOV AH,02H 
     
    MOV DL,DIS[4]
    INT 21H
        
    MOV DL,DIS[3]
    INT 21H
    
    MOV DL,DIS[2]
    INT 21H
    
    MOV DL,"."
    INT 21H
    
    MOV DL,DIS[1]
    INT 21H
    
    MOV DL,DIS[0]
    INT 21H  
    
    JMP TPRICE 
    

TPRICE:;FORMAT TOTAL PRICE
     
    CMP TSUM[0],10000 ;CHECK IF THE PRICE > 100
    JB  TPRICE2
    JNB TCON1
   

TPRICE2:  
    CMP TSUM[0],1000 ;CHECK IF THE VALUE CONTAIN 4 DIGITS
    JB TCON3
    JA TCON2

TCON3: ;FOR 3 DIGITS VALUE (MAKING IT 4 DIGITS BY MUL 10)
    
    MOV AX,TSUM[0]
    MOV BX,10
    MUL BX
    
    MOV TSUM[0],AX
    JMP TCON2
        
TCON1:  ; FOR TOTAL PRICE > RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX           ; CLEAR DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, TSUM[0]      ; DIVIEND (105)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      TSUM[1], AX      ;QUOTIENT = AX
    MOV      SUM[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX     
    XOR      DX, DX           ; CLEAR DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, TSUM[1]    ; DIVIEND (10)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      TSUM[2], AX      ;QUOTIENT = AX
    MOV      SUM[1], DL      ;REMAINDER = DX  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, TSUM[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      SUM[3], AL      ;QUOTIENT = AL
    MOV      SUM[2], AH      ;REMAINDER = AH
   
    ;DIVISION (SINCE THE SSUM ALR < 3 DIGITS WE CAN USE AL AH INSTEAD OF DX AX
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, SUM[3]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION  ;SINCE THE SSUM ALR < 3 DIGITS WE CAN USE AL AH INSTEAD OF DX AX
    MOV      SUM[4], AL      ;QUOTIENT = AL
    MOV      SUM[3], AH      ;REMAINDER = AH   
    
    JMP TOTAL

TCON2: ; FOR TOTAL PRICE < RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, TSUM[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      TSUM[1], AX      ;QUOTIENT = AX
    MOV      SUM[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, TSUM[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      SUM[2], AL      ;QUOTIENT = AL
    MOV      SUM[1], AH     ;REMAINDER = AH  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, SUM[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      SUM[3], AL      ;QUOTIENT = AL
    MOV      SUM[2], AH      ;REMAINDER = AH
    
    JMP TOTAL2   
    
     
TOTAL:;DISPLAY TOTAL PRICE
    display SUMMSG
    
    ;CONVERT DIGIT TO ASCII
    
    
    ADD SUM[0],30H 
    ADD SUM[1],30H
    ADD SUM[2],30H 
    ADD SUM[3],30H
    ADD SUM[4],30H     
    
    MOV AH,02H  
    
    MOV DL,SUM[4]
    INT 21H
    
    MOV DL,SUM[3]
    INT 21H
    
    MOV DL,SUM[2]
    INT 21H
    
    MOV DL,"."
    INT 21H
    
    MOV DL,SUM[1]
    INT 21H
    
    MOV DL,SUM[0]
    INT 21H  
    
    JMP CON
    

TOTAL2:;DISPLAY TOTAL  PRICE < RM100
    display SUMMSG
    
    ;CONVERT DIGIT TO ASCII
    
    ADD SUM[0],30H 
    ADD SUM[1],30H
    ADD SUM[2],30H 
    ADD SUM[3],30H     
    
    MOV AH,02H  
    
    MOV DL,SUM[3]
    INT 21H
    
    
    MOV DL,SUM[2]
    INT 21H 
    
    MOV DL,"."
    INT 21H
    
    MOV DL,SUM[1]
    INT 21H  
    
    MOV DL,SUM[0]   
    INT 21H  
         
    JMP CON  
    
    
CON:   ;CONFIRMATION SESSION
 
   display CONFIRM   
   display CONFIRM2
   display CONFIRM3   
   
   MOV AH,01H ;READ USER INPUT FOR CONFIRMATION
   INT 21H  
   
   CMP AL,"0" ;RETURN TO MAIN MANU
   JE  TORETURN 
   
   CMP AL,"1"  ;PROCEED TO PAYMENT
   JE  PAYMENT
   JNE ERROR5
 
TORETURN:
    CALL RETURN
    
ERROR5:

    display MSG4
    JMP CON

PAYMENT:
     
      display PAYMSG
      
      MOV AH,01H
      INT 21H ;Wait for user input and store in AL   

      MOV PAYINPUT[0],AL  
     
;2ND DIGIT INPUT FOR PAYMENT
   
     MOV AH,01H
     INT 21H ;Wait for user input and store in AL 
     
     MOV PAYINPUT[1],AL 
     
;3RD DIGIT INPUT FOR PAYMENT
   
     MOV AH,01H
     INT 21H ;Wait for user input and store in AL
     
     MOV PAYINPUT[2],AL
     
     MOV CX,3
     MOV SI,0 
     JMP PVAL     ;JUMP TO VALIDATION
     
    
PVAL:;VALIDATE 2 INPUT BY LOOPING

     CMP PAYINPUT[SI],0030H
     JB  PERROR
     
     CMP PAYINPUT[SI],0039H
     JA  PERROR
     
     INC SI
     LOOP PVAL

PTEST:
     CMP SI,3
     JE  PCONV1
     

PERROR:

     display MSG6
     
     JMP PAYMENT

PCONV1:  ;CONVERT PAYMENT INPUT INTO 3 DIGITS
     ;convert ASCII input to DIGIT and save in PAY1
     SUB PAYINPUT[0], 30H  ;PAY[1] = PAY[1] - 30H
 
     XOR AX, AX   ;CLEAR AX 
     MOV AL,PAYINPUT[0];MOVE FIRST VALUE TO AL
     MOV PAY1,AX ;MOVE AX TO FIRST VALUE FOR LATER CALCULATION
     
     MOV BX, 100
     MOV AX, PAY1
     MUL BX      ; AX = AL * BL = 1 * 100 = 100
     MOV PAY1, AX  ; PAY[1] = 100d
          
    ;convert ASCII input to DIGIT and save in PAY2
     SUB PAYINPUT[1],30H  ;PAY[2]= PAY[2] - 30H 
     MOV AX,PAY1   ;AX = 100d
     XOR AX, AX   ;CLEAR AX 
     MOV AL,PAYINPUT[1];MOVE SECOND VALUE TO AL
     MOV PAY2,AX ;MOVE AX TO SECOND VALUE FOR LATER CALCULATION
     
     XOR AX, AX   ;CLEAR AX
     MOV BX, 10
     MOV AX, PAY2
     MUL BX      ; AX = AL * BL = 1 * 10 = 10
     MOV PAY2, AX  ; PAY[2] = 10d  
     ;convert ASCII input to DIGIT and save in PAY3 
     
     SUB PAYINPUT[2],30H 
     XOR AX, AX   ;CLEAR AX 
     MOV AL,PAYINPUT[2];MOVE THIRD VALUE TO AL
     MOV PAY3,AX ;MOVE AX TO THIRD VALUE FOR LATER CALCULATION 
     
     XOR AX,AX
     ;combine 2 digits input into PAY
     
     
     MOV AX,PAY1   ;AX = 100d
     ADD AX,PAY2   ;AX = 150d
     ADD AX,PAY3   ;AX = 155d
     MOV PAY,AX  ;PAY[0] = 155d
     
     CMP PAY,653    ;CHECK IF PAYMENT VALUE > 653
     JA  PERROR3    ;JMP TO ERROR MESSAGE
     
     ;FORMAT PAYMENT FOR CALCULATION
     
     XOR AX,AX
     MOV AX,PAY
     MOV BX,100
     MUL BX
     
     MOV PAY,AX
     MOV AX,TSUMSAVE
     
     CMP TSUMSAVE,1000
     JB  ADDSUM
     JNB CMPPRICE
     
ADDSUM:
     MOV AX,TSUMSAVE
     MOV BX,10
     MUL BX      
     MOV TSUMSAVE,AX
     
     ;COMPARE TWO VALUE
CMPPRICE:     
     MOV AX,TSUMSAVE 
     CMP PAY,AX
     JB  PERROR2
     JAE CAL 

    
PERROR2:  ;IF PAYMENT < TOTAL PRICE
    
     display MSG7
     
     JMP PAYMENT  
     
     
PERROR3: ; IF PAYMENT > RM653
    
     display MSG8
     JMP PAYMENT

CAL: ;PERFORM CALCULATION
     MOV AX,PAY 
     MOV BX,TSUMSAVE 

     SUB AX,BX
     
     MOV CHANGES[0],AX
     MOV CHANGESSAVE,AX
     
CALPRICE:;FORMAT CHANGE PRICE 

    CMP CHANGES[0],10000 ;CHECK IF THE PRICE > RM100
    JB  CTEST1
    JNB CALCON1

CTEST1:
    CMP CHANGES[0],1000  ;CHECK IF THE PRICE < RM10
    JB  CALCON2
    JNB CALCON3
    
CALCON1:  ; FOR CHANGES PRICE > RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX           ; CLEAR DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, CHANGES[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      CHANGES[1], AX      ;QUOTIENT = AX
    MOV      CHANGES2[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX     
    XOR      DX, DX           ; CLEAR DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, CHANGES[1]    ; DIVIEND (10)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      CHANGES[2], AX      ;QUOTIENT = AX
    MOV      CHANGES2[1], DL      ;REMAINDER = DX  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, CHANGES[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      CHANGES2[3], AL      ;QUOTIENT = AL
    MOV      CHANGES2[2], AH      ;REMAINDER = AH
   
    ;DIVISION (SINCE THE SSUM ALR < 3 DIGITS WE CAN USE AL AH INSTEAD OF DX AX
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, CHANGES2[3]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION  ;SINCE THE SSUM ALR < 3 DIGITS WE CAN USE AL AH INSTEAD OF DX AX
    MOV      CHANGES2[4], AL      ;QUOTIENT = AL
    MOV      CHANGES2[3], AH      ;REMAINDER = AH   
    
    JMP CPRICE

CALCON2: ; FOR CHANGES PRICE < RM10
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, CHANGES[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      CHANGES[1], AX      ;QUOTIENT = AX
    MOV      CHANGES2[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, CHANGES[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      CHANGES2[2], AL      ;QUOTIENT = AL
    MOV      CHANGES2[1], AH      ;REMAINDER = AH  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, CHANGES2[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      CHANGES2[3], AL      ;QUOTIENT = AL
    MOV      CHANGES2[2], AH      ;REMAINDER = AH
    
    JMP CPRICE2
    

CALCON3: ; FOR CHANGES PRICE < RM100
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX 
    XOR      DX, DX
    MOV      BX, 10           ; DIVISOR (10)
    MOV      AX, CHANGES[0]    ; DIVIEND (105)
    DIV      BX               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      CHANGES[1], AX      ;QUOTIENT = AX
    MOV      CHANGES2[0], DL        ;REMAINDER  = DX

    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AX, CHANGES[1]    ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL

    ;SAVE RESULT OF DIVISION
    MOV      CHANGES2[2], AL      ;QUOTIENT = AL
    MOV      CHANGES2[1], AH      ;REMAINDER = AH  
    
    ;DIVISION (SEPARATE RESULT INTO DIFFERENT DIGITS)
    XOR      AX, AX           ; CLEAR AX
    MOV      BL, 10           ; DIVISOR (10)
    MOV      AL, CHANGES2[2]        ; DIVIEND (10)
    DIV      BL               ; AX = AL/BL
    
    ;SAVE RESULT OF DIVISION
    MOV      CHANGES2[3], AL      ;QUOTIENT = AL
    MOV      CHANGES2[2], AH      ;REMAINDER = AH
    
    JMP CPRICE3
        
     
CPRICE:;DISPLAY DISCOUNT PRICE > RM100
    display CHAMSG
    
    ;CONVERT DIGIT TO ASCII
    
    
    ADD CHANGES2[0],30H 
    ADD CHANGES2[1],30H
    ADD CHANGES2[2],30H 
    ADD CHANGES2[3],30H
    ADD CHANGES2[4],30H    
    
    MOV AH,02H  
    
    MOV DL,CHANGES2[4]
    INT 21H
    
    MOV DL,CHANGES2[3]
    INT 21H
    
    MOV DL,CHANGES2[2]
    INT 21H
    
    MOV DL,"."
    INT 21H
    
    MOV DL,CHANGES2[1]
    INT 21H
    
    MOV DL,CHANGES2[0]
    INT 21H  
    
    JMP CONTINUE
    

CPRICE2:;DISPLAY CHANGE PRICE < RM10
    display CHAMSG
    
    ;CONVERT DIGIT TO ASCII
    
    ADD CHANGES2[0],30H 
    ADD CHANGES2[1],30H
    ADD CHANGES2[2],30H      
    
    MOV AH,02H  
    
    
    MOV DL,CHANGES2[2]
    INT 21H 
    
    MOV DL,"."
    INT 21H
    
    MOV DL,CHANGES2[1]
    INT 21H  
    
    MOV DL,CHANGES2[0]   ;EXTRA 0 FOR DISPLAY PURPOSE
    INT 21H 
    
    JMP CONTINUE     
    
CPRICE3:;DISPLAY DISCOUNT PRICE > RM10
    display CHAMSG
    
    ;CONVERT DIGIT TO ASCII
    
    ADD CHANGES2[0],30H 
    ADD CHANGES2[1],30H
    ADD CHANGES2[2],30H 
    ADD CHANGES2[3],30H      
    
    MOV AH,02H  
    
    MOV DL,CHANGES2[3]
    INT 21H
    
    MOV DL,CHANGES2[2]
    INT 21H 
    
    MOV DL,"."
    INT 21H
    
    MOV DL,CHANGES2[1]
    INT 21H  
    
    MOV DL,CHANGES2[0]   ;EXTRA 0 FOR DISPLAY PURPOSE
    INT 21H 
    
    JMP CONTINUE
    


CONTINUE: ;AFTER PAYMENT SESSION, START A NEW SESSION
   
   display THXMSG  
   
   MOV AH,07H ;READ USER INPUT FOR CONFIRMATION
   INT 21H  
   
   JMP RETURN

RETURN: 
   
   display RETMSG 
   display RETMSG3
   
   MOV AH,07H
   INT 21H  
   
   clear
   
   
   JMP RESET

RETURN2:

   
   display RETMSG2 
   display RETMSG3 
   
   MOV AH,07H
   INT 21H
   
   clear
   
   JMP RESET

RESET: 
   MOV TICSUM,0 ;RESET
   MOV CX, 5
   MOV SI, 0
   XOR AX,AX  
    
 LOOP1:
 
   MOV STUTIC[SI],0
   MOV SCTIC[SI], 0
   MOV TSUM[SI],0
   MOV NORTIC[SI],0
   MOV DIS[SI],0
   MOV DISSUM[SI],0
   MOV SUM[SI],0
   MOV NSUM[SI],0
   MOV SSUM[SI],0
   MOV SCSUM[SI],0
   MOV CSUM[SI],0
   INC SI
   LOOP LOOP1
   
   JMP START 
               
ENDING:

     newline  
     display ENDMSG        
     ;------End Of Codes-------;
        
      MOV     AX,4C00H
      INT     21H

MAIN ENDP
END MAIN
