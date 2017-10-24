import data
from parseutils import parseFloat

type EvaluationError* = object of Exception

proc eval*(ast: JulepValue): JulepValue

proc jAdd(args: seq[JulepValue]): JulepValue =
    result = julepNumber(args[0].number)
    for arg in args[1..^1]:
        result.number = result.number + arg.number

proc jSub(args: seq[JulepValue]): JulepValue =
    result = julepNumber(args[0].number)
    for arg in args[1..^1]:
        result.number = result.number - arg.number

proc jMult(args: seq[JulepValue]): JulepValue =
    result = julepNumber(args[0].number)
    for arg in args[1..^1]:
        result.number = result.number * arg.number

proc jDiv(args: seq[JulepValue]): JulepValue =
    result = julepNumber(args[0].number)
    for arg in args[1..^1]:
        if (arg.number == 0):
            result = julepError(jekDivideByZero)
            break
        result.number = result.number / arg.number

proc jDo(args: seq[JulepValue]): JulepValue =
    for arg in args:
        result = eval(arg)

proc findBuiltinFn(name: string): JulepBuiltin =  
    if (name == "+"): return jAdd
    if (name == "-"): return jSub
    if (name == "*"): return jMult
    if (name == "/"): return jDiv
    if (name == "do"): return jDo

proc eval*(ast: JulepValue): JulepValue =
    if (ast.kind == jvkLiteral):
        var number: float
        discard parseFloat(ast.contents, number)
        result = julepNumber(number)
    elif (ast.kind == jvkSymbol):
        result = julepBuiltin(findBuiltinFn(ast.contents))
    elif (ast.kind == jvkList):
        var jFunc = eval(ast.children[0])
        var args: seq[JulepValue] = @[] 
        for child in ast.children[1..^1]:
            var arg = eval(child)
            if (arg.kind == jvkError): return arg
            args.add(arg)
        result = jFunc.fn(args)
    elif (ast.kind in {jvkFunction, jvkNumber, jvkString, jvkBuiltin}):
        result = ast
    else:
        raise newException(EvaluationError, "Unevaluatable node: " & $ast.kind)
    return