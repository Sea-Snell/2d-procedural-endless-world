//
//  randomNumbers.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/27/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func generateRandomNumber(seed: Int) -> Int{
    return seed * 2147483647 % 16807
}

func getRangedRandomNumber(num: Int) -> Double{
    return Double(num) / 16807.0
}

func rand(var seed: Int) -> Double{
    for _ in 0..<3{
        seed = generateRandomNumber(seed)
    }
    return getRangedRandomNumber(seed)
}

func randRange(minVal: Double, maxVal: Double, seed: Int) -> Double{
    return (rand(seed)) * (maxVal - minVal) + minVal
}