
DEFINE CLASS Qiyu_CursorAdapter AS CursorAdapter

odbsqlhelper = .F.
ocon = .F.
msg = ""
isupdatedelcmd = .T.

FUNCTION Init
LPARAMETERS ncon
IF EMPTY(NCON)
   this.ocon = NEWOBJECT("qiyu_connection","qiyu³¬Àà")
   this.datasource = THIS.OCON.getconnection()
ELSE
   this.datasource = NCON
ENDIF
this.odbsqlhelper = NEWOBJECT("MsSQLhelper","Class\MsSQLhelper.prg","",THIS.datasource)
ENDFUNC

FUNCTION Add
APPEND IN (THIS.alias) BLANK
ENDFUNC

FUNCTION Delete
LOCAL llok
WITH THIS
   IF NOT EOF(.ALIAS) .AND. THIS.onbeforedelete()
      DELETE IN (THIS.alias)
      llok = DELETED(.ALIAS)
      IF LLOK
         IF THIS.isupdatedelcmd = .T. .AND. CURSORGETPROP("Buffering",.ALIAS) > 1
            IF RECNO(.ALIAS) < 0
               llok = IIF(TABLEREVERT(.F.,(.ALIAS)) > 0,.T.,.F.)
            ELSE
               llok = TABLEUPDATE(0,.T.,(.ALIAS))
            ENDIF
         ENDIF
      ENDIF
      IF LLOK
         IF NOT BOF(.ALIAS)
            SKIP -1 IN (.ALIAS)
         ENDIF
         .ONAFTERDELETE()
      ELSE
         AERROR(LAERROR)
         this.msg = laerror(2)
      ENDIF
   ENDIF
ENDWITH
RETURN LLOK
ENDFUNC

FUNCTION DeleteList
LOCAL llok
WITH THIS
   IF THIS.onbeforedelete()
      DELETE IN (THIS.alias)
      IF CURSORGETPROP("Buffering",.ALIAS) > 1
         llok = TABLEUPDATE(1,.T.,(.ALIAS))
      ELSE
         llok = .T.
      ENDIF
      IF LLOK
         .ONAFTERDELETE()
      ENDIF
   ENDIF
ENDWITH
RETURN LLOK
ENDFUNC

FUNCTION Undo
LOCAL lnreturnrecords
lnreturnrecords = 0
SELECT (THIS.alias)
IF THIS.detectchanged()
   lnreturnrecords = TABLEREVERT(.T.,THIS.alias)
ENDIF
THIS.onafterundo()
RETURN LNRETURNRECORDS
ENDFUNC

FUNCTION Go
LPARAMETERS uid
ENDFUNC

FUNCTION Save
LOCAL llok
llok = .F.
IF CURSORGETPROP("Buffering",THIS.alias) > 1 .AND. THIS.onbeforesave() .AND. THIS.validate()
   llok = TABLEUPDATE(.T.,.T.,THIS.alias)
   IF LLOK
      THIS.onaftersave()
   ELSE
      AERROR(LAERROR)
      this.msg = laerror(2)
   ENDIF
ENDIF
RETURN LLOK
ENDFUNC

FUNCTION GetCurrentRecord
LOCAL odata,lnselect
odata = .NULL.
IF NOT EOF(THIS.alias)
   lnselect = SELECT()
   SELECT (THIS.alias)
   SCATTER MEMO  NAME odata
   SELECT (LNSELECT)
ENDIF
RETURN ODATA
ENDFUNC

FUNCTION SetCurrentRecord
LPARAMETERS todata
LOCAL lnselect,llwritten
IF NOT EOF(THIS.alias) .AND. VARTYPE(TODATA) = "O"
   lnselect = SELECT()
   SELECT (THIS.alias)
   GATHER MEMO
   llwritten = .T.
   SELECT (LNSELECT)
ENDIF
RETURN LLWRITTEN
ENDFUNC

FUNCTION DetectChanged
LOCAL llunsavedchangedsexist,lcmodstring,nrecno
IF NOT USED(THIS.alias)
   RETURN .F.
ENDIF
DO CASE
CASE CURSORGETPROP("Buffering",THIS.alias) > 3
   IF NOT EOF(THIS.alias)
      nrecno = RECNO(THIS.alias)
      GOTO (RECNO(THIS.alias)) IN (THIS.alias)
   ENDIF
   IF GETNEXTMODIFIED(0,THIS.alias,.T.) <> 0
      llunsavedchangedsexist = .T.
   ENDIF
   IF NOT EMPTY(NRECNO)
      GOTO NRECNO IN (THIS.alias)
   ENDIF
CASE CURSORGETPROP("Buffering",THIS.alias) > 1
   lcmodstring = GETFLDSTATE(-1)
   IF NOT ISNULL(LCMODSTRING)
      llunsavedchangedsexist =  NOT LEN(LCMODSTRING) = OCCURS("1",LCMODSTRING)
   ENDIF
OTHERWISE
ENDCASE
RETURN LLUNSAVEDCHANGEDSEXIST
ENDFUNC

FUNCTION Validate
LOCAL llok,lnmodifiedrecord,nrecno
llok = .T.
IF NOT EOF(THIS.alias)
   nrecno = RECNO(THIS.alias)
   GOTO (RECNO(THIS.alias)) IN (THIS.alias)
ENDIF
DO CASE
CASE INLIST(CURSORGETPROP("Buffering",THIS.alias),4,5)
   lnmodifiedrecord = GETNEXTMODIFIED(0,THIS.alias,.T.)
   DO WHILE LNMODIFIEDRECORD <> 0
      GOTO LNMODIFIEDRECORD IN (THIS.alias)
      llok = THIS.fieldvalid()
      IF NOT LLOK
         EXIT
      ENDIF
      lnmodifiedrecord = GETNEXTMODIFIED(LNMODIFIEDRECORD,THIS.ALIAS,.T.)
   ENDDO
   IF NOT EMPTY(NRECNO)
      GOTO NRECNO IN (THIS.alias)
   ENDIF
CASE INLIST(CURSORGETPROP("Buffering",THIS.alias),2,3)
   llok = THIS.fieldvalid()
CASE CURSORGETPROP("Buffering",THIS.alias) = 1
ENDCASE
RETURN LLOK
ENDFUNC

FUNCTION Error
LPARAMETERS nerror,cmethod,nline
DO CASE
CASE TYPE("this.parent") = "O" .AND. NOT ISNULL(THIS.parent) .AND. PEMSTATUS(THIS.parent,"Error",0)
   lcaction = THIS.PARENT.ERROR(NERROR,CMETHOD,NLINE)
CASE TYPE("thisform") = "O" .AND. NOT ISNULL(THISFORM) .AND. PEMSTATUS(THISFORM,"Error",0)
   lcaction = THISFORM.ERROR(NERROR,CMETHOD,NLINE)
ENDCASE
ENDFUNC

FUNCTION Edit
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
ENDFUNC

FUNCTION FieldValid
ENDFUNC

ENDDEFINE

LPARAMETERS ncon
IF EMPTY(NCON)
   this.odbsqlhelper = NEWOBJECT("MsSQLhelper","Class\MsSQLhelper.prg")
ELSE
   this.odbsqlhelper = NEWOBJECT("MsSQLhelper","Class\MsSQLhelper.prg","",NCON)
ENDIF
