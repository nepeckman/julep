from tokenizer import Token, TokenType
from parser import Node, NodeType
from eval import Value, ValueType, ErrorType
from strutils import indent
from math import round

proc printTokens*(tokens: seq[Token]) =
    for token in tokens:
        echo repr(token)

proc printAst(ast: Node, level: int) =
    if (ast.nodeType in {literal, symbol}):
        echo indent(ast.contents, level * 2)
    elif (ast.nodeType == sexpr):
        echo indent(">", level * 2)
        for child in ast.children:
            printAst(child, level + 1)
    else:
        for child in ast.children:
            printAst(child, level)

proc printAst*(ast: Node) =
    printAst(ast, 0)

proc printNumber*(x: float) =
    if (round(x) == x):
        echo int(x)
    else:
        echo x

proc printValue*(x: Value) =
    if (x.valueType == errorValue): 
        if(x.error == divideByZero):
            echo "Divide by Zero error"
        elif (x.error == unknownOp):
            echo "Unknown operator"
        elif (x.error == badNumber):
            echo "Bad Number"
    if (x.valueType == numberValue): printNumber(x.number)