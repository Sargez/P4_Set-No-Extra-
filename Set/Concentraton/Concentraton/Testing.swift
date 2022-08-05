//
//  Testing.swift
//  Concentraton
//
//  Created by 1C on 05/04/2022.
//

import Foundation

func LetTestSwift() {
    
    // Testing: nested function
    var CurrentValue = 5
    let MoveCurrentValueToZero = ChooseStepFunction(backward: CurrentValue > 0)
    
    while CurrentValue != 0 {
        print("Current value = \(CurrentValue)")
        CurrentValue = MoveCurrentValueToZero(CurrentValue)
    }
    print("Current value = \(CurrentValue)")
    
    //Testing: closure
    let Names = ["Alex", "Chris", "Barry", "Ewa", "Daniella"]
    
    //closure
    let reverseNames = Names.sorted(by: >  )
    //trailing closure
    let reverseNames1 = Names.sorted {$0>$1}
    
    print("\(reverseNames)")
    print("\(reverseNames1)")
    
    //trailing closure
    let Numbers = [16, 501, 58]
    let digitNames = [1:"One", 2:"Two", 3:"Three", 4:"Four", 5:"Five", 6:"Six", 7:"Seven", 8:"Eight", 9:"Nine", 0:"Zero"]
    
    let strings = Numbers.map { (number) -> String in
        var number = number
        var outputString = ""
        while number != 0 {
            outputString = digitNames[number%10]! + outputString
            number/=10
        }
        return outputString
    }
    print("strings: \(strings)")
    
    //closure. Capturing value
    let IncrementByTen = MakeIncrement(forIncrement: 10)
    
    print(IncrementByTen())
    print(IncrementByTen())
    print(IncrementByTen())
    
    let IncrementByFive = MakeIncrement(forIncrement: 5)
    
    print(IncrementByFive())
    print(IncrementByFive())
    
    print(IncrementByTen())
    print(IncrementByFive())
    
//    Testing escape closure
    let instance = SomeClass()
    print(instance.x)
    instance.doSmth()
    print(instance.x)
    
    CompletionHandlers.first?()
    print(instance.x)
    
//    Methods
    let counter = Counter()
    counter.increment()
    print(counter.counter)
    counter.increment(by: 5)
    print(counter.counter)
    counter.reset()
    print(counter.counter)
    
    var somePoint = Point(x: 2, y: 3)
    
    print("The point is now as \(somePoint.x), \(somePoint.y)")
    somePoint.moveBy(x: 3, y: 7)
    print("The point is now as \(somePoint.x), \(somePoint.y)")
    
    let car = Car()
    car.gear = 3
    car.currentSpeed = 40
    print("Car: \(car.showDescription())")
    car.MakeNoise()
    
    let automaticCar = AutomaticCar()
    automaticCar.currentSpeed = 30
    print("Automatic car: \(automaticCar.showDescription())")
    automaticCar.MakeNoise()
    
    let Point = 11
    if let somePlanet = Planet(rawValue: Point) {
            print("\(somePlanet)")
    } else {
        print("There isn't planet with this position")
    }
    
//    let compassPoint = CompassPoint.east
//    switch compassPoint {
//    case .north:
//        print("north")
//    case .south:
//        print("south")
//    default:
//        print("another")
//    }
    
    for compassPoint in CompassPoint.allCases {
            print("\(compassPoint)")
    }
    print("There are \(CompassPoint.allCases.count)")
    
//    var animal=Animals.pig("Meat", 25)
//    let animalChicken = Animals.chicken(12)
//    switch animal {
//    case let .pig(parametr, count):
//        print("This is a pig \(parametr) and \(count)")
//    default:
//        print("test")
//    }
    
//    switch animalChicken {
//    case .chicken(let countOfEggs):
//        print("This is a chicken. Give \(countOfEggs) eggs")
//    default:
//        print("test")
//    }
    
//    animal = .cow("test")
//    print("\(animal)")
    
//    (5 + 4) * 2 = 18
    
    let five = ArithmeticOperation.number(5)
    let four = ArithmeticOperation.number(4)
    let sum = ArithmeticOperation.addition(five, four)
    let two = ArithmeticOperation.number(2)
    let product = ArithmeticOperation.multiply(sum, two)
    
    print(evaluate(product))
    
//    in-out parametr in function
    
    var first = 5
    var second = 10
    if swapTwoNumbers(first: &first, second: &second) {
        print("Now first = \(first) and the second = \(second)")
    } else {
        print("Mistake")
    }
    
//    extensions
    print("\(12345678[0])")
    print("\(12345678[1])")
    print("\(12345678[5])")
    
//   protocols
    let vector1 = Vector3D(x: 2.0, y: 3.0, z: 4.0)
    let vector2 = Vector3D(x: 4.0, y: 3.0, z: 2.0)
    
    if vector1 == vector2 {
        print("vector 1 is equal to vector2")
    }
    
//    ARC (automating references counting
//    var reference1: Person?
//    var reference2: Person?
//    var reference3: Person?
//
//    reference1 = Person(name: "Sergey Zlobin")
//    reference2 = reference1
//    reference3 = reference1
//
//    reference1 = nil
//    reference3 = nil
//
//    reference2 = nil
    
//      weak
    var personSergey: Person?
    var flat: Apartment?
    
    personSergey = Person(name: "Sergey Zlobin")
    flat = Apartment(name: "4A")
    
    personSergey?.apartment = flat
    flat?.tenant = personSergey
    
    personSergey = nil
    flat = nil
    
    var personIvan: Person?
    
    
    personIvan = Person(name: "Ivan Ivanov")
    personIvan?.creditCard = CreditCard(number: 1234123412341234, person: personIvan!)
    
    personIvan = nil
    
    var countryRussia: Country!
    countryRussia = Country(name: "Russia", nameCapitalCity: "Moscow")
    
    print("\(countryRussia.name)'s capital city is called \(countryRussia.capitalCity.name)")
    
    countryRussia = nil
    
}

class Country {
    let name: String
    var capitalCity: City!
    
    init(name: String, nameCapitalCity: String) {
        self.name = name
        self.capitalCity = City(name: nameCapitalCity, country: self)
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class City {
    let name: String
    unowned var country: Country
    
    init(name: String, country: Country) {
        self.name = name
        self.country = country
        print("\(name) is being initialized in country \(country.name)")
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    var number: UInt64
    unowned var person: Person
    
    init(number: UInt64, person: Person) {
        self.number = number
        self.person = person
    }
    
    deinit {
        print("\(number) is being deinitialized")
    }
    
}

class Person {
    var name: String
    var apartment: Apartment?
    var creditCard: CreditCard?
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

class Apartment {
    var name: String
    weak var tenant: Person?
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
      
    
    static func == (lhs: Vector3D, rhs: Vector3D) -> Bool {
            lhs.x == rhs.z && lhs.y == rhs.y && lhs.z == rhs.x
        }
}

extension Int {
    subscript(digetIndex: Int) -> Int {
        var decimal = 1
        for _ in 0..<digetIndex {
            decimal *= 10
        }
        return (self/decimal) % 10
    }
}

func swapTwoNumbers(first a: inout Int, second b: inout Int) -> Bool {
    let temp = a
    a = b
    b = temp
    
    return true
}

func evaluate(_ Expression: ArithmeticOperation) -> Int {
    switch Expression {
    case .number(let value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiply(left, right):
        return evaluate(left) * evaluate(right)
    }
}

indirect enum ArithmeticOperation {
    case
        number(Int)
    case
        addition(ArithmeticOperation, ArithmeticOperation)
    case
        multiply(ArithmeticOperation, ArithmeticOperation)
}

enum Planet:Int {
    case mercury=1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

enum CompassPoint: CaseIterable {
    case north
    case south
    case east
    case west
}

enum Animals {
    case pig(String, Int)
    case cow(String)
    case chicken(Int)
}

struct Point {
    var x=0.0, y=0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

class Counter {
    var counter = 0
    
    func increment() {
        counter += 1
    }
    
    func increment(by amount: Int) {
        counter += amount
    }
    
    func  reset() {
        counter = 0
    }
}

class SomeClass {
    var x = 10
    func doSmth() {
        
        let isTest = true
        SomeFuncWithNonescapingClosure(isTrue: isTest) { x = 200 } MyClosure: { x=99 }
        
        someFuncWithEscapingClosure() {self.x = 100}
    }
}

var CompletionHandlers: [() -> Void] = []
func someFuncWithEscapingClosure(CompletionHandler: @escaping () -> Void) {
    CompletionHandlers.append(CompletionHandler)
}

    
func SomeFuncWithNonescapingClosure(isTrue: Bool, closure: () -> Void, MyClosure: () -> Void) {
    if isTrue {
        MyClosure()
    } else {
        closure()
    }
}

// Testing: Nested function
private func ChooseStepFunction(backward: Bool) -> (Int) -> Int {
    func StepForward(input: Int) -> Int {return input+1}
    func StepBackward(input: Int) -> Int {return input-1}
    
    return backward ? StepBackward : StepForward
    
}

//Testing: Closure
//Capturing value
private func MakeIncrement(forIncrement amount: Int) -> () -> Int {
    var Total = 0
    func increment() -> Int {
        Total += amount
        return Total
    }
    return increment
}
