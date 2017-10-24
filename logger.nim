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
        for child in ast.children:
            printAst(child, level + 1)

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