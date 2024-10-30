//#####   可选链 Optional Chaining   #####//
// 可选链（Optional Chaining）允许在可能为 nil 的可选值上安全地访问属性、方法和下标。

class sPerson {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

let xjohn = sPerson()
let roomCount = xjohn.residence!.numberOfRooms
// 这会引发运行时错误，因为 residence 为 nil

if let roomCount = xjohn.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}
// 输出: "Unable to retrieve the number of rooms."
// 可以为 john.residence 赋值，使其不再为 nil：
xjohn.residence = Residence()



// 定义可选链接的模型类  Defining Model Classes for Optional Chaining
// 下面定义了四个模型类：Person、Residence、Room 和 Address。
// 这些类通过关联的属性和方法相互连接，形成一个复杂的模型结构。
class Person {
    var residence: sResidence?
}

class sResidence {
    var rooms: [Room] = []
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}


class Room {
    let name: String
    init(name: String) { self.name = name }
}


class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}

let john = Person()
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}


// 通过可选链访问属性 Calling Methods Through Optional Chaining
let sjohn = Person()
if let roomCount = sjohn.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}
// Prints "Unable to retrieve the number of rooms."

// 通过可选链设置属性
let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
john.residence?.address = someAddress

// 使用函数演示可选链的效果
func createAddress() -> Address {
    print("Function was called.")
    
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    
    return someAddress
}

john.residence?.address = createAddress()


// 通过可选链访问下标  Accessing Subscripts Through Optional Chaining
if let firstRoomName = sjohn.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}
// Prints "Unable to retrieve the first room name."

 

//  访问可选类型的下标  Accessing Subscripts of Optional Type
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72
// The "Dave" array is now [91, 82, 84] and the "Bev" array is now [80, 94, 81]


//  多层可选链操作  Linking Multiple Levels of Chaining
if let johnsStreet = john.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}
// Prints "Unable to retrieve the address."


// 链接带有可选返回值的方法  Chaining on Methods with Optional Return Values
if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
    print("John's building identifier is \(buildingIdentifier).")
}
// Prints "John's building identifier is The Larches."
// buildingIdentifier() 返回 String?，并且通过可选链调用后，最终的返回类型也是 String?。
// 如果方法返回值为 nil，则整个表达式的结果也是 nil。