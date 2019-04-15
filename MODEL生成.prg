odbsqlhelper = NEWOBJECT("MSSQLHelper","MSSQLhelper.prg")
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW
select * from Hrcomsumer
ENDTEXT
lcsqlcmd = LCSQLCMD+" where 1<>1"
ODBSQLHELPER.sqlquery(LCSQLCMD,"structs")
cstr = ""
SELECT structs
FOR i = 1 TO FCOUNT()
   cstr = CSTR+","+"'"+FIELD(I)+"'"
ENDFOR
_CLIPTEXT = RIGHT(CSTR,LEN(CSTR)-1)
odbsqlhelper = NEWOBJECT("MSSQLHelper","MSSQLhelper.prg")
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW
select * from hrpr_saleorder
ENDTEXT
lcsqlcmd = LCSQLCMD+" where 1<>1"
ODBSQLHELPER.sqlquery(LCSQLCMD,"structs")
cstr = ""
SELECT structs
FOR i = 1 TO FCOUNT()
   TEXT TO lcshow TEXTMERGE  NOSHOW
 	{ header: '<<FIELD(i)>>', dataIndex: '<<FIELD(i)>>'},
   ENDTEXT
   cstr = CSTR+CHR(10)+LCSHOW
ENDFOR
_CLIPTEXT = RIGHT(CSTR,LEN(CSTR)-1)
odbsqlhelper = NEWOBJECT("MSSQLHelper","MSSQLhelper.prg")
TEXT TO lcsqlcmd TEXTMERGE  NOSHOW
select * from HrPrOdUCt
ENDTEXT
lcsqlcmd = LCSQLCMD+" where 1<>1"
ODBSQLHELPER.sqlquery(LCSQLCMD,"structs")
cstr = ""
SELECT structs
FOR i = 1 TO FCOUNT()
   TEXT TO lcshow TEXTMERGE  NOSHOW
 	{xtype: 'textfield',name : '<<FIELD(i)>>',fieldLabel: '<<FIELD(i)>>'},
   ENDTEXT
   cstr = CSTR+CHR(10)+LCSHOW
ENDFOR
_CLIPTEXT = RIGHT(CSTR,LEN(CSTR)-1)
