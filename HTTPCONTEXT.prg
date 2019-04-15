
DEFINE CLASS HttpContext AS Custom


FUNCTION getAbsoluteUri
LOCAL cabsoluteuri,cservername,cport,cpath_info,cquery_string
cabsoluteuri = ""
IF INLIST(_VFP.startmode,0)
   cservername = OFRMMAIN.HTTPHEAD1.host
   cabsoluteuri = "http://"+CSERVERNAME+OFRMMAIN.HTTPHEAD1.url
ELSE
   cservername = fws_header("SERVER_NAME")
   cport = fws_header("SERVER_PORT")
   cpath_info = fws_header("PATH_INFO")
   cquery_string = fws_header("QUERY_STRING")
   TEXT TO cabsoluteuri TEXTMERGE  NOSHOW PRETEXT 3
  http://<<cServername>>:<<cPort>><<cPATH_INFO>>?<<cQUERY_STRING>>
   ENDTEXT
ENDIF
RETURN CABSOLUTEURI
ENDFUNC

FUNCTION getWxRedirect_uri
LOCAL cabsoluteuri,cservername,cport,cpath_info,cquery_string,lnmh
cabsoluteuri = ""
IF INLIST(_VFP.startmode,0)
   cservername = OFRMMAIN.HTTPHEAD1.host
   lnmh = AT(":",CSERVERNAME)
   IF (LNMH > 0)
      cservername = LEFT(CSERVERNAME,LNMH-1)
   ENDIF
   cabsoluteuri = "http://"+CSERVERNAME+OFRMMAIN.HTTPHEAD1.url
ELSE
   cservername = fws_header("SERVER_NAME")
   cport = fws_header("SERVER_PORT")
   cpath_info = fws_header("PATH_INFO")
   cquery_string = fws_header("QUERY_STRING")
   TEXT TO cabsoluteuri TEXTMERGE  NOSHOW PRETEXT 3
    http://<<cServername>><<cPATH_INFO>>?<<cQUERY_STRING>>
   ENDTEXT
ENDIF
RETURN CABSOLUTEURI
ENDFUNC

ENDDEFINE
