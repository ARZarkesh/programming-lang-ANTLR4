grammar Project;
program: statement*;
statement:
    import_statement;

/****************** skip whitespaces ******************/
WHITE_SPACE:[ \t\n\r]+ -> skip;

/****************** comments ******************/
COMMENT_TYPE1: '/*' .+? '*/';
COMMENT_TYPE2: '//' ~[\r\n]* -> skip;

/****************** imports ******************/
import_statement: 'import' library_name ';' ;
library_name: NAME;

// Lexer Rules
NAME: (UPPERCASE_LETTERS+ | LOWERCASE_LETTERS+ | DIGITS+)+;
UPPERCASE_LETTERS: [A-Z];
LOWERCASE_LETTERS: [a-z];
DIGITS: [0-9];
