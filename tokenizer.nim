from re import nil
from parseutils import nil

type
    TokenType* = enum
        parenToken
        numberToken
        stringToken
        symbolToken
    Token* = ref object of RootObj
        tokenType*: TokenType
        value*: string
    UnknownTokenError* = object of Exception

let sexprChars: set[char] = {'(', ')'}
let whitespaceRe= re.re(r"\s") 
let numberChars: set[char] = {'0'..'9'}
let symbolChars: set[char] = {'a'..'z', 'A'..'Z', '0'..'9', '+', '-', '*', '/'}

proc tokenize*(program: string): seq[Token] =
    var tokens: seq[Token] = @[]
    var idx = 0
    while (idx < len(program)):
        let current = program[idx]
        if (current in sexprChars):
            inc(idx)
            tokens.add(Token(tokenType: parenToken, value: $current))
            continue
        if (re.match($current, whitespaceRe)):
            inc(idx, parseutils.skipWhitespace(program, idx))
            continue
        var value: string
        if (current in numberChars):
            inc(idx, parseutils.parseWhile(program, value, numberChars, idx))
            tokens.add(Token(tokenType: numberToken, value: value))
            continue
        if (current == '"'):
            inc(idx)
            inc(idx, parseutils.parseUntil(program, value, '"', idx))
            inc(idx)
            tokens.add(Token(tokenType: stringToken, value: value))
            continue
        if (current in symbolChars):
            inc(idx, parseutils.parseWhile(program, value, symbolChars, idx))
            tokens.add(Token(tokenType: symbolToken, value: value))
            continue
        raise newException(UnknownTokenError, "Unknown Token: " & current)
    result = tokens

proc main() =
    echo "no tests yet"

when isMainModule:
    main()