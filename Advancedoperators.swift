//#####      高级运算符    Advanced Operators   #####//

 

// Swift 中的算术运算符默认情况下不会溢出。溢出行为会被捕获并报告为错误。


//  按位运算符   Bitwise Operators
// 按位运算符允许操作数据结构中的单个原始数据位

// Bitwise NOT Operator
let initialBits: UInt8 = 0b00001111
let invertedBits = ~initialBits  // 等于 11110000


// Bitwise AND Operator
let firstSixBits: UInt8 = 0b11111100
let lastSixBits: UInt8  = 0b00111111
let middleFourBits = firstSixBits & lastSixBits  // 等于 00111100


// Bitwise OR Operator
let someBits: UInt8 = 0b10110010
let moreBits: UInt8 = 0b01011110
let combinedBits = someBits | moreBits  // 等于 11111110


// Bitwise XOR Operator
let firstBits: UInt8 = 0b00010100
let otherBits: UInt8 = 0b00000101
let outputBits = firstBits ^ otherBits  // 等于 00010001


//   按位左移和右移运算符   Bitwise Left and Right Shift Operators



// 无符号整数的移位行为  Shifting Behavior for Unsigned Integers
let shiftBits: UInt8 = 4   // 二进制为 00000100
shiftBits << 1             // 00001000
shiftBits << 2             // 00010000
shiftBits << 5             // 10000000
shiftBits << 6             // 00000000
shiftBits >> 2             // 00000001

// 使用一个名为 pink 的 UInt32 常量来存储粉色的级联样式表颜色值
// CSS 颜色值 #CC6699 在 Swift 的十六进制数字表示中写作 0xCC6699
// 然后，通过按位与运算符（&）和按位右移运算符（>>）将该颜色分解为
// 其红色（CC）、绿色（66）和蓝色（99）组件
let pink: UInt32 = 0xCC6699
let redComponent = (pink & 0xFF0000) >> 16    // redComponent 为 0xCC，或 204
let greenComponent = (pink & 0x00FF00) >> 8   // greenComponent 为 0x66，或 102
let blueComponent = pink & 0x0000FF           // blueComponent 为 0x99，或 153



//  有符号整数的移位行为   Shifting Behavior for Signed Integers

// 正数的存储方式与无符号整数完全相同
// 负数的存储方式则不同。
// 它们通过从 2 的 n 次方中减去其绝对值来存储，其中 n 是数值位的数量。
// 八位数有七个数值位，因此这意味着 2 的 7 次方，即 128
// 这种负数的编码方式称为二的补码表示




//   溢出运算符   Overflow Operators
var potentialOverflow = Int16.max
// potentialOverflow 等于 32767，这是 Int16 可以容纳的最大值
potentialOverflow += 1
// 这会导致错误


// 当您特别希望溢出条件截断可用的位数时，可以选择这种行为，而不是触发错误
// Swift 提供了三个算术溢出运算符，以选择整数计算的溢出行为。
// 这些运算符都以一个 ampersand（&）开头：
//
// 溢出加法 (&+)
// 溢出减法 (&-)
// 溢出乘法 (&*)


//    值溢出  Value Overflow
// 数值可以在正方向和负方向上发生溢出。

// 使用溢出加法运算符 (&+) 允许无符号整数向正方向溢出
var unsignedOverflow = UInt8.max
// unsignedOverflow 等于 255，这是 UInt8 可以容纳的最大值
unsignedOverflow = unsignedOverflow &+ 1
// unsignedOverflow 现在等于 0
// 溢出加法后，UInt8 范围内剩余的值为 00000000，即零


// 使用溢出减法运算符 (&-)  允许无符号整数在负方向上溢出 
var uunsignedOverflow = UInt8.min
// unsignedOverflow 等于 0，这是 UInt8 能够容纳的最小值
uunsignedOverflow = uunsignedOverflow &- 1
// unsignedOverflow 现在等于 255
// UInt8 能容纳的最小值是零，即二进制的 00000000。
// 如果用溢出减法运算符 (&-) 从 00000000 中减去 1，
// 这个数字会溢出并绕回到 11111111，或十进制的 255


// 对于有符号整数也会发生溢出。
// 所有有符号整数的加法和减法都是按位操作的，其中符号位也包含在相加或相减的数字中
var signedOverflow = Int8.min
// signedOverflow 等于 -128，这是 Int8 能够容纳的最小值
signedOverflow = signedOverflow &- 1
// signedOverflow 现在等于 127
// nt8 能容纳的最小值是 -128，或二进制的 10000000。
// 使用溢出运算符从该二进制数中减去 1，会得到二进制值 01111111，
// 这会切换符号位，使其变为正数 127，这是 Int8 可以容纳的最大正值


//   优先级和结合性   Precedence and Associativity

var x = 2 + 3 % 4 * 5
// 结果为 17
// 取余运算符（%）和乘法运算符（*）的优先级高于加法运算符（+）
// 取余和乘法运算符的优先级相同


//   运算符方法   Operator Methods
// 类和结构体可以提供对现有运算符的自定义实现，这种方式称为对现有运算符的重载（overloading）

// 示例展示了如何为自定义结构体实现算术加法运算符（+）
// 定义了一个用于表示二维位置向量 (x, y) 的 Vector2D 结构体，
// 随后定义了一个运算符方法以将 Vector2D 结构体的实例相加
struct Vector2D {
    var x = 0.0, y = 0.0
}

extension Vector2D {
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
       return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}

let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector
// combinedVector 是一个值为 (5.0, 5.0) 的 Vector2D 实例


// Prefix and Postfix Operators  前缀和后缀运算符
// 类和结构体还可以实现标准的一元运算符。
// 一元运算符仅对单个目标操作，如果运算符位于目标之前（例如 -a），则称为前缀运算符；
// 如果位于目标之后（例如 b!），则称为后缀运算符。

extension Vector2D {
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive
// negative 是一个值为 (-3.0, -4.0) 的 Vector2D 实例
let alsoPositive = -negative
// alsoPositive 是一个值为 (3.0, 4.0) 的 Vector2D 实例


//   复合赋值运算符   Compound Assignment Operators
extension Vector2D {
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}
// 之前已经定义了加法运算符，这里不需要重新实现加法过程
var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd
// original 现在的值为 (4.0, 6.0)
// 默认的赋值运算符（=）无法被重载。
// 只有复合赋值运算符可以被重载。
// 同样地，三元条件运算符（a ? b : c）也无法被重载。 


//  等价运算符   Equivalence Operators 
// 默认情况下，自定义类和结构体并没有实现等价运算符，即“等于”运算符（==）和“不等于”运算符（!=）

extension Vector2D: Equatable {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
       return (left.x == right.x) && (left.y == right.y)
    }
}
let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
    print("These two vectors are equivalent.")
}
// 输出 "These two vectors are equivalent."


//  自定义运算符    Custom Operators 

// 使用 operator 关键字在全局范围内声明一个新的运算符 +++，
// 并用 prefix 修饰符标记它为前缀运算符（即运算符出现在目标值之前）
prefix operator +++
// 此时，+++ 运算符在 Swift 中还没有任何具体含义。

extension Vector2D {
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector  // 使用已定义的加法赋值运算符将 vector 自加
        return vector
    }
}

var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
// toBeDoubled 和 afterDoubling 的 `x` 和 `y` 值现在都为 (2.0, 8.0)



// 自定义中缀运算符的优先级   Precedence for Custom Infix Operators
// 自定义的中缀运算符都属于一个“优先级组”（precedence group）
// 优先级组指定了运算符相对于其他中缀运算符的优先级以及运算符的结合性（associativity）

// 示例定义了一个新的自定义中缀运算符 +-，并将其归入了 AdditionPrecedence 优先级组
infix operator +-: AdditionPrecedence

extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}

let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector
// plusMinusVector 是一个 Vector2D 实例，其值为 (4.0, -2.0)



//   结果构建器    Result Builders
// 结果构建器是一种可以定义的新类型，能够通过一种自然、声明式的方式来创建嵌套的数据结构，如列表或树

protocol Drawable {
    func draw() -> String
}
struct Line: Drawable {
    var elements: [Drawable]
    func draw() -> String {
        return elements.map { $0.draw() }.joined(separator: "")
    }
}
struct Text: Drawable {
    var content: String
    init(_ content: String) { self.content = content }
    func draw() -> String { return content }
}
struct Space: Drawable {
    func draw() -> String { return " " }
}
struct Stars: Drawable {
    var length: Int
    func draw() -> String { return String(repeating: "*", count: length) }
}
struct AllCaps: Drawable {
    var content: Drawable
    func draw() -> String { return content.draw().uppercased() }
}

let name: String? = "Ravi Patel"
let manualDrawing = Line(elements: [
     Stars(length: 3),
     Text("Hello"),
     Space(),
     AllCaps(content: Text((name ?? "World") + "!")),
     Stars(length: 2),
])
print(manualDrawing.draw())
// 输出： "***Hello RAVI PATEL!**"

//  定义一个结果构建器，需要在类型声明上使用 @resultBuilder 属性
@resultBuilder
struct DrawingBuilder {
    static func buildBlock(_ components: Drawable...) -> Drawable {
        return Line(elements: components)
    }
    static func buildEither(first: Drawable) -> Drawable {
        return first
    }
    static func buildEither(second: Drawable) -> Drawable {
        return second
    }
}

// 将 @DrawingBuilder 属性应用于函数参数，这会将传递给函数的闭包转换为结果构建器从闭包创建的值
func draw(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return content()
}
func caps(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return AllCaps(content: content())
}

func makeGreeting(for name: String? = nil) -> Drawable {
    let greeting = draw {
        Stars(length: 3)
        Text("Hello")
        Space()
        caps {
            if let name = name {
                Text(name + "!")
            } else {
                Text("World!")
            }
        }
        Stars(length: 2)
    }
    return greeting
}

let genericGreeting = makeGreeting()
print(genericGreeting.draw())
// 输出："***Hello WORLD!**"

let personalGreeting = makeGreeting(for: "Ravi Patel")
print(personalGreeting.draw())
// 输出："***Hello RAVI PATEL!**"


// Swift 将上例中对 caps(_:) 的调用转换成以下代码：
let capsDrawing = caps {
    let partialDrawing: Drawable
    if let name = name {
        let text = Text(name + "!")
        partialDrawing = DrawingBuilder.buildEither(first: text)
    } else {
        let text = Text("World!")
        partialDrawing = DrawingBuilder.buildEither(second: text)
    }
    return partialDrawing
}

// 要在特殊的绘图语法中支持 for 循环，可以添加 buildArray(_:) 方法
extension DrawingBuilder {
    static func buildArray(_ components: [Drawable]) -> Drawable {
        return Line(elements: components)
    }
}

let manyStars = draw {
    Text("Stars:")
    for length in 1...3 {
        Space()
        Stars(length: length)
    }
}
