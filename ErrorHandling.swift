//#####   错误处理  Error Handling   #####//


//  错误的表示和抛出   Representing and Throwing Errors
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}
throw VendingMachineError.insufficientFunds(coinsNeeded: 5)

//  Swift 中有四种处理错误的方法
// 可以将错误从函数传播到调用该函数的代码中，使用 do-catch 语句处理错误，
// 将错误作为可选值处理，或断言错误不会发生

//  使用抛出函数传播错误  Propagating Errors Using Throwing Functions  //
func canThrowErrors() throws -> String
func cannotThrowErrors() -> String
// 抛出函数会将它内部抛出的错误传播到调用它的范围内。

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0

    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }

        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }

        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem

        print("Dispensing \(name)")
    }
}

// 由于 vend(itemNamed:) 方法会传播它抛出的任何错误，
// 因此调用该方法的任何代码必须处理这些错误
// 使用 do-catch 语句、try? 或 try!，或者继续传播它们。
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}


struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}


//   使用 do-catch 处理错误  Handling Errors Using Do-Catch   //
do {
    try <#expression#>
    <#statements#>
} catch <#pattern 1#> {
    <#statements#>
} catch <#pattern 2#> where <#condition#> {
    <#statements#>
} catch <#pattern 3#>, <#pattern 4#> where <#condition#> {
    <#statements#>
} catch {
    <#statements#>
}
// 在 catch 后面你可以写一个模式，来指示该子句可以处理哪些错误。
// 如果 catch 子句没有模式，该子句匹配任何错误，并将错误绑定到一个名为 error 的局部常量中。
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}
// Prints "Insufficient funds. Please insert an additional 2 coins."

// 上面的 do--catch 例子可以这样写，以便处理任何不是 VendingMachineError 的错误：
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Couldn't buy that from the vending machine.")
    }
}

do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
}
// Prints "Couldn't buy that from the vending machine."


// 用逗号列出多个错误
func eat(item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch VendingMachineError.invalidSelection, VendingMachineError.insufficientFunds, VendingMachineError.outOfStock {
        print("Invalid selection, out of stock, or not enough money.")
    }
}

//  指定错误类型  Specifying the Error Type
enum StatisticsError: Error {
    case noRatings
    case invalidRating(Int)
}
// 要指定一个函数只抛出 StatisticsError 类型的错误，
// 可以在函数声明时写 throws(StatisticsError) 
func summarize(_ ratings: [Int]) throws(StatisticsError) {
    guard !ratings.isEmpty else { throw .noRatings }

    var counts = [1: 0, 2: 0, 3: 0]
    for rating in ratings {
        guard rating > 0 && rating <= 3 else { throw .invalidRating(rating) }
        counts[rating]! += 1
    }

    print("*", counts[1]!, "-- **", counts[2]!, "-- ***", counts[3]!)
}
// 在普通的抛出函数中调用使用类型化抛出的函数
func someThrowingFunction() throws {
    let ratings = [1, 2, 3, 2, 2, 1]
    try summarize(ratings)
}
// 还可以将错误类型显式写为 throws(any Error)；以下代码等同于上述代码：
func samesomeThrowingFunction() throws(any Error) {
    let ratings = [1, 2, 3, 2, 2, 1]
    try summarize(ratings)
}

// 不会抛出错误的函数
func nonThrowingFunction() throws(Never) {
    // ...
}

// 还可以为 do-catch 语句编写特定的错误类型
let ratings = []
do throws(StatisticsError) {
    try summarize(ratings)
} catch {
    switch error {
    case .noRatings:
        print("No ratings available")
    case .invalidRating(let rating):
        print("Invalid rating: \(rating)")
    }
}
// Prints "No ratings available"


// 类型推断下面抛出 StatisticsError
let ratings = []
do {
    try summarize(ratings)
} catch {
    switch error {
    case .noRatings:
        print("No ratings available")
    case .invalidRating(let rating):
        print("Invalid rating: \(rating)")
    }
}
// Prints "No ratings available"


//  将错误转换为可选值  Converting Errors to Optional Values
func someThrowingFunction() throws -> Int {
    // 这个函数可能抛出错误
}

let x = try? someThrowingFunction() // x 是 Int? 类型


let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil // 如果发生错误，y 设置为 nil
}


// 可以使用 try! 来断言该函数不会抛出错误
let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg") // 断言这个操作不会失败


//  指定错误类型   Specifying the Error Type

enum StatisticsError: Error {
    case noRatings
    case invalidRating(Int)
}

func summarize(_ ratings: [Int]) throws(StatisticsError) {
    guard !ratings.isEmpty else { throw .noRatings }
    var counts = [1: 0, 2: 0, 3: 0]
    for rating in ratings {
        guard rating > 0 && rating <= 3 else { throw .invalidRating(rating) }
        counts[rating]! += 1
    }
    print("*", counts[1]!, "-- **", counts[2]!, "-- ***", counts[3]!)
}

//  在 do-catch 中使用特定错误类型
let ratings = []
do throws(StatisticsError) {
    try summarize(ratings)
} catch {
    switch error {
    case .noRatings:
        print("没有可用的评分")
    case .invalidRating(let rating):
        print("无效评分: \(rating)")
    }
}
// 输出 "没有可用的评分"


//   指定清理操作   Specifying Cleanup Actions
// 使用 defer 指定清理操作  // differre 拉丁语 推迟
// defer 语句用于在退出当前代码块之前执行一组语句
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file) // 确保文件会在离开作用域时关闭
        }
        while let line = try file.readline() {
            // 处理文件
        }
        // close(file) 在作用域结束时被调用
    }
}
