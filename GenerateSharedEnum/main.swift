import Foundation
enum OpCode: CaseIterable {
    // GENERAL
    case OP_return
    case OP_true
    case OP_false
    case OP_pop
    case OP_pop_n // [1bu count]
    case OP_popExplicitlyTypedValue
    case OP_loadEmbeddedByteConstant // [1bu value], loads directly the 8-bit value from the next operand
    case OP_loadEmbeddedLongConstant // [8bu value], loads directly the 64-bit value from the next operand
    case OP_loadEmbeddedExplicitlyTypedConstant // [16b value], loads directly the 2-byte value from the next operand
    case OP_loadConstantFromTable // [1bu index], loads constant of `index` from the table
    case OP_LONG_loadConstantFromTable // [3bu index], loads constant of `index` from the table
    // UNARY OPERATORS
    case OP_negateInt
    case OP_negateDouble
    case OP_notBool
    // BINARY OPERATORS
    case OP_greaterInt
    case OP_greaterDouble
    case OP_greaterString
    case OP_greaterOrEqualInt
    case OP_greaterOrEqualDouble
    case OP_greaterOrEqualString
    case OP_lessInt
    case OP_lessDouble
    case OP_lessString
    case OP_lessOrEqualInt
    case OP_lessOrEqualDouble
    case OP_lessOrEqualString
    case OP_equalEqualInt
    case OP_equalEqualDouble
    case OP_equalEqualString
    case OP_equalEqualBool
    case OP_notEqualInt
    case OP_notEqualDouble
    case OP_notEqualString
    case OP_notEqualBool
    case OP_minusInt
    case OP_minusDouble
    case OP_divideInt
    case OP_divideDouble
    case OP_multiplyInt
    case OP_multiplyDouble
    case OP_intDivideInt
    case OP_intDivideDouble
    case OP_modInt
    case OP_addInt
    case OP_addDouble
    case OP_addString
    // LOGICAL OPERATORS
    case OP_orBool
    case OP_andBool
    // OUTPUT
    case OP_outputInt
    case OP_outputDouble
    case OP_outputBoolean
    case OP_outputString
    case OP_outputArray
    case OP_outputAny
    case OP_outputClass
    case OP_outputVoid
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
    var ifdefName = String(filePath[filePath.index(filePath.lastIndex(of: "/")!, offsetBy: 1)...])
    ifdefName = ifdefName.lowercased()
    ifdefName = ifdefName.replacingOccurrences(of: ".", with: "_")
    
    var result = "#ifndef \(ifdefName)\n#define \(ifdefName)\n\nenum \(name) {"
    for i in 0..<cases.count {
        result+="\n    \(cases[i])=\(i),"
    }
    result+="\n};\n\n#endif /* \(ifdefName) */"
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
