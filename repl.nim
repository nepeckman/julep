import tokenizer
import parser
import logger

proc main() =
    var 
        program = ""
        tokens: seq[Token]
        ast: Node
    while (program != "exit"):
        stdout.write("nimlisp->")
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
        printAst(parse(tokens))

when isMainModule:
    main()