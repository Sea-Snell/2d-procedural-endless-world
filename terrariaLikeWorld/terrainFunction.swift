//
//  terrainFunction.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func terrainFunction(a: Int) -> Int{
    let left = randRange(1, maxVal: 100, seed: (a - (a % 100)))
    let right = randRange(1, maxVal: 100, seed: 100 + (a - (a % 100)))
    return Int(cosineInterplation(left, b: right, x: Double(a % 100) / 100.0))
}

func cosineInterplation(a: Double, b: Double, x: Double) -> Double{
    let scaled = x * 3.1415927
    let cosined = (1 - cos(scaled)) * 0.5
    
    return  a * (1 - cosined) + b * cosined
}