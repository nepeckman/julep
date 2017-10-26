type
    JulepValueKind* = enum
        jvkList,
        jvkLiteral,
        jvkSymbol,
        jvkNumber,
        jvkString,
        jvkBuiltin,
        jvkFunction,
        jvkError,
        jvkNil

    JulepErrorKind* = enum
        jekDivideByZero,
        jekBadNumber
        jekUnknownSymbol
    
    JulepBuiltin* = proc (args: seq[JulepValue]): JulepValue

    JulepValue* = ref JulepValueObj
    JulepValueObj* = object
        case kind*: JulepValueKind
        of jvkList:
            value*: JulepValue
            next*: JulepValue
        of jvkLiteral, jvkSymbol: contents*: string
        of jvkNumber: number*: float
        of jvkString: string*: string
        of jvkBuiltin: fn*: JulepBuiltin
        of jvkFunction: 
            args*: seq[JulepValue]
            body*: JulepValue
        of jvkError: error*: JulepErrorKind
        of jvkNil: nil

proc julepNil*(): JulepValue =
    result = JulepValue(kind: jvkNil)

proc julepList*(value: JulepValue = julepNil(), next: JulepValue = julepNil()): JulepValue =
    result = JulepValue(kind: jvkList, value: value, next: next)

proc julepLiteral*(contents: string): JulepValue =
    result = JulepValue(kind: jvkLiteral, contents: contents)

proc julepSymbol*(name: string): JulepValue =
    result = JulepValue(kind: jvkSymbol, contents: name)

proc julepNumber*(number: float): JulepValue =
    result = JulepValue(kind: jvkNumber, number: number)

proc julepString*(str: string): JulepValue =
    result = JulepValue(kind: jvkString, string: str) 

proc julepBuiltin*(fn: JulepBuiltin): JulepValue =
    result = JulepValue(kind: jvkBuiltin, fn: fn)

proc julepError*(error: JulepErrorKind): JulepValue =
    result = JulepValue(kind: jvkError, error: error)

proc first*(list: JulepValue): JulepValue =
    result = list.value

proc conj*(list: JulepValue, value: JulepValue): JulepValue =
    result = julepList(value, list)

proc rest*(list: JulepValue): JulepValue =
    result = list.next