//#####   Basic Operators 运算符  #####//
// 赋值运算符 = 不返回值，以避免错误地将其用于比较操作（即错用 = 而不是 == 比较运算符）
// 算术运算符，Swift 会自动检测和阻止值的溢出，这样能避免数据溢出问题。
// 运算符按作用对象的数量分为一元、二元和三元运算符 Unary operators  Binary operators Ternary operators 
// Operand 操作数是运算符作用的对象。例如在表达式 1 + 2 中，+ 是中缀运算符，而 1 和 2 是它的操作数。


// Assignment Operator 赋值运算符
// 语法是 a = b，表示将右边表达式 b 的值赋给左边的变量 a


// Arithmetic Operators 算数运算符
// Addition (+)
// Subtraction (-)
// Multiplication (*)
// Division (/)

// Swift 中的余数运算符返回的是一个余数，
// 而不是模值（即不论是负数或正数，返回的结果可能会与某些编程语言的模运算符有所不同）。
// Remainder Operator  余数运算符(%)
print(9 % 4)    // 结果是 1
print(-9 % 4 ) // 结果是 -1

// 这里运算符(%)后面的数字的负值被忽略
let result1 = 9 % 4    // 结果是 1
let result2 = 9 % -4   // 结果也是 1


// Unary Minus Operator 一元负号运算符(-)
let three = 3
let minusThree = -three       // minusThree 的值为 -3
let plusThree = -minusThree   // plusThree 的值为 3，即“负负得正”
// Unary Plus Operator 一元正号运算符(+)
// 一元正号运算符只是简单地返回其操作的值，而不改变该值。
// 它的作用在于明确表示一个值是正的，但实际上并没有任何变化。
let minusSix = -6
let alsoMinusSix = +minusSix  // alsoMinusSix 的值为 -6

let value = -5
let result = +value + 3  // 使用一元正号运算符增加了代码的一致性
print(result)  // 输出 -2

// Compound Assignment Operators 复合赋值运算符
// 加法赋值运算符（+=）
// 减法赋值运算符（-=）
// 乘法赋值运算符（*=）
// 除法赋值运算符（/=）

// Comparison Operators  比较运算符
// 比较两个值并返回一个布尔值（Bool）
// 相等运算符（==）
// 不相等运算符（!=）
// 大于运算符（>）
// 小于运算符（<）
// 大于或等于运算符（>=）
// 小于或等于运算符（<=）


// 元组比较
var f = (1, "zebra") < (2, "apple")   // true，因为 1 小于 2；"zebra" 和 "apple" 不进行比较
var g = (3, "apple") < (3, "bird")    // true，因为 3 等于 3，而 "apple" 小于 "bird"
var h = (4, "dog") == (4, "dog")      // true，因为 4 等于 4，而 "dog" 等于 "dog"

var d = ("blue", -1) < ("purple", 1)        // OK，评估为 true
var s = ("blue", false) < ("purple", true)  // 错误，因为 < 不能比较布尔值

// Ternary Conditional Operator  三元条件运算符
// question ? answer1 : answer2
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)
// rowHeight 等于 90

// 上面的代码可以被看作是以下更详细的 if 语句的简写
let LLcontentHeight = 40
let LLhasHeader = true
let LLrowHeight: Int
if LLhasHeader {
    LLrowHeight = LLcontentHeight + 50
} else {
    LLrowHeight = LLcontentHeight + 20
}
// rowHeight 等于 90


// Nil-Coalescing Operator  空合并运算符
//  a != nil ? a! : b


let defaultColorName = "red"
var userDefinedColorName: String?   // 默认为 nil

var colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName 为 nil，因此 colorNameToUse 被设置为默认值 "red"


userDefinedColorName = "green"
colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName 不为 nil，因此 colorNameToUse 被设置为 "green"


//#####   Range Operators  #####//
// Closed Range Operator  闭区间运算符
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
// 输出：
// 1 times 5 is 5
// 2 times 5 is 10
// 3 times 5 is 15
// 4 times 5 is 20
// 5 times 5 is 25

// Half-Open Range Operator 半开区间运算符
// 表示方式为 a..<b，被称为“半开”是因为它包含第一个值，但不包含最后一个值
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    print("Person \(i + 1) is called \(names[i])")
}
// 输出：
// Person 1 is called Anna
// Person 2 is called Alex
// Person 3 is called Brian
// Person 4 is called Jack

// One-Sided Ranges
// 用于一个方向无限延续的范围
// names[2...] 下标2直到最后。
// names[...2] 从最开始到下标 2
// names[..<2] 从最开始到下标 2 的前一位
for name in names[2...] {
    print(name)
}
// 输出：
// Brian
// Jack

let range = ...5  // range 是一个从负无穷大到 5 的范围



// Logical Operators  逻辑运算符

// 逻辑非（Logical NOT）(!a)
// 逻辑与（Logical AND）(a && b)
// 逻辑或（Logical OR）(a || b)

// 组合逻辑运算符 Combining Logical Operators 
// 具有多个逻辑运算符的复合表达式从左到右依次计算

// Explicit Parentheses 显式括号
let enteredDoorCode = true
let passedRetinaScan = false
let hasDoorKey = false
let knowsOverridePassword = true
// 使用括号将 enteredDoorCode && passedRetinaScan 包围起来，
// 表示这两个条件被视为一个单独的可能状态
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
// 输出 "Welcome!"
