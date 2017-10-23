import tokenizer

type NodeType* = enum
    program,
    sexpr,
    literal,
    symbol

type Node* = ref object of RootObj
    nodeType*: NodeType
    children*: seq[Node]
    contents*: string

type InvalidSyntaxError* = object of Exception

proc walk(tokens: seq[Token], idx: var int): Node =
    let current = tokens[idx]
    inc(idx)
    if (current.tokenType in {numberToken, stringToken}):
        return Node(nodeType: literal, children: nil, contents: current.value)
    if (current.tokenType == symbolToken):
        return Node(nodeType: symbol, children: nil, contents: current.value)
    if (current.tokenType == parenToken and current.value == "("):
        let sexprNode = Node(nodeType: sexpr, children: @[], contents: nil)
        if (not (idx < len(tokens))):
            raise newException(InvalidSyntaxError, "Invalid Syntax: Unclosed Paren")
        while (tokens[idx].value != ")"):
            sexprNode.children.add(walk(tokens, idx))
            if (not (idx < len(tokens))):
                 raise newException(InvalidSyntaxError, "Invalid Syntax: Unclosed Paren")
        inc(idx)
        return sexprNode
    raise newException(InvalidSyntaxError, "Unexpected token: " & current.value)

proc parse*(tokens: seq[Token]): Node =
    let ast = Node(nodeType: program, children: @[], contents: nil)
    var idx = 0;
    while (idx < len(tokens)):
        ast.children.add(walk(tokens, idx))
    return ast

proc main() =
    echo "no tests yet"

when isMainModule:
    main()