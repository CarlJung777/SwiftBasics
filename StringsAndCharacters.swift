//#####   Strings And Characters   #####//
// 字符串（String）和字符（Character）是用来存储和操作文本的基本类型


// String Literals 字符串字面量
let someString = "Some string literal value"


// Multiline String Literals 多行字符串字面量
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
// backslash
// 不希望这些换行符成为字符串值的一部分，可以在行末添加一个反斜杠（\）
let softWrappedQuotation = """
The White Rabbit put on his spectacles.  "Where shall I begin, \
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on \
till you come to the end; then stop."
"""
// 字符串缩进
// 整个多行字符串字面量缩进，第一行和最后一行都没有缩进
let lineBreaks = """

This string starts with a line break.
It also ends with a line break.

"""

// Special Characters in String Literals
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
// "Imagination is more important than knowledge" - Einstein
let dollarSign = "\u{24}"        // $,  Unicode scalar U+0024
let blackHeart = "\u{2665}"      // ♥,  Unicode scalar U+2665
let sparklingHeart = "\u{1F496}" // 💖, Unicode scalar U+1F496

// 使用三个引号就可以在字符串中添加双引号
let threeDoubleQuotationMarks = """
Escaping the first quotation mark \"""
Escaping all three quotation marks \"\"\"
"""

// Extended String Delimiters 扩展字符串定界符

let myString = #"Line 1\nLine 2"#
print(myString) // 输出 Line 1\nLine 2，而不是将其视为换行

let breakLine = #"Line 1\#nLine 2"#
print(breakLine)// \#n 被处理为换行，因此会在输出中产生换行

let multiBreakLine = ###"Line1\###nLine2"###
print(multiBreakLine) // ### 的存在使得 \n 被解析为换行，因此输出会分成两行

let threeMoreDoubleQuotationMarks = #"""
Here are three more double quotes: """
"""#
// 其中包含了三重引号（"""），而不会导致字符串字面量的意外结束。


// Initializing an Empty String  初始化空字符串
var emptyString = ""               // empty string literal
var anotherEmptyString = String()  // initializer syntax
// these two strings are both empty, and are equivalent to each other

if emptyString.isEmpty {
    print("Nothing to see here")
}
// Prints "Nothing to see here"


// String Mutability  字符串的可变性

var variableString = "Horse"
variableString += " and carriage"
// variableString 现在的值是 "Horse and carriage"
// 如果将字符串赋值给一个常量（let），则该字符串是不可变的


// 字符串是值类型  Strings Are Value Types 
// 只有在确实需要复制时才会执行实际的复制操作
var originalString = "Hello"
var copiedString = originalString  // 这里 copiedString 是 originalString 的一个副本
copiedString += ", World!"         // 修改 copiedString 不会影响 originalString
print(originalString)               // 输出: Hello
print(copiedString)                 // 输出: Hello, World!


// Working with Characters  处理字符串中的字符

for character in "Dog!🐶" {
    print(character)
} 
// 输出
// D
// o
// g
// !
// 🐶

// 将 Character 数组作为参数传递给 String 的初始化器来构建字符串
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)  // 输出 "Cat!🐱"


// Concatenating Strings and Characters 字符串和字符的连接

// 使用加法运算符将两个字符串连接在一起，生成一个新的字符串值
let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2
// welcome 现在等于 "hello there"

// 用加法赋值运算符，将一个字符串值追加到已有的字符串变量中
var instruction = "look over"
instruction += string2
// instruction 现在等于 "look over there"

// 使用 String 类型的 append() 方法将一个字符追加到字符串变量中

let exclamationMark: Character = "!"
welcome.append(exclamationMark)
// welcome 现在等于 "hello there!"


// String Interpolation  字符串插值
// 占位符用 \( ... ) 语法 
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message 是 "3 times 2.5 is 7.5"

// 用扩展字符串定界符
print(#"Write an interpolated string in Swift using \(multiplier)."#)
// 打印 "Write an interpolated string in Swift using \(multiplier)."

// 多个数值定界符
print(#"6 times 7 is \#(6 * 7)."#)
// 打印 "6 times 7 is 42."



// Unicode  统一码

// Unicode Scalar Values  Unicode  标量值
let characterA = "\u{0061}" // Unicode for 'a'
let babyChick = "\u{1F425}" // Unicode for '🐥' (Front-Facing Baby Chick)

print("Character for U+0061: \(characterA)") // Output: Character for U+0061: a
print("Character for U+1F425: \(babyChick)")  // Output: Character for U+1F425: 🐥

// Extended Grapheme Clusters  扩展音节簇
let eAcute: Character = "\u{E9}"                         // é
let combinedEAcute: Character = "\u{65}\u{301}"          // e followed by ́

// Regional Indicator Symbols  区域指示符符号
let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"
// regionalIndicatorForUS 是 🇺🇸


//  Counting Characters  字符的计数
let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
print("unusualMenagerie has \(unusualMenagerie.count) characters")
// 输出 unusualMenagerie has 40 characters