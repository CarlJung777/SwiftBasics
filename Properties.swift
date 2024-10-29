//#####   Properties   #####//
// **属性（Properties）**用于将值与特定的类、结构体或枚举类型关联
// 属性可以分为存储属性（stored properties）、计算属性（computed properties）、
// 类型属性（type properties）和属性观察器（property observers）。


//#####   Stored Properties 存储属性   #####//

//#####   Stored Properties of Constant Structure Instances 常量结构体实例的存储属性   #####//
struct FixedLengthRange {
    var firstValue: Int  
    let length: Int      
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
rangeOfFourItems.firstValue = 6 // 会报错
// 将结构体实例赋值给一个常量（用 let 声明），那么该实例的所有属性都将无法修改，哪怕它们是变量属性。

// 懒加载存储属性（Lazy Stored Properties）
class DataImporter {
    var filename = "data.txt"
}

class DataManager {
    lazy var importer = DataImporter()
    var data: [String] = []
}

let manager = DataManager()
print(manager.importer.filename) // 只有在访问时才会创建 DataImporter 实例

//#####   Computed Properties 计算属性   #####//
// 计算属性（Computed Properties） 是不直接存储值的属性，
// 而是通过获取器（getter）和可选的设置器（setter）来间接获取或设置其他属性或值。
// 类、结构体和枚举都可以定义计算属性。

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center  // (5.0, 5.0)
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
// 打印 "square.origin is now at (10.0, 10.0)"
// 在不直接存储值的情况下，能够动态计算和更新属性。


//#####   Read-Only Computed Properties 只读计算属性  #####//
// 只读计算属性是指只有 getter 而没有 setter 的计算属性。
// 这种属性总是返回一个值，可以通过点语法访问，但不能被赋值。

struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    // 这个属性没有 setter，所以不能直接给 volume 赋值，因为体积的计算依赖于宽度、高度和深度的值。
    var volume: Double {  
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
// Prints "the volume of fourByFiveByTwo is 40.0"


//#####   Property Observers 属性观察者  #####//
// willSet 将要设置：在属性的值被修改之前调用
// didSet  已经设置：在属性的值被修改之后立即调用
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
// 定义了一个名为 totalSteps 的存储属性
// 该属性具有 willSet 和 didSet 观察者

let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps

stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps

stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps


//#####   Property Wrappers 属性包装器  #####//
// 可以将属性存储和管理逻辑分离开来，从而提高代码的重用性和可读性

@propertyWrapper
struct TwelveOrLess {
    private var number = 0

    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }  //  setter 确保了值始终小于或等于 12。
    }
}

struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}


// 属性包装器还可以定义投影值（projected value）。
// 投影值是一种附加功能，可以通过在属性名前加上 $ 符号来访问


//#####   Type Properties 类型属性  #####//
// 无论创建了多少该类型的实例，类型属性只会有一个拷贝。
// 因此，所有实例都共享该类型属性。
// 用 static 关键字声明
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}

enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}

class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

print(SomeStructure.storedTypeProperty) // 输出 "Some value."
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)  // 输出 "Another value."
// 访问类型属性时是在类型本身上操作，而不是在某个特定实例上。

