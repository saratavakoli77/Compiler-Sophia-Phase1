grammar Sophia;

@members {
	String operators = "";

    void print(String obj){
        System.out.print(obj);
    }

    void printEmptyLine(){
        System.out.println("");
    }

    void printOperator(String obj) {
        System.out.println("Operator:" + obj);
    }
}

// parser

sophia:
    classDeclaratiaon*
    EOF;

classDeclaratiaon:
    CLASS IDENTIFIER {print("ClassDec:" + $IDENTIFIER.text);}
    (EXTENDS IDENTIFIER {print("," + $IDENTIFIER.text);})? 
    {printEmptyLine();} LCURLY
    classBody?
    RCURLY;


classBody: 
    oneLineVarDeclaration*
    methodDeclaration*
    constructorDeclaration?
    methodDeclaration*;

oneLineVarDeclaration:
    IDENTIFIER 
    {print("VarDec:" + $IDENTIFIER.text); printEmptyLine();} 
    COLON returnType SEMICOLON;

// different from oneLineVarDeclaration for print
varDeclaration: 
    IDENTIFIER COLON returnType;

constructorDeclaration: 
    DEFENITION IDENTIFIER 
    {print("ConstructorDec:" + $IDENTIFIER.text); printEmptyLine();}
    argumentDeclaration LCURLY
    methodBody
    RCURLY;

methodDeclaration:
    voidMethodDeclaration |
    returnMothodDeclaration;

voidMethodDeclaration:
    DEFENITION VOID IDENTIFIER 
    {print("MethodDec:" + $IDENTIFIER.text); printEmptyLine();}
    argumentDeclaration LCURLY
    methodBody
    RCURLY ;

returnMothodDeclaration: 
    DEFENITION returnType IDENTIFIER 
    {print("MethodDec:" + $IDENTIFIER.text); printEmptyLine();}
    argumentDeclaration LCURLY
    methodBody
    RCURLY ;

argumentDeclaration:
    LPAR (varDeclaration (COMMA varDeclaration)*)? RPAR;


methodBody: 
    oneLineVarDeclaration*
    statement*;

block: multiStatement | statement;

multiStatement:
    LCURLY
        statement*
    RCURLY;

statement:
    forStatement |
    foreachStatment |
    conditionalStatement |
    oneLineStatment;

oneLineStatment:
    oneLine SEMICOLON;

oneLine:
    variableAssignmentStatment |
    ({print("MethodCall"); printEmptyLine();} methodCall) |
    returnStatement | 
    (CONTINUE {print("Control:continue"); printEmptyLine();}) |
    (BREAK {print("Control:break"); printEmptyLine();}) |
    printMethod;

returnStatement:
    {print("Return"); printEmptyLine();}
    RETURN expression?;

forStatement:
    {print("Loop:for"); printEmptyLine();}
    FOR LPAR variableAssignmentStatment? SEMICOLON expression? SEMICOLON variableAssignmentStatment? RPAR
        block;

foreachStatment:
    {print("Loop:foreach"); printEmptyLine();}
    FOREACH LPAR IDENTIFIER IN expression RPAR
        block;

conditionalStatement:
    ifStatment
    elseIfStatement*
    elseStatement?;

ifStatment:
    {print("Conditional:if"); printEmptyLine();}
    IF LPAR expression RPAR
        block;

elseIfStatement:
    {print("Conditional:else"); printEmptyLine();
    print("Conditional:if"); printEmptyLine();}
    ELSE IF LPAR expression RPAR
        block;

elseStatement:
    {print("Conditional:else"); printEmptyLine();}
    ELSE
        block;


//all types, both primitive and user defined
returnType: type | IDENTIFIER;

type: primitive | listDeclaration | fptrDeclaration;

primitive: STRING | BOOLEAN | INT;

listDeclaration:
    LIST LPAR (typeChaining)? RPAR |
    LIST argumentDeclaration |
    LIST LPAR INTEGER_LITERAL SHARP returnType RPAR;

fptrDeclaration:
    FUNCTION LT (typeChaining | VOID) SUB GT (type | VOID) GT;

typeChaining:
    type (COMMA type)*;


classInstantiation:
    NEW (IDENTIFIER argumentPassing);


variableAssignmentStatment:
    logicExpression ASSIGN expression {printOperator($ASSIGN.text);};

expression:
    logicExpression (ASSIGN expression {printOperator($ASSIGN.text);})?;


logicExpression: 
    orLogicExpresion;

orLogicExpresion:
    andLogicExpresion 
    (OR andLogicExpresion {printOperator($OR.text);})*;

andLogicExpresion:
    equalityComparatorExpresion 
    (AND equalityComparatorExpresion {printOperator($AND.text);})*;

equalityComparatorExpresion:
    relationalComparatorExpression 
    (equalityOperator relationalComparatorExpression {printOperator($equalityOperator.text);})*;

relationalComparatorExpression:
    addSubExpression 
    (relationalOperator addSubExpression {printOperator($relationalOperator.text);})*;

addSubExpression:
    multDivideModExpression 
    (addSubOperator multDivideModExpression {printOperator($addSubOperator.text);})*;

multDivideModExpression: 
    unaryPrefixExpression 
    (multDivideModOperator unaryPrefixExpression {printOperator($multDivideModOperator.text);})*;

unaryPrefixExpression:
    (unaryPrefixOperator unaryPrefixExpression {printOperator($unaryPrefixOperator.text);}) | 
    unaryPostfixExpression;

unaryPostfixExpression:
    otherExpression (unaryPostfixOperator {printOperator($unaryPostfixOperator.text);})?;

methodCall:
    otherExpression argumentPassing;

otherExpression:
    (parenthesis |
    classInstantiation |
    literal |
    IDENTIFIER |
    THIS) otherExpressionTemp;

otherExpressionTemp:
    ((DOT IDENTIFIER | LBRACK expression RBRACK | argumentPassing) otherExpressionTemp)?;

parenthesis:
    (LPAR expression RPAR);

literal:
    INTEGER_LITERAL | STRING_LITERAL | BOOL_LITERAL | listDefenition;

equalityOperator:
    EQ | NE;

relationalOperator:
    GT | LT;

addSubOperator:
    ADD | SUB;

multDivideModOperator:
    MUL | DIV | MOD;

unaryPrefixOperator:
    INC | DEC | SUB | NOT;

unaryPostfixOperator:
    INC | DEC;

argumentPassing:
    LPAR expressionChaining? RPAR;

listDefenition:
    LBRACK expressionChaining? RBRACK;

expressionChaining:
    expression (COMMA expression)*;


// biult-in
printMethod:
    ({print("Built-in:print"); printEmptyLine();}
    PRINT LPAR expression RPAR);

// Literals
INTEGER_LITERAL: Digits;

BOOL_LITERAL: TRUE | FALSE;

STRING_LITERAL: '"' (~["\r\n])* '"';

// Keywords

PRINT: 'print';

IF: 'if';
ELSE: 'else';

INT: 'int';
STRING: 'string';
BOOLEAN: 'bool';

FOR: 'for';
FOREACH: 'foreach';
BREAK: 'break';
CONTINUE: 'continue';

TRUE : 'true';
FALSE: 'false';

CLASS: 'class';
NEW: 'new';
NULL: 'null';
EXTENDS: 'extends';
THIS: 'this';
DEFENITION: 'def';
FUNCTION: 'func';
VOID: 'void';
RETURN: 'return';

LIST: 'list';
IN: 'in';


// Operators

// arithmetic

// unary
INC: '++';
DEC: '--';

// binary
ADD: '+';
SUB: '-';
MUL: '*';
DIV: '/';
MOD: '%';



// compartive
EQ: '==';
NE: '!=';
GT: '>';
LT: '<';

// logical
NOT: '!';
AND: '&&';
OR: '||';

// other
ASSIGN: '=';

COLON: ':';

// Separators
SEMICOLON: ';';

DOT: '.';
COMMA: ',';

LPAR: '(';
RPAR: ')';

LBRACK: '[';
RBRACK: ']';

LCURLY: '{';
RCURLY: '}';

SHARP: '#';

// Whitespace and comments
WS: [ \t\r\n]+ -> skip;
// WS: [ \t]+ -> skip;
COMMENT: '//' ~[\r\n]* -> skip;

// Identifiers
IDENTIFIER: Letter LetterOrDigit*;

// Fragment rules
fragment Digit: [0-9];
fragment Digits: Digit+;

fragment Letter: [a-zA-Z_];

fragment LetterOrDigit: Letter | Digit;