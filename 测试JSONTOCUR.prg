CLEAR
TEXT TO cresult NOSHOW
[{"id":30,"休假id":1000052,"部门":"组织部","日期":"2018-05-01","序号":1,"姓名":"1周志明","假期类型":"病假","请休假事由":"","从请假日期":"2018.05.31","至请假日期":"2018.05.31","请假天数":1,"备注":"","操作员":"11","操作日期":"05/14/18 04:55:18 PM","qystatus":"modi"}]
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
oreader.keylist = "休假id"
OREADER.PARSECURSOR(CRESULT,0)
