
DEFINE CLASS a2get AS Session


FUNCTION get
cresult = httpqueryparams("key1",THIS.iconnid)
RETURN "�����Ĳ�����:"+CRESULT
ENDFUNC

ENDDEFINE
