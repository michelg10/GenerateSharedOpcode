import Foundation
enum OpCode: CaseIterable {
    case OP_return
    case OP_true
    case OP_false
    case OP_pop
    case OP_pop_n // [1bu count]
    case OP_loadEmbeddedLongConstant // [8bu value], loads directly the 64-bit value from the next operand
    case OP_loadConstantFromTable // [1bu index], loads constant of `index` from the table
    case OP_LONG_loadConstantFromTable // [3bu index], loads constant of `index` from the table
    case OP_addInt
    case OP_addDouble
    case OP_addString
    case OP_minusInt
    case OP_minusDouble
    case OP_multiplyInt
    case OP_multiplyDouble
    case OP_divideInt
    case OP_divideDouble
    case OP_intDivideInt
    case OP_intDivideDouble
    case OP_negateInt
    case OP_negateDouble
    case OP_not
}
enum VMType: CaseIterable {
    case Int
    case Double
    case Boolean
    case AnyType
    case Array
}

func writeEnumToSwift(filePath: String, name: String, cases: [String]) {
    var result = "enum \(name): Int {"
    for i in cases {
        result+="\n    case \(i)"
    }
    result+="\n}"
    do {
        try result.write(to: .init(fileURLWithPath: filePath), atomically: false, encoding: .utf8)
    } catch {
        print(error)
    }
}

func writeEnumToCpp(filePath: String, name: String, cases: [String]) {
    var result = "enum \(name) {"
    for i in 0..<cases.count {
        result+="\n    \(cases[i])=\(i),"
    }
    result+="\n};"
    do {
        try result.write(to: .init(fileURLWithPath: filePath), atomically: false, encoding: .utf8)
    } catch {
        print(error)
    }
}

func writeSharedEnum(filePathSwift: String, filePathCpp: String, name: String, cases: [String]) {
    writeEnumToSwift(filePath: filePathSwift, name: name, cases: cases)
    writeEnumToCpp(filePath: filePathCpp, name: name, cases: cases)
}

let dir = "/Users/michel/Desktop/Quasicode/Interpreter/Interpreter/"
writeSharedEnum(filePathSwift: dir+"Compiler/OpCode.swift", filePathCpp: dir+"VM/OpCode.h", name: "OpCode", cases: OpCode.allCases.map({ aCase in
    String(describing: aCase)
}))
writeSharedEnum(filePathSwift: dir+"Compiler/VMType.swift", filePathCpp: dir+"VM/VMType.h", name: "VMType", cases: VMType.allCases.map({ aCase in
    String(describing: aCase)
}))
