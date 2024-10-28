//#####   Collection Types   #####//
// @@ Array      @@
// @@ Set        @@
// @@ Dictionary @@
// the collection  will be mutable


//#####   Creating an Empty Array   #####//
var votersInt: [Int] = []
print("there is \(votersInt.count) voter in votersInt.")

votersInt.append(99) // now it contains 1 value of type Int

votersInt = [] // votersInt now is empty array, still of type [Int]

//#####   Creating an Array with a Default Value  #####//
var fourDoubles = Array(repeating: 0.0, count: 4)
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
var sixDoubles = fourDoubles + anotherThreeDoubles
print(sixDoubles) // [0.0, 0.0, 0.0, 0.0, 2.5, 2.5, 2.5]

//#####   Creating an Array with an Array Literal  #####//
var bucketList: [String] = ["fly a plane", "write a book"]
var sameBucketList = ["fly a plane", "write a book"]

//#####   Accessing and Modifying an Array  #####//
print(sameBucketList.count)

if bucketList.isEmpty {
    print("The bucke tList is empty")
} else {
    print("The bucke List isn't empty")
}

bucketList.append("buy a plane")
// Alternatively
bucketList += ["speak japanese"]

var firstWish = bucketList[0]
bucketList[2] = "owning a building"

// replacing in range
bucketList[2...3] = ["a cat", "beagle"]

bucketList.insert("a dog", at: 0)

let dog = bucketList.remove(at: 0)

firstWish = bucketList[0]

let lastDog = bucketList.removeLast()


//#####  Iterating Over an Array  #####//

for wish in bucketList {
    print(wish)
}
// if you need index, use enumerated()
for (index, value) in bucketList.enumerated() {
    print("Item \(index + 1): \(value)")
}


//#####   Creating and Initializing an Empty Set   #####//
// A type must be hashable in order to be stored in a set
// All of Swift’s basic types (such as String, Int, Double, and Bool) are hashable by default
var letters = Set<Character>()
print("letters is of type Set<Character> with \(letters.count) items.")
letters.insert("a")
// letters now contains 1 value of type Character
letters = []
// letters is now an empty set, but is still of type Set<Character>

//#####   Creating a Set with an Array Literal   #####//
 var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
 // Alternatively
 var favoriteAnimals: Set = ["dog, cat, bee"]

 //#####   Accessing and Modifying a Set   #####//
 print("I have \(favoriteGenres.count) favorite music genres.")

 if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}

favoriteGenres.insert("Jazz")

// calling the set’s remove(_:) method
// which removes the item if it’s a member of the set,
// and returns the removed value, or returns nil if the set didn’t contain it.
if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}

if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}


//#####   Iterating Over a Set   #####//
for genre in favoriteGenres {
    print("\(genre)")
}

// Swift’s Set type doesn’t have a defined ordering. 
for genre in favoriteGenres.sorted() {
    print("\(genre)")
}

//#####   Fundamental Set Operations   #####//
// intersection(_:) create a new set with only the values common to both sets.
// symmetricDifference(_:) create a new set with values in either set, but not both.
// union(_:) create a new set with all of the values in both sets.
// subtracting(_:) create a new set with values not in the specified set.

let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]


var unionSet = oddDigits.union(evenDigits).sorted()
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
var intersectionSet = oddDigits.intersection(evenDigits).sorted()
// []
var subtractingSet = oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
// [1, 9]
var symmetricDifferenceSet = oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
// [1, 2, 9]
