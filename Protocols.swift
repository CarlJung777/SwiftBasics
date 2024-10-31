//#####    协议   Protocols   #####//
// 协议定义了符合类型必须实现的要求
// 协议定义了一组方法、属性和其他要求的蓝图，这些要求适合特定的任务或功能
// 然后，类、结构或枚举可以采用该协议，以提供这些要求的实际实现
// 任何满足协议要求的类型都被称为符合该协议


// 定义: 协议（Protocol）是一种抽象类型，
// 它定义了一组方法、属性和其他要求，
// 任何 conforming 类型（如类、结构体或枚举）都需要实现这些要求。
// 协议可以看作是一个行为的蓝图，描述了某种特定功能或任务所需的行为。


//    Protocol Syntax

protocol SomeProtocol {
    // 协议定义在此处
}


// 自定义类型通过在类型名称后加上协议名称来声明采用某个协议，二者之间用冒号分隔。
// 多个协议可以列出，并用逗号分隔
struct SomeStructure: FirstProtocol, AnotherProtocol {
    // 结构定义在此处
}


// 如果类有一个超类，在协议名称之前列出超类名称，并用逗号分隔
class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
    // 类定义在此处
}
// 因为协议是类型，因此其名称应以大写字母开头（如 FullyNamed 和 RandomNumberGenerator），
// 以符合 Swift 中其他类型（如 Int、String 和 Double）的命名规则。


//   属性要求   Property Requirements
// 协议可以要求任何遵循该协议的类型提供具有特定名称和类型的实例属性或类型属性。

// 可读写属性通过在类型声明后加上 { get set } 来标记，只读属性则使用 { get }。
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}

// 在协议中定义类型属性要求时，总是需要使用 static 关键字作为前缀
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}

// 单个实例属性要求的协议示例
protocol FullyNamed {
    var fullName: String { get }
}
// 一个简单结构体示例，该结构体采用并符合 FullyNamed 协议：
struct Person: FullyNamed {
    var fullName: String
}
let john = Person(fullName: "John Appleseed")
// john.fullName 为 "John Appleseed"


// 一个更复杂的类，它也采用并符合 FullyNamed 协议
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
// ncc1701.fullName 为 "USS Enterprise"



//   方法要求   Method Requirements
// 协议可以要求符合的类型实现特定的实例方法和类型方法。
// 和类型属性要求一样，定义协议时，类型方法要求总是以 static 关键字作为前缀
protocol SomeProtocol {
    static func someTypeMethod()
}

// 示例定义了一个带有单个实例方法要求的协议
protocol RandomNumberGenerator {
    func random() -> Double
}
// 采用并符合 RandomNumberGenerator 协议的类的实现
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c)
            .truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// 输出 "Here's a random number: 0.3746499199817101"
print("And another one: \(generator.random())")
// 输出 "And another one: 0.729023776863283"



//   可变方法要求   Mutating Method Requirements
protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch 现在等于 .on



//   构造器要求    Initializer Requirements
protocol SomeProtocol {
    init(someParameter: Int)
}


//  类对协议构造器要求的实现   Class Implementations of Protocol Initializer Requirements

// 可以在符合协议的类上，将协议构造器要求实现为指定构造器或便捷构造器
// 在这两种情况下，都必须在构造器实现前加上 required 修饰符
class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        // 构造器的实现
    }
}

// 如果子类重写了超类的指定构造器，同时实现了协议中的匹配构造器要求，
// 则应同时添加 required 和 override 修饰符
protocol SomeProtocol {
    init()
}

class SomeSuperClass {
    init() {
        // 构造器的实现
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // 来自 SomeProtocol 的 "required"，来自 SomeSuperClass 的 "override"
    required override init() {
        // 构造器的实现
    }
}

//  可失败的构造器要求  Failable Initializer Requirements

//   协议作为类型   Protocols as Types
// 协议本身并不实现任何功能，但可以在代码中将协议用作一种类型。

//   委托   Delegation
// 委托是一种设计模式，使类或结构体可以将某些职责交由其他类型的实例来执行。
// 该设计模式通过定义一个封装委托职责的协议来实现，
// 这样符合协议的类型（称为委托）就保证了提供已委托的功能。

class DiceGame {
    let sides: Int
    let generator = LinearCongruentialGenerator()
    weak var delegate: Delegate?

    init(sides: Int) {
        self.sides = sides
    }

    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }

    func play(rounds: Int) {
        delegate?.gameDidStart(self)
        for round in 1...rounds {
            let player1 = roll()
            let player2 = roll()
            if player1 == player2 {
                delegate?.game(self, didEndRound: round, winner: nil)
            } else if player1 > player2 {
                delegate?.game(self, didEndRound: round, winner: 1)
            } else {
                delegate?.game(self, didEndRound: round, winner: 2)
            }
        }
        delegate?.gameDidEnd(self)
    }
    // DiceGame.Delegate 协议提供了三个方法来跟踪游戏的进展
    protocol Delegate: AnyObject {
        func gameDidStart(_ game: DiceGame)
        func game(_ game: DiceGame, didEndRound round: Int, winner: Int?)
        func gameDidEnd(_ game: DiceGame)
    }
}

let tracker = DiceGameTracker()
let game = DiceGame(sides: 6)
game.delegate = tracker
game.play(rounds: 3)
// Started a new game
// Player 2 won round 1
// Player 2 won round 2
// Player 1 won round 3
// Player 2 won!

// 为防止强引用循环，委托属性声明为弱引用。


//   使用扩展添加协议遵循    Adding Protocol Conformance with an Extension

// 以下协议 TextRepresentable 可以由任何能用文本表示的类型实现
protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
// 任何 Dice 实例都可以被视为 TextRepresentable 类型
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)
// 输出 "A 12-sided dice"

//  有条件地遵循协议  Conditionally Conforming to a Protocol
// 泛型类型可能只在某些条件下满足协议的要求，例如当其泛型参数符合该协议时。
// 你可以通过在扩展类型时列出约束条件，使泛型类型有条件地遵循协议。
// 在采用协议名称后添加一个 where 子句来书写这些约束条件。
// 以下扩展使 Array 实例在存储符合 TextRepresentable 协议的元素类型时，
// 自动符合 TextRepresentable 协议
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let myDice = [d6, d12]
print(myDice.textualDescription)
// 输出 "[A 6-sided dice, A 12-sided dice]"

//  使用扩展声明协议遵循  Declaring Protocol Adoption with an Extension
// 如果一个类型已经符合了协议的所有要求，但尚未声明它采用该协议，
// 你可以通过一个空的扩展来声明它遵循该协议

struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
// 这里通过一个空的扩展来声明它遵循该协议
extension Hamster: TextRepresentable {}

// 现在，Hamster 的实例可以在任何需要 TextRepresentable 类型的地方使用
let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)
// 输出 "A hamster named Simon"



// 使用自动生成的实现来遵循协议  Adopting a Protocol Using a Synthesized Implementation

// Swift 在许多简单情况下可以自动提供 Equatable、Hashable 和 Comparable 协议的遵循


// Swift 会为以下几种自定义类型提供 Equatable 的自动生成实现：
// 仅包含符合 Equatable 协议的存储属性的结构体
// 仅包含符合 Equatable 协议的关联类型的枚举
// 没有任何关联类型的枚举

// 示例定义了一个三维位置向量 Vector3D 结构体（包含 x、y 和 z 属性），
// 由于这些属性都是 Equatable 类型，Vector3D 会自动生成等价运算符的实现
struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}

let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
if twoThreeFour == anotherTwoThreeFour {
    print("These two vectors are also equivalent.")
}
// 输出 "These two vectors are also equivalent."


// Swift 会为以下几种自定义类型提供 Hashable 的自动生成实现：
// 仅包含符合 Hashable 协议的存储属性的结构体
// 仅包含符合 Hashable 协议的关联类型的枚举
// 没有任何关联类型的枚举


// Swift 会为没有原始值的枚举提供 Comparable 的自动生成实现。
// 如果枚举有关联类型，则所有关联类型都必须符合 Comparable 协议
// Comparable 协议的默认实现还提供了 <=、> 和 >= 等剩余的比较运算符。
enum SkillLevel: Comparable {
    case beginner
    case intermediate
    case expert(stars: Int)
}

var levels = [SkillLevel.intermediate, SkillLevel.beginner,
              SkillLevel.expert(stars: 5), SkillLevel.expert(stars: 3)]
for level in levels.sorted() {
    print(level)
}
// 输出 "beginner"
// 输出 "intermediate"
// 输出 "expert(stars: 3)"
// 输出 "expert(stars: 5)"


//  协议类型集合   Collections of Protocol Types
// 协议可以作为集合（例如数组或字典）中存储的类型

// thing 常量的类型是 TextRepresentable，
// 而不是 Dice、DiceGame 或 Hamster，即便这些实例的实际类型可能是其中之一
let things: [TextRepresentable] = [game, d12, simonTheHamster]
for thing in things {
    print(thing.textualDescription)
}
// 输出：
// A game of Snakes and Ladders with 25 squares
// A 12-sided dice
// A hamster named Simon


//  协议继承  Protocol Inheritance
// 一个协议可以继承一个或多个其他协议，并可以在继承的基础上添加进一步的要求

// 协议继承的语法类似于类继承的语法，但可以列出多个继承的协议，用逗号分隔
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // 协议定义在此
}
// 下面是一个继承自上述 TextRepresentable 协议的协议示例
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

// SnakesAndLadders 类可以扩展以采用并符合 PrettyTextRepresentable 协议
extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}

print(game.prettyTextualDescription)
// 输出：
// A game of Snakes and Ladders with 25 squares:
// ○ ○ ▲ ○ ○ ▲ ○ ○ ▲ ▲ ○ ○ ○ ▼ ○ ○ ○ ○ ▼ ○ ○ ▼ ○ ▼ ○ 


//  仅限类的协议   Class-Only Protocols

// 通过将 AnyObject 协议添加到协议的继承列表中来限制协议的采用仅限于类类型（而不是结构体或枚举）。
// SomeClassOnlyProtocol 只能被类类型采用。
protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
    // 仅限类的协议定义在此
}

// 协议组合  Protocol Composition
// 一个将名为 Named 和 Aged 的两个协议组合成函数参数的单一协议组合要求的示例
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}
// 定义一个 wishHappyBirthday(to:) 函数。
// celebrator 参数的类型为 Named & Aged，/
// 这意味着“任何同时符合 Named 和 Aged 协议的类型”。
// 传递给函数的具体类型并不重要，只要它符合两个要求的协议即可。
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}

let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)
// 输出： "Happy birthday, Malcolm, you're 21!"

// 将前面示例中的 Named 协议与 Location 类组合的示例
class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}

func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}


//  检查协议符合性  Checking for Protocol Conformance
// 可以使用 is 和 as 操作符来检查协议的符合性，并将其转换为特定的协议
// is 操作符返回 true，如果一个实例符合某个协议；返回 false，如果不符合。
// as? 版本的向下转换操作符返回该协议类型的可选值，如果实例不符合该协议，则返回 nil。
// as! 版本的向下转换操作符强制进行协议类型的向下转换，如果转换失败，则会触发运行时错误。

// 一个名为 HasArea 的协议
protocol HasArea {
    var area: Double { get }
}
// 两个类，Circle 和 Country，它们都符合 HasArea 协议
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}

class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}

// 一个不符合 HasArea 协议的类 Animal
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

// Circle、Country 和 Animal 类没有共享的基类。
// 尽管如此，它们都是类，因此这三种类型的实例都可以用来初始化一个存储 AnyObject 类型值的数组
let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

// 现在可以迭代 objects 数组，并检查数组中的每个对象是否符合 HasArea 协议
for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}
// 输出：
// Area is 12.5663708
// Area is 243610.0
// Something that doesn't have an area
// 底层对象在转换过程中并没有改变。它们仍然是 Circle、Country 和 Animal。
// 然而，在存储到 objectWithArea 常量的那一刻，它们只能被视为 HasArea 类型，
// 因此只能访问它们的 area 属性。

//  可选协议要求   Optional Protocol Requirements
// 可选要求在协议定义中以 optional 修饰符为前缀。
// 可选要求的设置使您可以编写与 Objective-C 互操作的代码。
// 协议及其可选要求都必须标记为 @objc 属性。请注意，@objc 协议只能被类采用，而不能被结构或枚举采用。
// 当您在可选要求中使用某个方法或属性时，其类型会自动变为可选类型。
// 例如，类型为 (Int) -> String 的方法变为 ((Int) -> String)?

// 示例定义了一个名为 Counter 的整数计数类，它使用外部数据源提供增量值。
// 此数据源由 CounterDataSource 协议定义，包含两个可选要求
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}
// 下面定义的 Counter 类具有一个类型为 CounterDataSource? 的可选 dataSource 属性
class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

// 下面是一个简单的 CounterDataSource 实现，
// 其中数据源每次查询时返回一个常量值 3。
// 它通过实现可选的 fixedIncrement 属性要求来实现：
class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

// 将 ThreeSource 的一个实例用作新的 Counter 实例的数据源
var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}
// 输出：
// 3
// 6
// 9
// 12
// 一个更复杂的数据源，名为 TowardsZeroSource，它使 Counter 实例从其当前计数值向零递增或递减
class TowardsZeroSource: NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}
// 可以使用 TowardsZeroSource 的一个实例与现有的 Counter 实例一起，
// 从 -4 计数到零。一旦计数器达到零，就不再进行计数
counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}
// 输出：
// -3
// -2
// -1
// 0
// 0


//  协议扩展  Protocol Extensions
// 协议可以被扩展，以为符合该协议的类型提供方法、初始化器、下标和计算属性的实现。
// 这使您能够在协议本身上定义行为，而不是在每个类型的单独符合中或在全局函数中定义


// RandomNumberGenerator 协议可以扩展以提供一个 randomBool() 方法，
// 该方法使用必需的 random() 方法的结果返回一个随机的 Bool 值
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}
// 通过在协议上创建扩展，所有符合类型会自动获得此方法的实现，而无需额外修改。
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// 输出 "Here's a random number: 0.3746499199817101"
print("And here's a random Boolean: \(generator.randomBool())")
// 输出 "And here's a random Boolean: true"
// 协议扩展可以为符合的类型添加实现，但不能使协议扩展或继承自其他协议。
// 协议继承始终在协议声明本身中指定。

//   提供默认实现   Providing Default Implementations
// 您可以使用协议扩展为该协议的任何方法或计算属性要求提供默认实现。

// 继承 TextRepresentable 协议的 PrettyTextRepresentable 协议
// 可以为其要求的 prettyTextualDescription 属性提供默认实现，
// 以简单地返回访问 textualDescription 属性的结果：
extension PrettyTextRepresentable  {
    var prettyTextualDescription: String {
        return textualDescription
    }
}


//   向协议扩展添加约束  Adding Constraints to Protocol Extensions
// 在定义协议扩展时，可以指定符合的类型必须满足的约束，才能使用扩展的方法和属性。
// 您在扩展协议名称之后写这些约束，使用一个泛型的 where 子句

// 定义一个适用于元素符合 Equatable 协议的任何集合的 Collection 协议的扩展。
// 通过将集合的元素约束为 Equatable 协议（这是 Swift 标准库的一部分），
// 可以使用 == 和 != 运算符检查两个元素之间的相等性和不等性。
extension Collection where Element: Equatable {
    // allEqual() 方法只有在集合中的所有元素相等时才返回 true
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}
let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]

print(equalNumbers.allEqual())
// 输出 "true"
print(differentNumbers.allEqual())
// 输出 "false"
