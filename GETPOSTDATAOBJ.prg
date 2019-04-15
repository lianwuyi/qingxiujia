
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
