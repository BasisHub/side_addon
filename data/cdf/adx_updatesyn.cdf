[[ADX_UPDATESYN.OLD_SYN_FILE.AVAL]]
rem --- Validate old syn file

	old_syn$ = callpoint!.getUserInput()
	gosub validate_old_syn
[[ADX_UPDATESYN.UPDATE_SYN_FILE.AVAL]]
rem --- Validate update syn file

	update_syn$ = callpoint!.getUserInput()
	gosub validate_update_syn

rem --- Set defaults for data STBLs
	if success
		pos=pos("\"=update_syn$)
		while pos
			update_syn$=update_syn$(1, pos-1)+"/"+update_syn$(pos+1)
			pos=pos("\"=update_syn$)
		wend

		path$=""
		if pos("/config/"=update_syn$)
			path$=update_syn$(1, pos("/config/"=update_syn$)-1)

		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.ADDATA"),3)="" 
			callpoint!.setColumnData("ADX_UPDATESYN.ADDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.APDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.APDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.ARDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.ARDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.BMDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.BMDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.GLDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.GLDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.IVDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.IVDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.MPDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.MPDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.OPDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.OPDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.PODATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.PODATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.PRDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.PRDATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.SADATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.SADATA",path$+"/data/")
		if cvs(callpoint!.getColumnData("ADX_UPDATESYN.SFDATA"),3)=""
			callpoint!.setColumnData("ADX_UPDATESYN.SFDATA",path$+"/data/")

		callpoint!.setStatus("REFRESH")
	endif
[[ADX_UPDATESYN.AREC]]
rem --- Initialize update addon.syn file to the one in default upgrade directory
rem --- Default upgrade directory is /aon_prod/vnnnn (where nnnn=new version)
rem --- Get new version from SYS line of download addon.syn file

	bbjHome$ = System.getProperty("basis.BBjHome")
	download_loc$ = bbjHome$ + "/apps/aon"
	synChan=unt
	open(synChan,isz=-1, err=file_not_found)download_loc$ + "/config/addon.syn"

	while 1
		read(synChan,end=*break)record$
		rem --- locate SYS line
		if(pos("SYS="=record$) = 1) then
			rem --- parse version from SYS line
			start$ = "^Version "
			startLen = len(start$)
			startPos = pos(start$=record$)
			end$ = " - "
			endPos = pos(end$=record$(startPos + startLen))
			synVersion$ = cvs(record$(startPos + startLen, endPos - 1),3)
			rem -- remove decimal point
			dotPos = pos("."=synVersion$)
			if(dotPos) then
				synVersion$ = synVersion$(1, dotPos - 1) + synVersion$(dotPos + 1)
			endif
			break
		endif
	wend
	close(synChan)

	update_syn$ = "/aon_prod/v" + synVersion$ + "/aon/config/addon.syn"
	open(synChan,isz=-1, err=file_not_found)update_syn$
	close(synChan)

	callpoint!.setColumnData("ADX_UPDATESYN.UPDATE_SYN_FILE", update_syn$)
	callpoint!.setStatus("REFRESH")
	break

file_not_found:
[[ADX_UPDATESYN.<CUSTOM>]]
validate_update_syn: rem --- Validate update syn file

	success=0

	rem --- File must exist

	testFile$=update_syn$
	gosub verify_file_exists
	if !exists
		callpoint!.setFocus("ADX_UPDATESYN.UPDATE_SYN_FILE")
		callpoint!.setStatus("ABORT")
		return
	endif

	rem --- File should end with .syn extension

	testFile$=update_syn$
	gosub verify_syn_file_ext
	if msg_opt$="C"
		callpoint!.setFocus("ADX_UPDATESYN.UPDATE_SYN_FILE")
		callpoint!.setStatus("ABORT")
		return
	endif

	rem --- Don�t allow current download location

	testLoc$=update_syn$
	gosub verify_not_download_loc
	if !loc_ok
		callpoint!.setFocus("ADX_UPDATESYN.UPDATE_SYN_FILE")
		callpoint!.setStatus("ABORT")
		return
	endif

	success=1

	return

validate_old_syn: rem --- Validate old syn file

	rem --- File must exist

	testFile$=old_syn$
	gosub verify_file_exists
	if !exists
		callpoint!.setFocus("ADX_UPDATESYN.OLD_SYN_FILE")
		callpoint!.setStatus("ABORT")
		return
	endif

	rem --- File should end with .syn extension

	testFile$=old_syn$
	gosub verify_syn_file_ext
	if msg_opt$="C"
		callpoint!.setFocus("ADX_UPDATESYN.OLD_SYN_FILE")
		callpoint!.setStatus("ABORT")
		return
	endif

	rem --- Don�t allow current download location

	testLoc$=old_syn$
	gosub verify_not_download_loc
	if !loc_ok
		callpoint!.setFocus("ADX_UPDATESYN.OLD_SYN_FILE")
		callpoint!.setStatus("ABORT")
		return
	endif

	return

verify_file_exists: rem --- Verify file exists

	exists=0
	testChan=unt
	open(testChan, err=file_missing)testfile$
	close(testChan)
	exists=1

file_missing:
	if !exists
		msg_id$="AD_FILE_MISSING"
		dim msg_tokens$[1]
		msg_tokens$[1]=testfile$
		gosub disp_message
	endif

	return


verify_syn_file_ext: rem --- Verify file extension is .syn

	msg_opt$=""
	if len(testFile$)<4 or testFile$(len(testFile$)-3)<>".syn"
		msg_id$="AD_WRONG_FILE_EXT"
		dim msg_tokens$[1]
		msg_tokens$[1]=".syn"
		gosub disp_message
	endif

	return

verify_not_download_loc: rem --- Verify not using current download location
	rem --- Some needed improvements
	rem --- Doesn't handle . or .. relative paths
	rem --- Doesn't handle symbolic links
	rem --- / vs \ may be an issue
	rem --- Should be case insensitive for Windows
	rem --- basis.BBjHome includes the Windows drive id

	loc_ok=1
	bbjHome$ = System.getProperty("basis.BBjHome")
	if pos(bbjHome$=testLoc$)=1
		msg_id$="AD_INSTALL_LOC_BAD"
		dim msg_tokens$[1]
		msg_tokens$[1]=bbjHome$
		gosub disp_message
		loc_ok=0
	endif

	return
[[ADX_UPDATESYN.ASVA]]
rem --- Validate update syn file

	update_syn$ = callpoint!.getColumnData("ADX_UPDATESYN.UPDATE_SYN_FILE")
	gosub validate_update_syn

rem --- Validate old syn file

	if num(callpoint!.getColumnData("ADX_UPDATESYN.UPGRADE"))
		old_syn$ = callpoint!.getColumnData("ADX_UPDATESYN.OLD_SYN_FILE")
		gosub validate_old_syn
	endif