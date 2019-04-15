xx = CREATEOBJECT("Menulist")
_CLIPTEXT = XX.getmenu()
? _CLIPTEXT

DEFINE CLASS Menulist AS Session


FUNCTION Init
SET LIBRARY TO foxjson.fll ADDITIVE
SET PROCEDURE TO foxjson  ADDITIVE
ENDFUNC

FUNCTION getMenu
LOCAL odbsqlhelper,crigthval,lcsqlcmd
cuser = urldecode(httpgetcookie("username",THIS.iconnid))
cuser = STRCONV(URLDECODE(CUSER),11)
odbsqlhelper = NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
oright = NEWOBJECT("Right_User","Right_User.prg","",ODBSQLHELPER.datasource)
oright.crightfield = "id"
oright.uoperid = CUSER
crigthval = ORIGHT.getrightlist()
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW
	select * from Menu WHERE <<cRigthVal>> ORDER BY sortid
ENDTEXT
OFRMMAIN.LOG(LCSQLCMD)
IF ODBSQLHELPER.sqlquery(LCSQLCMD,"MyMenus") < 0
   ERROR ODBSQLHELPER.errmsg
ENDIF
SELECT mymenus
orowlist = CREATEOBJECT("foxJson",{//})
SCAN
   orowmx = CREATEOBJECT("foxJson")
   OROWMX.APPEND("id",ID)
   OROWMX.append("text",ALLTRIM(MENUTEXT))
   OROWMX.append("menuname",ALLTRIM(MENUNAME))
   OROWMX.append("leaf",.T.)
   OROWLIST.APPEND(OROWMX)
ENDSCAN
RETURN OROWLIST.tostring()
ENDFUNC

FUNCTION menutest
TEXT TO lctext TEXTMERGE  NOSHOW PRETEXT 3
	 [{
	"id": 1,
	"text": "¿¼ÇÚÂ¼Èë",
	"menuname": "kq_edit.html",
	"leaf": true
}, {
	"id": 2,
	"text": "¿¼ÇÚ²éÑ¯",
	"menuname": "kqcx.html",
	"leaf": true
}, {
	"id": 3,
	"text": "×ÛºÏ²éÑ¯",
	"menuname": "kqcx2.html",
	"leaf": true
}]

ENDTEXT
RETURN LCTEXT
ENDFUNC

ENDDEFINE
