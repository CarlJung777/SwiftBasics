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
print("now it's", directionToHead) // now it's east





enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}