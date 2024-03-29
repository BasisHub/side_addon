[[GLM_ACCT.BDEL]]
rem --- Check for activity
	okay$="Y"
	mp=13
	reason$=""

rem --- Check glm-02 for activity
	files=1,begfile=1,endfile=files
	dim files$[files],options$[files],chans$[files],templates$[files]
	files$[1]="GLM_ACCTSUMMARY",options$[1]="OTA"

	call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:		chans$[all],templates$[all],table_chans$[all],batch,status$

	glm02_dev=num(chans$[1])
	dim glm02a$:templates$[1]
	this_acct$=callpoint!.getColumnData("GLM_ACCT.GL_ACCOUNT")
	read(glm02_dev,key=firm_id$+this_acct$,dom=*next)
	while 1
		readrecord (glm02_dev,end=*break)glm02a$
		if pos(firm_id$+this_acct$=glm02a.firm_id$+glm02a.gl_account$)<>1 break
		if glm02a.begin_amt<>0 break
		if glm02a.begin_units<>0 break
		for x=1 to mp
			if nfield(glm02a$,"period_amt_"+str(x:"00"))<>0 okay$="N"
			if nfield(glm02a$,"period_units_"+str(x:"00"))<>0 okay$="N"
		next x
		if okay$="N"
			reason$=Translate!.getTranslation("AON_ACCOUNT_SUMMARY")
			break
		endif
	wend

	files=1,begfile=1,endfile=files
	dim files$[files],options$[files],chans$[files],templates$[files]
	files$[1]="GLM_ACCTSUMMARY",options$[1]="CX"

	call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:		chans$[all],templates$[all],table_chans$[all],batch,status$

rem --- Check glt-06 for history
	if okay$="Y"
	files=1,begfile=1,endfile=files
	dim files$[files],options$[files],chans$[files],templates$[files]
	files$[1]="GLT_TRANSDETAIL",options$[1]="OTA"

	call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:		chans$[all],templates$[all],table_chans$[all],batch,status$

		glt06_dev=num(chans$[1])
		read (glt06_dev,key=firm_id$+this_acct$,dom=*next)
		while 1
			glt06_key$=key(glt06_dev,end=*break)
			if pos(firm_id$+this_acct$=glt06_key$)=1
				okay$="N"
				reason$=Translate!.getTranslation("AON_TRANSACTION_HISTORY")
			endif
			break
		wend

		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLT_TRANSDETAIL",options$[1]="CX"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:			chans$[all],templates$[all],table_chans$[all],batch,status$

	endif

rem ---Check Journal Entries for activity
	if okay$="Y"
		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLE_JRNLDET",options$[1]="OTA"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$
		gle11_dev=num(chans$[1])
		read (gle11_dev,key=firm_id$+this_acct$,knum="BY ACCOUNT",dom=*next)
		while 1
			gle11_key$=key(gle11_dev,end=*break)
			if pos(firm_id$+this_acct$=gle11_key$)=1
				okay$="N"
				reason$=Translate!.getTranslation("AON_JOURNAL_ENTRY")
			endif
			break
		wend

		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLE_JRNLDET",options$[1]="CX"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$
	endif

rem ---Check Recurring Journal Entries for activity
	if okay$="Y"
		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLE_RECJEDET",options$[1]="OTA"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$
		gle12_dev=num(chans$[1])
		read (gle12_dev,key=firm_id$+this_acct$,knum="BY ACCOUNT",dom=*next)
		while 1
			gle12_key$=key(gle12_dev,end=*break)
			if pos(firm_id$+this_acct$=gle12_key$)=1
				okay$="N"
				reason$=Translate!.getTranslation("AON_RECURRING_JOURNAL_ENTRY")
			endif
			break
		wend

		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLE_RECJEDET",options$[1]="CX"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$
	endif

rem ---Check Allocation Detail for activity
	if okay$="Y"
		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLE_ALLOCDET",options$[1]="OTA"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$

		gle13_dev=num(chans$[1])
		read (gle13_dev,key=firm_id$+this_acct$,dom=*next)
		while 1
			gle13_key$=key(gle13_dev,end=*break)
			if pos(firm_id$+this_acct$=gle13_key$)=1
				okay$="N"
				reason$=Translate!.getTranslation("AON_ACCOUNT_ALLOCATION")
			endif
			break
		wend
		if okay$="Y"
			read (gle13_dev,key=firm_id$+this_acct$,knum="AO_DEST_ACCT",dom=*next)
			while 1
				gle13_key$=key(gle13_dev,end=*break)
				if pos(firm_id$+this_acct$=gle13_key$)=1
					okay$="N"
					reason$=Translate!.getTranslation("AON_ACCOUNT_ALLOCATION")
				endif
				break
			wend
		endif

		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLE_ALLOCDET",options$[1]="CX"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$

	endif

rem ---Check Daily Detail for activity
	if okay$="Y"
		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLE_DAILYDETAIL",options$[1]="OTA"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$

		glt04_dev=num(chans$[1])
		read (glt04_dev,key=firm_id$+this_acct$,knum="AO_TRDAT_PROCESS",dom=*next)
		while 1
			glt04_key$=key(glt04_dev,end=*break)
			if pos(firm_id$+this_acct$=glt04_key$)=1
				okay$="N"
				reason$=Translate!.getTranslation("AON_DAILY_DETAIL")
			endif
			break
		wend

		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLE_DAILYDETAIL",options$[1]="CX"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:			chans$[all],templates$[all],table_chans$[all],batch,status$
	endif

rem --- Check Retained Earnings Account
	if okay$="Y"
		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLS_EARNINGS",options$[1]="OTA"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$

		gls_earnings_dev=num(chans$[1])
		dim gls01b$:templates$[1]
		read record(gls_earnings_dev,key=firm_id$+"GL01")gls01b$
		if gls01b.gl_account$=this_acct$
			okay$="N"
			reason$=Translate!.getTranslation("AON_RETAINED_EARNINGS_ACCOUNT")
		endif

		files=1,begfile=1,endfile=files
		dim files$[files],options$[files],chans$[files],templates$[files]
		files$[1]="GLS_EARNINGS",options$[1]="CX"

		call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:               		                  chans$[all],templates$[all],table_chans$[all],batch,status$

	endif

rem --- Disallow delete if flag is set
	if okay$="N"
		msg_id$="ACTIVITY_EXISTS"
		dim msg_tokens$[1]
		msg_tokens$[1]=reason$
		gosub disp_message
		callpoint!.setStatus("ABORT")
	else
		msg_id$="ENTRY_DTL_DELETE"
		msg_opt$=""
		gosub disp_message
		if msg_opt$="N"
			callpoint!.setStatus("ABORT")
		endif
	endif
[[GLM_ACCT.AOPT-TRAN]]
rem Transaction History Inquiry

cp_acct$=""

rem --- need to set cp_acct$ from grid if we're running glm_acct as maint grid
while 1
	gridObj!=Form!.getControl(5000,err=*break)
	cp_acct$=gridObj!.getCellText(gridObj!.getSelectedRow(),0)
	break
wend

rem --- or set cp_acct$ by getting column data if we did an expand on a validated GL acct in some other form
if cp_acct$="" then cp_acct$=callpoint!.getColumnData("GLM_ACCT.GL_ACCOUNT")

user_id$=stbl("+USER_ID")
dim dflt_data$[2,1]
dflt_data$[1,0]="GL_ACCOUNT_1"
dflt_data$[1,1]=cp_acct$
dflt_data$[2,0]="GL_ACCOUNT_2"
dflt_data$[2,1]=cp_acct$
call stbl("+DIR_SYP")+"bam_run_prog.bbj",
:                       "GLR_TRANSHISTORY",
:                       user_id$,
:                   	  "",
:                       "",
:                       table_chans$[all],
:                       "",
:                       dflt_data$[all]
[[GLM_ACCT.AOPT-SUMM]]
rem Summary Activity Inquiry

cp_acct$=""

rem --- need to set cp_acct$ from grid if we're running glm_acct as maint grid
while 1
	gridObj!=Form!.getControl(5000,err=*break)
	cp_acct$=gridObj!.getCellText(gridObj!.getSelectedRow(),0)
	break
wend

rem --- or set cp_acct$ by getting column data if we did an expand on a validated GL acct in some other form
if cp_acct$="" then cp_acct$=callpoint!.getColumnData("GLM_ACCT.GL_ACCOUNT")

user_id$=stbl("+USER_ID")
dim dflt_data$[2,1]
dflt_data$[1,0]="GL_ACCOUNT"
dflt_data$[1,1]=cp_acct$
call stbl("+DIR_SYP")+"bam_run_prog.bbj",
:                       "GLM_SUMMACTIVITY",
:                       user_id$,
:                   	  "",
:                       "",
:                       table_chans$[all],
:                       "",
:                       dflt_data$[all]
[[GLM_ACCT.<CUSTOM>]]
#include std_missing_params.src
[[GLM_ACCT.BSHO]]
rem --- Open/Lock files

files=1,begfile=1,endfile=files
dim files$[files],options$[files],chans$[files],templates$[files]
files$[1]="GLS_PARAMS",options$[1]="OTA"

call dir_pgm$+"bac_open_tables.bbj",begfile,endfile,files$[all],options$[all],
:                                 chans$[all],templates$[all],table_chans$[all],batch,status$

if status$<>"" then
	remove_process_bar:
	bbjAPI!=bbjAPI()
	rdFuncSpace!=bbjAPI!.getGroupNamespace()
	rdFuncSpace!.setValue("+build_task","OFF")
	release
endif

gls01_dev=num(chans$[1])
dim gls01a$:templates$[1]


rem --- init/parameters

gls01a_key$=firm_id$+"GL00"
find record (gls01_dev,key=gls01a_key$,err=std_missing_params) gls01a$
