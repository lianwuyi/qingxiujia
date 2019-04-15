
PROCEDURE CursorToBASE64
LPARAMETERS tablename,ntotoal
LOCAL lncount,lcresult,cmydata
IF NOT USED(TABLENAME)
   ERROR TABLENAME+"没有被打开"
ENDIF
oldtable = SELECT()
SELECT (TABLENAME)
COUNT TO lncount
odata = CREATEOBJECT("foxJson")
ODATA.append("Data","<<cmyData>>")
IF PCOUNT() > 1
   ODATA.append("total",CEILING(NTOTOAL))
ELSE
   ODATA.APPEND("total",LNCOUNT)
ENDIF
ODATA.APPEND("count",LNCOUNT)
ODATA.append("errno",0)
ODATA.append("errmsg","ok")
cmydata = STRCONV(CURSORTOSTR(TABLENAME),13)
ODATA.APPEND(DATA,CMYDATA)
SELECT (OLDTABLE)
RETURN ODATA.tostring()
