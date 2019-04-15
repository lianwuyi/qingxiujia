
PROCEDURE HttpQueryParams
LPARAMETERS cparam1,iconnid
LOCAL cresult
cresult = ""
IF INLIST(_VFP.startmode,0)
   cresult = OFRMMAIN.SOCKETHTTP1.QIYU_REQUEST(STRCONV(CPARAM1,9),ICONNID)
   IF EMPTY(CRESULT)
      cresult = OFRMMAIN.SOCKETHTTP1.QIYU_FORMPARAMS(CPARAM1,ICONNID)
   ENDIF
ELSE
   cresult = fws_request(urlencode(STRCONV(CPARAM1,9)))
ENDIF
RETURN CRESULT

PROCEDURE HttpGetPostData
LPARAMETERS m.iconnid
LOCAL cresult
cresult = ""
IF INLIST(_VFP.startmode,0)
   cresult = OFRMMAIN.SOCKETHTTP1.httpgetpostdata(m.iconnid)
ELSE
   cresult = fws_binread()
   cresult = STRCONV(CRESULT,11)
ENDIF
RETURN CRESULT

PROCEDURE HttpResponseWrite
LPARAMETERS cparam1,iconnid
IF INLIST(_VFP.startmode,0)
   OFRMMAIN.SOCKETHTTP1.QIYU_WRITE(STRCONV(CPARAM1,9),ICONNID)
ELSE
   fws_write(m.cparam1)
ENDIF

PROCEDURE Httpgetcookie
LPARAMETERS ccookiename,iconnid
LOCAL cresult,ctmp,laarry
cresult = ""
IF INLIST(_VFP.startmode,0)
   ctmp = OFRMMAIN.HTTPHEAD1.getotherfields("Cookie")
   DIMENSION laarry[1]
   ALINES(LAARRY,CTMP,";","=")
   FOR i = 1 TO ALEN(LAARRY) STEP 2
      IF ALLTRIM(CCOOKIENAME) == ALLTRIM(LAARRY(I))
         cresult = laarry(I+1)
         EXIT
      ENDIF
   ENDFOR
ELSE
   cresult = FWS_COOKIES(CCOOKIENAME)
ENDIF
RETURN CRESULT

PROCEDURE Httpsetcookie
LPARAMETERS ccookievalue,ckeyvalue,texprietime,cpath,cdomain,iconnid
LOCAL cresult
cresult = ""
IF INLIST(_VFP.startmode,0)
   OFRMMAIN.SOCKETHTTP1.QIYU_WRITECOOKIES(CCOOKIEVALUE,CKEYVALUE,TEXPRIETIME)
ELSE
   FWS_COOKIES(CCOOKIEVALUE,CKEYVALUE,TEXPRIETIME)
ENDIF

PROCEDURE GetPostDataObj
LPARAMETERS nconnectid
LOCAL cdata,odata,i,cparsechar,nfieldcnt,cfieldhead,cfielddata,cfieldname
DIMENSION aform(1)
m.cdata = httpgetpostrawdata(m.nconnectid)
m.odata = CREATEOBJECT("Collection")
m.ODATA.addproperty("RawData",m.cdata)
m.ODATA.addproperty("FieldType",CREATEOBJECT("Collection"))
m.ODATA.addproperty("FieldFileName",CREATEOBJECT("Collection"))
IF NOT EMPTY(m.cdata)
   m.cparsechar = STREXTRACT(m.cdata,"",CHR(13))
   m.nfieldcnt = ALINES(AFORM,m.cdata,4,m.cparsechar)-1
   FOR i = 1 TO m.nfieldcnt
      nstart = AT(CHR(13)+CHR(10),AFORM(I),4)
      m.cfieldhead = LEFT(AFORM(I),NSTART)
      m.cfielddata = RIGHT(aform(1),LEN(AFORM(I))-NSTART-1)
      m.cfieldname = STREXTRACT(m.cfieldhead,'name="','"')
      ODATA.add(m.cfielddata,m.cfieldname)
      ODATA.FIELDTYPE.add(ALLTRIM(STREXTRACT(m.cfieldhead,"Content-Type:","")),m.cfieldname)
      ODATA.FIELDFILENAME.add(JUSTFNAME(STREXTRACT(m.cfieldhead,'filename="','"')),m.cfieldname)
   ENDFOR
ENDIF
RETURN m.odata

PROCEDURE getMethod
LOCAL cresult
cresult = ""
IF INLIST(_VFP.startmode,0)
   cresult = OFRMMAIN.HTTPHEAD1.method
ELSE
   cresult = fws_header("REQUEST_METHOD")
ENDIF
RETURN CRESULT

PROCEDURE HttpRedirect
LPARAMETERS curl,iconnid
LOCAL cresult
cresult = ""
IF INLIST(_VFP.startmode,0)
   cresult = OFRMMAIN.SOCKETHTTP1._HTTPREDIRECT(CURL,ICONNID)
ELSE
   cresult = FWS_REDIRECT(CURL)
ENDIF
RETURN CRESULT
