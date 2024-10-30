//#####   析构器  Deinitialization   #####//
// 用于在类实例被释放（即内存被释放）之前执行清理工作。
// 使用 deinit 关键字定义


// Swift 使用 自动引用计数（ARC）来管理内存，
// 这意味着当一个实例不再被引用时，Swift 会自动释放该实例以释放资源。
// 大多数情况下，您不需要手动清理，因为 ARC 会自动处理大部分内存管理。
// 在处理自定义资源（如打开文件、网络连接等）时，
// 您可能需要执行一些额外的清理工作，例如在类实例被释放之前关闭打开的文件。


// Deinitializers in Action
class FileHandler {
    var fileName: String

    init(fileName: String) {
        self.fileName = fileName
        // 可能在这里打开文件
        print("File \(fileName) is opened.")
    }

    deinit {
        // 在析构器中关闭文件
        print("File \(fileName) is closed.")
    }
}

if true {
    let handler = FileHandler(fileName: "example.txt")
    // handler 被创建并打开了文件
}
// 当 handler 超出范围后，析构器会被调用

class Bank {
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
} 

class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}

var playerOne: Player? = Player(coins: 100)
print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
// Prints "A new player has joined the game with 100 coins"
print("There are now \(Bank.coinsInBank) coins left in the bank")
// Prints "There are now 9900 coins left in the bank"


playerOne!.win(coins: 2_000)
print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
// Prints "PlayerOne won 2000 coins & now has 2100 coins"
print("The bank now only has \(Bank.coinsInBank) coins left")
// Prints "The bank now only has 7900 coins left"

playerOne = nil
print("PlayerOne has left the game")
// Prints "PlayerOne has left the game"
print("The bank now has \(Bank.coinsInBank) coins")
// Prints "The bank now has 10000 coins"