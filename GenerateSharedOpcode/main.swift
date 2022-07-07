import Foundation
enum OpCode: CaseIterable {
    case loadLongConstant // loads directly the 64-bit value from the next operand
    case loadConstantFromTable // has an extra operand
    case addInt
    case addDouble
    case addAny
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
