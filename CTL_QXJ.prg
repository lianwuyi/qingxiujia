
DEFINE CLASS ctl_Qxj AS Session


FUNCTION INIT
DO setenv
ENDFUNC

FUNCTION getlist
LOCAL nstart,nlimit,npageno
nstart = VAL(httpqueryparams("start",THIS.iconnid))
nlimit = VAL(httpqueryparams("limit",THIS.iconnid))
npageno = VAL(httpqueryparams("page",THIS.iconnid))
ryxm = httpqueryparams("name",THIS.iconnid)
rq1 = httpqueryparams("rq1",THIS.iconnid)
rq2 = httpqueryparams("rq2",THIS.iconnid)
bm = httpqueryparams("bm",THIS.iconnid)
bm = httpgetcookie("bmmc",THIS.iconnid)
bm = URLDECODE(BM)
bm = STRCONV(URLDECODE(BM),11)
cname = httpgetcookie("username",THIS.iconnid)
cname = URLDECODE(CNAME)
cname = STRCONV(URLDECODE(CNAME),11)
LOCAL odbsqlhelper
IF CNAME <> "连武宜"
   TEXT TO cwhere TEXTMERGE  NOSHOW
	        日期 >= '<<rq1>>' and 日期<= '<<rq2>>' and 部门='<<bm>>'
   ENDTEXT
   IF NOT EMPTY(RYXM)
      cwhere = CWHERE+STRINGFORMAT(" and 姓名='{1}'",RYXM)
   ENDIF
   cwhere = CWHERE+" order by 休假id asc"
ELSE
   cwhere = ""
ENDIF
OFRMMAIN.LOG(CWHERE)
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlselectpage("qxj",CWHERE,NPAGENO,NLIMIT,"Qxj")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
RETURN cursortojson("Qxj",ODBSQLHELPER.ntotal)
ENDFUNC

FUNCTION getmx
LOCAL nstart,nlimit,npageno
nstart = VAL(httpqueryparams("start",THIS.iconnid))
nlimit = VAL(httpqueryparams("limit",THIS.iconnid))
npageno = VAL(httpqueryparams("page",THIS.iconnid))
nid = VAL(httpqueryparams("id",THIS.iconnid))
LOCAL odbsqlhelper
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW
        (SELECT case(休假id,varchar(10))+序号 ID,* FROM qxj) v
ENDTEXT
TEXT TO cwhere TEXTMERGE  NOSHOW
        休假id=<<nid>>
ENDTEXT
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlselectpage("qxj",CWHERE,NPAGENO,NLIMIT,"Qxj")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
RETURN cursortojson("Qxj",ODBSQLHELPER.ntotal)
ENDFUNC

FUNCTION toexcel
LOCAL nstart,nlimit,npageno
nstart = VAL(httpqueryparams("start",THIS.iconnid))
nlimit = VAL(httpqueryparams("limit",THIS.iconnid))
npageno = VAL(httpqueryparams("page",THIS.iconnid))
nid = VAL(httpqueryparams("id",THIS.iconnid))
LOCAL odbsqlhelper
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW
        SELECT * FROM qxj WHERE 休假id=<<nid>>
ENDTEXT
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlquery(LCSQLCMD,"test")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
IF NROW = 0
   ERROR "没有记录"
ENDIF
IF NROW < 10
   SELECT * FROM test INTO CURSOR test READWRITE
   nendrow = 10-NROW
   FOR i = 1 TO NENDROW
      APPEND IN test BLANK
   ENDFOR
ENDIF
SELECT test
GOTO TOP
oexcelengine = NEWOBJECT("QiyuExcelEngine","QiyuExcelEngine.prg")
OEXCELENGINE.parsefile("模板.xml")
OEXCELENGINE.setvalue(TEST.部门,"部门")
OEXCELENGINE.setvalue("test")
OEXCELENGINE.setvalue(TEST.日期,"日期")
lcfilename = SYS(2015)+".xls"
OEXCELENGINE.process()
IF _VFP.startmode = 0
   OEXCELENGINE.save("wwwroot\temp\"+LCFILENAME)
ELSE
   OEXCELENGINE.save("temp\"+LCFILENAME)
ENDIF
TEXT TO lcreturn TEXTMERGE  NOSHOW PRETEXT 3
        {"errno":0,"errmsg":"ok","filename":"temp/<<lcfilename>>"}
ENDTEXT
RETURN LCRETURN
ENDFUNC

FUNCTION toexcel2
LOCAL nstart,nlimit,npageno
nstart = VAL(httpqueryparams("start",THIS.iconnid))
nlimit = VAL(httpqueryparams("limit",THIS.iconnid))
npageno = VAL(httpqueryparams("page",THIS.iconnid))
rq1 = httpqueryparams("rq1",THIS.iconnid)
rq2 = httpqueryparams("rq2",THIS.iconnid)
ryxm = httpqueryparams("name",THIS.iconnid)
LOCAL odbsqlhelper
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW
        SELECT * FROM qxj WHERE 日期 >= '<<rq1>>' and 日期<= '<<rq2>>'
ENDTEXT
IF NOT EMPTY(RYXM)
   lcsqlcmd = LCSQLCMD+STRINGFORMAT(" and  姓名='{1}'",RYXM)
ENDIF
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlquery(LCSQLCMD,"test")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
IF NROW = 0
   ERROR "没有记录"
ENDIF
oexcelengine = NEWOBJECT("QiyuExcelEngine","QiyuExcelEngine.prg")
OEXCELENGINE.parsefile("模板2.xml")
OEXCELENGINE.setvalue("test")
OEXCELENGINE.setvalue(DATE(),"日期")
lcfilename = SYS(2015)+".xls"
OEXCELENGINE.process()
IF _VFP.startmode = 0
   OEXCELENGINE.save("wwwroot\temp\"+LCFILENAME)
ELSE
   OEXCELENGINE.save("temp\"+LCFILENAME)
ENDIF
TEXT TO lcreturn TEXTMERGE  NOSHOW PRETEXT 3
        {"errno":0,"errmsg":"ok","filename":"temp/<<lcfilename>>"}
ENDTEXT
RETURN LCRETURN
ENDFUNC

FUNCTION Save
LOCAL cresult,oca,cname,loginame
cname = httpgetcookie("username",THIS.iconnid)
cname = URLDECODE(CNAME)
cname = STRCONV(URLDECODE(CNAME),11)
cresult = httpgetpostdata(THIS.iconnid)
OFRMMAIN.LOG(CRESULT)
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
odalca = NEWOBJECT("dal_qxj","dal_qxj.prg","",ODBSQLHELPER.datasource)
IF NOT ODALCA.parsejson(CRESULT,"",0)
   ERROR ODALCA.msg
ENDIF
SELECT (ODALCA.alias)
IF EMPTY(休假ID)
   TEXT TO lcsqlcmd NOSHOW
	         update hm set 休假ID =休假ID +1
	         SELECT 休假ID FROM hm
   ENDTEXT
   nid = ODBSQLHELPER.GETSINGLE(LCSQLCMD)
   REPLACE 休假id WITH NID IN (ODALCA.alias) FOR EMPTY(休假ID)
ENDIF
REPLACE 操作员 WITH CNAME , 操作日期 WITH DATETIME() IN (ODALCA.alias) ALL
SELECT (ODALCA.alias)
GOTO TOP
IF NOT ODALCA.save()
   ERROR ODALCA.msg
ELSE
   SELECT (ODALCA.alias)
   TEXT TO lcreturn TEXTMERGE  NOSHOW PRETEXT 3
		   {"errno":0,"errmsg":"ok","success":true,"nid":<<休假id>>}
   ENDTEXT
   RETURN LCRETURN
ENDIF
ENDFUNC

ENDDEFINE
