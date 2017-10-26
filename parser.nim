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
        let head = julepList()
        var tail = head
        var next: JulepValue
        if (not (idx < len(tokens))):
            raise newException(InvalidSyntaxError, "Invalid Syntax: Unclosed Paren")
        while (tokens[idx].value != ")"):
            next = julepList(walk(tokens, idx))
            tail.next = next
            tail = next
            if (not (idx < len(tokens))):
                 raise newException(InvalidSyntaxError, "Invalid Syntax: Unclosed Paren")
        inc(idx)
        return rest(head)
    raise newException(InvalidSyntaxError, "Unexpected token: " & current.value)

proc parse*(tokens: seq[Token]): JulepValue =
    let ast = julepList(julepSymbol("do"))
    var tail = ast
    var next: JulepValue
    var idx = 0
    while (idx < len(tokens)):
        next = julepList(walk(tokens, idx))
        tail.next = next
        tail = next
    return ast

proc main() =
    echo "no tests yet"

when isMainModule:
    main()