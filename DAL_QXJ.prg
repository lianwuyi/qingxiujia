
DEFINE CLASS Dal_qxj AS Qiyu_CursorAdapter OF F OF F F:\VFPM\祺佑考勤\CLASS\QIYU_CURSORADAPTER.FXP

alias = "qxj"
wheretype = 1
keyfieldlist = "id"
tables = "qxj"
odal = .F.
nrecno = 0
uid = .F.
uoldid = .F.
datasourcetype = "ODBC"
buffermodeoverride = 5
isupdatedelcmd = .T.
fetchsize = -1

FUNCTION setupCA
TEXT TO this.selectcmd NOSHOW
		select ID,休假ID,部门,日期,序号,姓名,假期类型,请休假事由,从请假日期,至请假日期,请假天数,备注,操作员,操作日期 from qxj
ENDTEXT
TEXT TO this.cursorschema NOSHOW
		 ID   I(4) , 休假id  I(4) , 部门  C(50) , 日期  C(10) , 序号  I(4) , 姓名  C(50) , 假期类型 C(50) , 请休假事由 C(100) , 从请假日期 C(10) , 至请假日期 C(10) , 请假天数 N(10,2) , 备注  C(150) , 操作员  C(30) , 操作日期 T(8)
ENDTEXT
TEXT TO this.updatablefieldlist NOSHOW
		ID,休假ID,部门,日期,序号,姓名,假期类型,请休假事由,从请假日期,至请假日期,请假天数,备注,操作员,操作日期
ENDTEXT
TEXT TO this.updatenamelist NOSHOW
		ID qxj.ID,休假ID qxj.休假ID,部门 qxj.部门,日期 qxj.日期,序号 qxj.序号,姓名 qxj.姓名,假期类型 qxj.假期类型,请休假事由 qxj.请休假事由,从请假日期 qxj.从请假日期,至请假日期 qxj.至请假日期,请假天数 qxj.请假天数,备注 qxj.备注,操作员 qxj.操作员,操作日期 qxj.操作日期
ENDTEXT
ENDFUNC

FUNCTION Init
LPARAMETERS ncon,uid
DODEFAULT(NCON)
THIS.setupca()
ENDFUNC

FUNCTION AfterUpdate
LPARAMETERS cfldstate,lforce,nupdatetype,updateinsertcmd,deletecmd,lresult
OFRMMAIN.LOG(UPDATEINSERTCMD)
ENDFUNC

FUNCTION New
this.nrecno = RECNO(THIS.alias)
THIS.add()
ENDFUNC

FUNCTION Edit
LPARAMETERS cname
this.nrecno = RECNO(THIS.alias)
ENDFUNC

FUNCTION Go
LPARAMETERS uid
ENDFUNC

FUNCTION OnBeforeDelete
ENDFUNC

FUNCTION OnAfterDelete
ENDFUNC

FUNCTION OnAfterSave
ENDFUNC

FUNCTION OnBeforeSave
llok = .T.
TRY
lnselect = SELECT()
SELECT (THIS.alias)
GOTO TOP
ncount = 1
SCAN
   REPLACE 序号 WITH NCOUNT
   ncount = NCOUNT+1
ENDSCAN
SELECT (LNSELECT)
CATCH
llok = .F.
ROLLBACK
ENDTRY
RETURN LLOK
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
oreader.cursorstruct = THIS.cursorschema
oreader.alias = THIS.alias
oreader.root = CROOT
oreader.keylist = THIS.keyfieldlist
OREADER.PARSECURSOR(CJSON,NACTION)
IF NOT THIS.cursorattach(THIS.alias,.T.)
   AERROR(LAERROR)
   this.msg = laerror(2)
   RETURN .F.
ELSE
   RETURN .T.
ENDIF
ENDFUNC

ENDDEFINE
