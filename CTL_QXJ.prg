
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
IF CNAME <> "������"
   TEXT TO cwhere TEXTMERGE  NOSHOW
	        ���� >= '<<rq1>>' and ����<= '<<rq2>>' and ����='<<bm>>'
   ENDTEXT
   IF NOT EMPTY(RYXM)
      cwhere = CWHERE+STRINGFORMAT(" and ����='{1}'",RYXM)
   ENDIF
   cwhere = CWHERE+" order by �ݼ�id asc"
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
        (SELECT case(�ݼ�id,varchar(10))+��� ID,* FROM qxj) v
ENDTEXT
TEXT TO cwhere TEXTMERGE  NOSHOW
        �ݼ�id=<<nid>>
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
        SELECT * FROM qxj WHERE �ݼ�id=<<nid>>
ENDTEXT
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlquery(LCSQLCMD,"test")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
IF NROW = 0
   ERROR "û�м�¼"
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
OEXCELENGINE.parsefile("ģ��.xml")
OEXCELENGINE.setvalue(TEST.����,"����")
OEXCELENGINE.setvalue("test")
OEXCELENGINE.setvalue(TEST.����,"����")
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
        SELECT * FROM qxj WHERE ���� >= '<<rq1>>' and ����<= '<<rq2>>'
ENDTEXT
IF NOT EMPTY(RYXM)
   lcsqlcmd = LCSQLCMD+STRINGFORMAT(" and  ����='{1}'",RYXM)
ENDIF
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlquery(LCSQLCMD,"test")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
IF NROW = 0
   ERROR "û�м�¼"
ENDIF
oexcelengine = NEWOBJECT("QiyuExcelEngine","QiyuExcelEngine.prg")
OEXCELENGINE.parsefile("ģ��2.xml")
OEXCELENGINE.setvalue("test")
OEXCELENGINE.setvalue(DATE(),"����")
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
IF EMPTY(�ݼ�ID)
   TEXT TO lcsqlcmd NOSHOW
	         update hm set �ݼ�ID =�ݼ�ID +1
	         SELECT �ݼ�ID FROM hm
   ENDTEXT
   nid = ODBSQLHELPER.GETSINGLE(LCSQLCMD)
   REPLACE �ݼ�id WITH NID IN (ODALCA.alias) FOR EMPTY(�ݼ�ID)
ENDIF
REPLACE ����Ա WITH CNAME , �������� WITH DATETIME() IN (ODALCA.alias) ALL
SELECT (ODALCA.alias)
GOTO TOP
IF NOT ODALCA.save()
   ERROR ODALCA.msg
ELSE
   SELECT (ODALCA.alias)
   TEXT TO lcreturn TEXTMERGE  NOSHOW PRETEXT 3
		   {"errno":0,"errmsg":"ok","success":true,"nid":<<�ݼ�id>>}
   ENDTEXT
   RETURN LCRETURN
ENDIF
ENDFUNC

ENDDEFINE
