
DEFINE CLASS ctl_YG AS Session


FUNCTION getlist
LOCAL odbsqlhelper
bm = httpqueryparams("bm",THIS.iconnid)
bm = httpgetcookie("bmmc",THIS.iconnid)
bm = URLDECODE(BM)
bm = STRCONV(URLDECODE(BM),11)
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW PRETEXT 3
        SELECT * FROM YG WHERE 部门 like '<<bm>>%' OR 部门='系统'
ENDTEXT
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlquery(LCSQLCMD,"Qxj")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
IF NROW = 0
   ERROR "账号或密码错误"
ENDIF
RETURN cursortojson("user")
ENDFUNC

FUNCTION getCombo
LOCAL act,param1,odbsqlhelper,orows,orow,lcsqlcmd
bm = httpqueryparams("bm",THIS.iconnid)
bm = httpgetcookie("bmmc",THIS.iconnid)
bm = URLDECODE(BM)
bm = STRCONV(URLDECODE(BM),11)
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW PRETEXT 3
	select * from YG WHERE 部门 like '<<bm>>%' OR 部门='系统'
ENDTEXT
? lcsqlcmd
odbsqlhelper = NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
IF ODBSQLHELPER.sqlquery(LCSQLCMD,"city") < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
SELECT city
orows = CREATEOBJECT("foxJson",{//})
SCAN
   orow = CREATEOBJECT("foxJson")
   OROW.append("id",CITY.员工id)
   OROW.append("cname",ALLTRIM(CITY.姓名))
   OROWS.APPEND(OROW)
ENDSCAN
USE IN city
RETURN OROWS.tostring()
ENDFUNC

ENDDEFINE
