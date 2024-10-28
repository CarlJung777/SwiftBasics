//#####  Enumeration Syntax   #####//

// cases of an enumeration are a defined (and typed) value in their own right
// Swift enumeration cases don’t have an integer value set by default,
// the different enumeration cases are values in their own right,
//  with an explicitly defined type of CompassPoint.
enum CompassPoint {
    case north
    case south
    case east
    case west
}

var directionToHead = CompassPoint.west
print("now it's", directionToHead)  // now it's west

// Once directionToHead is declared as a CompassPoint,
// you can set it to a different CompassPoint value using a shorter dot syntax
directionToHead = .east
print("now it's", directionToHead)  // now it's east

switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
// Prints "Where the sun rises"

enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

//  When it isn’t appropriate to provide a case for every enumeration case,
//  you can provide a default case to cover any cases that aren’t addressed explicitly
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}
// Prints "Mostly harmless"

//#####  Iterating over Enumeration Cases   #####//

enum Animal: CaseIterable {
    case dog, cat, ant
}
let numberOfChoices = Animal.allCases.count
print("There are\(numberOfChoices) animals")
// Prints "There are 3 animals"

for animal in Animal.allCases {
    print(animal)
}
// dog
// cat
// ant

//#####   Associated Values  #####//

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."

//#####   Raw Values  #####//

enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

//#####   Implicitly Assigned Raw Values  #####//

enum Color: Int {
    case blue = 1, green, yellow, cyan, red, black, white, scarlet
}

enum Utensil: String {
    case fork, spoon, chopsticks, pot
}

let colorPosition = Color.scarlet.rawValue
print(colorPosition) // scarlet at position 8
let whichUtensil = Utensil.chopsticks.rawValue
print(whichUtensil) // It's chopsticks

//#####   Initializing from a Raw Value  #####//

let possibleColor = Color(rawValue: 7)
print(possibleColor!) // now possible color is white

let positionToFind = 11

if let someColor = Color(rawValue: positionToFind) {
    switch someColor {
    case .yellow:
        print("color is yellow")
    default:
        print("Not your color")   
    }
} else {
    print("not color is at position \(positionToFind)")
}   
// position 11 does not exist , so print "no color is at position 11"

//#####   Recursive Enumerations  #####//

indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}


let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))


func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}


print(evaluate(product))
// Prints "18"
