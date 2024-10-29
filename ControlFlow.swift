//#####   For-In Loops   #####//

let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}
// Hello, Anna!
// Hello, Alex!
// Hello, Brian!
// Hello, Jack!


let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}
// cats have 4 legs
// ants have 6 legs
// spiders have 8 legs


for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
// 1 times 5 is 5
// 2 times 5 is 10
// 3 times 5 is 15
// 4 times 5 is 20
// 5 times 5 is 25


let base = 3
let power = 10
var answer = 1
for _ in 1...power {
    answer *= base
}
print("\(base) to the power of \(power) is \(answer)")
// Prints "3 to the power of 10 is 59049"


let minutes = 60
for tickMark in 0..<minutes {
    print(tickMark)
    // render the tick mark each minute (60 times)
}

let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    print(tickMark)
    // render the tick mark every 5 minutes (0, 5, 10, 15 ... 45, 50, 55)
}

let hours = 12
let hourInterval = 3
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
    print(tickMark)
    // render the tick mark every 3 hours (3, 6, 9, 12)
}



//#####   While Loops   #####//
var count = 1

while count <= 5 {
    print("Count is \(count)")
    count += 1
}

//#####   Repeat-While   #####//
repeat {
    print("Count is \(count)")
    count += 1
} while count <= 5



//#####   Conditional Statements   #####//
//#####   If   #####//
var someRabbits = 17

if someRabbits <= 0 {
    print("not enough rabbit")
} else if someRabbits >= 30 {
    print("a lot of rabbits")
} else {
    print("rabbits")
}
 

let dogs = 45

let dogMessage = if dogs<=0 {
    "no dog"
} else if dogs >= 15 {
    "enough dog for me"
} else {
    "we need more"
}
print(dogMessage)


//#####   Switch   #####//