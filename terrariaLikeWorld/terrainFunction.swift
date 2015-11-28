//
//  terrainFunction.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func terrainFunction(var a: Int) -> Int{
    a = abs(a)
    
    var total = 0
    for i in 1...8{
        let pt1 = Int(pow(2.0, Double(i)))
        total += noiseGenerator(a, wavelength: pt1, amplitude: pt1 / 2)
    }
    
    return total
}

func noiseGenerator(a: Int, wavelength: Int, amplitude: Int) -> Int{
    let left = randRange(1, maxVal: Double(amplitude), seed: (a - (a % wavelength)) * wavelength)
    let right = randRange(1, maxVal: Double(amplitude), seed: (wavelength + (a - (a % wavelength))) * wavelength)
    return Int(cosineInterplation(left, b: right, x: Double(a % wavelength) / Double(wavelength)))
}

func cosineInterplation(a: Double, b: Double, x: Double) -> Double{
    let scaled = x * 3.1415927
    let cosined = (1 - cos(scaled)) * 0.5
    
    return  a * (1 - cosined) + b * cosined
}