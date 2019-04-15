
DEFINE CLASS a2get AS Session


FUNCTION get
cresult = httpqueryparams("key1",THIS.iconnid)
RETURN "您传的参数是:"+CRESULT
ENDFUNC

ENDDEFINE
