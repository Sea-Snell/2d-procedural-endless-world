//
//  RandomNums.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 8/28/18.
//  Copyright © 2018 sea_software. All rights reserved.
//


import Foundation

import Foundation

class RandomNumber{
    var seed: Int64
    init(){
        self.seed = 1
    }
    
    func rand(minVal: Double = 0.0, maxVal: Double = 1.0) -> Double{
        if self.seed == 0{
            self.seed = 1
        }
        for _ in 0..<10{
            self.seed = Int64(self.seed * Int64(2147483647) % Int64(16807))
        }
        return abs(Double(self.seed) / 16807.0) * (maxVal - minVal) + minVal
    }
}
