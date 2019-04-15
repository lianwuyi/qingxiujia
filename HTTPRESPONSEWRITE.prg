
PROCEDURE HttpResponseWrite
LPARAMETERS cparam1,iconnid
IF INLIST(_VFP.startmode,0)
   SET LIBRARY TO HttpServer.Fll ADDITIVE
   httpsetheader(ICONNID,"Content-Type","text/plain;charset=utf8")
   httpwrite(ICONNID,STRCONV(m.cparam1,9))
ELSE
   fws_write(m.cparam1)
ENDIF
