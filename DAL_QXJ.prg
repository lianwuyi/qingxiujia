
DEFINE CLASS Dal_qxj AS Qiyu_CursorAdapter OF F OF F F:\VFPM\���ӿ���\CLASS\QIYU_CURSORADAPTER.FXP

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
		select ID,�ݼ�ID,����,����,���,����,��������,���ݼ�����,���������,���������,�������,��ע,����Ա,�������� from qxj
ENDTEXT
TEXT TO this.cursorschema NOSHOW
		 ID   I(4) , �ݼ�id  I(4) , ����  C(50) , ����  C(10) , ���  I(4) , ����  C(50) , �������� C(50) , ���ݼ����� C(100) , ��������� C(10) , ��������� C(10) , ������� N(10,2) , ��ע  C(150) , ����Ա  C(30) , �������� T(8)
ENDTEXT
TEXT TO this.updatablefieldlist NOSHOW
		ID,�ݼ�ID,����,����,���,����,��������,���ݼ�����,���������,���������,�������,��ע,����Ա,��������
ENDTEXT
TEXT TO this.updatenamelist NOSHOW
		ID qxj.ID,�ݼ�ID qxj.�ݼ�ID,���� qxj.����,���� qxj.����,��� qxj.���,���� qxj.����,�������� qxj.��������,���ݼ����� qxj.���ݼ�����,��������� qxj.���������,��������� qxj.���������,������� qxj.�������,��ע qxj.��ע,����Ա qxj.����Ա,�������� qxj.��������
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
   REPLACE ��� WITH NCOUNT
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
