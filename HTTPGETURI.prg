
PROCEDURE HttpGetUri
LPARAMETERS iconnid
LOCAL cresult
cresult = ""
IF INLIST(_VFP.startmode,0)
   cresult = httpgeturlfield(m.iconnid,3)
ELSE
   cresult = fws_header("PATH_INFO")
ENDIF
RETURN CRESULT
