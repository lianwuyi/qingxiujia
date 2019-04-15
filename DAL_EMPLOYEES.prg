
DEFINE CLASS Dal_employees AS Qiyu_CursorAdapter OF E OF \VFPM\XIAMI\CLASS\QIYU_CURSORADAPTER.FXP

alias = "employees"
wheretype = 1
keyfieldlist = "ID"
tables = "employees"
odal = .F.
nrecno = 0
uid = .F.
uoldid = .F.
datasourcetype = "ODBC"
buffermodeoverride = 5
isupdatedelcmd = .T.
fetchsize = -1
insertcmdrefreshfieldlist = "ID"
updatecmdrefreshfieldlist = "ID"
insertcmdrefreshcmd = "SELECT ID FROM employees WHERE ID=@@IDENTITY"
strwhere = ""

FUNCTION setupCA
TEXT TO this.selectcmd NOSHOW
		select ID,NAME,AGE from employees
ENDTEXT
TEXT TO this.cursorschema NOSHOW
		 ID   I(4) , NAme  C(50) , AGe   I(4)
ENDTEXT
TEXT TO this.updatablefieldlist NOSHOW
		ID,NAME,AGE
ENDTEXT
TEXT TO this.updatenamelist NOSHOW
		ID employees.ID,NAME employees.NAME,AGE employees.AGE
ENDTEXT
IF NOT EMPTY(THIS.strwhere)
   this.selectcmd = THIS.selectcmd+" where "+THIS.strwhere
ENDIF
ENDFUNC

FUNCTION Init
LPARAMETERS ncon,uid
DODEFAULT(NCON)
THIS.setupca()
ENDFUNC

FUNCTION New
this.nrecno = RECNO(THIS.alias)
THIS.add()
ENDFUNC

FUNCTION Edit
LPARAMETERS cname
this.nrecno = RECNO(THIS.alias)
ENDFUNC

FUNCTION OnBeforeDelete
ENDFUNC

FUNCTION OnAfterDelete
ENDFUNC

FUNCTION OnAfterSave
ENDFUNC

FUNCTION OnBeforeSave
ENDFUNC

FUNCTION OnAfterUndo
SELECT (THIS.alias)
LOCATE FOR THIS.nrecno = RECNO()
ENDFUNC

FUNCTION FieldValid
ENDFUNC

FUNCTION parsejson
LPARAMETERS cjson,croot,naction
LOCAL oreader,cfield,nfieldstate
oreader = NEWOBJECT("QiyuJsonReader","QiyuJsonReader.prg")
oreader.cursorstruct = OCA.cursorschema
oreader.alias = OCA.alias
oreader.root = CROOT
oreader.keylist = THIS.keyfieldlist
OREADER.PARSECURSOR(CJSON,NACTION)
IF NOT THIS.cursorattach(OCA.alias,.T.)
   AERROR(LAERROR)
   this.msg = laerror(2)
   RETURN .F.
ELSE
   RETURN .T.
ENDIF
ENDFUNC

ENDDEFINE
