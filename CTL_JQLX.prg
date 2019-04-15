
DEFINE CLASS ctl_jqlx AS Session


FUNCTION getlist
LOCAL odbsqlhelper
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW PRETEXT 3
        SELECT * FROM jqlx
ENDTEXT
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlquery(LCSQLCMD,"Qxj")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
IF NROW = 0
   ERROR "ÕËºÅ»òÃÜÂë´íÎó"
ENDIF
RETURN cursortojson("user")
ENDFUNC

FUNCTION getCombo
LOCAL act,param1,odbsqlhelper,orows,orow,lcsqlcmd
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW PRETEXT 3
	select * from jqlx
ENDTEXT
odbsqlhelper = NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
IF ODBSQLHELPER.sqlquery(LCSQLCMD,"city") < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
SELECT city
orows = CREATEOBJECT("foxJson",{//})
SCAN
   orow = CREATEOBJECT("foxJson")
   OROW.append("id",RECNO())
   OROW.append("cname",ALLTRIM(CITY.¼ÙÆÚÀàÐÍ))
   OROWS.APPEND(OROW)
ENDSCAN
USE IN city
RETURN OROWS.tostring()
ENDFUNC

ENDDEFINE
