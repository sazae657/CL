lexer grammar CLLexer;
//
// JOB
JOB		:	'JOB' ;
CLASS	:	'CLASS' ;
MSGCLASS:	'MSGCLASS' ;
USER	:	'USER' ;
PASSWORD:	'PASSWORD' ;

// DD
DUMMY	:	'DUMMY' ;
DD		:	'DD' ;
DSN		:	'DSN' ;
DISP	:	'DISP' ;
UNIT	:	'UNIT' ;
AFF		:	'AFF' ;
SPACE	:	'SPACE' ;
DCB		:	'DCB' ;
RECFM	:	'RECFM' ;
LRECL	:	'LRECL' ;
BLKSIZE	:	'BLKSIZE' ;
TRTCH	:	'TRTCH' ;
VOL		:	'VOL' ;
SER		:	'SER' ;
RESERVE	:	'RESERVE' ;
REF		:	'REF' ;
LABEL	:	'LABEL' ;
UNLOAD	:	'UNLOAD' ;
SYSOUT	:	'SYSOUT' ;
MODE	:	'MODE' ;
FREE	:	'FREE' ;
DUMP	:	'DUMP' ;
HOLD	:	'HOLD' ;
//GAIJI	:	'GAIJI' ;
OPTCD	:	'OPTCD' ;
DSORG	:	'DSORG' ;
OVERLAY	:	'OVERLAY' ;
FCB		:	'FCB' ;
COPIES	:	'COPIES' ;
RETAIN	:	'RETAIN' ;
//DEN		:	'DEN' ;
AMP		:	'AMP' ;

// EXEC文
EXEC	:	'EXEC' ;
PGM		:	'PGM' ;
PARM	:	'PARM' ;
COND	:	'COND' ;
REGION	:	'REGION' ;
PRTY	:	'PRTY' ;
TIME	:	'TIME' ;

EOL: '\r'? '\n';

CONT : ','[ ]+ EOL ;

COMMA: ',' ;
EQU: '=' ;
ANY: '*';


LB: '(';
RB: ')';

STL :  '//' ;

CARD_CONT :  [/]'/'? ;

IDENTIFIER  : [\*a-zA-Z_&\\@][a-zA-Z_0-9\.&\\]* ;

SYMBOL  :  IDENTIFIER ;

CXDD :  '//'[ ]+'DD'[ ]+ ;

DATASET_NAME	: [\*a-zA-Z_&\\@][a-zA-Z_0-9\.&\\]+('('[+-]?[0-9A-Z]+')')?  ; 

COMMENT :  '//*' ( ~('\r' | '\n') )* (EOL|EOF) -> channel(HIDDEN);

END_OF_CARD :	 '/*' ;

WS : [ \t]+;
NEWLINE : WS? ('\r'? '\n' | ':' ' ') ;

CN: '0'..'9'+EOL;

NUM	:			[-|+]?[1-9]([0-9]+)?['K''|'M']?;

STRING :  [a-zA-Z&][a-zA-Z0-9\.&]+
    ;

BEGIN_CARD :  WS '*' EOL -> pushMode(CARD)
			;
			
BEGIN_PARAM:   '\'' -> pushMode(PARAM)	
			;		
	    
mode CARD;
	CARD_BODY : .*?  EOL '/*'   ->popMode
			;
	
mode PARAM;
	PARAM_BODY: ( ~('\r' | '\n' | '\'') )* '\''  ->popMode
	;
