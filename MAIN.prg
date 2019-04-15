SET TALK OFF
SET SAFETY OFF
SET CENTURY ON
SET ESCAPE OFF
SET DATE Ansi
PUBLIC connhandle
PUBLIC pc_id, pc_name, pc_qz, pc_ck
PUBLIC pc_path, pc_ver
IF INLIST(_VFP.startmode,0)
   pc_path = JUSTPATH(_VFP.ACTIVEPROJECT.name)
   SET DEFAULT TO (PC_PATH)
ENDIF
pc_path = SYS(5)+SYS(2003)+"\"
SET DEFAULT TO (PC_PATH)
SET PATH TO Menus;prgs;Forms;Class;Images;dll;Report;Database;DAL;BLL;otherclass
SET PATH TO "WebAPIframework"
SQLSETPROP(0,"DispLogin",3)
IF NOT INLIST(_VFP.startmode,0)
   READ EVENTS
ENDIF
