
PROCEDURE inlist2
LPARAMETERS ctext AS STRING ,cexp AS STRING ,cparsechar AS STRING
DIMENSION larray(1)
IF EMPTY(CPARSECHAR)
   cparsechar = ","
ENDIF
ALINES(LARRAY,CTEXT,0,CPARSECHAR)
RETURN ASCAN(LARRAY,CEXP,-1,-1,0,15) > 0
