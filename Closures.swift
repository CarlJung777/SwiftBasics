//#####   Clsures   #####//
// 闭包（Closures）是一种可以在代码中捕获并存储变量和常量的代码块或函数
// Swift 中，闭包是一等公民，这意味着它们可以像变量一样被赋值给变量、传递给函数、并在函数中被返回。
// Closures are self-contained blocks of functionality
// that can be passed around and used in your code. 
// Global and nested functions, as introduced in Functions,
// are actually special cases of closures

// Closures take one of three forms:
// 1.Global functions are closures that have a name and don’t capture any values.
// 2.Nested functions are closures that have a name and can capture values from their enclosing function.
// 3.Closure expressions are unnamed closures written in a lightweight syntax that can capture values from their surrounding context.

// The Sorted Method
// sorted(by:)
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]

//#####   Closure Expression Syntax  #####//

// { (<#parameters#>) -> <#return type#> in
//    <#statements#>
// }

// { (参数) -> 返回类型 in
//     // 闭包体
// }
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )


//#####   Inferring Type From Context  #####//
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

// Implicit Returns from Single-Expression Closures
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )


//#####   Shorthand Argument Names  #####//
reversedNames = names.sorted(by: { $0 > $1 } )

//#####   Operator Methods  #####//
reversedNames = names.sorted(by: >)



//#####   Trailing Closures  #####//
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body goes here
}

// Here's how you call this function without using a trailing closure:

someFunctionThatTakesAClosure(closure: {
    // closure's body goes here
})

// Here's how you call this function with a trailing closure instead:


someFunctionThatTakesAClosure() {
    // trailing closure's body goes here
}

reversedNames = names.sorted() { $0 > $1 }
reversedNames = names.sorted { $0 > $1 }

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
// strings is inferred to be of type [String]
// its value is ["OneSix", "FiveEight", "FiveOneZero"]



func loadPicture(from server: Server, completion: (Picture) -> Void, onFailure: () -> Void) {
    if let picture = download("photo.jpg", from: server) {
        completion(picture)
    } else {
        onFailure()
    }
}

loadPicture(from: someServer) { picture in
    someView.currentPicture = picture
} onFailure: {
    print("Couldn't download the next picture.")
}



//#####   Capturing Values 闭包捕获值  #####//
// 返回一个闭包 () -> Int，表示这是一个不接受参数并返回 Int 的闭包。
func makeIncrementer(incrementAmount: Int) -> () -> Int {
    var total = 0
    let incrementer: () -> Int = {   // 在这里捕获
        total += incrementAmount
        return total
    }
    return incrementer
}

let incrementByTwo = makeIncrementer(incrementAmount: 2)
print(incrementByTwo())  // 输出: 2
print(incrementByTwo())  // 输出: 4
// 闭包 incrementer 捕获了 total 和 incrementAmount，
// 即使它们在 makeIncrementer 作用域之外，仍然可以继续使用和修改。


//#####   Closures Are Reference Types 闭包是引用类型  #####//
// 在变量或常量之间传递时，其引用的实例不会被复制，而是会保持对原始实例的引用。
// 将一个闭包赋值给多个不同的变量或常量时，它们实际上都指向同一个闭包实例。
// 闭包捕获了某个外部变量（如累加器变量）并修改它时，所有指向这个闭包的引用都会看到该变量的更新值，
// 这也是闭包可以在某个环境中保持状态的原因。

// 闭包之所以是引用类型
// 是因为它可能捕获的变量需要在多次调用时保持和更新状态
// 这样，闭包可以像“存储属性”一样持续跟踪状态，避免在不同调用间丢失数据
// 这种特性非常适用于多次调用之间共享状态的场景

func makeCounter() -> () -> Int {
    var count = 0
    let incrementer: () -> Int = {
        count += 1
        return count
    }
    return incrementer
}
let counter1 = makeCounter()
let counter2 = counter1
print(counter1())  // 输出 1
print(counter1())  // 输出 2
print(counter2())  // 输出 3
// counter1 和 counter2 都引用了同一个闭包实例 incrementer
// 它们访问的是同一个捕获的 count 变量，所以 count 值会继续累加。


//#####   Escaping Closures  #####//



//#####   Autoclosures  #####//


