//#####    内存安全   Memory Safety   #####//
// 理解潜在冲突发生的位置，以避免编写存在内存访问冲突的代码

//  理解内存访问的冲突   Understanding Conflicting Access to Memory

// 写入对存储了值 1 的内存的访问。
var one = 1

// 从存储了值 1 的内存的读取访问。
print("We're number \(one)!")


//  概念：临时的无效状态  it’s in a temporary, invalid state


//  内存访问的特征   Characteristics of Memory Access

// 如果你有两个访问符合以下所有条件，就会发生冲突：
// 这两个访问都不是读，也不是原子操作。
// 它们访问同一个内存位置。
// 它们的持续时间重叠。


// 下面代码中的所有读写访问都是瞬时的
func oneMore(than number: Int) -> Int {
    return number + 1
}

var myNumber = 1
myNumber = oneMore(than: myNumber)
print(myNumber)
// 输出 "2"


// 对 in-out 参数的冲突访问   Conflicting Access to In-Out Parameters
// 函数对其所有 in-out 参数具有长期写访问
// in-out 参数的写访问在所有非 in-out 参数被评估后开始，并在整个函数调用期间持续
// 如果有多个 in-out 参数，则写访问按照参数出现的顺序开始。

// 无法访问作为 in-out 传递的原始变量，
// 即使作用域规则和访问控制通常允许这样做——对原始变量的任何访问都会产生冲突。
// 例子
var stepSize = 1 // 全局变量

func increment(_ number: inout Int) {
    number += stepSize  // 内部访问全局变量
}

increment(&stepSize)
// 错误：对 stepSize 的冲突访问
// 对 stepSize 的读取访问与对 number 的写入访问重叠
// number 和 stepSize 都指向内存中的同一位置。
// 读取和写入访问都指向相同的内存，并且它们重叠，从而产生冲突。

// 解决此冲突的一种方法是显式地复制 stepSize
// 制作一个显式副本。
var copyOfStepSize = stepSize
increment(&copyOfStepSize)

// 更新原始变量。
stepSize = copyOfStepSize
// stepSize 现在是 2


// 将单个变量作为相同函数的多个 in-out 参数传递会产生冲突。
// 例如
func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)  // OK 虽然有两个写访问在时间上重叠，但它们访问的是内存中的不同位置
balance(&playerOneScore, &playerOneScore)
// 错误：对 playerOneScore 的冲突访问
// 将 playerOneScore 作为两个参数的值传递会产生冲突，
// 因为它试图在同一时间对内存中的同一位置执行两个写访问


//  方法中 self 的冲突访问    Conflicting Access to self in Methods

// 结构的变异方法在方法调用期间对 self 具有写访问
struct Player {
    var name: String
    var health: Int
    var energy: Int

    static let maxHealth = 10
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
oscar.shareHealth(with: &maria)  // OK
