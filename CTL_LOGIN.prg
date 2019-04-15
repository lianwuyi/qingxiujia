
DEFINE CLASS ctl_login AS Session


FUNCTION login
LOCAL cuser,cpwd
cuser = httpqueryparams("username",THIS.iconnid)
cpwd = httpqueryparams("password",THIS.iconnid)
tempstr = ""
FOR i = 1 TO LEN(TRIM(CPWD))
   tempchr = BITXOR(ASC(SUBSTR(TRIM(CPWD),I,1)),73)
   tempstr = TEMPSTR+CHR(TEMPCHR)
ENDFOR
LOCAL odbsqlhelper
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW PRETEXT 3
        SELECT * FROM Mmk WHERE ×¢²áºÅ='<<cuser>>' AND ÃÜÂë='<<TempStr>>'
ENDTEXT
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLHelper.prg")
nrow = ODBSQLHELPER.sqlquery(LCSQLCMD,"user")
IF NROW < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
IF NROW = 0
   ERROR "ÕËºÅ»òÃÜÂë´íÎó"
ENDIF
RETURN cursortojson("user")
ENDFUNC

ENDDEFINE
