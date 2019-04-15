
PROCEDURE StringFormat
PARAMETERS ctext,parameter1,parameter2,parameter3,parameter4,parameter5,parameter6,parameter7,parameter8,parameter9,parameter10
LOCAL _tokens AS COLLECTION ,cendtext AS STRING ,ncount AS INTEGER ,cname AS STRING ,otokenparser AS OBJECT
LOCAL opara AS COLLECTION
cendtext = ""
IF VARTYPE(CTEXT) <> "C"
   RETURN .T.
ENDIF
opara = CREATEOBJECT("Collection")
FOR ncount = 1 TO 10
   cname = "Parameter"+ALLTRIM(STR(NCOUNT))
   oPara.Add(&cName)
ENDFOR
otokenparser = CREATEOBJECT("TokenParser")
OTOKENPARSER.PARSETEMPLATE(CTEXT)
ncount = 1
FOR EACH token IN otokenparser._tokens
   IF LIKE("{*}",TOKEN)
      ctmp = SUBSTR(TOKEN,2,LEN(TOKEN)-2)
      IF ISDIGIT(CTMP) .AND. VAL(CTMP) <= 10
         cval = OPARA.item(VAL(CTMP))
         DO CASE
         CASE VARTYPE(CVAL) == "C"
            cendtext = CENDTEXT+CVAL
         CASE VARTYPE(CVAL) == "L"
            cendtext = CENDTEXT+IIF(CVAL == .T.,".T.",".F.")
         CASE VARTYPE(CVAL) == "N"
            cendtext = CENDTEXT+ALLTRIM(STR(CVAL))
         CASE VARTYPE(CVAL) == "D"
            cendtext = CENDTEXT+"{^"+DTOC(CVAL)+"}"
         CASE VARTYPE(CVAL) == "T"
            cendtext = CENDTEXT+"{^"+TTOC(CVAL)+"}"
         ENDCASE
         ncount = NCOUNT+1
      ENDIF
   ELSE
      cendtext = CENDTEXT+TOKEN
   ENDIF
ENDFOR
RETURN CENDTEXT

LOCAL tty AS COLLECTION
tty = CREATEOBJECT("collection")
this._tokens = TTY
