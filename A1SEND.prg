
DEFINE CLASS a1send AS Session


FUNCTION Send
RETURN "Hello world"
ENDFUNC

FUNCTION SendJson
ojson = CREATEOBJECT("foxjson")
OJSON.append("name","����")
OJSON.append("age",21)
OJSON.append("sex",.T.)
RETURN OJSON.tostring()
ENDFUNC

FUNCTION sendcursor
IF NOT USED("��ʦ")
   USE ��ʦ IN 0
ENDIF
RETURN cursortojson("��ʦ")
ENDFUNC

FUNCTION SendCursorBase64
IF NOT USED("database\��ʦ")
   USE ��ʦ IN 0
ENDIF
RETURN cursortobase64("��ʦ")
ENDFUNC

ENDDEFINE
