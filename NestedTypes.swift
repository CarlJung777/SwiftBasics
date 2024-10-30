//#####   嵌套类型  Nested Types   #####//
// Swift 允许定义嵌套类型，即将支持类型（如枚举、结构体和协议）嵌套在其支持的类型的定义内。


// Nested Types in Action
// BlackjackCard 结构包含两个嵌套的枚举类型，分别叫做 Suit 和 Rank
struct BlackjackCard {
    // 嵌套的 Suit 枚举
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }

    // 嵌套的 Rank 枚举
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        
        struct Values {
            let first: Int, second: Int?
        }
        
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }

    // BlackjackCard 的属性和方法
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}
// Rank 和 Suit 嵌套在 BlackjackCard 内，但其类型可以通过上下文推断，
// 因此该实例的初始化能够仅通过其情况名称（.ace 和 .spades）进行引用。
let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
print("theAceOfSpades: \(theAceOfSpades.description)")
// 打印 "theAceOfSpades: suit is ♠, value is 1 or 11"


//  引用嵌套类型    Referring to Nested Types 
let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
// heartsSymbol 是 "♡"
