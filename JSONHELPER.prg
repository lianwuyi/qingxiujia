
DEFINE CLASS JsonHelper AS Custom


FUNCTION rowtojobject
LPARAMETERS ctable
LOCAL ojobject
ojobject = CREATEOBJECT("foxJson")
FOR i = 1 TO FCOUNT(CTABLE)
   uval = FIELD(I,CTABLE)
   oJobject.Append(uVal,&uVal)
ENDFOR
RETURN OJOBJECT
ENDFUNC

ENDDEFINE
