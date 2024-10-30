//#####     类型转换    Type Casting   #####//
// 确定值的运行时类型，并赋予其更具体的类型信息。

//   定义类型转换的类层次结构   Defining a Class Hierarchy for Type Casting

// 可以使用类和子类的层次结构进行类型转换，
// 以检查特定类实例的类型，并将该实例转换为同一层次结构中的另一个类。

// 定义了一个新的基类 MediaItem
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}
// 子类 Movie 
class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}
// 子类 Song
class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}
// 由于用数组字面量初始化它，
// Swift 的类型检查器能够推断出 Movie 和 Song 具有共同的超类 MediaItem，
// 因此推断出 library 数组的类型为 [MediaItem]
let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// "library" 的类型被推断为 [MediaItem]


//    检查类型   Checking Type   // 

//  使用类型检查操作符 is
var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}

print("Media library contains \(movieCount) movies and \(songCount) songs")
// 打印 "Media library contains 2 movies and 3 songs"


//   向下转换    Downcasting

// 某个特定类类型的常量或变量可能实际上在幕后引用的是一个子类的实例
// 可以尝试使用类型转换操作符 as? 或 as! 将其向下转换为子类类型

// 由于向下转换可能失败，类型转换操作符有两种不同的形式。
// 条件形式 as? 返回你尝试向下转换的类型的可选值。
// 强制形式 as! 尝试向下转换并将结果强制解包为单个复合操作

// 无法预先知道每个项目实际的类，
// 因此在每次循环中使用类型转换操作符的条件形式 as? 检查向下转换是合适的
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}

// 输出:
// Movie: Casablanca, dir. Michael Curtiz
// Song: Blue Suede Shoes, by Elvis Presley
// Movie: Citizen Kane, dir. Orson Welles
// Song: The One And Only, by Chesney Hawkes
// Song: Never Gonna Give You Up, by Rick Astley
// 类型转换并不会实际修改实例或改变其值。底层实例保持不变；它只是被视为已被转换到其被转换类型的实例。


//  用于 Any 和 AnyObject 的类型转换   Type Casting for Any and AnyObject

// Swift 提供了两种特殊类型以处理不具体的类型：
// Any 可以表示任何类型的实例，包括函数类型。
// AnyObject 可以表示任何类类型的实例。


var things: [Any] = []


things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })


for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}


// zero as an Int
// zero as a Double
// an integer value of 42
// a positive double value of 3.14159
// a string value of "hello"
// an (x, y) point at 3.0, 5.0
// a movie called Ghostbusters, dir. Ivan Reitman
// Hello, Michael


// Any 类型表示任何类型的值，包括可选类型。
// 如果你在需要 Any 类型的地方使用了可选值，Swift 会给你一个警告。
// 如果你确实需要将可选值作为 Any 值使用，可以使用 as 操作符显式将可选值转换为 Any，如下所示：
let optionalNumber: Int? = 3
things.append(optionalNumber)        // 警告
things.append(optionalNumber as Any) // 没有警告
