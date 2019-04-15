CLEAR
oqiyujson = CREATEOBJECT("QiyuJson")
OQIYUJSON.append("name","123")
OQIYUJSON.appendcursor("cpkc",10)
OQIYUJSON.appendcursor("cpkc2",10)
? OQIYUJSON.tojson()
_CLIPTEXT = OQIYUJSON.tojson()

DEFINE CLASS QiyuJson AS Custom

ocoll = .F.
ocursor = .F.

FUNCTION Init
this.ocoll = CREATEOBJECT("collection")
this.ocursor = CREATEOBJECT("collection")
ENDFUNC

FUNCTION Append
LPARAMETERS ckey,cvalue
THIS.OCOLL.ADD(CVALUE,CKEY)
ENDFUNC

FUNCTION AppendCursor
LPARAMETERS ctablename,ntotal
IF NOT USED(CTABLENAME)
   ERROR "表没有被打开"
ENDIF
IF EMPTY(NTOTAL)
   Select Count(*) From &ctablename Into Array xxy
   ntotal = XXY
ELSE
   IF VARTYPE(NTOTAL) <> "N"
      ERROR "请传入数值型"
   ENDIF
ENDIF
ofly = CREATEOBJECT("empty")
ADDPROPERTY(OFLY,"tablename",CTABLENAME)
ADDPROPERTY(OFLY,"nTotal",NTOTAL)
THIS.OCURSOR.ADD(OFLY,CTABLENAME)
ENDFUNC

FUNCTION ToJson
LPARAMETERS nparam
LOCAL oobject,orows,otable
oobject = CREATEOBJECT("foxJson")
IF EMPTY(NPARAM)
   nparam = 2
ENDIF
DO CASE
CASE NPARAM = 1
CASE NPARAM = 2
   OOBJECT.append("errno",0)
   OOBJECT.append("errmsg","ok")
OTHERWISE
   ERROR "参数不正确"
ENDCASE
istotal = .F.
FOR i = 1 TO THIS.OCOLL.count
   OOBJECT.APPEND(THIS.OCOLL.GETKEY(I),THIS.OCOLL.ITEM(I))
ENDFOR
DO CASE
CASE THIS.OCURSOR.count = 1
   orows = CREATEOBJECT("foxJson",{//})
   ctablename = THIS.OCURSOR.ITEM(1).tablename
   SELECT (CTABLENAME)
   SCAN
      ojson = CREATEOBJECT("foxJson")
      FOR i = 1 TO FCOUNT()
         cfield = LOWER(FIELD(I))
         DO CASE
            Case  Vartype(&cField)=='C'
            uVal=Transform(&cField,'@T')
            Case  Vartype(&cField)=='G'
            uval = ""
         OTHERWISE
            uVal=&cField
         ENDCASE
         OJSON.APPEND(CFIELD,UVAL)
      ENDFOR
      OROWS.APPEND(OJSON)
   ENDSCAN
   OOBJECT.append("total",INT(THIS.OCURSOR.ITEM(1).ntotal))
   OOBJECT.append("count",OROWS.count)
   OOBJECT.APPEND("rows",OROWS)
CASE THIS.OCURSOR.count > 1
   FOR i = 1 TO THIS.OCURSOR.count
      ctablename = THIS.OCURSOR.ITEM(I).TABLENAME
      ? ctablename , THIS.OCURSOR.ITEM(I).NTOTAL
      SELECT (CTABLENAME)
      otable = CREATEOBJECT("foxJson")
      orows = CREATEOBJECT("foxJson",{//})
      SCAN
         ojson = CREATEOBJECT("foxJson")
         FOR j = 1 TO FCOUNT()
            cfield = LOWER(FIELD(J))
            DO CASE
               Case  Vartype(&cField)=='C'
               uVal=Transform(&cField,'@T')
               Case  Vartype(&cField)=='G'
               uval = ""
            OTHERWISE
               uVal=&cField
            ENDCASE
            OJSON.APPEND(CFIELD,UVAL)
         ENDFOR
         OROWS.APPEND(OJSON)
      ENDSCAN
      OTABLE.append("total",INT(THIS.OCURSOR.ITEM(I).NTOTAL))
      OTABLE.append("count",OROWS.count)
      OTABLE.APPEND("rows",OROWS)
      OOBJECT.APPEND(CTABLENAME,OTABLE)
   ENDFOR
ENDCASE
RETURN OOBJECT.tostring()
ENDFUNC

ENDDEFINE
