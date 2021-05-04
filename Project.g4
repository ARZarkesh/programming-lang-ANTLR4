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
   define_array_statement SEMICOLON
   |
   if_statement
   |
   for_loop_statement
   |
   foreach_loop_statement
   |
   while_loop_statement;

/****************** imports ******************/
import_statement: (FROM lib_name)? IMPORT ((lib_name(COMMA lib_name)*) | (lib_name(DOT lib_name)*) | (lib_name ARROW lib_name) | STAR);
lib_name: VARIABLE_NAME;

/****************** define variable ******************/
define_var_statement: variable_type define_var (COMMA define_var)*;
define_var: define_var_with_type | define_var_without_type;
variable_type: VAR | CONST;
define_var_without_type: VARIABLE_NAME ASSIGN ((INT_VALUE | DOUBLE_VALUE | EXP_VALUE | BOOLEAN_VALUE) | DOUBLE_QUOTE .*? DOUBLE_QUOTE);
define_var_with_type: VARIABLE_NAME COLON data_type (ASSIGN ((INT_VALUE | DOUBLE_VALUE | EXP_VALUE | BOOLEAN_VALUE) | (DOUBLE_QUOTE .*? DOUBLE_QUOTE)))?;
define_array_statement: define_array_with_initialization |  define_array_without_initialization;
define_array_without_initialization: variable_type VARIABLE_NAME COLON NEW ARRAY BRACKET_BEGIN data_type BRACKET_END PARENTHESE_BEGIN (INT_VALUE | DOUBLE_VALUE) PARENTHESE_END ;
define_array_with_initialization: variable_type VARIABLE_NAME ASSIGN ARRAY PARENTHESE_BEGIN (INT_VALUE | DOUBLE_VALUE) (COMMA (INT_VALUE | DOUBLE_VALUE))*  PARENTHESE_END;
data_type: INT | STRING | DOUBLE | BOOLEAN | CHARACTER | FLOAT;


/****************** if statement ******************/
if_statement: IF PARENTHESE_BEGIN condition PARENTHESE_END block
              (ELSE_IF PARENTHESE_BEGIN condition PARENTHESE_END block)?
              (ELSE block)?;

// for loop
for_loop_statement: FOR
                PARENTHESE_BEGIN
                (VARIABLE_NAME ASSIGN (INT_VALUE | DOUBLE_VALUE | EXP_VALUE))? SEMICOLON
                (((NEGATE)? condition) ((AND | OR) (NEGATE)? condition)*)? SEMICOLON
                (VARIABLE_NAME (PLUS_PLUS | MINUS_MINUS))?
                PARENTHESE_END
                block;

// foreach loop
foreach_loop_statement: FOR
                        PARENTHESE_BEGIN
                        VAR VARIABLE_NAME IN VARIABLE_NAME
                        PARENTHESE_END
                        block;

// while loop
while_loop_statement: WHILE
                      PARENTHESE_BEGIN
                      (((NEGATE)? condition) ((AND | OR) (NEGATE)? condition)*)?
                      PARENTHESE_END
                      block;

condition: BOOLEAN_VALUE | expression;
block: BRACE_BEGIN statement* BRACE_END;
expression: (BOOLEAN_VALUE | INT_VALUE | DOUBLE_VALUE | EXP_VALUE | VARIABLE_NAME)
            compare_sign
            (BOOLEAN_VALUE | INT_VALUE | DOUBLE_VALUE | EXP_VALUE | VARIABLE_NAME);
compare_sign: EQUAL | LESS | LESS_EQUAL | GREATER | GREATHER_EQUAL | NON_EQUAL;
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
IF              : 'if';
ELSE_IF         : 'elif';
ELSE            : 'else';
FOR             : 'for';
IN              : 'in';
WHILE           : 'while';

// symbols
DOT             : '.';
COLON           : ':';
SEMICOLON       : ';';
COMMA           : ',';
ARROW           : '=>';
STAR            : '*';
ASSIGN          : '=';
BRACKET_BEGIN   : '[';
BRACKET_END     : ']';
BRACE_BEGIN     : '{';
BRACE_END       : '}';
PARENTHESE_BEGIN: '(';
PARENTHESE_END  : ')';
DOUBLE_QUOTE    : '"';
SINGLE_QUOTE    : '\'';
EXP_SYMBOL      : 'E' | 'e';
PLUS            : '+';
MINUS           : '-';
PLUS_PLUS       : '++';
MINUS_MINUS     : '--';

// compare signs
EQUAL           : '==';
GREATER         : '>';
LESS            : '<';
GREATHER_EQUAL  : '>=';
LESS_EQUAL      : '<=';
NON_EQUAL       : '!=';

// logical operators
AND             : '&&';
OR              : '||';
NEGATE          : '!';

// primitive data types
INT             : 'Int';
STRING          : 'String';
DOUBLE          : 'Double';
BOOLEAN         : 'Boolean';
CHARACTER       : 'Char';
FLOAT           : 'Float';
VOID            : 'Void';

// Access Modifiers
PUBLIC          : 'public';
PRIVATE         : 'private';
PROTECTED       : 'protected';

// values
BOOLEAN_VALUE: 'true' | 'false';
INT_VALUE: DIGIT+;
DOUBLE_VALUE: DIGIT+ DECIMAL_PART;
EXP_VALUE: DIGIT? '.' DIGIT+ EXP_PART;
DECIMAL_PART: '.' DIGIT+;
EXP_PART: EXP_SYMBOL (PLUS | MINUS)? DIGIT+;

// variable naming rule
VARIABLE_NAME: [a-zA-Z$_]+ [a-zA-Z0-9$_]+;

LETTER: [a-zA-Z];
DIGIT: [0-9];