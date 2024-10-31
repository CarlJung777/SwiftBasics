//#####    不透明类型和盒装协议类型   Opaque and Boxed Protocol Types   #####//

// 隐藏有关值类型的实现细节。
// Swift 提供了两种方式来隐藏有关值类型的细节：
// 不透明类型和盒装协议类型。

// 返回不透明类型的函数或方法隐藏其返回值的类型信息。
// 它并不提供一个具体的类型作为函数的返回类型，
// 而是用它所支持的协议来描述返回值。
// 不透明类型保持类型标识——编译器可以访问类型信息，但模块的客户端无法访问。

// 盒装协议类型可以存储符合给定协议的任何类型的实例。
// 盒装协议类型不保持类型标识——值的具体类型在运行时才能确定，并且可以随着不同值的存储而变化。

//   不透明类型解决的问题   The Problem That Opaque Types Solve

// 假设正在编写一个绘制 ASCII 艺术形状的模块。
// ASCII 艺术形状的基本特征是一个 draw() 函数，
// 它返回该形状的字符串表示，可以将其用作 Shape 协议的要求
protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
       var result: [String] = []
       for length in 1...size {
           result.append(String(repeating: "*", count: length))
       }
       return result.joined(separator: "\n")
    }
}

let smallTriangle = Triangle(size: 3)
print(smallTriangle.draw())
// *
// **
// ***

// 可以使用泛型来实现像垂直翻转形状这样的操作
// 这种方法有一个重要的限制：翻转的结果暴露了用于创建它的确切泛型类型。
struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

let flippedTriangle = FlippedShape(shape: smallTriangle)
print(flippedTriangle.draw())
// ***
// **
// *


// 像下面的代码所示，
// 定义一个 JoinedShape<T: Shape, U: Shape> 结构体
// 来垂直连接两个形状的方式，会导致从连接一个三角形与一个翻转三角形所得到的类型
// 如 JoinedShape<Triangle, FlippedShape<Triangle>>

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
       return top.draw() + "\n" + bottom.draw()
    }
}

let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
print(joinedTriangles.draw())
// *
// **
// ***
// ***
// **
// *

// 暴露有关形状创建的详细信息会导致不应作为 ASCII 艺术模块公共接口一部分的类型泄漏，
// 因为需要声明完整的返回类型。



//   返回不透明类型    Returning an Opaque Type
// 可以将不透明类型视为泛型类型的反向
// 泛型类型允许调用函数的代码选择该函数参数和返回值的类型，
// 这种选择是从函数实现中抽象出来的

// 例如，以下代码中的函数返回的类型取决于其调用者
func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }
// 调用 max(_:_:) 的代码选择 x 和 y 的值，而这些值的类型决定了 T 的具体类型。
// 调用代码可以使用任何符合 Comparable 协议的类型。
// 函数内部的实现以通用的方式编写，因此可以处理调用者提供的任何类型
// max(_:_:) 的实现只使用所有 Comparable 类型共有的功能。

// 对于具有不透明返回类型的函数，这些角色是反转的。
// 不透明类型允许函数实现选择其返回值的类型，这种选择是从调用该函数的代码中抽象出来的。

// 示例中的函数返回一个梯形，而不暴露该形状的底层类型：
struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}
// makeTrapezoid() 函数将其返回类型声明为 some Shape
// 因此，函数返回一个符合 Shape 协议的某个类型的值，而不指定任何特定的具体类型。
func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}


// 还可以将不透明返回类型与泛型结合使用。
// 以下代码中的两个函数都返回一个符合 Shape 协议的某种类型的值
func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}

func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    JoinedShape(top: top, bottom: bottom)
}


// 以下是一个无效的形状翻转函数，它包括对正方形的特殊处理：
func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
    if shape is Square {
        return shape // 错误：返回类型不匹配
    }
    return FlippedShape(shape: shape) // 错误：返回类型不匹配
}

// 修复
struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        if shape is Square {
           return shape.draw()
        }
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

// 以下是一个将其类型参数融入返回值底层类型的函数示例：
func `repeat`<T: Shape>(shape: T, count: Int) -> some Collection {
    return Array<T>(repeating: shape, count: count)
}
// 返回值的底层类型取决于 T：无论传入的是什么形状，
// repeat(shape:count:) 都会创建并返回一个该形状的数组。


//   Boxed 协议类型   Boxed Protocol Types
// Boxed 协议类型有时也称为存在类型（existential type），
// 源于 “存在一个类型 T，使得 T 符合协议” 的表述。

// 创建 boxed 协议类型，在协议名称前加上 any。以下是一个示例
// VerticalShapes 将 shapes 的类型声明为 [any Shape] ——一个包含 boxed Shape 元素的数组。
// 数组中的每个元素可以是不同的类型，并且这些类型都必须符合 Shape 协议。
struct VerticalShapes: Shape {
    var shapes: [any Shape]
    func draw() -> String {
        return shapes.map { $0.draw() }.joined(separator: "\n\n")
    }
}

let largeTriangle = Triangle(size: 5)
let largeSquare = Square(size: 5)
let vertical = VerticalShapes(shapes: [largeTriangle, largeSquare])
print(vertical.draw())

// 当已知 boxed 值的底层类型时，可以使用 as 类型转换。例如：

if let downcastTriangle = vertical.shapes[0] as? Triangle {
    print(downcastTriangle.size)
}
// 输出 “5”



//  Opaque 类型和 Boxed 协议类型的区别   Differences Between Opaque Types and Boxed Protocol Types
// Opaque 类型指的是一个特定的类型，尽管函数的调用者无法看到该类型；
// 而 boxed 协议类型则可以引用任何符合协议的类型

// 以下代码展示了 flip(_:) 函数使用 boxed 协议类型作为返回类型，而不是 opaque 类型
func protoFlip<T: Shape>(_ shape: T) -> Shape {
    return FlippedShape(shape: shape)
}

func protoFlip<T: Shape>(_ shape: T) -> Shape {
    if shape is Square {
        return shape
    }

    return FlippedShape(shape: shape)
}
// 经过修改的代码可以根据传入的 shape，返回 Square 实例或 FlippedShape 实例。


// opaque 类型保留了底层类型的标识。
// Swift 可以推断关联类型，
// 这使得 opaque 返回值可以在一些无法使用 boxed 协议类型作为返回值的地方使用。
// 例如，以下是来自泛型部分的 Container 协议的一个版本：
protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
extension Array: Container { }


// 无法使用 Container 作为函数的返回类型，因为该协议有一个关联类型。
// 你也无法将它用作泛型返回类型中的约束，因为在函数体外没有足够的信息来推断泛型类型应是什么
// 错误：包含关联类型的协议不能用作返回类型。
func makeProtocolContainer<T>(item: T) -> Container {
    return [item]
}

// 错误：没有足够的信息来推断 C。
func makeProtocolContainer<T, C: Container>(item: T) -> C {
    return [item]
}

// 使用 opaque 类型 some Container 
// 作为返回类型可以表达所需的 API 合约——该函数返回一个容器，但不指定容器的类型
func makeOpaqueContainer<T>(item: T) -> some Container {
    return [item]
}
let opaqueContainer = makeOpaqueContainer(item: 12)
let twelve = opaqueContainer[0]
print(type(of: twelve))
// 输出 “Int”
