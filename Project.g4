grammar Project;
start: statement*;
statement:
    imports |
    define_variable |
    define_class |
    instantiation |
    loop_statement |
    if_statement |
    switch_case_statement |
    define_function |
    exceptions |
    string_interpolation;

/****************** skip whitespaces ******************/
WS:[ \t\n\r]+ -> skip;

/****************** comments ******************/
COMMENT_TYPE1: '/*' .* '*/';
COMMENT_TYPE2: '//' ~[\r\n]* -> skip;

/****************** imports ******************/
