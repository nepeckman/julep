from parser import Node, NodeType
from parseutils import parseInt

type ValueType* = enum
    stringValue,
    numberValue,
    functionValue

type Value* = ref object of RootObj
    number*: int

type EvaluationError* = object of Exception

proc evalOperator(x: int, op: string, y: int): int =
    if (op == "+"): result = x + y
    if (op == "-"): result = x - y
    if (op == "*"): result = x * y
    return

proc eval*(ast: Node): Value =
    result = Value()
    if (ast.nodeType == literal):
        discard parseInt(ast.contents, result.number)
    elif (ast.nodeType == sexpr):
        var op = ast.children[0].contents
        var x = eval(ast.children[1])
        result.number = x.number
        for child in ast.children[2..^1]:
            result.number = evalOperator(result.number, op, eval(child).number)
    elif (ast.nodeType == program):
        for child in ast.children:
            result = eval(child)
    else:
        raise newException(EvaluationError, "Unevaluatable node: " & $ast.nodeType)
    return