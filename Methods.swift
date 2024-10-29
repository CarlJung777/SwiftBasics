//#####   Methods   #####//
// **方法（methods）**是与特定对象或数据类型关联的函数或过程
// 方法可以直接操作该对象的属性、调用其功能，通常是面向对象编程的核心部分
// 方法的设计目的是为了提供和封装操作某个对象的行为，使得操作更加模块化和便于复用

// 方法属于类或对象：方法通常是类的成员，用于操作对象的属性或执行特定任务。
// 封装：方法将特定功能封装在一个函数体内，提高代码的可读性和复用性。
// 可以接受参数：方法可以接受参数，用于执行特定任务或操作。
// 返回值：方法可以返回一个值，或执行操作后不返回任何值。

// 在 Swift 中，方法分为实例方法（Instance Methods）和类型方法（Type Methods）


//  Counter 类的示例，包含三个实例方法
class Counter {
    var count = 0

    func increment() {
        count += 1
    }

    func increment(by amount: Int) {
        count += amount
    }

    func reset() {
        count = 0
    }
}


let counter = Counter()  // 创建一个 Counter 实例，初始值 count 为 0
counter.increment()      // count 的值变为 1
counter.increment(by: 5) // count 的值变为 6
counter.reset()          // count 的值重置为 0


//#####   self 属性 The self Property    #####//
// 每个类型的实例都有一个隐式的 self 属性，它表示实例本身
struct Point {
    var x = 0.0, y = 0.0

    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x  // self.x 表示实例的 x 属性
    }
}

let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}
// 输出: This point is to the right of the line where x == 1.0
// 如果不写 self，Swift 会认为 x 指的是方法参数 x，而不是实例的 x 属性。

//#####   Modifying Value Types from Within Instance Methods    #####//
// 结构体和枚举是值类型，它们的属性在实例方法中默认不能被修改
// 如果需要在方法内修改结构体或枚举的属性，可以在方法前加上 mutating 关键字来“允许修改”。

struct aPoint {
    var x = 0.0, y = 0.0
    
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var asomePoint = aPoint(x: 1.0, y: 1.0)
asomePoint.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint.x), \(somePoint.y))")
// 输出 "The point is now at (3.0, 4.0)"
// 常量不可调用 mutating 方法

//#####   Type Methods 类型方法    #####//
// 类型方法（type methods）是与类型本身关联的方法，而不是特定实例的方法
// 通过在方法前使用 static 关键字，可以在结构体、枚举和类中定义类型方法


struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1

    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }

    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }

    // @discardableResult 属性用于允许调用者忽略返回值，而不会触发编译器警告
    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}


class Player {
    var tracker = LevelTracker()
    let playerName: String

    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }

    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
// 输出 "highest unlocked level is now 2"

player = Player(name: "Beto")
if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 hasn't yet been unlocked")
}
// 输出 "level 6 hasn't yet been unlocked"
