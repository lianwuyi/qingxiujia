
DEFINE CLASS mydata AS Session


FUNCTION getUser
TEXT TO lcjson NOSHOW
{success:true,msg:'数据不存在','data':[{text:"Ilike java"},{text:"22"}]}
ENDTEXT
RETURN LCJSON
ENDFUNC

FUNCTION getList2
nstart = VAL(httpqueryparams("start",THIS.iconnid))
nlimit = VAL(httpqueryparams("limit",THIS.iconnid))
npageno = CEILING(NSTART/NLIMIT)+1
cwhere = ""
cpm = httpqueryparams("pm",THIS.iconnid)
IF NOT EMPTY(CPM)
   cwhere = CWHERE+IIF(EMPTY(CWHERE),""," and ")+STRINGFORMAT("品名 like '%{1}%'",CPM)
ENDIF
ckf = httpqueryparams("kf",THIS.iconnid)
IF NOT EMPTY(CPM)
   cwhere = CWHERE+IIF(EMPTY(CWHERE),""," and ")+STRINGFORMAT("品名 like '%{1}%'",CKF)
ENDIF
_CLIPTEXT = CWHERE
odbsqlhelper = NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
ODBSQLHELPER.sqlselectpage("employees",CWHERE,NPAGENO,NLIMIT,"employees")
RETURN cursortojson("employees",ODBSQLHELPER.ntotal)
ENDFUNC

FUNCTION getlist
nstart = VAL(httpqueryparams("start",THIS.iconnid))
nlimit = VAL(httpqueryparams("limit",THIS.iconnid))
npageno = CEILING(NSTART/NLIMIT)+1
ctj = httpqueryparams("query",THIS.iconnid)
cwhere = ""
IF NOT EMPTY(CTJ)
   cwhere = STRINGFORMAT("name like '%{1}%'",CTJ)
ENDIF
odbsqlhelper = NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
ODBSQLHELPER.sqlselectpage("employees",CWHERE,NPAGENO,NLIMIT,"employees")
RETURN cursortojson("employees",ODBSQLHELPER.ntotal)
ENDFUNC

FUNCTION save
cresult = httpgetpostdata(THIS.iconnid)
oca = NEWOBJECT("Dal_employees","Dal_employees.prg")
OCA.parsejson(CRESULT,"",0)
OCA.save()
ENDFUNC

FUNCTION delete
cresult = httpgetpostdata(THIS.iconnid)
oca = NEWOBJECT("Dal_employees","Dal_employees.prg")
OCA.parsejson(CRESULT,"",3)
OCA.save()
ENDFUNC

FUNCTION getjson2
nstart = httpqueryparams("start")
DO CASE
CASE NSTART = "0"
   TEXT TO lcjson NOSHOW
    {total:2,count:1,employees:[{name:'www.qeefee.com', age:1}]}
   ENDTEXT
   _SCREEN.print("页码:"+httpqueryparams("start")+CHR(13))
CASE NSTART = "1"
   TEXT TO lcjson NOSHOW
    {total:2,count:1,employees:[{name:'Tom', age:26}]}
   ENDTEXT
ENDCASE
RETURN LCJSON
ENDFUNC

FUNCTION getJson
TEXT TO lcjson NOSHOW
{'users':[{name:'www.qeefee.com', age:1}, {name:'Tom', age:26}]}
ENDTEXT
RETURN LCJSON
ENDFUNC

FUNCTION savejson
txtval = httpqueryparams("text")
TEXT TO lcjson TEXTMERGE  NOSHOW
{'success':true,msg:'<<txtval>>'}
ENDTEXT
RETURN LCJSON
ENDFUNC

ENDDEFINE
