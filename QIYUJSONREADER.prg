TEXT TO cresult NOSHOW
{"id":1,"name":"ff","age":1}
ENDTEXT
oreader = NEWOBJECT("QiyuJsonReader","QiyuJsonReader.prg")
TEXT TO oreader.cursorstruct TEXTMERGE  NOSHOW
id i,name c(50),age numeric(4)
ENDTEXT
oreader.alias = "test"
oreader.keylist = "id"
oreader.root = ""
OREADER.PARSECURSOR(CRESULT,0)
BROWSE

DEFINE CLASS QiyuJsonReader AS Custom

alias = ""
cursorstruct = ""
errmsg = ""
root = ""
keylist = ""

FUNCTION Init
SET LIBRARY TO foxjson.fll ADDITIVE
SET PROCEDURE TO foxjson.prg  ADDITIVE
ENDFUNC

FUNCTION ParseCursor
LPARAMETERS cresult,naction
LOCAL lccmd,oldtable
IF EMPTY(THIS.cursorstruct)
   ERROR "cursorstruct属性不能为空"
ENDIF
TEXT TO lccmd TEXTMERGE  NOSHOW
    CREATE CURSOR <<this.alias>>(<<this.cursorstruct>>)
ENDTEXT
EXECSCRIPT(LCCMD)
SET MULTILOCKS ON
CURSORSETPROP("Buffering",5,THIS.alias)
ojson = CREATEOBJECT("foxJson")
OJSON.PARSE(CRESULT)
iskey = .F.
IF EMPTY(THIS.root) .OR. ISNULL(THIS.root)
   THIS.LOADDATA(OJSON)
ELSE
   THIS.loaddata(OJSON.item(THIS.root))
ENDIF
IF NACTION = 3
   DELETE IN (THIS.alias)
ENDIF
ENDFUNC

FUNCTION loaddata
LPARAMETERS oobject
LOCAL strname,isnew,lliseditmode,ofly
IF OOBJECT.isarray()
   DIMENSION latmp[1]
   FOR i = 1 TO OOBJECT.count
      ofly = CREATEOBJECT("empty")
      APPEND IN (THIS.alias) BLANK
      FOR j = 1 TO OOBJECT.ITEM(I).COUNT
         strname = OOBJECT.ITEM(I).ITEM(J).KEY
         latmp[1] = OOBJECT.ITEM(I).ITEM(J).VALUE
         IF inlist2(UPPER(THIS.keylist),UPPER(STRNAME))
            IF NOT EMPTY(LATMP)
               SELECT (THIS.alias)
               GATHER MEMO
               TABLEUPDATE(0,.T.,THIS.alias)
            ENDIF
         ELSE
            IF VARTYPE(latmp(1)) == "C" .AND. LEN(latmp(1)) = 24 .AND. RIGHT(latmp(1),1) = "Z"
               lutmpval = CTOT(latmp(1))+28800
            ELSE
               lutmpval = latmp(1)
            ENDIF
            ADDPROPERTY(OFLY,STRNAME,LUTMPVAL)
         ENDIF
      ENDFOR
      GATHER
      IF PEMSTATUS(OFLY,"qystatus",5)
         IF OFLY.qystatus == "del"
            DELETE IN (THIS.alias)
         ENDIF
      ENDIF
   ENDFOR
ELSE
   DIMENSION latmp[1]
   APPEND IN (THIS.alias) BLANK
   ofly = CREATEOBJECT("empty")
   FOR j = 1 TO OOBJECT.count
      strname = OOBJECT.ITEM(J).KEY
      latmp[1] = OOBJECT.ITEM(J).VALUE
      IF inlist2(UPPER(THIS.keylist),UPPER(STRNAME))
         SELECT (THIS.alias)
         GATHER MEMO
         TABLEUPDATE(0,.T.,THIS.alias)
      ELSE
         IF VARTYPE(latmp(1)) == "C" .AND. LEN(latmp(1)) = 24 .AND. RIGHT(latmp(1),1) = "Z"
            latmp[1] = CTOT(latmp(1))+28800
         ENDIF
         ADDPROPERTY(OFLY,STRNAME,latmp(1))
      ENDIF
   ENDFOR
   GATHER
   IF PEMSTATUS(OFLY,"qystatus",5)
      IF OFLY.qystatus == "del"
         DELETE IN (THIS.alias)
      ENDIF
   ENDIF
ENDIF
ENDFUNC

FUNCTION KeyList_ASSIGN
LPARAMETERS m.newval
DO CASE
CASE VARTYPE(m.newval) == "C"
   this.keylist = m.newval
CASE VARTYPE(m.newval) == "L"
   this.keylist = ""
OTHERWISE
   ERROR "KEYLIST必须为C类型"
ENDCASE
ENDFUNC

ENDDEFINE
