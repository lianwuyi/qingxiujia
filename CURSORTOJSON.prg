
PROCEDURE CursorToJson
LPARAMETERS tablename,ntotoal
SET LIBRARY TO foxjson.Fll ADDITIVE
SET PROCEDURE TO foxjson  ADDITIVE
SET LIBRARY TO myfll ADDITIVE
IF NOT USED(TABLENAME)
   ERROR TABLENAME+"没有被打开"
ENDIF
orows = CREATEOBJECT("foxJson",{//})
oldtable = SELECT()
SELECT (TABLENAME)
SCAN
   ojson = CREATEOBJECT("foxJson")
   FOR i = 1 TO FCOUNT()
      cfield = LOWER(FIELD(I))
      DO CASE
         CASE  VARTYPE(&cField)=='C'
         uVal=transform(&cField,'@T')
         CASE  VARTYPE(&cField)=='G'
         uval = ""
         CASE  VARTYPE(&cField)=='T'
         uVal=TTOC(&cField)	
      OTHERWISE
         uVal=&cField
      ENDCASE
      OJSON.APPEND(CFIELD,UVAL)
   ENDFOR
   OROWS.APPEND(OJSON)
ENDSCAN
odata = CREATEOBJECT("foxJson")
IF PCOUNT() > 1
   ODATA.append("total",CEILING(NTOTOAL))
ELSE
   ODATA.append("total",OROWS.count)
ENDIF
ODATA.append("count",OROWS.count)
ODATA.APPEND("rows",OROWS)
ODATA.append("errno",0)
ODATA.append("errmsg","ok")
SELECT (OLDTABLE)
RETURN ODATA.tostring()
