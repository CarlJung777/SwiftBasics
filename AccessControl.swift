//#####   访问控制   Access Control   #####//
// 通过声明、文件和模块来管理代码的可见性。

// 访问控制限制了其他源文件和模块中的代码对您代码部分的访问。
// 此功能使您可以隐藏代码的实现细节，并指定可访问和使用该代码的首选接口。

// 可以为单个类型（类、结构体和枚举）以及属于这些类型的属性、方法、初始化器和下标分配特定的访问级别
// 协议也可以限制在特定上下文中使用，全球常量、变量和函数也是如此

//   模块、源文件和包    Modules, Source Files, and Packages

// Swift 的访问控制模型基于模块、源文件和包的概念。
// 
// 1,模块是一个单一的代码分发单元——作为一个单元构建和发布的框架或应用程序，
//   可以通过 Swift 的 import 关键字被另一个模块导入
// 2,在 Xcode 中，每个构建目标（例如应用程序包或框架）都被视为 Swift 中的一个独立模块
// 3,源文件是模块内的一个单一 Swift 源代码文件（实际上是应用程序或框架内的一个单一文件）
// 4,包是您作为一个单元开发的模块组


//  访问级别  Access Levels
// Swift 为代码中的实体提供六种不同的访问级别。
// 这些访问级别相对于定义实体的源文件、该源文件所属的模块以及该模块所属的包。

// 1.Open 和 Public 访问允许实体在其定义模块的任何源文件中使用，
// 也可以在导入定义模块的其他模块的源文件中使用。
// 通常在指定框架的公共接口时使用 open 或 public 访问。open 和 public 访问之间的区别如下所述。

// 2.Package 访问允许实体在其定义包的任何源文件中使用，
// 但不能在该包之外的任何源文件中使用。通常在一个结构为多个模块的应用程序或框架中使用包访问。

// 3.Internal 访问允许实体在其定义模块的任何源文件中使用，
// 但不能在该模块之外的任何源文件中使用。
// 通常在定义应用程序或框架的内部结构时使用 internal 访问。

// 4.File-private 访问限制了实体在其自身定义的源文件中的使用。
// 使用 file-private 访问隐藏特定功能的实现细节，当这些细节在整个文件内使用时。

// 5.Private 访问限制了实体在封闭声明中以及在同一文件中的该声明的扩展中的使用。
// 使用 private 访问隐藏特定功能的实现细节，当这些细节仅在单一声明内使用时。

// open 访问是最高的（限制最少的）访问级别，而 private 访问是最低的（限制最多的）访问级别


//  访问级别的指导原则  Guiding Principle of Access Levels
// Swift 中的访问级别遵循一个总体指导原则：
// 不能根据具有较低（更限制性）访问级别的另一个实体来定义实体

//  默认访问级别   Default Access Levels
// 代码中的所有实体如果不自己指定显式访问级别，
// 则具有 internal 的默认访问级别(个别例外)



//  单目标应用程序的访问级别   Access Levels for Single-Target Apps
// 当您编写简单的单目标应用程序时，应用程序中的代码通常是自包含的，不需要在应用程序的模块之外可用


// 框架的访问级别   Access Levels for Frameworks
// 当您开发框架时，请将该框架的公共接口标记为 open 或 public，
// 以便可以被导入该框架的其他模块（例如应用程序）查看和访问。
// 此公共接口是该框架的应用程序编程接口（API）


//   单元测试目标的访问级别   Access Levels for Unit Test Targets
// 当您编写带有单元测试目标的应用程序时，应用程序中的代码需要向该模块公开，以便进行测试



//  访问控制语法  Access Control Syntax
//  除非另有说明，默认访问级别为 internal
open class SomeOpenClass {}
public class SomePublicClass {}
internal class SomeInternalClass {}
fileprivate class SomeFilePrivateClass {}
private class SomePrivateClass {}

open var someOpenVariable = 0
public var somePublicVariable = 0
internal let someInternalConstant = 0
fileprivate func someFilePrivateFunction() {}
private func somePrivateFunction() {}


class SomeInternalClass {}              // 隐式 internal
let someInternalConstant = 0            // 隐式 internal



//  自定义类型  Costom Types

// 公共类型默认具有 internal 成员，而不是 public 成员。
// 如果您希望类型成员为 public，则必须显式标记它。
// 这一要求确保您选择公开类型的公共 API，避免错误地将类型的内部实现呈现为公共 API。
public class SomePublicClass {                   // 显式公共类
    public var somePublicProperty = 0            // 显式公共类成员
    var someInternalProperty = 0                 // 隐式内部类成员
    fileprivate func someFilePrivateMethod() {}  // 显式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

class SomeInternalClass {                        // 隐式内部类
    var someInternalProperty = 0                 // 隐式内部类成员
    fileprivate func someFilePrivateMethod() {}  // 显式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

fileprivate class SomeFilePrivateClass {         // 显式文件私有类
    func someFilePrivateMethod() {}              // 隐式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

private class SomePrivateClass {                 // 显式私有类
    func somePrivateMethod() {}                  // 隐式私有类成员
}


//  元组类型  Tuple Types
// 元组类型的访问级别是组成该元组的所有类型中最严格的访问级别
// 如果你从两种不同的类型组合一个元组，其中一种类型的访问级别为 internal，
// 而另一种类型的访问级别为 private，那么该复合元组类型的访问级别将是 private。
// 元组类型并没有像类、结构、枚举和函数那样的独立定义。
// 元组类型的访问级别是根据构成该元组的类型自动确定的，无法显式指定



//   函数类型   Function Types
// 函数类型的访问级别是根据函数参数类型和返回类型中最严格的访问级别来计算的
// 下面的 someFunction() 代码将无法编译：
func someFunction() -> (SomeInternalClass, SomePrivateClass) {
    // 函数实现代码
}
// 该函数的返回类型是由上面自定义类型中定义的两个类组成的元组类型。
// 其中一个类的访问级别为 internal，另一个类的访问级别为 private。
// 因此，该复合元组类型的整体访问级别为 private（元组组成类型的最小访问级别）

// 由于函数的返回类型为 private，
// 因此必须使用 private 修饰符标记函数的整体访问级别，以使函数声明有效
private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
    // 函数实现代码
}



//   枚举类型   Enumeration Types
// 不能为单独的枚举案例指定不同的访问级别。
public enum CompassPoint {
    case north
    case south
    case east
    case west
}

// 原始值和关联值  Raw Values and Associated Values
// 枚举定义中使用的任何原始值或关联值的类型必须具有至少与枚举相同的访问级别



// 嵌套类型  Nested Types
// 嵌套类型的访问级别与其包含类型相同，除非包含类型是 public



//   子类化    Subclassing
// 可以子类化当前访问上下文中可访问的任何类，并且该类是在与子类相同的模块中定义的

// 重写可以使继承的类成员比其超类版本更具可访问性
// 例子
public class A {
    fileprivate func someMethod() {}
}

internal class B: A {
    override internal func someMethod() {}
}

// 因为超类 C 和子类 D 定义在同一源文件中，
// 因此 D 实现的 someMethod() 调用 super.someMethod() 是有效的
public class C {
    fileprivate func someMethod() {}
}

internal class D: C {
    override internal func someMethod() {
        super.someMethod()
    }
}


//    常量、变量、属性和下标    Constants, Variables, Properties, and Subscripts

// 常量、变量或属性不能比其类型具有更高的公共访问级别
// 如果常量、变量、属性或下标使用了私有类型，则该常量、变量、属性或下标也必须标记为私有
private var privateInstance = SomePrivateClass()



//   Getters and Setters
// 常量、变量、属性和下标的 getter 和 setter 
// 自动获得与它们所属的常量、变量、属性或下标相同的访问级别

struct TrackedString {
    private(set) var numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
}


var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
print("The number of edits is \(stringToEdit.numberOfEdits)")
// 输出 "The number of edits is 3"


public struct sTrackedString {
    public private(set) var numberOfEdits = 0
    public var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    public init() {}
}


//  初始化器   Initializers
// 自定义初始化器的访问级别可以小于或等于其所初始化的类型


//  默认初始化器   Default Initializers
// Swift 会为任何提供了默认值的属性且没有提供至少一个初始化器的结构或基类自动提供一个没有参数的默认初始化器
// 默认初始化器的访问级别与其所初始化的类型相同，除非该类型被定义为公共类型。


//  结构类型的默认成员初始化器   Default Memberwise Initializers for Structure Types
//  如果结构的任何存储属性是私有的，则该结构类型的默认成员初始化器被视为私有。
//  类似地，如果结构的任何存储属性是文件私有的，则初始化器为文件私有。
//  否则，初始化器的访问级别为内部。


//   协议   Protocols
// 协议定义中的每个要求的访问级别会自动设置为与协议相同


//  协议继承   Protocol Inheritance
// 如果您定义一个继承自现有协议的新协议，则新协议的访问级别最多可以与其继承的协议相同


//  协议遵循  Protocol Conformance
//  类型可以遵循访问级别低于其自身的协议
//  类型遵循特定协议的上下文是该类型访问级别和协议访问级别的最小值


// 当您编写或扩展一个类型以遵循某个协议时，
// 必须确保该类型对每个协议要求的实现至少具有与该类型对该协议遵循相同的访问级别


//   扩展   Extensions
// 可以在任何可用的访问上下文中扩展类、结构或枚举
// 在扩展中添加的任何类型成员具有与原始类型成员相同的默认访问级别

// 可以用显式的访问级别修饰符（例如，私有）来标记扩展，
// 以便为扩展内定义的所有成员设置一个新的默认访问级别
// 此新默认访问级别仍然可以在扩展中被单独成员覆盖


//  扩展中的私有成员  Private Members in Extensions

// 与扩展的类、结构或枚举在同一文件中的扩展行为就像代码是原始类型声明的一部分。因此，可以：
// 在原始声明中声明一个私有成员，并从同一文件中的扩展访问该成员。
// 在一个扩展中声明一个私有成员，并从同一文件中的另一个扩展访问该成员。
// 在扩展中声明一个私有成员，并从同一文件中的原始声明访问该成员。

protocol SomeProtocol {
    func doSomething()
}
// 可以使用扩展添加协议遵循，如下所示：
struct SomeStruct {
    private var privateVariable = 12
}

extension SomeStruct: SomeProtocol {
    func doSomething() {
        print(privateVariable)
    }
}


//   泛型   Generics
// 泛型类型或泛型函数的访问级别是其自身访问级别与任何类型参数上的类型约束的访问级别中的最小值。


//  类型别名   Type Aliases
// 定义的任何类型别名在访问控制方面被视为不同的类型
// 类型别名可以具有小于或等于其所别名类型的访问级别
