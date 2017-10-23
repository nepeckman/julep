from parser import Node, NodeType
from parseutils import parseFloat

type ValueType* = enum
    numberValue,
    builtinValue,
    sexprValue,
    errorValue

type ErrorType* = enum
    divideByZero,
    unknownOp,
    badNumber

type Value* = ref object of RootObj
    valueType*: ValueType
    number*: float
    builtinFunction*: proc (args: seq[Value]): Value
    sexpr*: seq[Value]
    error*: ErrorType

type EvaluationError* = object of Exception

proc lAdd(args: seq[Value]): Value =
    result = Value(valueType: numberValue, number: args[0].number)
    for arg in args[1..^1]:
        result.number = result.number + arg.number

proc lSub(args: seq[Value]): Value =
    result = Value(valueType: numberValue, number: args[0].number)
    for arg in args[1..^1]:
        result.number = result.number - arg.number

proc lMult(args: seq[Value]): Value =
    result = Value(valueType: numberValue, number: args[0].number)
    for arg in args[1..^1]:
        result.number = result.number * arg.number

proc lDiv(args: seq[Value]): Value =
    result = Value(valueType: numberValue, number: args[0].number)
    for arg in args[1..^1]:
        if (arg.number == 0):
            result = Value(valueType: errorValue, error: divideByZero)
            break
        result.number = result.number / arg.number

proc findBuiltinFn(name: string): proc (args: seq[Value]): Value =
    if (name == "+"): return lAdd
    if (name == "-"): return lSub
    if (name == "*"): return lMult
    if (name == "/"): return lDiv

proc eval*(ast: Node): Value =
    result = Value()
    if (ast.nodeType == literal):
        result.valueType = numberValue
        discard parseFloat(ast.contents, result.number)
    elif (ast.nodeType == symbol):
        result.valueType = builtinValue
        result.builtinFunction = findBuiltinFn(ast.contents)
    elif (ast.nodeType == sexpr):
        var fn = eval(ast.children[0])
        var args: seq[Value] = @[] 
        for child in ast.children[1..^1]:
            var arg = eval(child)
            if (arg.valueType == errorValue): return arg
            args.add(arg)
        result = fn.builtinFunction(args)
    elif (ast.nodeType == program):
        for child in ast.children:
            result = eval(child)
    else:
        raise newException(EvaluationError, "Unevaluatable node: " & $ast.nodeType)
    return