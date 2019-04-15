
DEFINE CLASS QiyuList AS Custom

caption = "QiyuList "
name = "QiyuList"
DIMENSION alist[1,2]
nrows = 0

FUNCTION Add
LPARAMETERS citem,ckey
this.nrows = THIS.nrows+1
THIS.resize()
this.alist(THIS.nrows, 1) = CITEM
this.alist(THIS.nrows, 2) = CKEY
ENDFUNC

FUNCTION GetItem
LPARAMETERS ckey
LOCAL nrecno
nrecno = ASCAN(THIS.ALIST,ckey,-1,-1,2,3)
oreturn = CREATEOBJECT("Empty")
IF NRECNO = 0
   ADDPROPERTY(ORETURN,"errno","1")
   ADDPROPERTY(ORETURN,"value",.NULL.)
ELSE
   ADDPROPERTY(ORETURN,"errno","0")
   ADDPROPERTY(ORETURN,"value",THIS.alist(NRECNO/2,1))
ENDIF
RETURN ORETURN
ENDFUNC

FUNCTION SetItem
LPARAMETERS uvalue,ckey
LOCAL nrecno
nrecno = ASCAN(THIS.ALIST,ckey,-1,-1,2,0)
IF NRECNO <> 0
   this.alist(NRECNO/2, 1) = UVALUE
ELSE
   THIS.ADD(UVALUE,CKEY)
ENDIF
ENDFUNC

FUNCTION Contains
LPARAMETERS uvalue
LOCAL nrecno
nrecno = ASCAN(THIS.ALIST,ckey,-1,-1,1)
RETURN NRECNO
ENDFUNC

FUNCTION resize
WITH THIS
   DIMENSION .alist(IIF(.NROWS = 0,1,.NROWS),2)
   IF .NROWS = 0
      .alist = .F.
   ENDIF
ENDWITH
ENDFUNC

FUNCTION Destroy
this.alist = .NULL.
ENDFUNC

ENDDEFINE
