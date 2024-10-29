//#####   Subscripts 下标   #####//
// **Subscripts（下标）**在 Swift 中是用于访问集合、列表或序列的元素的快捷方式
// 自定义下标：Swift 允许开发者为自定义类型定义自己的下标，
// 这使得可以在自定义类型中使用下标语法来获取或设置值

// 定义和使用：下标允许使用一组标识符（如索引或键）来直接访问数据结构中的元素。
// 通常，它们使用方括号 [] 来表示

// 一个只读下标的实现 
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")  // 输出 "six times three is 18"


// Subscript Usage
var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
numberOfLegs["ant"] = nil  // 删除键 "ant" 对应的值
print(numberOfLegs)  // 输出 ["spider": 8, "cat": 4]


// Subscript Options
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }

    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    // 下标实现
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5  // 设置矩阵第一行第二列的值
matrix[1, 0] = 3.2  // 设置矩阵第二行第一列的值
let someValue = matrix[2, 2]  // 这将触发一个断言，因为 [2, 2] 超出了矩阵的范围。


// Type Subscripts
// 允许在类型本身上调用而不是在类型的实例上调用
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    
    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
}

let whatPlanet = Planet[4]
print(whatPlanet)

