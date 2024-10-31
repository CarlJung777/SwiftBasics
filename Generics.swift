//#####   泛型   Generics   #####//


// 泛型解决的问题  The Problem That Generics Solve

// 一个标准的非泛型函数 swapTwoInts(_:_:)，用于交换两个 Int 值
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// 输出: "someInt is now 107, and anotherInt is now 3"

// swapTwoInts(_:_:) 函数很有用，但它只能用于 Int 值。
// 如果想要交换两个 String 值或两个 Double 值，就必须编写更多的函数

// 例如 swapTwoStrings(_:_:) 和 swapTwoDoubles(_:_:)，如下所示
func swapTwoStrings(_ a: inout String, _ b: inout String) {
    let temporaryA = a
    a = b
    b = temporaryA
}

func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// 这三个函数的函数体是相同的。唯一的区别是它们接受的值的类型（Int、String 和 Double）



//  泛型函数  Generic Functions
// 泛型函数使用一个占位符类型名称（在这里称为 T）
// <T>   Type 的简写，表示“类型”
// 尖括号告诉 Swift T 是 swapTwoValues(_:_:) 函数定义中的占位符类型名称。
// 由于 T 是占位符，Swift 并不会寻找一个名为 T 的实际类型。


// 以下是上述 swapTwoInts(_:_:) 函数的泛型版本，称为 swapTwoValues(_:_:)
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var ssomeInt = 3
var aanotherInt = 107
swapTwoValues(&ssomeInt, &aanotherInt)
// ssomeInt 现在为 107，aanotherInt 现在为 3

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
// someString 现在为 "world"，anotherString 现在为 "hello"


//   类型参数    Type Parameters
// 类型参数指定并命名一个占位符类型，并在函数名称后立即写在一对匹配的尖括号中（如 <T>）

//   命名类型参数   Naming Type Parameters
// 类型参数具有描述性名称，
// 例如在 Dictionary<Key, Value> 中的 Key 和 Value，
// 以及在 Array<Element> 中的 Element，
// 这些名称告诉读者类型参数与所用的泛型类型或函数之间的关系。
// 然而，当它们之间没有有意义的关系时，通常使用单个字母命名，如 T、U 和 V

// 始终给类型参数使用首字母大写的驼峰命名（如 T 和 MyTypeParameter），
// 以表明它们是类型的占位符，而不是值

//  泛型类型   Generic Types
// 除了泛型函数，Swift 还允许你定义自己的泛型类型。

// 以下是一个非泛型的栈实现，在此情况下用于存储 Int 值的栈
//  a nongeneric version of a stack
struct IntStack {
    var items: [Int] = []
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// 泛型栈的实现
// a generic version of the same code
struct Stack<Element> {
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// 创建泛型 Stack 实例
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
// 现在栈中包含 4 个字符串

let fromTheTop = stackOfStrings.pop()
// fromTheTop 等于 "cuatro"，而栈现在包含 3 个字符串

//   扩展泛型类型   Extending a Generic Type
// 扩展一个泛型类型时，不需要在扩展定义中提供类型参数列表

// 示例扩展了泛型 Stack 类型，添加了一个只读的计算属性 topItem，
// 该属性返回栈顶的项目，而不将其从栈中弹出
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}
// 输出 "The top item on the stack is tres."


//   类型约束   Type Constraints
// 类型约束指定类型参数必须继承自特定类，或符合特定协议或协议组合。

//   类型约束语法  Type Constraint Syntax

// 通过在类型参数名称后面放置一个类或协议约束并用冒号分隔，
// 可以写出类型约束，作为类型参数列表的一部分
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    // 函数体在这里
}

//   类型约束的实际应用   Type Constraints in Action

// 一个非泛型函数 findIndex(ofString:in:)，
// 它接受一个要查找的字符串值和一个字符串值数组，
// 返回一个可选的 Int 值。如果在数组中找到匹配的字符串，
// 它将是第一个匹配字符串的索引；如果找不到字符串，则返回 nil
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}
// 输出 "The index of llama is 2"

// 泛型版本 此函数无法编译
// 问题在于相等检查“if value == valueToFind”。
// 并非所有类型都可以使用相等运算符 (==) 进行比较。
func findIndex<T>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

// 使用 Equatable 协议改良后
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
// doubleIndex 是一个可选的 Int，没有值，因为 9.3 不在数组中
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
// stringIndex 是一个可选的 Int，包含值 2


//   关联类型   Associated Types
//  关联类型使用 associatedtype 关键字来指定

//  关联类型的实际应用  Associated Types in Action

// 一个名为 Container 的协议示例，它声明了一个名为 Item 的关联类型
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
// Container 协议定义了任何容器必须提供的三个必需功能：
// 必须能够通过 append(_:) 方法向容器添加新项。
// 必须能够通过 count 属性访问容器中的项的数量，该属性返回一个 Int 值。
// 必须能够通过下标来检索容器中的每个项，该下标接受一个 Int 索引值。

// 以下是上面提到的非泛型 IntStack 类型的一个版本，经过调整以符合 Container 协议
struct IntStack: Container {
    // 原始 IntStack 实现
    var items: [Int] = []
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // 符合 Container 协议
    typealias Item = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

// 还可以让泛型 Stack 类型符合 Container 协议
struct Stack<Element>: Container {
    // 原始 Stack<Element> 实现
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // 符合 Container 协议
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}


// 扩展现有类型以指定关联类型  Extending an Existing Type to Specify an Associated Type
// Swift 的 Array 类型已经提供了
//  append(_:) 方法、count 属性以及使用 Int 索引来检索其元素的下标。
// 这三种能力与 Container 协议的要求相匹配。
// 这意味着你可以扩展 Array 以符合 Container 协议，只需声明 Array 采用该协议即可
// 在定义了这个扩展后，可以将任何 Array 视为一个 Container
extension Array: Container {}



//  为关联类型添加约束   Adding Constraints to an Associated Type

// 这个版本的 Container，容器的 Item 类型必须遵循 Equatable 协议
protocol Container {
    // 要求容器中的项是可比较的（equatable）
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}


//  在关联类型的约束中使用协议   Using a Protocol in Its Associated Type’s Constraints

// 以下是一个协议，它细化了 Container 协议，增加了 suffix(_:) 方法的要求。
// suffix(_:) 方法返回容器末尾的指定数量的元素，并将其存储在 Suffix 类型的实例中
protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}
// 在这个协议中，Suffix 是一个关联类型

// 以下是对之前的 Stack 类型的扩展，使其符合 SuffixableContainer 协议
extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
    // 推断出 Suffix 是 Stack。
}

var stackOfInts = Stack<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
stackOfInts.append(30)
let suffix = stackOfInts.suffix(2)
// suffix 包含 20 和 30



//   泛型 Where 子句（条款？）    Generic Where Clauses
// 通过定义一个泛型的 where 子句来实现这一点
// 泛型 where 子句以 where 关键字开始，
// 后面跟着关联类型的约束或类型与关联类型之间的相等关系

func allItemsMatch<C1: Container, C2: Container>
        (_ someContainer: C1, _ anotherContainer: C2) -> Bool
        where C1.Item == C2.Item, C1.Item: Equatable {

    // 检查两个容器是否包含相同数量的项。
    if someContainer.count != anotherContainer.count {
        return false
    }

    // 检查每对项以查看它们是否相等。
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }

    // 所有项匹配，因此返回 true。
    return true
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}
// 输出 "All items match."


//  带有泛型 Where 子句的扩展   Extensions with a Generic Where Clause

// 可以在扩展中使用泛型的 where 子句
// 下面的示例扩展了之前示例中的泛型 Stack 结构，添加了一个 isTop(_:) 方法。
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
if stackOfStrings.isTop("tres") {
    print("Top element is tres.")
} else {
    print("Top element is something else.")
}
// 输出 "Top element is tres."


// 可以使用泛型 where 子句扩展协议
// 下面的示例扩展了之前的 Container 协议，添加了一个 startsWith(_:) 方法。
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}
// 输出 "Starts with something else."


// 上面的示例中的泛型 where 子句要求 Item 符合某个协议，
// 但您也可以编写要求 Item 是特定类型的泛型 where 子句

extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}


print([1260.0, 1200.0, 98.6, 37.0].average())
// 输出 "648.9"


//   上下文的 Where 子句    Contextual Where Clauses

// 下面示例中的 where 子句指定了要满足的类型约束，以使这些新方法在容器上可用
extension Container {
    func average() -> Double where Item == Int {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
    
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count-1] == item
    }
}

// 想在不使用上下文 where 子句的情况下编写此代码，
// 可以编写两个扩展，每个泛型 where 子句一个
// 上面的示例和下面的示例具有相同的行为
extension Container where Item == Int {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
}

extension Container where Item: Equatable {
    func endsWith(_ item: Item) -> Bool {
        return count >= 1 && self[count-1] == item
    }
}


//    带有泛型 Where 子句的关联类型    Associated Types with a Generic Where Clause

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }

    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}


protocol ComparableContainer: Container where Item: Comparable { }


//   泛型下标   Generic Subscripts

extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
            where Indices.Iterator.Element == Int {
        var result: [Item] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}
