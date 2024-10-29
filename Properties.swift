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