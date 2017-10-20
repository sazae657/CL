parser grammar CLParser;

options { tokenVocab=CLLexer;  }


program			: (contents)+ EOF
				;

contents	:  job_stmnt EOL (php_cmd|COMMENT)+ 
			| 	COMMENT 
			;

php_cmd			: 	php_stmnt
				|	CN EOL 
				|	EOL
				;
			
php_stmnt		:	dd_stmnt
				|	exec_stmnt
				|	cproc_op
				;

//------------------------------------------------------------------------------
//  JOB
//------------------------------------------------------------------------------
job_stmnt		:	STL IDENTIFIER WS JOB WS job_stmnt_list
				;
job_stmnt_list	:
				|	STRING	
				|	job_stmnt_cont	job_stmnt_list
				|	job_stmnt_list COMMA job_stmnt_cont
				;
				
job_stmnt_cont	:	STRING					
				|	CLASS 	EQU IDENTIFIER	
				|	CLASS 	EQU NUM			
				|	MSGCLASS EQU IDENTIFIER	
				|	MSGCLASS EQU NUM		
				|	PRTY	EQU NUM 		
				|	USER	EQU IDENTIFIER	
				|	PASSWORD EQU IDENTIFIER
				|	REGION	EQU region_op

				;

/*------------------------------------------------------------------------------
  EXEC
------------------------------------------------------------------------------*/
exec_stmnt		:	STL IDENTIFIER WS EXEC WS exec_stmnt_list
				;
exec_stmnt_list	:	exec_stmnt_cont
				|	exec_stmnt_list COMMA exec_stmnt_cont
				;
exec_stmnt_cont :	PGM  EQU IDENTIFIER
				|	PARM EQU BEGIN_PARAM PARAM_BODY
				|	PARM EQU IDENTIFIER
				|	TIME EQU NUM
				|	COND EQU cond_op
				|	REGION EQU region_op
				;

// カタプロ用
cproc_op		:	STL IDENTIFIER WS EXEC WS cproc_op_list
				;
cproc_op_list	:	cproc_op_cont
				|	cproc_op_cont COMMA cproc_op_list
				;
cproc_op_cont	:	IDENTIFIER
				|	COND EQU cond_op
				|	IDENTIFIER EQU IDENTIFIER
				;

// CONDオペランド
cond_op			:	LB cond_op_frm RB
				;
cond_op_frm		:	cond_op_list
				|	cond_op_mul
				;
cond_op_list	:	cond_op_cont
				|	cond_op_cont COMMA cond_op_list
				;
cond_op_cont	:	IDENTIFIER
				|	NUM	
				;
cond_op_mul		:	LB cond_op_list RB
				|	LB cond_op_list RB COMMA cond_op_mul
				;

// REGION
region_op		:	region_op_cont
				|	LB region_op_list RB
				;
region_op_list	:	region_op_cont
				|	region_op_cont COMMA region_op_list
				|	COMMA  region_op_cont
				;
region_op_cont	:	NUM	;

/*------------------------------------------------------------------------------
  DD文
------------------------------------------------------------------------------*/
dd_stmnt		: STL IDENTIFIER WS DD BEGIN_CARD CARD_BODY 
				| STL IDENTIFIER WS DD WS (dd_oper_list EOL
				| dd_oper_list COMMA EOL dd_multiline)
				;
				
dd_multiline	: STL WS dd_oper_list EOL
				| (STL WS dd_oper_list COMMA EOL dd_multiline)+
				;

dd_oper_list	:	dd_oper_cont
				|	dd_oper_cont COMMA dd_oper_list 
				;

dd_oper_cont	:	dsn_op
				|	DISP	EQU disp_op
				|	UNIT	EQU unit_op
				|	SPACE	EQU space_op
				|	DCB		EQU dcb_op
				|	SYSOUT	EQU syo_op		
				|	VOL 	EQU vol_op
				|	LABEL	EQU label_op
				|	UNLOAD	EQU IDENTIFIER
				|	FREE	EQU IDENTIFIER
				|	DUMP	EQU IDENTIFIER
				|	HOLD	EQU IDENTIFIER
				|	OVERLAY EQU IDENTIFIER
				|	FCB		EQU NUM
				|	FCB		EQU IDENTIFIER
				|	COPIES	EQU NUM
				|	AMP		EQU	LB STRING RB
				|	DUMMY
				;


/* DSNオペランド */
dsn_op			:	DSN	EQU (DATASET_NAME|IDENTIFIER) 
				|   DSN EQU BEGIN_PARAM PARAM_BODY 
				;

/* UNITオペランド */
unit_op			:	unit_op_cont
				|	LB unit_op_list RB
				;
unit_op_list	:	unit_op_cont
				|	unit_op_cont COMMA unit_op_list
				;
unit_op_cont	:	IDENTIFIER
				|	NUM
				|	AFF EQU IDENTIFIER
				;

/* DISP オペランド */
disp_op			:	IDENTIFIER
				|	LB (disp_op_list)+ RB
				;
disp_op_list	:	COMMA? disp_op_cont
				|	disp_op_cont COMMA disp_op_list
				;
disp_op_cont	:	IDENTIFIER
				;

/* SPACE オペランド */
space_op		:	LB IDENTIFIER COMMA
					LB space_def RB
					space_opt RB
				;
space_def		:	space_num
				|	space_def COMMA space_num
				;
space_num		:	NUM
				;
space_opt		:	
				|	COMMA IDENTIFIER
				;

/* DCB オペランド */
dcb_op			:	dcb_op_cont
				|	LB dcb_op_list RB
				;
dcb_op_list		:	dcb_op_cont
				|	dcb_op_cont COMMA dcb_op_list
				;
dcb_op_cont		:	RECFM EQU IDENTIFIER
				|	DSORG EQU IDENTIFIER
				|	LRECL EQU NUM
				|	LRECL EQU IDENTIFIER
				|	BLKSIZE EQU NUM
				|	BLKSIZE EQU IDENTIFIER
				|	MODE EQU IDENTIFIER	
				|	OPTCD EQU IDENTIFIER
				|	TRTCH EQU IDENTIFIER
				;

/* SYSOUTオペランド */
syo_op			:	syo_op_cont
				|	LB (syo_op_list)+ RB
				;
syo_op_list		:	COMMA? syo_op_cont
				|	syo_op_cont COMMA syo_op_cont
				;
syo_op_cont		:   IDENTIFIER
				|	NUM	
				|	ANY	
				;

/* VOLオペランド */
vol_op			:	vol_op_cont
				|	LB vol_op_list RB
				;
vol_op_list		:	vol_op_cont
				|	vol_op_cont COMMA vol_op_list
				;
vol_op_cont		:	
				|	RESERVE
				|	RETAIN
				|	SER EQU vol_ser_op
				|	REF EQU vol_ref_op
				;
vol_ser_op		:	vol_ser_cont
				|	LB vol_ser_list RB
				;
vol_ser_list	:	vol_ser_cont
				|	vol_ser_cont COMMA vol_ser_list
				;
vol_ser_cont	:	IDENTIFIER
				;
vol_ref_op		:	vol_ref_cont
				|	LB vol_ref_list RB
				;
vol_ref_list	:	vol_ref_cont
				|	vol_ref_cont COMMA vol_ref_list
				;
vol_ref_cont	:	IDENTIFIER
				|	IDENTIFIER LB NUM RB
				;

/* LABELオペランド */
label_op		:	label_op_cont
				|	LB label_op_list RB
				;
label_op_list	:	label_op_cont
				|	label_op_cont COMMA label_op_list
				;
label_op_cont	:	
				|	IDENTIFIER	
				|	NUM 
				;



