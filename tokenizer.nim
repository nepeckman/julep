from re import nil
from parseutils import nil

type
    TokenKind* = enum
        tkParen
        tkNumber
        tkString
        tkSymbol
    Token* = ref object of RootObj
        kind*: TokenKind
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
            tokens.add(Token(kind: tkParen, value: $current))
            continue
        if (re.match($current, whitespaceRe)):
            inc(idx, parseutils.skipWhitespace(program, idx))
            continue
        var value: string
        if (current in numberChars):
            inc(idx, parseutils.parseWhile(program, value, numberChars, idx))
            tokens.add(Token(kind: tkNumber, value: value))
            continue
        if (current == '"'):
            inc(idx)
            inc(idx, parseutils.parseUntil(program, value, '"', idx))
            inc(idx)
            tokens.add(Token(kind: tkString, value: value))
            continue
        if (current in symbolChars):
            inc(idx, parseutils.parseWhile(program, value, symbolChars, idx))
            tokens.add(Token(kind: tkSymbol, value: value))
            continue
        raise newException(UnknownTokenError, "Unknown Token: " & current)
    result = tokens

proc main() =
    echo "no tests yet"

when isMainModule:
    main()