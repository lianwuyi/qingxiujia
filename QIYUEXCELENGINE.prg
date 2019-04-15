CLEAR
CREATE CURSOR test (姓名 C (50 ),电话 N (13 ))
INSERT INTO TEST VALUES ("张三",100)
INSERT INTO TEST VALUES ("李四",101)
INSERT INTO TEST VALUES ("王五",701)
INSERT INTO TEST VALUES ("王小二",701)
PUBLIC xx2
xx2 = NEWOBJECT("QiyuExcelEngine","QiyuExcelEngine.prg")
XX2.parsefile("模板.xml")
XX2.setvalue("http://www.baidu.com","标题")
XX2.setvalue("test")
XX2.setvalue(DATETIME(),"时间")
lcfilename = SYS(2015)+".xls"
XX2.process()
XX2.SAVE(LCFILENAME)

DEFINE CLASS QiyuExcelEngine AS Custom

lnbz = 0
oxmldom = .F.
ovaluelist = .F.

FUNCTION init
this.oxmldom = CREATEOBJECT("Microsoft.XMLDOM")
this.ovaluelist = NEWOBJECT("qiyulist","qiyulist.prg")
ENDFUNC

FUNCTION Parse
LPARAMETERS cxml
THIS.OXMLDOM.LOADXML(CXML)
ENDFUNC

FUNCTION ParseFile
LPARAMETERS cfilename
THIS.OXMLDOM.LOAD(CFILENAME)
ENDFUNC

FUNCTION Process
otables = THIS.OXMLDOM.getelementsbytagname("Table")
otemp = CREATEOBJECT("collection")
calias = ""
FOR EACH otable IN otables
   lnrow = 0
   FOR EACH orow IN otable.childnodes
      OROW.removeattribute("ss:Index")
      DO CASE
      CASE THIS.isscan(OROW.text)
         OTABLE.REMOVECHILD(OROW)
         this.lnbz = 1
         calias = THIS.getscanalias(OROW.text)
      CASE THIS.isendscan(OROW.text)
         omycoll = THIS.SCANTABLE(OTEMP,CALIAS)
         FOR EACH orowtmp IN omycoll
            OTABLE.INSERTBEFORE(OROWTMP,OROW)
         ENDFOR
         OTABLE.REMOVECHILD(OROW)
         lnrow = LNROW-1
         this.lnbz = 0
      OTHERWISE
         IF THIS.lnbz = 0
            LOCAL uattribvalue,ufieldvalue
            FOR EACH ocell IN orow.childnodes
               ofield = THIS.OVALUELIST.getitem(OCELL.text)
               uattribvalue = THIS.getattributevalue(OFIELD.value)
               IF OCELL.CHILDNODES.length > 0
                  OCELL.CHILDNODES.ITEM(0).text = IIF(OFIELD.errno = "0",NVL(OFIELD.value,""),OCELL.text)
                  OCELL.CHILDNODES.ITEM(0).setattribute("ss:Type",UATTRIBVALUE)
               ENDIF
            ENDFOR
         ELSE
            myclonerow2 = OROW.clonenode(.T.)
            OTEMP.ADD(MYCLONEROW2)
            OTABLE.REMOVECHILD(OROW)
         ENDIF
      ENDCASE
   ENDFOR
   OTABLE.setattribute("ss:ExpandedRowCount",TRANSFORM(THIS.getrowcount(OTABLE.childnodes)))
ENDFOR
ENDFUNC

FUNCTION Save
LPARAMETERS cfilename
THIS.OXMLDOM.SAVE(CFILENAME)
ENDFUNC

FUNCTION ScanTable
LPARAMETERS orowcolls AS COLLECTION ,calias
omycoll1 = CREATEOBJECT("collection")
SELECT (CALIAS)
SCAN
   THIS.SETVALUE(CALIAS)
   myrow = CREATEOBJECT("collection")
   FOR EACH orowcoll IN orowcolls
      myclone1 = OROWCOLL.clonenode(.T.)
      MYROW.ADD(MYCLONE1)
      LOCAL tempvalue
      FOR EACH ocell IN myclone1.childnodes
         ofield = THIS.OVALUELIST.getitem(OCELL.text)
         uattribvalue = THIS.getattributevalue(OFIELD.value)
         IF OCELL.CHILDNODES.length > 0 .AND. AT("{",OCELL.text) > 0
            OCELL.CHILDNODES.ITEM(0).text = IIF(OFIELD.errno = "0",NVL(OFIELD.value,""),OCELL.text)
            OCELL.CHILDNODES.ITEM(0).setattribute("ss:Type",UATTRIBVALUE)
         ENDIF
      ENDFOR
      FOR EACH omyrow IN myrow
         OMYCOLL1.ADD(OMYROW)
      ENDFOR
   ENDFOR
ENDSCAN
RETURN OMYCOLL1
ENDFUNC

FUNCTION SetValue
LPARAMETERS uvalue,ckey
LOCAL lcfield,lcfieldvalue
IF EMPTY(CKEY)
   If !Used("&uValue")
      ERROR TRANSFORM(UVALUE)+"传入的不是一个表"
   ENDIF
   IF EMPTY(UVALUE)
      ERROR TRANSFORM(UVALUE)+"无表名"
   ENDIF
   FOR lni = 1 TO FCOUNT(UVALUE)
      lcfield = UPPER(ALLTRIM(UVALUE))+"."+FIELD(LNI)
      lcValuetmp=&lcField
      DO CASE
      CASE VARTYPE(LCVALUETMP) = "C"
         lcFieldValue=TRANSFORM(&lcField,'@t')
      OTHERWISE
         lcFieldValue=&lcField
      ENDCASE
      THIS.OVALUELIST.setitem(LCFIELDVALUE,"{"+LCFIELD+"}")
   ENDFOR
ELSE
   IF VARTYPE(CKEY) <> "C"
      ERROR "Key必须为字符型"
   ENDIF
   THIS.OVALUELIST.setitem(UVALUE,"{"+CKEY+"}")
ENDIF
ENDFUNC

FUNCTION GetAttributeValue
LPARAMETERS uvalue
LOCAL lcreturn
lcreturn = "String"
DO CASE
CASE INLIST(VARTYPE(UVALUE),"I","N","Y")
   lcreturn = "Number"
CASE INLIST(VARTYPE(UVALUE),"D","T")
   lcreturn = "String"
ENDCASE
RETURN LCRETURN
ENDFUNC

FUNCTION GetRowcount
LPARAMETERS onode
LOCAL lnrowcount
lnrowcount = 0
FOR i = 0 TO ONODE.length-1
   IF ONODE.ITEM(I).NODENAME = "Row"
      lnrowcount = LNROWCOUNT+1
   ENDIF
ENDFOR
RETURN LNROWCOUNT
ENDFUNC

FUNCTION isEndScan
LPARAMETERS lccmd
oresub = CREATEOBJECT("VBScript.RegExp")
oresub.ignorecase = .T.
oresub.global = .F.
oresub.pattern = "{\s*#EndScan\s*[^{}\s]*}"
RETURN ORESUB.TEST(LCCMD)
ENDFUNC

FUNCTION isScan
LPARAMETERS lccmd
oresub = CREATEOBJECT("VBScript.RegExp")
oresub.ignorecase = .T.
oresub.global = .F.
oresub.pattern = "{\s*#scan\s*[^{}\s]*in\s*\w*}"
RETURN ORESUB.TEST(LCCMD)
ENDFUNC

FUNCTION GetScanAlias
LPARAMETERS lccmd
RETURN ALLTRIM(STREXTRACT(LCCMD,"in","}"))
ENDFUNC

ENDDEFINE
