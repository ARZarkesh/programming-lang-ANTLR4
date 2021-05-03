grammar Project;
program: statement*;
statement:
   import_statement SEMICOLON
   |
   define_var_statement SEMICOLON
   |
   define_array_statement SEMICOLON;

/****************** imports ******************/
import_statement:
    IMPORT NAME(DOT NAME)*
    |
    FROM NAME IMPORT NAME(COMMA NAME)*
    |
    FROM NAME IMPORT NAME ARROW_RIGHT NAME
    |
    FROM NAME IMPORT STAR ;

/****************** define variable ******************/
define_var_statement:
    (VAR | CONST) define_var (COMMA define_var)*;
define_var:
    define_var_with_type_declaration
    |
    define_var_without_type_declaration;

define_var_without_type_declaration:
    NAME ASSIGN (INT_NUMBER | DOUBLE_QUOTE NAME DOUBLE_QUOTE);
define_var_with_type_declaration:
    NAME COLON DATA_TYPE (ASSIGN (INT_NUMBER | (DOUBLE_QUOTE NAME DOUBLE_QUOTE)))?;

define_array_statement:
    (VAR | CONST) NAME COLON NEW ARRAY BRACKET_BEGIN DATA_TYPE BRACKET_END PARENTHESE_BEGIN ARRAY_SIZE PARENTHESE_END ;


// Lexer Rules
VAR: 'var';
CONST: 'const';
IMPORT: 'import';
FROM: 'from';
NEW: 'new';
ARRAY: 'Array';
DOT: '.';
COLON: ':';
SEMICOLON: ';';
COMMA: ',';
ARROW_RIGHT: '=>';
STAR: '*';
ASSIGN: '=';
BRACKET_BEGIN: '[';
BRACKET_END: ']';
PARENTHESE_BEGIN: '(';
PARENTHESE_END: ')';
DOUBLE_QUOTE: '"';
SINGLE_QUOTE: '\'';

DATA_TYPE: INT | STRING | DOUBLE | BOOLEAN | CHARACTER | FLOAT;
INT: 'Int';
STRING: 'String';
DOUBLE: 'Double';
BOOLEAN: 'Boolean';
CHARACTER: 'Char';
FLOAT: 'Float';
ARRAY_SIZE: DIGITS+;

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