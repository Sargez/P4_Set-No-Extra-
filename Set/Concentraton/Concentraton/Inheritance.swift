//
//  Inheritance.swift
//  Concentraton
//
//  Created by 1C on 07/04/2022.
//

import Foundation

class Vehicle {
    
    var currentSpeed = 0
    
    func showDescription() -> String {
        return "Traviling \(currentSpeed) metres per hour"
    }
    
    func MakeNoise() {
        print("no noise. I don't know what is a vehicle might be")
    }
    
}

class Car: Vehicle {
    var gear = 1
    
    override func showDescription() -> String {
        return super.showDescription() + " in \(gear) gear"
    }
    
    final override func MakeNoise() {
        print("trrr...trrr")
    }
}

class AutomaticCar: Car {
    
    override var currentSpeed: Int {
        didSet {
            gear = Int(currentSpeed/10) + 1
        }
    }
    
    override func showDescription() -> String {
        return super.showDescription() + " NEW \(gear)! Yeahhh"
    }
        
}
