[[IVR_ITEMTURNS.ARAR]]
num_files=1
dim open_tables$[1:num_files],open_opts$[1:num_files],open_chans$[1:num_files],open_tpls$[1:num_files]
open_tables$[1]="IVS_PARAMS",open_opts$[1]="OTA"
gosub open_tables

ivs01a_chn=num(open_chans$[1])
ivs01a_tpl$=open_tpls$[1]

dim ivs_params$:ivs01a_tpl$
readrecord(ivs01a_chn,key=firm_id$+"IV00")ivs_params$

callpoint!.setColumnData("PICK_GL_PER",ivs_params.current_per$)
callpoint!.setColumnData("PICK_YEAR",ivs_params.current_year$)
callpoint!.setColumnData("PICK_LISTBUTTON","A")
callpoint!.setColumnData("REPORT_SEQUENCE","B")
callpoint!.setColumnData("ITEM_TURNS","1")
callpoint!.setColumnData("STOCK_LEVEL","W")
callpoint!.setStatus("REFRESH")
