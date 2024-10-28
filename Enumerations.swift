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

enum color: Int {
    case blue = 1, green, yellow, cyan, red, black, white, scarlet
}

enum Utensil: String {
    case fork, spoon, chopsticks, pot
}

let colorPosition = color.scarlet.rawValue
print(colorPosition) // scarlet at position 8
let whichUtensil = Utensil.chopsticks.rawValue
print(whichUtensil) // It's chopsticks
