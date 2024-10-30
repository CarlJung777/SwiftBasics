//#####   宏 (Macros)   #####//

// 宏用于在编译时生成代码。
// 编译过程中，Swift 会在常规构建代码之前，展开代码中的任何宏。
// 宏展开始终是一个增量操作：宏添加新代码，但永远不会删除或修改现有代码。
// 如果宏在展开时遇到错误，编译器会将其视为编译错误。

// Swift 提供了两种类型的宏：
// 独立宏（Freestanding macros）：出现在代码中，不附属于任何声明。
// 附加宏（Attached macros）：修饰其附属的声明。

// （Freestanding macros）

// 要调用独立宏，可以在其名称前加上井号 (#)，并在名称后面的括号中写入任何参数
func myFunction() {
    print("Currently running \(#function)")
    #warning("Something's wrong")
}
// 在第一行，#function 调用了 Swift 标准库中的 function() 宏。
// 在第二行，#warning 调用了标准库中的 warning(_:) 宏，用于生成自定义的编译时警告。


// （Attached macros）
// 要调用附加宏，可以在名称前加上 @ 符号，并在名称后面的括号中写入任何参数

// 没有使用宏的代码
// SundaeToppings 选项集中每个选项都包含对初始化函数的调用，这种做法重复且需要手动处理。
struct SundaeToppings: OptionSet {
    let rawValue: Int
    static let nuts = SundaeToppings(rawValue: 1 << 0)
    static let cherry = SundaeToppings(rawValue: 1 << 1)
    static let fudge = SundaeToppings(rawValue: 1 << 2)
}

// 使用宏的版本
@OptionSet<Int>
struct SundaeToppings {
    private enum Options: Int {
        case nuts
        case cherry
        case fudge
    }
}


// 宏展开后的代码
// 只有特意请求 Swift 显示宏展开时才会看到
struct SundaeToppings {
    private enum Options: Int {
        case nuts
        case cherry
        case fudge
    }

    typealias RawValue = Int
    var rawValue: RawValue
    init() { self.rawValue = 0 }
    init(rawValue: RawValue) { self.rawValue = rawValue }
    static let nuts: Self = Self(rawValue: 1 << Options.nuts.rawValue)
    static let cherry: Self = Self(rawValue: 1 << Options.cherry.rawValue)
    static let fudge: Self = Self(rawValue: 1 << Options.fudge.rawValue)
}
extension SundaeToppings: OptionSet { }




//   宏声明   Macro Declarations

// 对于宏而言，声明和实现是分开的。
// 宏的声明包含其名称、参数、使用位置和生成的代码类型，
// 而宏的实现包含生成 Swift 代码以展开宏的代码。
// 宏总是声明为 public 的
public macro OptionSet<RawType>() =
        #externalMacro(module: "SwiftMacros", type: "OptionSetMacro")

@attached(member)
@attached(extension, conformances: OptionSet)
public macro OptionSet<RawType>() =
        #externalMacro(module: "SwiftMacros", type: "OptionSetMacro")



//   宏展开    Macro Expansion

//  Swift 中宏的展开过程如下：
// 编译器读取代码，并在内存中生成代码的语法表示。
// 编译器将部分语法表示传递给宏的实现，宏会对该部分进行展开。
// 编译器将宏调用替换为展开后的内容。
// 编译器继续使用展开后的源码进行编译。



//   实现宏   Implementing a Macro
// 要实现一个宏，需创建两个组件：一个执行宏展开的类型，以及一个将宏声明为 API 的库。



//  Developing and Debugging Macros
// 宏非常适合使用测试进行开发：
// 它们将一个 AST 转换为另一个 AST，而不依赖于任何外部状态，也不会对任何外部状态进行更改。
// 此外，还可以从字符串字面量创建语法节点，这简化了设置测试输入的过程。
// 还可以读取 AST 的 description 属性，以获得一个字符串来与预期值进行比较。



import Foundation

// 使用 #file、#function 和 #line 宏
func logMessage(message: String, file: String = #file, function: String = #function, line: Int = #line) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timestamp = dateFormatter.string(from: Date())
    
    print("[\(timestamp)] [\(file):\(line)] \(function) - \(message)")
}

// 使用 #available 宏进行版本检查
@available(iOS 14.0, *)
func useNewFeature() {
    logMessage(message: "使用了 iOS 14 新特性")
}

// 使用内置宏的示例
func main() {
    logMessage(message: "这是一个测试消息")
    
    if #available(iOS 14.0, *) {
        useNewFeature()
    } else {
        logMessage(message: "未能使用新特性，当前版本不支持")
    }
}

main()
