//#####   Initialization 初始化   #####//
// 初始化是为类、结构体或枚举的实例准备使用的过程。

// 初始化的目的
// 设定初始值：确保类型的所有存储属性在实例化时都有一个有效的初始值。
// 执行设置：除了初始化属性之外，还可以进行一些必要的设置，以确保实例可以正常工作。

// 存储属性的初始值设置 Setting Initial Values for Stored Properties

// 初始化器（Initializer）是用来创建特定类型新实例的特殊方法
// 使用 init 关键字定义

// 默认属性值 (Default Property Values)

// 自定义初始化 Customizing Initialization

// Initialization Parameters

// Parameter Names and Argument Labels

// Initializer Parameters Without Argument Labels

// Optional Property Types 可选属性类型
// 如果属性可能没有初始值，可以将它声明为可选类型（optional type），
// 这时它会自动初始化为 nil，表示暂时没有值。

class SurveyQuestion {
    var text: String
    var response: String? // 可选类型
    init(text: String) {
        self.text = text
    }
}

// Assigning Constant Properties During Initialization
// 常量属性在初始化过程中只能赋值一次，初始化完成后就无法修改了

// Default Initializers   默认初始化器
// 如果一个结构体或类的所有属性都有默认值，
// 并且没有自己定义任何初始化器，Swift 会自动生成一个默认的初始化器
class sShoppingListItem {
    var name: String?          // 可选类型，默认值为 nil
    var quantity = 1           // 默认值为 1
    var purchased = false      // 默认值为 false
}
var item = sShoppingListItem()


// 成员逐一初始化器  Memberwise Initializers for Structure Types
// 结构体在没有定义任何自定义初始化器时，
// 会自动获得一个成员逐一初始化器（memberwise initializer）。

// 默认初始化器不同的是，即使结构体包含没有默认值的存储属性，
// Swift 仍然会提供一个成员逐一初始化器。

// Size 没有定义自己的初始化器，
// Swift 自动为它提供了一个成员逐一初始化器 init(width:height:)。
struct Size {
    var width = 0.0, height = 0.0
}
// 所以可以直接用该初始化器，通过指定属性名来初始化一个新的 Size 实例
let twoByTwo = Size(width: 2.0, height: 2.0)

// 省略默认值的属性
let zeroByTwo = Size(height: 2.0)
print(zeroByTwo.width, zeroByTwo.height) // 输出 "0.0 2.0"

let zeroByZero = Size()
print(zeroByZero.width, zeroByZero.height) // 输出 "0.0 0.0"


//  初始化器委托  Initializer Delegation for Value Types
struct Rectangle {
    var width: Double
    var height: Double

    // 初始化器1
    // init(width:height:) 是第一个初始化器，可以独立完成矩形的宽和高的初始化。
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }

    // 初始化器2，调用第一个初始化器
    // init(size:) 是第二个初始化器，它使用 self.init(width:height:) 进行初始化委托。
    init(size: Double) {
        self.init(width: size, height: size)
    }
}

let square = Rectangle(size: 10.0)
// square 的宽和高都是 10.0
// 当你为一个值类型定义了自定义初始化器时，将不再拥有默认初始化器（对于结构体，还包括成员逐一初始化器）。
// 这样设计是为了防止使用自动初始化器时绕过自定义初始化器中的一些必要设置。


// Class Inheritance and Initialization
// 类的初始化方式被分为两种：
// 指定初始化器（designated initializer）和便捷初始化器（convenience initializer）。
class Person {
    var name: String
    var age: Int
    // 指定初始化器，直接给 name 和 age 属性赋值。
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class PersonA {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    // 便捷初始化器，必须委托调用同一类中的另一个初始化器，最终调用链上会到达指定初始化器。
    // 便捷初始化器不直接对存储属性进行赋值，而是通过委托来完成。
    convenience init(name: String) {
        self.init(name: name, age: 18) // 默认年龄为 18
    }
}

// Designated Initializers and Convenience Initializers
// 指定初始化器 (Designated Initializer)
// 便捷初始化器（convenience initializer）

// Swift 针对类的初始化器提供了三个委托规则，以简化初始化器之间的关系：
// 规则 1：指定初始化器必须调用直接父类的指定初始化器。
// 规则 2：便捷初始化器必须调用同类中的另一个初始化器。
// 规则 3：便捷初始化器最终必须调用指定初始化器。
// 可以简单理解为：指定初始化器必须向上委托，而便捷初始化器必须横向委托。

// 两阶段初始化 (Two-Phase Initialization)
// Swift 的类初始化采用了两阶段初始化流程，以确保在复杂的类继承链中所有属性都能被安全地初始化：
// 第一阶段：从下到上初始化所有存储属性。
// 第二阶段：从上到下的个性化设置。


// 安全检查 safety-checks
// Swift 编译器提供四个安全检查来确保初始化的正确性：
// 检查 1：指定初始化器必须在委托到父类初始化器前初始化自己引入的所有属性。
// 检查 2：指定初始化器必须先委托到父类初始化器，才能给继承的属性赋值，否则父类的初始化器会覆盖新值。
// 检查 3：便捷初始化器必须先委托到另一个初始化器，才能为任何属性赋值。
// 检查 4：在第一阶段完成前，不能调用实例方法、访问属性或引用 self。


//  初始化器的继承和重写  Initializer Inheritance and Overriding
// Swift 中的子类默认不会继承父类的初始化器，但在满足某些条件下会自动继承：
// 规则 1：如果子类没有定义任何指定初始化器，它会自动继承父类的所有指定初始化器。
// 规则 2：如果子类提供了所有父类指定初始化器的实现（无论是通过继承还是自定义实现），它将继承所有父类的便捷初始化器。


// 自动初始化器继承  Automatic Initializer Inheritance

// 自动初始化器继承的前提:
// 子类不会默认继承父类的初始化器。
// 自动继承只有在确保子类能完全、安全地初始化所有属性的情况下才会发生。
// 如果子类为它新增的属性提供了默认值，则更可能继承父类初始化器。

// 自动继承的两条规则
// 规则 1：子类没有定义任何指定初始化器时
// 如果子类没有定义任何指定初始化器，那么它将自动继承所有父类的指定初始化器。
// 这个规则适用于子类属性都能通过默认值或父类的初始化器来正确初始化的情况。
class Animal {
    var age: Int
    init(age: Int) {
        self.age = age
    }
}

class Dog: Animal {
    // 因为 Dog 没有定义指定初始化器，所以它会自动继承父类的 init(age:) 初始化器。
}

// 规则 2：子类实现了所有父类指定初始化器时
// 如果子类已经通过继承（符合规则 1）或自定义实现的方式提供了所有父类指定初始化器的实现，那么它将自动继承所有父类的便捷初始化器。
// 这意味着子类在完整实现父类的指定初始化器后，也会自动获得父类的便捷初始化器。
class blackAnimal {
    var age: Int
    init(age: Int) {
        self.age = age
    }
    
    convenience init() {
        self.init(age: 0)
    }
}

class blackDog: blackAnimal {
    override init(age: Int) {
        super.init(age: age)
    }
    // 因为 Dog 已经实现了所有父类的指定初始化器 (init(age:))，它会自动继承父类的便捷初始化器 init()。
}


// Designated and Convenience Initializers in Action

// Food 类是层次结构中的基类，负责封装食物的名称。
class Food {
    var name: String
    // 指定初始化器 init(name: String)：必须传入名称的初始化器，确保所有存储属性都被完全初始化。
    init(name: String) {
        self.name = name
    }
    // 便捷初始化器 init()：这是一个无参数的初始化器，
    // 提供默认名称 "[Unnamed]"，通过调用指定初始化器 init(name: String) 实现。
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

let namedMeat = Food(name: "Bacon")  // namedMeat的name为"Bacon"
let mysteryMeat = Food()              // mysteryMeat的name为"[Unnamed]"

// RecipeIngredient 类继承自 Food，并添加了一个新的 Int 类型属性 quantity，表示食材的数量。
class RecipeIngredient: Food {
    var quantity: Int
    // 指定初始化器 init(name: String, quantity: Int)：接受名称和数量，
    // 并在初始化中设置数量，然后调用父类的指定初始化器。
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}
// RecipeIngredient 类重写了父类的便捷初始化器，但由于实现了所有指定初始化器
// RecipeIngredient 也自动继承了 Food 的便捷初始化器 init()。
let oneMysteryItem = RecipeIngredient()                 // 数量默认为1
let oneBacon = RecipeIngredient(name: "Bacon")          // oneBacon的name为"Bacon"，数量为1
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6) // sixEggs的name为"Eggs"，数量为6


class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}
// ShoppingListItem 类没有定义初始化器，因为它提供的属性都有默认值，
// 因此自动继承了所有指定和便捷初始化器。

var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name: "Bacon"),
    ShoppingListItem(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"  // 修改第一个项目的name为"Orange juice"
breakfastList[0].purchased = true         // 标记为已购买

for item in breakfastList {
    print(item.description)
}
// 输出:
// 1 x Orange juice ✔
// 1 x Bacon ✘
// 6 x Eggs ✘


// 初始化器的继承：通过不同的初始化器，子类可以安全地初始化其所有属性，
// 并且可以自动继承父类的初始化器，减少了重复代码的需要。

// 类的层次结构：Food 类作为基类提供基本的属性和功能，
// RecipeIngredient 和 ShoppingListItem 类在此基础上扩展并实现了各自特定的功能。

// 便捷性和可读性：便捷初始化器的存在使得创建实例更加便捷，
// 尤其是在不需要提供所有属性值时，提高了代码的可读性和简洁性。


//  可失败初始化器 Failable Initializers
struct aAnimal {
    let species: String
    // 可以在初始化失败时返回 nil
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}

let someCreature = aAnimal(species: "Giraffe")
// someCreature 是 aAnimal? 类型，表示初始化成功

if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}
// 输出: "An aAnimal was initialized with a species of Giraffe"

let anonymousCreature = aAnimal(species: "")
// anonymousCreature 是 aAnimal? 类型，表示初始化失败

if anonymousCreature == nil {
    print("The anonymous creature couldn't be initialized")
}
// 输出: "The anonymous creature couldn't be initialized"


//  可失败初始化器用于枚举  Failable Initializers for Enumerations

enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    // 传入的字符 symbol 来初始化相应的枚举值，如果不匹配任何情况，则返回 nil。
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}

let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
// 输出: "This is a defined temperature unit, so initialization succeeded."

let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This isn't a defined temperature unit, so initialization failed.")
}
// 输出: "This isn't a defined temperature unit, so initialization failed."


//  具有原始值的枚举的可失败初始化器  Propagation of Initialization Failure
enum tTemperatureUnit: Character {
    case kelvin = "K", celsius = "C", fahrenheit = "F"
}

let ffahrenheitUnit = tTemperatureUnit(rawValue: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
// 输出: "This is a defined temperature unit, so initialization succeeded."

let uunknownUnit = tTemperatureUnit(rawValue: "X")
if unknownUnit == nil {
    print("This isn't a defined temperature unit, so initialization failed.")
}
// 输出: "This isn't a defined temperature unit, so initialization failed."


// 重写可失败初始化器 Overriding a Failable Initializer
// 这部分内容介绍了如何在 Swift 中重写可失败初始化器（Failable Initializers），
// 以及如何使用隐式解包可失败初始化器（Implicitly Unwrapped Failable Initializers）。

class Document {
    var name: String?
    // 这个初始化器创建一个名称为 nil 的文档
    init() {}
    
    // 这个初始化器创建一个非空名称的文档
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class AutomaticallyNamedDocument: Document {
    // 重写
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    // 重写
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}

class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!  // 使用 ！ 强制解包
    }
}

// The init! Failable Initializer  隐式解包可失败初始化器   init!()
// 您可以在 init? 和 init! 之间进行委托，反之亦然，也可以从 init 委托到 init!。
// 如果从 init! 委托到 init?，会触发一个断言，前提是 init! 初始化器导致初始化失败。

// Required Initializers
// required 初始化器用于确保每个子类都必须实现该初始化器
// 关键字 required
class SomeClass {
    required init() {
        // 初始化器实现
    }
}
// 子类也需要使用关键字 required ，为了确保在更深层次的子类中，这一初始化器的要求仍然有效
class SomeSubclass: SomeClass {
    required init() {
        // 子类实现的 required 初始化器
    }
}
// 如果子类可以通过继承父类的初始化器来满足 required 初始化器的要求，则无需提供显式实现。
class AnotherSubclass: SomeSubclass {
    // 不需要实现 required 初始化器
}


// 使用闭包或函数为存储属性设置默认值
// Setting a Default Property Value with a Closure or Function

// boardColors 属性使用一个闭包来初始化，闭包的逻辑计算出每个方格的颜色
struct Chessboard {
    let boardColors: [Bool] = {
        var temporaryBoard: [Bool] = []
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return boardColors[(row * 8) + column]
    }
}

// 当创建一个新的 Chessboard 实例时，闭包会被执行，boardColors 的默认值会被计算并返回
let board = Chessboard()
print(board.squareIsBlackAt(row: 0, column: 1))  // 打印 "true"
print(board.squareIsBlackAt(row: 7, column: 7))  // 打印 "false"
