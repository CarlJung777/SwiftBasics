//#####   Inheritance   #####//
// 继承（Inheritance）是面向对象编程的一项基本特性，
// 它允许一个类（子类）从另一个类（超类）继承属性和方法，从而实现代码的重用和扩展
// 超类（Superclass）：被继承的类，也称为基类或父类
// 子类（Subclass）：继承自超类的类。子类可以添加新的属性和方法，也可以重写从超类继承的方法和属性

// Defining a Base Class
class Vehicle {
    var currentSpeed = 0.0 // 存储属性
    // 计算属性
    var description: String { 
        return "traveling at \(currentSpeed) miles per hour"
    }
    // 方法
    func makeNoise() { 
        // do nothing - an arbitrary vehicle doesn't necessarily make a noise
    }
}
// 使用初始化器创建 Vehicle 的一个实例
let someVehicle = Vehicle()
print("Vehicle: \(someVehicle.description)")
// Vehicle: traveling at 0.0 miles per hour


//   子类（Subclassing）
class Bicycle: Vehicle {
    var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true

bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")
// 输出: Bicycle: traveling at 15.0 miles per hour
// 子类自动获得超类的所有属性和方法，包括存储属性和计算属性
// 子类可以重写从超类继承的方法，以修改其行为，或者添加新的方法和属性

// 子类的进一步继承
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}

let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")
// 输出: Tandem: traveling at 22.0 miles per hour

// 重写（Overriding）
// 子类提供其自定义实现的方法、属性或下标，替代其从超类继承的默认实现

class anotherVehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    
    func makeNoise() {
        // 基类的默认实现
    }
}

class anotherBicycle: anotherVehicle {
    var hasBasket = false
    
    // override 关键字
    override var description: String {
        return "Bicycle: traveling at \(currentSpeed) miles per hour" + (hasBasket ? " with a basket" : "")
    }
    
    // override 关键字
    override func makeNoise() {
        print("Ring ring")
    }
}


// Accessing Superclass Methods, Properties, and Subscripts
// 使用 super 访问超类的实现
class blackVehicle {
    func makeNoise() {
        print("Some noise")
    }
}

class blackBicycle: blackVehicle {
    override func makeNoise() {
        super.makeNoise() // 调用超类的方法
        print("Ring ring") // 添加新的行为
    }
}

let BlackBicycle = blackBicycle()
BlackBicycle.makeNoise()
// 输出：
// Some noise
// Ring ring
// 重写属性的 getter 或 setter 时，可以使用 super 关键字来访问超类的同名属性。
// 当重写一个下标时，也可以使用 super 来访问超类的同名下标。



// Overriding Methods(重写方法)
// 重写属性的 Getter 和 Setter  Overriding Property Getters and Setters
class Car: Vehicle {
    var gear = 1

    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")
// 输出: Car: traveling at 25.0 miles per hour in gear 3

// 重写属性观察者  Overriding Property Observers
class AutomaticCar: Car {
    override var currentSpeed: Double {
        // didSet 观察者
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")
// 输出: AutomaticCar: traveling at 35.0 miles per hour in gear 4

// 防止重写  Preventing Overrides
// 使用 final 修饰符来防止方法、属性或下标被重写
final class FinalVehicle {
    final func makeNoise() {
        print("This is a final method and cannot be overridden.")
    }
}
