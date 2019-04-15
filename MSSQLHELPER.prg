
DEFINE CLASS MSSQLHelper AS custom

isthrowconecterror = .F.
datasource = .F.
ocon = .F.
errno = "0"
errmsg = ""
npagecount = 0
ntotal = 0

FUNCTION Init
LPARAMETERS ncon
IF EMPTY(NCON)
   this.ocon = NEWOBJECT("qiyu_connection","qiyu超类")
   this.datasource = THIS.OCON.getconnection()
ELSE
   this.datasource = NCON
   this.isthrowconecterror = .T.
ENDIF
ENDFUNC

FUNCTION ColumnExists
LPARAMETERS tablename AS STRING ,columnname AS STRING
csql = "select count(1) as col from syscolumns where [id]=object_id('"+TABLENAME+"') and [name]='"+COLUMNNAME+"'"
res = THIS.GETSINGLE(CSQL)
RETURN IIF(RES > 0,.T.,.F.)
ENDFUNC

FUNCTION GetMaxID
LPARAMETERS fieldname AS STRING ,tablename AS STRING
LOCAL strsql AS STRING
strsql = "select max("+FIELDNAME+")+1 from "+TABLENAME
obj = THIS.GETSINGLE(STRSQL)
RETURN OBJ
ENDFUNC

FUNCTION SQLExists
LPARAMETERS strsql AS STRING
LOCAL obj
res = THIS.GETSINGLE(STRSQL)
RETURN IIF(RES > 0,.T.,.F.)
ENDFUNC

FUNCTION ExecuteSql
LPARAMETERS strsql AS STRING
LOCAL dbcon AS INTEGER ,nrow AS INTEGER ,oldtable,lcona,nresult
DIMENSION laerror(1), lcona(2)
oldtable = SELECT()
TRY
nresult = SQLEXEC(THIS.datasource,strsql,"",LCONA)
IF NRESULT < 0
   AERROR(LAERROR)
   DO CASE
   CASE ALEN(LAERROR) >= 8
      IF laerror(2,4) = "08S01"
         this.errno = "1466"
         ERROR 1466
      ELSE
         this.errno = laerror(1,4)
         ERROR laerror(2)
      ENDIF
   OTHERWISE
      this.errno = laerror(1,4)
      ERROR laerror(2)
   ENDCASE
ELSE
   nrow = lcona(2)
ENDIF
CATCH TO oerr
nrow = -1
this.errmsg = OERR.message
DO CASE
CASE OERR.errorno = 1466 .AND. THIS.isthrowconecterror = .F.
   this.errno = "1466"
CASE OERR.errorno = 1098
   DO CASE
   CASE THIS.errno = "S0002"
   CASE THIS.errno = "37000"
      ERROR OERR.message
   OTHERWISE
   ENDCASE
OTHERWISE
   ERROR OERR.message
ENDCASE
ENDTRY
SELECT (OLDTABLE)
RETURN NROW
ENDFUNC

FUNCTION SQLQuery
LPARAMETERS strsql AS STRING ,tablename AS STRING
LOCAL nrow AS INTEGER ,oerrobj AS OBJECT
nrow = 0
IF EMPTY(TABLENAME)
   ERROR "表名不能为空"
ENDIF
DIMENSION lcona[10]
TRY
IF SQLEXEC(THIS.datasource,strsql,tablename,LCONA) < 0
   AERROR(LAERROR)
   DO CASE
   CASE ALEN(LAERROR) >= 8
      IF laerror(2,4) = "08S01"
         this.errno = "1466"
         ERROR 1466
      ELSE
         this.errno = TRANSFORM(laerror(1,4))
         ERROR laerror(2)
      ENDIF
   OTHERWISE
      this.errno = laerror(1,4)
      ERROR laerror(2)
   ENDCASE
ELSE
   nrow = lcona(2)
ENDIF
CATCH TO oerr
nrow = -1
this.errmsg = OERR.message
DO CASE
CASE OERR.errorno = 1466 .AND. THIS.isthrowconecterror = .F.
   this.errno = "1466"
CASE OERR.errorno = 1098
   DO CASE
   CASE THIS.errno = "S0002"
   CASE THIS.errno = "37000"
      ERROR OERR.message
   OTHERWISE
   ENDCASE
OTHERWISE
   ERROR OERR.message
ENDCASE
ENDTRY
RETURN NROW
ENDFUNC

FUNCTION GetSingle
LPARAMETERS lcsqlcmd AS STRING
LOCAL dbcon,oldtable,nrow
DIMENSION lacath[255], ncol[255]
oldtable = SELECT()
TRY
nrow = SQLEXEC(THIS.datasource,lcsqlcmd,"tmp_table",LACATH)
IF NROW < 0
   AERROR(LAERROR)
   IF ALEN(LAERROR) >= 8
      IF laerror(2,4) = "08S01"
         this.errno = "1466"
         ERROR 1466
      ELSE
         this.errno = laerror(1,4)
         ERROR laerror(2)
      ENDIF
   ELSE
      this.errno = laerror(1,4)
      ERROR laerror(2)
   ENDIF
ELSE
   IF NOT USED("tmp_table")
      lcerror = "无法生成临时表,检查SQL语句:"+ALLTRIM(LCSQLCMD)
      ERROR LCERROR
   ENDIF
   ncol = FIELD(1,"tmp_table")
   nCol=&nCol			
ENDIF
CATCH TO oerr
ncol = .NULL.
this.errmsg = OERR.message
DO CASE
CASE OERR.errorno = 1466 .AND. THIS.isthrowconecterror = .F.
   this.errno = "1466"
CASE OERR.errorno = 1098
   DO CASE
   CASE THIS.errno = "S0002"
   CASE THIS.errno = "37000"
      ERROR OERR.message
   OTHERWISE
   ENDCASE
OTHERWISE
   ERROR OERR.message
ENDCASE
FINALLY
IF USED("tmp_table")
   USE IN tmp_table
ENDIF
ENDTRY
SELECT (OLDTABLE)
RETURN NCOL
ENDFUNC

FUNCTION Reconnect
LOCAL lncontmp,llcon
IF THIS.isthrowconecterror
   ERROR "共用句柄无法使用重连方法"
ENDIF
lncontmp = THIS.OCON.getconnection()
TRY
llcon = IIF(SQLEXEC(LNCONTMP,"") > 0,.T.,.F.)
CATCH
llcon = .F.
ENDTRY
IF LLCON
   this.datasource = LNCONTMP
ENDIF
RETURN LLCON
ENDFUNC

FUNCTION isconnect
LOCAL llvalid
llconect = .T.
TRY
llconect = IIF(SQLEXEC(THIS.datasource,"") > 0,.T.,.F.)
CATCH
llconect = .F.
ENDTRY
RETURN LLCONECT
ENDFUNC

FUNCTION SQLQueryEx
LPARAMETERS strsql AS STRING ,tablename AS STRING ,ccursorschema AS STRING ,isrefresh AS LOGICAL
LOCAL nrow AS INTEGER ,lntype AS INTEGER
nrow = 0
IF EMPTY(TABLENAME)
   ERROR "表名不能为空"
ENDIF
IF EMPTY(CCURSORSCHEMA)
   ccursorschema = ""
ENDIF
IF NOT USED(TABLENAME)
   lntype = 1
ELSE
   lntype = 4
ENDIF
SET LIBRARY TO vfp2c32.fll ADDITIVE
DIMENSION lainfo[1,4]
TRY
IF SQLEXECEX(THIS.datasource,STRSQL,TABLENAME,"laInfo",LNTYPE,CCURSORSCHEMA) > 0
   nrow = lainfo(1,2)
ELSE
   nrow = -1
   aerrorex("laError")
   ERROR laerror(2)
ENDIF
CATCH TO ex
ERROR EX.message
ENDTRY
ENDFUNC

FUNCTION SQLSelectPage
LPARAMETERS ctablename AS STRING ,cwhere AS STRING ,npageno AS INTEGER ,npagesize AS INTEGER ,calias AS STRING
LOCAL lncount,nrow
IF EMPTY(CALIAS)
   ERROR "表名不能为空"
ENDIF
DIMENSION lcona[10]
lncount = 0
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW
	exec selectbase ?nPageNo,?nPageSize,?cTableName,?cwhere,?@lncount
ENDTEXT
TRY
IF SQLEXEC(THIS.datasource,lcsqlcmd,calias,LCONA) < 0
   AERROR(LAERROR)
   DO CASE
   CASE ALEN(LAERROR) >= 8
      IF laerror(2,4) = "08S01"
         this.errno = "1466"
         ERROR 1466
      ELSE
         this.errno = TRANSFORM(laerror(1,4))
         ERROR laerror(2)
      ENDIF
   OTHERWISE
      this.errno = laerror(1,4)
      ERROR laerror(2)
   ENDCASE
ELSE
   nrow = lcona(2)
ENDIF
this.npagecount = CEILING(LNCOUNT/NPAGESIZE)
this.ntotal = LNCOUNT
CATCH TO oerr
nrow = -1
this.errmsg = OERR.message
DO CASE
CASE OERR.errorno = 1466 .AND. THIS.isthrowconecterror = .F.
   this.errno = "1466"
CASE OERR.errorno = 1098
   DO CASE
   CASE THIS.errno = "S0002"
   CASE THIS.errno = "37000"
      ERROR OERR.message
   OTHERWISE
   ENDCASE
OTHERWISE
   ERROR OERR.message
ENDCASE
ENDTRY
RETURN NROW
ENDFUNC

ENDDEFINE
