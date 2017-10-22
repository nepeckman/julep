from parser import Node, NodeType
from parseutils import parseFloat

type ValueType* = enum
    stringValue,
    numberValue,
    functionValue

type Value* = ref object of RootObj
    number*: float

type EvaluationError* = object of Exception

proc evalOperator(x: float, op: string, y: float): float =
    if (op == "+"): result = x + y
    if (op == "-"): result = x - y
    if (op == "*"): result = x * y
    if (op == "/"): result = x / y
    return

proc eval*(ast: Node): Value =
    result = Value()
    if (ast.nodeType == literal):
        discard parseFloat(ast.contents, result.number)
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