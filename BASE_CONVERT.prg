
PROCEDURE Base_Convert
LPARAMETERS cnumber,nfrombase,ntobase
IF PARAMETERS() <> 3
   MESSAGEBOX("������������!",16,"����")
   RETURN ""
ENDIF
IF VARTYPE(CNUMBER) <> "C" .OR. VARTYPE(NFROMBASE) <> "N" .OR. VARTYPE(NTOBASE) <> "N" .OR. NOT BETWEEN(NFROMBASE,2,36) .OR. NOT BETWEEN(NTOBASE,2,36)
   MESSAGEBOX("�������Ͳ���!",16,"����")
   RETURN ""
ENDIF
PRIVATE ALL
lndecbak = SET("DECIMALS")
SET DECIMALS TO 18
dict = "0123456789ABCDEFGHIJKLMNOPQISTUVWXYZ"
cnumber = UPPER(ALLTRIM(TRANSFORM(CNUMBER)))
ndecimalswz = AT(".",CNUMBER)
IF NDECIMALSWZ > 0
   cnumber2 = SUBSTR(CNUMBER,NDECIMALSWZ+1)
   cnumber = LEFT(CNUMBER,NDECIMALSWZ-1)
ELSE
   cnumber2 = ""
ENDIF
dec = 0
n0 = LEN(CNUMBER)
FOR i = 1 TO N0
   ch = SUBSTR(CNUMBER,I,1)
   n = AT(CH,DICT)
   IF NOT BETWEEN(N,1,NFROMBASE)
      RETURN ""
   ENDIF
   dec = DEC+(N-1)*NFROMBASE^(N0-I)
ENDFOR
dec2 = 0
n02 = LEN(CNUMBER2)
FOR i = 1 TO N02
   ch2 = SUBSTR(CNUMBER2,I,1)
   n2 = AT(CH2,DICT)
   IF NOT BETWEEN(N2,1,NFROMBASE)
      RETURN ""
   ENDIF
   dec2 = DEC2+(N2-1)/NFROMBASE^I
ENDFOR
IF NTOBASE = 10
   SET DECIMALS TO (LNDECBAK)
   IF DEC2 = 0
      RETURN TRANSFORM(DEC)
   ELSE
      RETURN numtostr(DEC+DEC2)
   ENDIF
ENDIF
convert = ""
DO WHILE DEC >= NTOBASE
   n = MOD(DEC,NTOBASE)
   dec = INT(DEC/NTOBASE)
   convert = SUBSTR(DICT,N+1,1)+CONVERT
ENDDO
convert = SUBSTR(DICT,DEC+1,1)+CONVERT
convert2 = ""
DO WHILE DEC2 > 0
   n2 = INT(DEC2*NTOBASE)
   dec2 = DEC2*NTOBASE-N2
   convert2 = CONVERT2+SUBSTR(DICT,N2+1,1)
ENDDO
SET DECIMALS TO (LNDECBAK)
IF LEN(CONVERT2) > 0
   RETURN CONVERT+"."+CONVERT2
ELSE
   RETURN CONVERT
ENDIF

PROCEDURE numTOstr
LPARAMETERS lnnum
PRIVATE ALL
lndecbak = SET("DECIMALS")
SET DECIMALS TO 18
DO CASE
CASE VERSION(5) < 700
   lcnum = TRANSFORM(LNNUM)
CASE VERSION(5) >= 700 .AND. VERSION(5) < 900
   lcnum = TRANSFORM(LNNUM)
   IF AT(".",LCNUM) > 0
      lnnumlen = LEN(LCNUM)
      FOR i = LNNUMLEN TO 1 STEP -1
         IF NOT SUBSTR(LCNUM,I,1) == "0"
            EXIT
         ENDIF
      ENDFOR
      lcnum = LEFT(LCNUM,I)
   ENDIF
CASE VERSION(5) >= 900
   lcnum = ALLTRIM(TRANSFORM(LNNUM),"0")
ENDCASE
SET DECIMALS TO (LNDECBAK)
RETURN LCNUM