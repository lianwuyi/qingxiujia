LPARAMETERS cmdline
PUBLIC connhandle
PUBLIC pc_id, pc_name, pc_qz, pc_ck
PUBLIC pc_path, pc_ver
IF INLIST(_VFP.startmode,0)
   pc_path = ADDBS(JUSTPATH(_VFP.ACTIVEPROJECT.name))
   SET DEFAULT TO (PC_PATH)
ELSE
   pc_path = SYS(5)+SYS(2003)+"\"
   SET DEFAULT TO (PC_PATH)
ENDIF
SET PATH TO ADDBS(_VFP.servername)
SET PATH TO Menus;prgs;Forms;Class;Images;Dll;Report;Database;DAL;BLL;Model;Wxapi;WxClientApi;msgclass
SET PATH TO "WebAPIframework"
SET PATH TO "Controller"
SQLSETPROP(0,"DispLogin",3)
SET EXCLUSIVE OFF
SET CENTURY ON
SET DATE YMD
SET MARK TO "-"
SET DELETED ON
SET ANSI ON
SET TALK OFF
SET SAFETY OFF
ofrmmain = NEWOBJECT("QiyuLog","qiyulog.prg")
OFRMMAIN.log("系统启动"+VERSION())
SET LIBRARY TO myfll ADDITIVE
SET LIBRARY TO fws ADDITIVE
SET LIBRARY TO foxjson.fll ADDITIVE
SET PROCEDURE TO foxJson  ADDITIVE
SET PROCEDURE TO foxJson_Parse  ADDITIVE
SET PROCEDURE TO qiyuweblib  ADDITIVE
PUBLIC octlobjtype
octlobjtype = ""
TRY
ohttpcontext = NEWOBJECT("HttpContext","HttpContext.prg")
OFRMMAIN.log(OHTTPCONTEXT.getabsoluteuri())
lcappuser = ALLTRIM(fws_request("appuser"))
m.requestobject = JUSTSTEM(fws_header("PATH_INFO"))
m.classfile = m.requestobject+".prg"
OFRMMAIN.log(REQUESTOBJECT+"类应答")
ocontroll = NEWOBJECT(m.requestobject,m.classfile)
octlobjtype = OCONTROLL.parentclass
cproc = fws_request("proc")
DO CASE
CASE UPPER(OCONTROLL.parentclass) == UPPER("weixinApi")
   IF EMPTY(LCAPPUSER)
      ERROR "请传入Appuser参数"
   ENDIF
   ocontroll.appuser = LCAPPUSER
   cproc = "AnswerMsg"
CASE UPPER(OCONTROLL.parentclass) == "WEIXINFSP"
   IF EMPTY(LCAPPUSER)
      ERROR "请传入Appuser参数"
   ENDIF
   ocontroll.appuser = LCAPPUSER
ENDCASE
lccmd = "oControll."+CPROC+"()"
IF NOT PEMSTATUS(OCONTROLL,CPROC,5)
   ERROR m.requestobject+"."+CPROC+"类的方法不存在"
ENDIF
IF NOT PEMSTATUS(OCONTROLL,"iConnid",5)
   ADDPROPERTY(OCONTROLL,"iConnid",0)
ENDIF
OFRMMAIN.log(OCONTROLL.name+"."+CPROC+"开始调用")
DO CASE
CASE UPPER(OCONTROLL.parentclass) == "WXAPI"
   &lccmd
OTHERWISE
   LOCAL rethtml
   m.RetHtml=Transform(&lccmd)
   fws_write(m.rethtml)
   OFRMMAIN.log(OCONTROLL.name+"."+CPROC+"调用成功")
ENDCASE
CATCH TO ex
objall = CREATEOBJECT("foxjson")
OBJALL.append("errno",EX.errorno)
OBJALL.append("errmsg",EX.message)
OBJALL.append("success","false")
OBJALL.append("errorMsg",EX.message)
OBJALL.append("total",0)
orow = CREATEOBJECT("foxjson",{//})
OBJALL.append("rows",OROW.tostring())
IF UPPER(OCTLOBJTYPE) <> "WXAPI"
   fws_write(OBJALL.tostring())
ENDIF
OFRMMAIN.log(EX.message+",过程:"+EX.procedure+",行号:"+TRANSFORM(EX.lineno))
ENDTRY
OFRMMAIN.log(OCONTROLL.name+"."+CPROC+"程序退出")
SET LIBRARY TO
CLOSE ALL
QUIT
