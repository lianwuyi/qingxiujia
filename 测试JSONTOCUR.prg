CLEAR
TEXT TO cresult NOSHOW
[{"id":30,"�ݼ�id":1000052,"����":"��֯��","����":"2018-05-01","���":1,"����":"1��־��","��������":"����","���ݼ�����":"","���������":"2018.05.31","���������":"2018.05.31","�������":1,"��ע":"","����Ա":"11","��������":"05/14/18 04:55:18 PM","qystatus":"modi"}]
ENDTEXT
PUBLIC oca, ojson
oca = NEWOBJECT("dal_qxj","dal_qxj.prg")
OCA.parsejson(CRESULT,"",0)
SELECT (OCA.alias)
APPEND BLANK
myxt = ""
SELECT (OCA.alias)
GOTO TOP
APPEND BLANK
? OCA.save()
? oca.msg
RETURN
oreader = NEWOBJECT("QiyuJsonReader","QiyuJsonReader.prg")
oreader.cursorstruct = OCA.cursorschema
oreader.alias = OCA.alias
oreader.root = ""
oreader.keylist = "�ݼ�id"
OREADER.PARSECURSOR(CRESULT,0)
