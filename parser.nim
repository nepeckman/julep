import tokenizer
import data

type InvalidSyntaxError* = object of Exception

proc walk(tokens: seq[Token], idx: var int): JulepValue =
    let current = tokens[idx]
    inc(idx)
    if (current.kind in {tkNumber, tkString}):
        return julepLiteral(current.value)
    if (current.kind == tkSymbol):
        return julepSymbol(current.value)
    if (current.kind == tkParen and current.value == "("):
        let sexpr = julepList()
        if (not (idx < len(tokens))):
            raise newException(InvalidSyntaxError, "Invalid Syntax: Unclosed Paren")
        while (tokens[idx].value != ")"):
            sexpr.children.add(walk(tokens, idx))
            if (not (idx < len(tokens))):
                 raise newException(InvalidSyntaxError, "Invalid Syntax: Unclosed Paren")
        inc(idx)
        return sexpr
    raise newException(InvalidSyntaxError, "Unexpected token: " & current.value)

proc parse*(tokens: seq[Token]): JulepValue =
    let ast = julepList(@[julepSymbol("do")])
    var idx = 0;
    while (idx < len(tokens)):
        ast.children.add(walk(tokens, idx))
    return ast

proc main() =
    echo "no tests yet"

when isMainModule:
    main()