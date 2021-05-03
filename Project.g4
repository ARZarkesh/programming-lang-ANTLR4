grammar Project;
program: statement*;
statement:
   import_statement
   |
   define_var_statement;

/****************** imports ******************/
import_statement:
    IMPORT NAME(DOT NAME)* SEMICOLON
    |
    FROM NAME IMPORT NAME(COMMA NAME)* SEMICOLON
    |
    FROM NAME IMPORT NAME ARROW_RIGHT NAME SEMICOLON
    |
    FROM NAME IMPORT STAR SEMICOLON;

/****************** define variable ******************/
define_var_statement:
 (VAR | CONST)
 (NAME | INT_NUMBER)
 COLON
 DATA_TYPE
 (ASSIGN (INT_NUMBER | NAME))?
 SEMICOLON ;


// Lexer Rules
VAR: 'var';
CONST: 'const';
IMPORT: 'import';
FROM: 'from';
DOT: '.';
COLON: ':';
SEMICOLON: ';';
COMMA: ',';
ARROW_RIGHT: '=>';
STAR: '*';
ASSIGN: '=';
BRACKET_BEGIN: '[';
BRACKET_END: ']';

DATA_TYPE: INT | STRING | DOUBLE | BOOLEAN | CHARACTER | FLOAT;
INT: 'Int';
STRING: 'String';
DOUBLE: 'Double';
BOOLEAN: 'Boolean';
CHARACTER: 'Char';
FLOAT: 'Float';

NAME: (UPPERCASE_LETTERS | LOWERCASE_LETTERS | DIGITS)+;
fragment UPPERCASE_LETTERS: [A-Z];
fragment LOWERCASE_LETTERS: [a-z];

INT_NUMBER: DIGITS+;
DIGITS: [0-9];

WHITE_SPACE:[ \t\n\r]+ -> skip;

COMMENT_TYPE1: COMMENT_BEGIN .*? COMMENT_END -> skip;
COMMENT_BEGIN: '/*';
COMMENT_END: '*/';

COMMENT_TYPE2: SINGLE_LINE_COMMENT ~[\r\n]* -> skip;
SINGLE_LINE_COMMENT: '#';