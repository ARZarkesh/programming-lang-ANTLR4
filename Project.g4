grammar Project;

/*
 === === === === Parser Rules === === === ===
*/

program: import_statement* statement*;
statement:
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
   while_loop_statement
   |
   do_while_loop_statement
   |
   switch_case_statement
   |
   class_definitiion_statement
   |
   function_definition_statement
   |
   function_call_statement
   |
   obj_instant SEMICOLON
   |
   try_catch
   |
   operation SEMICOLON;

// import statement
import_statement: (FROM chaining)? IMPORT
                  (
                  (IDENTIFIER(COMMA IDENTIFIER)*)
                  |
                  (chaining)
                  |
                  (IDENTIFIER ARROW IDENTIFIER)
                  |
                  STAR
                  )
                  SEMICOLON;

// define variable statement
define_var_statement: variable_type define_var (COMMA define_var)*;
define_var: define_var_with_type | define_var_without_type;
define_var_without_type: IDENTIFIER ASSIGN operation;
define_var_with_type: IDENTIFIER COLON data_type ( ASSIGN operation )?;
define_array_statement: define_array_with_initialization | define_array_without_initialization;
define_array_without_initialization: variable_type
                                     IDENTIFIER
                                     COLON NEW ARRAY
                                     (BRACKET_BEGIN data_type BRACKET_END)?
                                     PARENTHESE_BEGIN (INT_VALUE | DOUBLE_VALUE) PARENTHESE_END;
define_array_with_initialization: variable_type
                                  IDENTIFIER
                                  ASSIGN
                                  ARRAY
                                  PARENTHESE_BEGIN
                                  args_list
                                  PARENTHESE_END;


// if statement
if_statement: IF
              PARENTHESE_BEGIN
              (((NOT)? condition) ((AND | OR) (NOT)? condition)*)?
              PARENTHESE_END
              block
              (
              ELSE_IF
              PARENTHESE_BEGIN
              (((NOT)? condition) ((AND | OR) (NOT)? condition)*)?
              PARENTHESE_END
              block
              )?
              (ELSE block)?;

// for loop
for_loop_statement: FOR
                    PARENTHESE_BEGIN
                    (IDENTIFIER ASSIGN (INT_VALUE | DOUBLE_VALUE | EXP_VALUE))? SEMICOLON
                    (((NOT)? condition) ((AND | OR) (NOT)? condition)*)? SEMICOLON
                    (IDENTIFIER (PLUS_PLUS | MINUS_MINUS))?
                    PARENTHESE_END
                    block;

// foreach loop
foreach_loop_statement: FOR
                        PARENTHESE_BEGIN
                        VAR IDENTIFIER IN IDENTIFIER
                        PARENTHESE_END
                        block;

// while loop
while_loop_statement: WHILE
                      PARENTHESE_BEGIN
                      (((NOT)? condition) ((AND | OR) (NOT)? condition)*)?
                      PARENTHESE_END
                      block;

// do while loop
do_while_loop_statement: DO
                         block
                         WHILE
                         PARENTHESE_BEGIN
                         (((NOT)? condition) ((AND | OR) (NOT)? condition)*)?
                         PARENTHESE_END;

// switch/case statement
switch_case_statement: SWITCH
                       PARENTHESE_BEGIN IDENTIFIER PARENTHESE_END
                       BRACE_BEGIN
                       (
                       CASE value COLON
                       statement*
                       (BREAK SEMICOLON)?
                       )+
                       (
                       DEFAULT COLON
                       statement*
                       (BREAK SEMICOLON)?
                       )?
                       BRACE_END;

// class definition
class_definitiion_statement: CLASS
                             IDENTIFIER
                             (EXTENDS IDENTIFIER)?
                             (IMPLEMENTS IDENTIFIER (WITH IDENTIFIER)*)?
                             BRACE_BEGIN
                             class_body
                             BRACE_END;
class_body: (function_definition_statement | property_definition | constructor)*;

constructor: IDENTIFIER
             PARENTHESE_BEGIN
             params_list?
             PARENTHESE_END
             BRACE_BEGIN
             statement*
             BRACE_END;

// function definition
function_definition_statement: data_type IDENTIFIER
                                         PARENTHESE_BEGIN
                                         params_list?
                                         PARENTHESE_END
                                         BRACE_BEGIN
                                         statement*
                                         RETURN (value | IDENTIFIER)? SEMICOLON
                                         BRACE_END;


// property definition ( in class )
property_definition: access_modifier define_var_statement SEMICOLON;

// object instantiation
obj_instant: variable_type IDENTIFIER COLON NEW IDENTIFIER PARENTHESE_BEGIN args_list? PARENTHESE_END;

// exception
try_catch: TRY block
           (
           ON IDENTIFIER (CATCH PARENTHESE_BEGIN IDENTIFIER PARENTHESE_END)? block
           |
           CATCH PARENTHESE_BEGIN IDENTIFIER PARENTHESE_END block
           );

// function ( method ) call
function_call_statement: chaining
                         PARENTHESE_BEGIN
                         args_list?
                         PARENTHESE_END
                         SEMICOLON;

//// change variable value
//change_value_statement: chaining assign_operator operation;

// operations
operation: PARENTHESE_BEGIN operation PARENTHESE_END
           |
           operation STAR_STAR operation*
           |
           TILDE operation
           |
           (PLUS | MINUS) operation
           |
           (PLUS_PLUS | MINUS_MINUS) operation
           |
           operation (STAR | SLASH_SLASH | DIVIDE | MOD) operation
           |
           operation (PLUS | MINUS) operation
           |
           operation (SHIFT_LEFT | SHIFT_RIGHT) operation
           |
           operation (BIT_AND | BIT_OR | BIT_XOR) operation
           |
           operation (EQUAL | NON_EQUAL) operation
           |
           operation (GREATHER_EQUAL | GREATER | LESS_EQUAL | LESS) operation
           |
           NOT operation
           |
           operation (AND | OR) operation
           |
           chaining assign_operator operation
           |
           value
           |
           chaining
           ;

// *************************************
params_list: data_type IDENTIFIER default_value? (COMMA data_type IDENTIFIER default_value?)*;
default_value: ASSIGN value;
args_list: ((value | chaining) (COMMA (value | chaining))*);
condition: BOOLEAN_VALUE | expression;
block: BRACE_BEGIN statement* BRACE_END;
expression: (value | IDENTIFIER) compare_sign (value | IDENTIFIER);
compare_sign: EQUAL | LESS | LESS_EQUAL | GREATER | GREATHER_EQUAL | NON_EQUAL;
access_modifier: PUBLIC | PRIVATE | PROTECTED;
variable_type: VAR | CONST;
data_type: INT | STRING | DOUBLE | BOOLEAN | CHARACTER | FLOAT | VOID;
value: INT_VALUE | BOOLEAN_VALUE | DOUBLE_VALUE | EXP_VALUE | STRING_VALUE;
chaining: IDENTIFIER (DOT IDENTIFIER)*;
assign_operator: ASSIGN | PLUS_ASSING | MULTIPLY_ASSING | MINUS_ASSING | DIVIDE_ASSING;

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
DO              : 'do';
SWITCH          : 'switch';
CASE            : 'case';
DEFAULT         : 'default';
BREAK           : 'break';
CLASS           : 'class';
EXTENDS         : 'extends';
IMPLEMENTS      : 'implements';
WITH            : 'with';
RETURN          : 'return';
TRY             : 'try';
ON              : 'on';
CATCH           : 'catch';

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
EXP_SYMBOL      : 'e';
PLUS            : '+';
MINUS           : '-';
PLUS_PLUS       : '++';
MINUS_MINUS     : '--';
STAR_STAR       : '**';
DIVIDE          : '/';
SLASH_SLASH     : '//';
MOD             : '%';
SHIFT_LEFT      : '<<';
SHIFT_RIGHT     : '>>';
BIT_AND         : '&' ;
BIT_OR          : '|' ;
BIT_XOR         : '^' ;
PLUS_ASSING     : '+=';
MINUS_ASSING    : '-=';
MULTIPLY_ASSING : '*=';
DIVIDE_ASSING   : '/=';
TILDE           : '~';

// compare signs
EQUAL           : '==';
GREATER         : '>';
LESS            : '<';
GREATHER_EQUAL  : '>=';
LESS_EQUAL      : '<=';
NON_EQUAL       : '!=';

// logical operators
AND             : '&&' | 'and';
OR              : '||' | 'or';
NOT             : '!'  | 'not';

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
STRING_VALUE: DOUBLE_QUOTE .*? DOUBLE_QUOTE;
BOOLEAN_VALUE: 'true' | 'false';
INT_VALUE: DIGIT+;
DOUBLE_VALUE: DIGIT+ DECIMAL_PART;
EXP_VALUE: DIGIT? '.' DIGIT+ EXP_PART;
DECIMAL_PART: '.' DIGIT+;
EXP_PART: EXP_SYMBOL (PLUS | MINUS)? DIGIT+;

// variable naming rule
IDENTIFIER: [a-zA-Z$_]+ [a-zA-Z0-9$_]+;

DIGIT: [0-9];