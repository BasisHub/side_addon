[[GLE_ALLOCDET.BWRI]]
rem SET BATCH NUMBER FIELD TO THE SAME VALUE AS IS IN THE HEADER REC

callpoint!.setColumnData("GLE_ALLOCDET.BATCH_NO",stbl("+BATCH_NO"))
