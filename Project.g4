grammar Project;

/*
 === === === === Parser Rules === === === ===
*/

program: statement*;
statement:
   import_statement SEMICOLON
   |
   define_var_statement SEMICOLON
   |
   define_array_statement SEMICOLON;

/****************** imports ******************/
import_statement: (FROM lib_name)? IMPORT ((lib_name(COMMA lib_name)*) | (lib_name(DOT lib_name)*) | (lib_name ARROW lib_name) | STAR);
lib_name: variable_name;

/****************** define variable ******************/
define_var_statement: variable_type define_var (COMMA define_var)*;
define_var: define_var_with_type | define_var_without_type;
variable_type: VAR | CONST;
define_var_without_type: variable_name ASSIGN (NUMBER | DOUBLE_QUOTE VALUE DOUBLE_QUOTE);
define_var_with_type: variable_name COLON data_type (ASSIGN (NUMBER | (DOUBLE_QUOTE VALUE DOUBLE_QUOTE)))?;
variable_name: WORD;
define_array_statement: define_array_with_initialization |  define_array_without_initialization;
define_array_without_initialization: variable_type variable_name COLON NEW ARRAY BRACKET_BEGIN data_type BRACKET_END PARENTHESE_BEGIN NUMBER PARENTHESE_END ;
define_array_with_initialization: variable_type variable_name ASSIGN ARRAY PARENTHESE_BEGIN NUMBER (COMMA NUMBER)*  PARENTHESE_END;
data_type: INT | STRING | DOUBLE | BOOLEAN | CHARACTER | FLOAT;

/*
 === === === === Lexer Rules === === === ===
*/

// skip
WHITE_SPACE:[ \t\n\r]+ -> skip;
COMMENT_TYPE1: '/*' .*? '*/' -> skip;
COMMENT_TYPE2: '#' ~[\r\n]* -> skip;

// keywords
VAR             : 'var';
CONST           : 'const';
IMPORT          : 'import';
FROM            : 'from';
NEW             : 'new';
ARRAY           : 'Array';
DOT             : '.';
COLON           : ':';
SEMICOLON       : ';';
COMMA           : ',';
ARROW           : '=>';
STAR            : '*';
ASSIGN          : '=';
BRACKET_BEGIN   : '[';
BRACKET_END     : ']';
PARENTHESE_BEGIN: '(';
PARENTHESE_END  : ')';
DOUBLE_QUOTE    : '"';
SINGLE_QUOTE    : '\'';

// primitive data types
INT             : 'Int';
STRING          : 'String';
DOUBLE          : 'Double';
BOOLEAN         : 'Boolean';
CHARACTER       : 'Char';
FLOAT           : 'Float';

// Access Modifiers
PUBLIC          : 'public';
PRIVATE         : 'private';
PROTECTED       : 'protected';

WORD: LETTER+(LETTER | DIGIT)+;
VALUE: (LETTER | DIGIT)+;
INT_NUM: '0' | POSITIVE_DIGIT DIGIT*;
POSITIVE_DIGIT: [1-9];
NUMBER: DIGIT+;
LETTER: [a-zA-Z];

DIGIT: [0-9];
