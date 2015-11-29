//
//  randomNumbers.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/27/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation
func generateRandomNumber(seed: Int64) -> Int64{
    return Int64(seed * Int64(2147483647) % Int64(16807))
}

func getRangedRandomNumber(seed: Int64) -> Double{
    return Double(seed) / 16807.0
}

func rand(var seed: Int64) -> Double{
    for _ in 0..<3{
        seed = generateRandomNumber(seed)
    }
    return abs(getRangedRandomNumber(seed))
}

func randRange(minVal: Double, maxVal: Double, seed: Int64) -> Double{
    return (rand(seed)) * (maxVal - minVal) + minVal
}