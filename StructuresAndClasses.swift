// Swift中的结构体和类具备以下共同功能：
// 定义属性：存储值。
// 定义方法：提供功能。
// 定义下标：使用下标语法访问值。
// 定义初始化器：设置初始状态。
// 扩展：扩展默认功能。
// 遵循协议：提供标准化功能。

// 类的独特功能,类相比结构体还具备以下额外功能：
// 继承：一个类可以继承另一个类的特性。
// 类型转换：在运行时检查并解释类实例的类型。
// 析构函数：允许类实例释放所占用的资源。
// 引用计数：允许多个引用指向同一个类实例。

//#####   Definition Syntax   #####//
struct anotherResolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = anotherResolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

//#####   Structure and Class Instances   #####//
let someResolution = anotherResolution()
let someVideoMode = VideoMode()

//#####   Accessing Properties   #####//
print("The width of someResolution is \(someResolution.width)")
// Prints "The width of someResolution is 0"
print("The width of someVideoMode is \(someVideoMode.resolution.width)")
// Prints "The width of someVideoMode is 0"
someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")
// Prints "The width of someVideoMode is now 1280"

//#####   Memberwise Initializers for Structure Types   #####//
let vga = Resolution(width: 640, height: 480)
// 在Swift中，结构体（struct） 会自动生成一个成员逐一构造器（memberwise initializer）
// 前提是结构体的所有属性都有默认值或是可选类型。

//#####   Structures and Enumerations Are Value Types   #####//
// 结构体（struct）和枚举（enum）都是值类型（Value Types）
// 当它们被赋值给另一个变量或传递给函数时，会产生一个副本，而不是引用同一个内存位置
// Swift 中的整数、浮点数、布尔值、字符串、数组和字典等基本类型都是值类型，它们在内部实现为结构体
// Swift 中，所有的结构体和枚举都是值类型。任何结构体或枚举实例，在代码中传递时都是被复制的
// Swift 标准库中的集合类型（如数组、字典和字符串）使用了写时复制（Copy-On-Write） 的优化机制，
// 这样可以在不改变副本的情况下共享内存，减少复制的开销。只有当副本被修改时，才会在修改前进行实际的复制。

struct Resolution {
    var width = 0
    var height = 0
}

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd

cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide") // 输出 "cinema is now 2048 pixels wide"
print("hd is still \(hd.width) pixels wide")       // 输出 "hd is still 1920 pixels wide"
// 因为 cinema 和 hd 是两个独立的实例。

enum CompassPoint {
    case north, south, east, west
    mutating func turnNorth() {
        self = .north
    }
}

var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

print("The current direction is \(currentDirection)")      // 输出 "The current direction is north"
print("The remembered direction is \(rememberedDirection)") // 输出 "The remembered direction is west"
// 修改 currentDirection 的值不会影响 rememberedDirection，因为它们是两个独立的副本

//#####   Classes Are Reference Types   #####//
// 在 Swift 中，类（class） 是引用类型（Reference Types）
// 当引用类型被赋值给一个变量或常量，或被传递给一个函数时，复制的是它的引用，而不是实例本身

let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
// 输出 "The frameRate property of tenEighty is now 30.0"
// 这行代码显示 tenEighty.frameRate 的帧率确实更新为了 30.0
// 因为 tenEighty 和 alsoTenEighty 指向的是同一个实例


// 虽然 tenEighty 和 alsoTenEighty 是常量，
// 但它们只是对 VideoMode 实例的引用，并不存储实例本身。
// 引用类型的常量可以修改实例的属性值，只要不改变它们指向的实例。


//#####   Identity Operators   #####//
// 需要判断两个变量是否引用同一个类实例时，Swift 提供了身份运算符（Identity Operators）
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
// 输出 "tenEighty and alsoTenEighty refer to the same VideoMode instance."
// 等价运算符（==）：判断两个实例在值上是否相等。
// 身份运算符（===）：判断两个变量是否指向同一个实例