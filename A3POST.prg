
DEFINE CLASS a3post AS Session


FUNCTION Post
LOCAL cpostdata
cpostdata = httpgetpostdata(THIS.iconnid)
RETURN CPOSTDATA
ENDFUNC

FUNCTION PostParams
LOCAL cname,cage
cname = httpqueryparams("name",THIS.iconnid)
cage = httpqueryparams("age",THIS.iconnid)
RETURN "����:"+CNAME+"����:"+CAGE
ENDFUNC

FUNCTION PostCursor
LOCAL cpostdata,cresult
cpostdata = httpgetpostdata(THIS.iconnid)
OFRMMAIN.log(TRANSFORM(LEN(CPOSTDATA)))
IF strtocursor(STRCONV(CPOSTDATA,14))
   cresult = "������ɹ�"
ELSE
   ERROR "������ʧ��"
ENDIF
RETURN CRESULT
ENDFUNC

FUNCTION Upload
LOCAL cpostdata
cpostdata = httpgetpostdata(THIS.iconnid)
RETURN STRCONV(CPOSTDATA,11)
ENDFUNC

ENDDEFINE
