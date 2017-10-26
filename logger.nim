from tokenizer import Token, TokenKind
import data
from strutils import indent
from math import round

proc printTokens*(tokens: seq[Token]) =
    for token in tokens:
        echo repr(token)

proc printAst(ast: JulepValue, level: int) =
    if (ast.kind in {jvkLiteral, jvkSymbol}):
        echo indent(ast.contents, level * 2)
    elif (ast.kind == jvkList):
        echo indent(">", level * 2)
        var rest = ast
        while (rest.kind != jvkNil):
            echo indent(repr(rest.value), (level + 1) * 2)
            rest = rest.next

proc printAst*(ast: JulepValue) =
    printAst(ast, 0)

proc printNumber*(x: float) =
    if (round(x) == x):
        echo int(x)
    else:
        echo x

proc printValue*(x: JulepValue) =
    if (x.kind == jvkError): 
        if(x.error == jekDivideByZero):
            echo "Divide by Zero error"
        elif (x.error == jekUnknownSymbol):
            echo "Unknown symbol"
        elif (x.error == jekBadNumber):
            echo "Bad Number"
    if (x.kind == jvkNumber): printNumber(x.number)