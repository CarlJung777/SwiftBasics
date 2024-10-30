//#####   The Basics   #####//


// Constants and Variables

// Declaring Constants and Variables

// Type Annotations

// Naming Constants and Variables
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"

// Printing Constants and Variables

// Comments

// Semicolons

// Integers

// Integer Bounds
let minValue = UInt8.min  // minValue is equal to 0, and is of type UInt8
let maxValue = UInt8.max  // maxValue is equal to 255, and is of type UInt8

// Int（有符号整数）
// 在 32 位平台上，Int 等价于 Int32。
// 在 64 位平台上，Int 等价于 Int64。
// Int 可以存储的值范围在 -2,147,483,648 到 2,147,483,647 之间。 

// UInt（无符号整数）
// 在 32 位平台上，UInt 等价于 UInt32。
// 在 64 位平台上，UInt 等价于 UInt64。
// 只有在确实需要无符号整数类型的情况下，才应使用 UInt
//（使用 Int 更为推荐，即使你知道要存储的值都是非负的）
// 避免类型转换：统一使用 Int 避免在不同整数类型之间进行转换。
// 类型推断：使用 Int 与 Swift 的类型安全性和类型推断相匹配，降低代码出错的风险。

// Floating-Point Numbers 浮点数 
// Double
// 表示一个 64 位的浮点数。
// 精度：至少可以精确到 15 位小数。
// 适用范围：适合需要高精度的计算，比如科学计算、金融应用等。

// Float
// 表示一个 32 位的浮点数。
// 精度：精确度可能低至 6 位小数。
// 适用范围：适合内存敏感的应用或对精度要求不高的场景，例如游戏开发中的简单计算。

// Type Safety and Type Inference

// Numeric Literals 数字字面量
let decimalInteger = 17 // 十进制没有前缀
let binaryInteger = 0b10001  // 二进制以 0b 为前缀    17 in binary notation
let octalInteger = 0o21      // 八进制以 0o 为前缀    17 in octal notation
let hexadecimalInteger = 0x11 // 十六进制以 0x 为前缀  17 in hexadecimal notation

// 数字字面量的格式化 
let paddedDouble = 000123.456   // 实际值为 123.456
let oneMillion = 1_000_000       // 实际值为 1000000
let justOverOneMillion = 1_000_000.000_000_1 // 实际值为 1000000.0000001


// Numeric Type Conversion 数字类型转换
// 整数转换 (Integer Conversion) 
// Int8：可以存储范围从 -128 到 127 的整数。
// UInt8：可以存储范围从 0 到 255 的整数。
// 尝试将一个超出某个整数类型范围的值赋给该类型的常量或变量，编译器会报错

// 显式的数字类型转换
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)  // 转换后相加

// 整数与浮点数的转换
let three = 3
let pointOneFourOneFiveNine = 0.14159
let pi = Double(three) + pointOneFourOneFiveNine  // three 被转换为 Double

let integerPi = Int(pi)  // pi 被转换为 Int

let sum = 3 + 0.14159  // 可以直接相加，因为数字字面量在评估时会被推断出类型



// 类型别名 (Type Aliases) 
// typealias AudioSample = UInt16
typealias Velocity = Float  // 将 Float 类型定义为 Velocity 的别名

var speed: Velocity = 88.5  // 使用别名来定义速度
print("The speed is \(speed) meters per second.")  // 输出：The speed is 88.5 meters per second.


// Booleans

// Tuples 元组

// Optionals 可选值
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
// convertedNumber 的类型是 "optional Int"
// 字符串不可转换的情况下就返回 nil

// ### nil ### //
var serverResponseCode: Int? = 404
// serverResponseCode 现在包含实际的 Int 值 404
serverResponseCode = nil
// serverResponseCode 现在没有值

var surveyAnswer: String?
// surveyAnswer 自动设置为 nil

// 在访问可选值时，你的代码必须处理 nil 和非 nil 两种情况。
// 
// 跳过处理：当值为 nil 时，可以选择不执行操作。
// 传播 nil 值：可以通过返回 nil 或使用可选链（?. 运算符）来实现。
// 提供默认值：使用 ?? 运算符来提供一个后备值。
// 强制解包：使用 ! 运算符停止程序执行，如果值为 nil，程序将崩溃。



// 可选绑定 (Optional Binding)
// 可选绑定是一种用于检查可选值是否包含值的机制。
// 如果可选值存在，它会将该值解包并存储在一个临时常量或变量中。
if let constantName = someOptional {
    // 代码块
}
// someOptional包含一个值的话，就会将值传递给constantName
// 并执行代码块


// 使用可选绑定替代强制解包（forced unwrapping）
let ppossibleNumber = "123"
if let actualNumber = Int(ppossibleNumber) {
    print("The string \"\(ppossibleNumber)\" has an integer value of \(actualNumber)")
} else {
    print("The string \"\(ppossibleNumber)\" couldn't be converted to an integer")
}
// 输出: The string "123" has an integer value of 123

// 不需要在访问可选值之后再次引用原始的可选常量或变量，可以使用相同的名称来声明新的常量或变量
let myNumber = Int(possibleNumber) // 这是一个可选整数
if let myNumber = myNumber {
    // 这里 myNumber 是一个非可选整数
    print("My number is \(myNumber)")
}
// 输出: My number is 123


// 一种简写方式，可以直接写出可选常量的名称
// 隐式地使用了与可选值相同的名称
if let myNumber {
    print("My number is \(myNumber)")
}
// 输出: My number is 123

//  使用变量与可选绑定 这种情况使用 var
if var myNumber = myNumber {
    // myNumber 是一个可变的整数
    myNumber += 1 // 对 myNumber 进行修改
    print("My updated number is \(myNumber)")
}

// 多个可选绑定
// 多个条件通过可选绑定和比较运算符组合在一起，只有当所有条件都为 true 时，才会执行代码块
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
// 输出: 4 < 42 < 100


// 使用 if 语句中的可选绑定创建的常量和变量仅在 if 语句的代码块中有效
// 相比之下，使用 guard 语句创建的常量和变量在 guard 语句之后的代码中也是可用的。


// Providing a Fallback Value  提供后备值
let name: String? = nil
let greeting = "Hello, " + (name ?? "friend") + "!"
print(greeting)
// 输出: Hello, friend!
// 使用 ?? 操作符来检查 name 是否有值
// 这里 name 是 nil，所以使用了默认值 friend

// Force Unwrapping 强制解包


// Implicitly Unwrapped Optionals  隐式解包可选型
// 通过在类型名后添加感叹号 (!) 来定义，而不是在可选名后添加问号 (?)
// 隐式解包可选型是 Swift 中的一种特殊类型的可选值
// 一个隐式解包可选型的字符串可以写成
let aassumedString: String! = "An implicitly unwrapped optional string."


let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // 需要显式解包

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString // 自动解包

// 使用与普通可选型相同的方式检查隐式解包可选型的值
if assumedString != nil {
    print(assumedString!) // 打印出值
}
// 输出: An implicitly unwrapped optional string.


// 使用可选绑定来同时检查和解包隐式解包可选型的值
if let definiteString = assumedString {
    print(definiteString) // 打印出值
}
// 输出: An implicitly unwrapped optional string.



// 错误处理 (Error Handling)
// Swift 会自动将错误从当前作用域传播到可以处理它们的地方，
// 直到它们被 catch 子句处理。
func canThrowAnError() throws {
    // 这个函数可能会抛出错误
}


do {
    try canThrowAnError()
    // 如果没有抛出错误，将继续执行
} catch {
    // 如果抛出错误，进入这里
}

/// 例子例子例子例子例子例子例子例子 ///
// 定义一个错误类型
enum DivisionError: Error {
    case divisionByZero
}

// 定义一个执行除法的函数
func divide(_ numerator: Int, by denominator: Int) throws -> Double {
    if denominator == 0 {
        throw DivisionError.divisionByZero // 抛出错误
    }
    return Double(numerator) / Double(denominator) // 返回结果
}

// 使用 do-catch 处理错误
do {
    let result = try divide(10, by: 2) // 正常除法
    print("Result: \(result)") // 打印结果
} catch DivisionError.divisionByZero {
    print("Error: Division by zero is not allowed.") // 处理除以零的错误
} catch {
    print("An unexpected error occurred: \(error).") // 处理其他错误
}

// 尝试一个会抛出错误的情况
do {
    let result = try divide(10, by: 0) // 试图除以零
    print("Result: \(result)") // 不会执行
} catch DivisionError.divisionByZero {
    print("Error: Division by zero is not allowed.") // 捕获并处理错误
} catch {
    print("An unexpected error occurred: \(error).") // 处理其他错误
}
/// 例子例子例子例子例子例子例子例子 ///


// 断言（Assertions）和前置条件（Preconditions）
// 断言和前置条件是运行时检查机制，用于确保程序在执行时满足特定条件
let age = 25
assert(age >= 18, "年龄必须大于或等于18岁") // 如果条件为真则继续执行；如果为假则终止


let value: Int? = nil
precondition(value != nil, "值必须不为 nil") // 在两种构建中均检查


/// 例子例子例子例子例子例子例子例子 ///
func ddivide(_ numerator: Int, by denominator: Int) -> Double {
    precondition(denominator != 0, "分母必须不为零") // 在两种构建中检查
    return Double(numerator) / Double(denominator)
}

func checkUserAge(_ age: Int) {
    assert(age >= 18, "用户必须至少18岁") // 仅在调试构建中检查
}

// 使用示例
let result = ddivide(10, by: 2) // 正常执行
print(result) // 输出: 5.0

checkUserAge(20) // 在调试模式下正常执行
// checkUserAge(16) // 如果在调试模式下取消注释此行，将导致断言失败而终止
/// 例子例子例子例子例子例子例子例子 ///


// Debugging with Assertions  使用断言进行调试
// 断言是运行时检查的一种工具，旨在帮助开发者在程序执行时验证条件
let aage = -3
assert(age >= 0, "A person's age can't be less than zero.")
assert(age >= 0)
if age > 10 {
    print("You can ride the roller-coaster or the ferris wheel.")
} else if age >= 0 {
    print("You can ride the ferris wheel.")
} else {
    assertionFailure("A person's age can't be less than zero.")
}



// Enforcing Preconditions 强制执行前置条件
precondition(index > 0, "Index must be greater than zero.")

switch someValue {
case 1:
    // 处理 case 1
case 2:
    // 处理 case 2
default:
    preconditionFailure("Unexpected value!")
}

fatalError("Unimplemented")

