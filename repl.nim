import tokenizer
import data
import parser
import eval
import logger
import rdstdin

proc main() =
    var 
        program = ""
        tokens: seq[Token]
        ast: JulepValue
        value: JulepValue
    while (program != "exit"):
        program = readLineFromStdin("julep-> ")
        try:
            tokens = tokenize(program)
        except UnknownTokenError:
            echo getCurrentExceptionMsg()
            continue
        try:
            ast = parse(tokens)
        except InvalidSyntaxError:
            echo getCurrentExceptionMsg()
            continue
        try:
            value = eval(ast)
        except EvaluationError:
            echo getCurrentExceptionMsg()
            continue
        printValue(value)

when isMainModule:
    main()