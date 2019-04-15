
DEFINE CLASS a1send AS Session


FUNCTION Send
RETURN "Hello world"
ENDFUNC

FUNCTION SendJson
ojson = CREATEOBJECT("foxjson")
OJSON.append("name","张三")
OJSON.append("age",21)
OJSON.append("sex",.T.)
RETURN OJSON.tostring()
ENDFUNC

FUNCTION sendcursor
IF NOT USED("教师")
   USE 教师 IN 0
ENDIF
RETURN cursortojson("教师")
ENDFUNC

FUNCTION SendCursorBase64
IF NOT USED("database\教师")
   USE 教师 IN 0
ENDIF
RETURN cursortobase64("教师")
ENDFUNC

ENDDEFINE
