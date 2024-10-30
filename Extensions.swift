//#####   扩展  Extensions   #####//

// 扩展为现有类型添加功能。
// 扩展可以为现有的类、结构、枚举或协议类型添加新功能。
// 这包括能够扩展您没有访问权限的原始源代码的类型（称为回溯建模）。
// 扩展类似于 Objective-C 中的类别（Category），
// 但与 Objective-C 类别不同，Swift 扩展没有名称。


// 在 Swift 中，扩展可以：
// 添加计算实例属性和计算类型属性
// 定义实例方法和类型方法
// 提供新的初始化器
// 定义下标
// 定义和使用新的嵌套类型
// 使现有类型符合协议

//  扩展语法   Extension Syntax
extension SomeType {
    // 要添加到 SomeType 的新功能
}

// 扩展可以扩展现有类型，使其采用一个或多个协议。
// 要添加协议遵循，您按与为类或结构书写协议名称相同的方式写出协议名称
extension SomeType: SomeProtocol, AnotherProtocol {
    // 协议要求的实现
}



//   计算属性  Computed Properties
// 扩展可以为现有类型添加计算实例属性和计算类型属性
// 示例为 Swift 的内置 Double 类型添加了五个计算实例属性，以提供处理距离单位的基本支持：

extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
// 打印 "One inch is 0.0254 meters"


//  初始化器  Initializers
// 扩展可以为现有类型添加新的初始化器

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))

// 可以扩展 Rect 结构，以提供一个接受特定中心点和大小的附加初始化器
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}



//  方法  Methods
// 扩展可以为现有类型添加新的实例方法和类型方法
// 此 repetitions(task:) 方法
// 接受一个类型为 () -> Void 的单个参数，表示一个没有参数且不返回值的函数。
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

// 可变实例方法  Mutating Instance Methods
// 通过扩展添加的实例方法也可以修改（或变更）实例本身。
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()
// someInt 现在是 9


//   下标  Subscripts
// 扩展可以为现有类型添加新的下标
// 示例为 Swift 的内置 Int 类型添加了一个整数下标。
// 该下标 [n] 返回数字右侧第 n 位的十进制数字：
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

//    嵌套类型   Nested Types 
// 扩展可以为现有的类、结构和枚举添加新的嵌套类型
// 示例向 Int 添加了一个新的嵌套枚举 Kind，
// 该枚举表示特定整数所代表的数字类型：负数、零或正数。
// 同时，添加了一个名为 kind 的新的计算实例属性，用于返回该整数的适当 Kind 枚举值。
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}


func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
