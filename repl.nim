import tokenizer
import parser
import eval
import logger

proc main() =
    var 
        program = ""
        tokens: seq[Token]
        ast: Node
        value: Value
    while (program != "exit"):
        stdout.write("julep->")
        program = readLine(stdin)
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