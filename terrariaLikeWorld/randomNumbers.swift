//
//  randomNumbers.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/27/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation
class RandomNumberGenerator{
    var seed: Int
    
    init(seed: Int){
        self.seed = seed
        for _ in 0..<5{
            self.rand()
        }
    }
    
    func generateRandomNumber() -> Int{
        return self.seed * 2147483647 % 16807
    }

    func getRangedRandomNumber() -> Double{
        return Double(self.seed) / 16807.0
    }

    func rand() -> Double{
        self.seed = generateRandomNumber()
        return getRangedRandomNumber()
    }

    func randRange(minVal: Double, maxVal: Double) -> Double{
        return (rand()) * (maxVal - minVal) + minVal
    }
}