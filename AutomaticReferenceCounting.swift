//#####    自动引用计数 (ARC) Automatic Reference Counting   #####//


// ARC 的工作原理   How ARC Works

// 每当你创建一个新的类实例时，ARC 就会分配一块内存来存储该实例的信息。
// 这块内存包含实例的类型信息以及与该实例相关的所有存储属性的值。

// 当一个实例不再需要时，ARC 会释放该实例所占用的内存，从而让这些内存可以被用于其他目的。

// 然而，如果 ARC 销毁了一个仍在使用的实例，就无法再访问该实例的属性或调用其方法。（程序崩溃）


// 为了确保实例在需要时不会被销毁，ARC 会追踪当前有多少属性、常量和变量引用了每个类实例。
// 只要至少还有一个活动引用存在，ARC 就不会销毁该实例。

// 为了实现这一点，每当你将一个类实例赋值给一个属性、常量或变量时，
// 该属性、常量或变量就会对该实例建立一个强引用。


//  ARC 实例演示   ARC in Action

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

// 这些变量是可选类型（Person? 而非 Person），
// 它们会自动初始化为 nil，目前不引用任何 Person 实例。
var reference1: Person?
var reference2: Person?
var reference3: Person?

// 创建一个新的 Person 实例，并将其赋值给其中一个变量
// 现在 reference1 对该实例建立了一个强引用
reference1 = Person(name: "John Appleseed")
// 打印 "John Appleseed is being initialized"

// 如果将相同的 Person 实例赋值给另外两个变量，就会再建立两个强引用
reference2 = reference1
reference3 = reference1
// 此时，这个单一的 Person 实例拥有三个强引用

// 如果通过将其中两个变量赋值为 nil 来断开两个强引用（包括原始引用），
// 则仍会剩下一个强引用，因此 Person 实例不会被释放
reference1 = nil
reference2 = nil

// 直到第三个、也是最后一个强引用被断开时，ARC 才会释放 Person 实例，
// 此时系统明确知道你不再需要该实例
reference3 = nil
// 打印 "John Appleseed is being deinitialized"


//   类 实例 之间的强引用循环  Strong Reference Cycles Between Class Instances

// 在某些情况下，可能出现类实例永远无法达到引用数为零的情况，这会导致实例无法释放。
// 这种情况可能发生在两个类实例相互持有强引用的情况下，即每个实例都让另一个实例保持存活。
// 这种现象称为强引用循环。

// 以下示例展示了如何无意中创建强引用循环。
class aPerson {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: aPerson?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: aPerson?
var unit4A: Apartment?

john = aPerson(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john
// Person 实例现在有一个指向 Apartment 实例的强引用，
// 而 Apartment 实例也有一个指向 Person 实例的强引用。
// 因此，当断开 john 和 unit4A 变量的强引用时，
// 引用计数并不会降为零，实例不会被 ARC 释放：

john = nil
unit4A = nil
// 当将这两个变量设置为 nil 时，析构函数并没有被调用。
// 这是因为强引用循环阻止了 Person 和 Apartment 实例被释放，
// 从而导致了应用程序中的内存泄漏。


// 解决类实例之间的强引用循环  Resolving Strong Reference Cycles Between Class Instances
// 在使用类类型的属性时，
// Swift 提供了两种方法来解决强引用循环问题：
// 弱引用（weak reference） 和 无主引用（unowned reference）。

// 使用弱引用：当另一个实例的生命周期较短时，即当另一个实例可以先被释放时，应该使用弱引用。
// 在上面的 Apartment 示例中，一个公寓在其生命周期中的某些时刻可能没有租户，
// 因此可以使用弱引用来打破引用循环。

// 使用无主引用：当另一个实例的生命周期与当前实例相同或更长时，使用无主引用更为合适。



//  弱引用   Weak References
// 由于弱引用不会对引用的实例保持强引用，因此该实例可能在弱引用仍然引用它时被释放
// 当被引用的实例被释放时，ARC 会自动将弱引用设为 nil
// 因为弱引用在运行时需要允许其值被设置为 nil，所以弱引用必须声明为可选类型的变量，而非常量。


// 弱引用 使用关键词 weak
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    // 关键词 weak
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john
// Apartment 实例现在对 Person 实例持有弱引用


john = nil
// 打印 "John Appleseed is being deinitialized"


//   无主引用   Unowned References
// 在属性或变量声明前加上 unowned 关键字来表明它是无主引用
// 与弱引用不同的是，无主引用总是预计有一个值。
// 因此，将值标记为无主引用不会使它成为可选类型，
// 且 ARC 永远不会将无主引用的值设为 nil。

// ！！ 仅当您确信该引用始终指向一个未被释放的实例时，才使用无主引用。
// ！！ 如果在该实例被释放后尝试访问无主引用的值，将导致运行时错误。

// 一个客户可能拥有也可能不拥有信用卡，但信用卡总是与客户相关联。
// 所以Customer 类具有一个可选的 card 属性
// 而 CreditCard 类具有一个无主的（且非可选的） customer 属性。
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    //  customer 属性定义为无主引用
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var john: Customer?

john = Customer(name: "John Appleseed") // 强引用
john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!) // 强引用 无主引用
// Customer 实例现在对 CreditCard 实例保持强引用，
// 而 CreditCard 实例对 Customer 实例保持无主引用。

john = nil
// 打印 "John Appleseed is being deinitialized"
// 打印 "Card #1234567890123456 is being deinitialized"


//  无主可选引用  Unowned Optional References
// 可以将一个类的可选引用标记为无主引用
// 当使用无主可选引用时，您需要确保它始终引用一个有效对象或被设置为 nil

// 示例
class Department {
    var name: String
    var courses: [Course]
    init(name: String) {
        self.name = name
        self.courses = []
    }
}

class Course {
    var name: String
    unowned var department: Department
    unowned var nextCourse: Course?
    init(name: String, in department: Department) {
        self.name = name
        self.department = department
        self.nextCourse = nil
    }
}

let department = Department(name: "Horticulture")

let intro = Course(name: "Survey of Plants", in: department)
let intermediate = Course(name: "Growing Common Herbs", in: department)
let advanced = Course(name: "Caring for Tropical Plants", in: department)

intro.nextCourse = intermediate
intermediate.nextCourse = advanced
department.courses = [intro, intermediate, advanced]


//  无主引用和隐式解包可选属性   Unowned References and Implicitly Unwrapped Optional Properties
// 上面的 weak 和 unowned 引用示例涵盖了两种常见的场景，即在破除强引用循环时的需求

// 还有第三种情况，其中两个属性在初始化完成后都应始终有值，且都不应为 nil。
// 在这种情况下，可以在一个类中使用无主属性，并在另一个类中使用隐式解包可选属性。
// 这样在初始化完成后可以直接访问这两个属性（无需解包），同时避免了强引用循环

// 例子
// Country 类具有 capitalCity 属性，而 City 类具有 country 属性
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
// 在 Country 的初始化器中调用 City 的初始化器
// 不过，Country 的初始化器在新的 Country 实例完全初始化之前无法将 self 传递给 City 初始化器
// 为了解决此问题
// 可以将 Country 的 capitalCity 属性声明为隐式解包可选属性，类型声明末尾的感叹号表示 City!
// 意味着 capitalCity 默认值为 nil，与其他可选值相同，但在完成初始化后可直接访问，无需解包其值。


var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
// 输出 "Canada's capital city is called Ottawa"


//   闭包中的强引用循环   Strong Reference Cycles for Closures
// 强引用循环的发生是因为闭包与类一样，都是引用类型
// 当你将一个闭包赋值给一个属性时，你实际上是在赋值一个对该闭包的引用
// 这与之前的问题相同——两个强引用相互维持着对方的生存。
// 然而，这次保持对方存活的是一个类实例和一个闭包

// 闭包捕获列表

class HTMLElement {
    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }
}

let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())
// 输出 "<h1>some default text</h1>"

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
// 输出 "<p>hello, world</p>"

// HTMLElement 类在 HTMLElement 实例和用于其默认 asHTML 值的闭包之间创建了强引用循环
// 循环表现
// 实例的 asHTML 属性持有对其闭包的强引用
// 然而，由于闭包在其主体中引用 self（以访问 self.name 和 self.text），
// 闭包捕获了 self，这意味着它持有对 HTMLElement 实例的强引用。
// 尽管闭包多次引用 self，但它只捕获对 HTMLElement 实例的一个强引用

paragraph = nil
// 如果将 paragraph 变量设置为 nil，并打破其与 HTMLElement 实例的强引用
// 强引用循环将阻止两个实例的释放：



//     解决闭包中的强引用循环    Resolving Strong Reference Cycles for Closures


// 要解决闭包与类实例之间的强引用循环，可以在闭包的定义中定义一个捕获列表

//   定义捕获列表    Defining a Capture List
// 将捕获列表放在闭包的参数列表和返回类型之前（如果它们是提供的）
lazy var someClosure = {
    [unowned self, weak delegate = self.delegate]
    (index: Int, stringToProcess: String) -> String in
    // 闭包主体放在这里
}

// 如果一个闭包没有指定参数列表或返回类型（因为可以从上下文中推断），
// 则将捕获列表放在闭包的最开头，后跟 in 关键字
lazy var someClosure = {
    [unowned self, weak delegate = self.delegate] in
    // 闭包主体放在这里
}


//   弱引用和无主引用   Weak and Unowned References
// 当闭包与其捕获的实例总是彼此引用，并且总是同时释放时，将捕获定义为 unowned 引用
// 相反，当捕获的引用在将来某个时候可能会变为 nil 时，将捕获定义为 weak 引用
// 弱引用总是可选类型，并在引用的实例被释放时自动变为 nil

// 解决强引用循环的合适捕获方法是使用无主引用
class HTMLElement {
    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }
}

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
// 输出 "<p>hello, world</p>"

paragraph = nil
// 输出 "p is being deinitialized"
