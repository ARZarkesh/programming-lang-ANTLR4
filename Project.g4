grammar Project;
program: statement*;
statement: import_statement;

/****************** skip whitespaces ******************/
WHITE_SPACE:[ \t\n\r]+ -> skip;

/****************** comments ******************/
COMMENT_TYPE1: '/*' .+? '*/';
COMMENT_TYPE2: '//' ~[\r\n]* -> skip;

/****************** imports ******************/
import_statement:
    'import' library_name('.'library_name)* ';'                     | // import lib_name
    'from' library_name 'import' library_name(','library_name)* ';' | // import lib 1 and lib 2 and ...
    'from' library_name 'import' library_name '=>' NAME ';'         | // import lib_name as something
    'from' library_name 'import' '*' ';';                             // import all from lib_name
library_name: NAME;

// Lexer Rules
NAME: (UPPERCASE_LETTERS+ | LOWERCASE_LETTERS+ | DIGITS+)+;
UPPERCASE_LETTERS: [A-Z];
LOWERCASE_LETTERS: [a-z];
DIGITS: [0-9];
