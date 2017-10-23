from parser import Node, NodeType
from parseutils import parseFloat

type ValueType* = enum
    numberValue,
    symbolValue,
    sexprValue,
    errorValue

type ErrorType* = enum
    divideByZero,
    unknownOp,
    badNumber

type Value* = ref object of RootObj
    valueType*: ValueType
    number*: float
    symbol*: string
    sexpr*: seq[Value]
    error*: ErrorType

type EvaluationError* = object of Exception

proc evalOperator(x: Value, op: string, y: Value): Value =
    if (x.valueType == errorValue): return x
    if (y.valueType == errorValue): return y
    if (op == "+"): return Value(number: x.number + y.number)
    if (op == "-"): return Value(number: x.number - y.number)
    if (op == "*"): return Value(number: x.number * y.number)
    if (op == "/"):
        if (y.number == 0): return Value(valueType: errorValue, error: divideByZero)
        else: return Value(number: x.number / y.number)
    return Value(valueType: errorValue, error: unknownOp)

proc eval*(ast: Node): Value =
    result = Value()
    if (ast.nodeType == literal):
        discard parseFloat(ast.contents, result.number)
    elif (ast.nodeType == sexpr):
        var op = ast.children[0].contents
        result = eval(ast.children[1])
        for child in ast.children[2..^1]:
            result = evalOperator(result, op, eval(child))
    elif (ast.nodeType == program):
        for child in ast.children:
            result = eval(child)
    else:
        raise newException(EvaluationError, "Unevaluatable node: " & $ast.nodeType)
    return