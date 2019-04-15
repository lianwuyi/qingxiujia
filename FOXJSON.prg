SET LIBRARY TO foxjson

DEFINE CLASS foxJson AS Collection

value = ""
key = ""
type = 0
count = 0
_object = ""

FUNCTION Init
LPARAMETERS value
IF PCOUNT() = 0
   this._object = json_create()
   RETURN
ENDIF
IF VARTYPE(VALUE) $ "INLCXD"
   this._object = JSON_CREATE(VALUE)
   RETURN
ENDIF
IF VARTYPE(VALUE) = "O" .AND. VALUE.class == THIS.class
   this._object = json_parse(VAL.tostring())
   RETURN
ENDIF
ERROR 11
ENDFUNC

FUNCTION Destroy
json_delete(THIS._object)
ENDFUNC

FUNCTION Item
LPARAMETERS name
NODEFAULT
IF NOT VARTYPE(m.name) $ "CIN"
   ERROR 2061
ENDIF
IF THIS.isarray() .AND. VARTYPE(m.name) = "C"
   ERROR 2061
ENDIF
PRIVATE ojson
IF INLIST(json_type(THIS._object,m.name),4,5)
   ojson = NEWOBJECT(THIS.class)
   json_delete(OJSON._object)
   ojson._object = json_value(THIS._object,m.name)
   json_addref(OJSON._object)
   RETURN OJSON
ENDIF
ojson = NEWOBJECT("empty")
ADDPROPERTY(OJSON,"Value",json_value(THIS._object,m.name))
ADDPROPERTY(OJSON,"Type",json_type(THIS._object,m.name))
IF THIS.isobject()
   IF VARTYPE(m.name) $ "IN"
      ADDPROPERTY(OJSON,"Key",json_key(THIS._object,m.name))
   ELSE
      ADDPROPERTY(OJSON,"Key",m.name)
   ENDIF
ENDIF
RETURN OJSON
ENDFUNC

FUNCTION Parse
LPARAMETERS cjson
json_delete(THIS._object)
this._object = JSON_PARSE(CJSON)
ENDFUNC

FUNCTION ToString
RETURN json_tostring(THIS._object)
ENDFUNC

FUNCTION Append
LPARAMETERS ckey,vvalue
IF PCOUNT() = 1 .AND. THIS.isarray()
   IF VARTYPE(CKEY) $ "INLCXDY"
      JSON_APPEND(THIS._object,JSON_CREATE(CKEY))
      RETURN
   ENDIF
   IF VARTYPE(CKEY) = "O" .AND. CKEY.class == THIS.class
      json_append(THIS._object,json_parse(CKEY.tostring()))
      RETURN
   ENDIF
   ERROR 11
   RETURN
ENDIF
IF PCOUNT() = 2 .AND. THIS.isobject() .AND. VARTYPE(CKEY) = "C"
   IF VARTYPE(VVALUE) == "T"
      JSON_APPEND(THIS._object,json_create(TTOC(VVALUE,3)),CKEY)
      RETURN
   ENDIF
   IF VARTYPE(VVALUE) $ "INLCXD"
      JSON_APPEND(THIS._object,JSON_CREATE(VVALUE),CKEY)
      RETURN
   ENDIF
   IF VARTYPE(VVALUE) $ "Y"
      LOCAL tmp_x1
      tmp_x1 = CAST(VVALUE,"N",.NULL.)
      JSON_APPEND(THIS._object,JSON_CREATE(TMP_X1),CKEY)
      RETURN
   ENDIF
   IF VARTYPE(VVALUE) = "O" .AND. VVALUE.class == THIS.class
      JSON_APPEND(THIS._object,json_parse(VVALUE.tostring()),CKEY)
      RETURN
   ENDIF
   ERROR 11
   RETURN
ENDIF
ERROR 11
ENDFUNC

FUNCTION Remove
LPARAMETERS ckey
NODEFAULT
IF THIS.isobject() .AND. VARTYPE(CKEY) $ "CINY"
   JSON_REMOVE(THIS._object,CKEY)
   RETURN
ENDIF
IF THIS.isarray() .AND. VARTYPE(CKEY) $ "INY"
   JSON_REMOVE(THIS._object,CKEY)
   RETURN
ENDIF
ERROR 11
ENDFUNC

FUNCTION Value_Access
IF THIS.isobject() .OR. THIS.isarray()
   ERROR 2061
ENDIF
RETURN json_value(THIS._object)
ENDFUNC

FUNCTION Key_Access
RETURN json_key(THIS._object)
ENDFUNC

FUNCTION Count_Access
IF THIS.isobject() .OR. THIS.isarray()
   RETURN json_childs(THIS._object)
ENDIF
ERROR 2061
ENDFUNC

FUNCTION Type_Access
RETURN json_type(THIS._object)
ENDFUNC

FUNCTION isNull
RETURN json_type(THIS._object) == 0
ENDFUNC

FUNCTION isBool
RETURN json_type(THIS._object) == 1
ENDFUNC

FUNCTION isDouble
RETURN json_type(THIS._object) == 2
ENDFUNC

FUNCTION isInt
RETURN json_type(THIS._object) == 3
ENDFUNC

FUNCTION isObject
RETURN json_type(THIS._object) == 4
ENDFUNC

FUNCTION isArray
RETURN json_type(THIS._object) == 5
ENDFUNC

FUNCTION isString
RETURN json_type(THIS._object) == 6
ENDFUNC

ENDDEFINE
