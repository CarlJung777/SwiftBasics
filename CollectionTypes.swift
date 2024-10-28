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
bucketList[2...3] = ["Bananas", "Apples"]