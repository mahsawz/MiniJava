grammar minijava;

goal : mainClass classDeclaration* ;

mainClass : 'class' identifier '{' 'public' 'static' 'void' 'main' '(' 'String' '[]' identifier ')' '{' ( varDeclaration )* (statement)* '}' '}' ;

identifier : [a-zA-Z][a-zA-Z_0-9]* ;

WS : [ \t\r\n]+ -> skip ;

MULTILINE_COMMENT: '/*' .*? '*/' -> skip ;

LINE_COMMENT: '//' .*? '\n' -> skip ;

INTEGER : '0'|[1-9][0-9]* ;

classDeclaration : 'class' identifier ( 'extends' identifier ) ? '{' ( varDeclaration )* ( methodDeclaration )* '}' ;

varDeclaration : type identifier ';' ;

methodDeclaration : 'public' type identifier '(' ( type identifier ( ',' type identifier )* ) ? ')' '{' ( varDeclaration )* ( statement )* 'return' expression ';' '}' ;

type : 'int' '['']'| 'boolean'| 'int' | 'char' | 'String' | identifier;

statement : '{' statement* '}'
|	'while' '(' expression ')' statement
|	'System.out.println' '(' expression ')' ';'
|	'if' '(' expression ')' statement ('else' statement)?
|	'break' ';'
|	'continue' ';'
|	'return' expression ';'
|	'do' statement 'while' '(' expression ')' ';'
|	identifier '[' expression ']' '=' expression ';' 
|	identifier '=' expression ';'
|	expression ';'
;

expression : INTEGER expressionPrim
|   'true' expressionPrim
|   'false' expressionPrim
|   identifier expressionPrim
|   'this' expressionPrim
|   'new' 'int' '[' expression ']' expressionPrim
|   'new' identifier '(' ')' expressionPrim
|   '!' expression expressionPrim
|   '(' expression ')' expressionPrim
|   INTEGER		# integerLitExpression
|   'true'		# boolLitExpression
|   'false'		# boolLitExpression
|   identifier		# identifierExpression
|   'this'
|   'new' type '[' expression ']'	# arrayInstantiationExpression
|   'new' identifier '(' ')' 		# objectInstantiationExpression
|   '!' expression			# notExpression
|   '(' expression ')' 
|    '"'(ESC_SEQ| ~( '\\' | '"' ))* '"'		# stringExpression
|    '\''(ESC_SEQ| ~( '\'' | '\\' )) '\''	# characterExpression
;

fragment ESC_SEQ: '\\'('b'| 't'| 'n'| 'f'| 'r'| '"'| '\''| '\\')| UNICODE_ESC| OCTAL_ESC ;

expressionPrim : ( ( '&&' | '<' | '+' | '-' | '*' | '>' ) expression expressionPrim ) ?
|   ( '[' expression ']' expressionPrim ) ?	# arrayAccessExpression
|   ( '.' 'length' expressionPrim ) ?		# dotlengthExpression
|   ('.' identifier'(' ( expression ( ',' expression )* )? ')' expressionPrim ) ?
;