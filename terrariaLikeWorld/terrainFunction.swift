//
//  terrainFunction.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func terrainFunction(a: Int) -> Int{
    
    var total1 = 0
    
    for i in 1...8{
        let pt1 = Int(pow(2.0, Double(i)))
        total1 += noiseGenerator(a, wavelength: pt1, amplitude: pt1 / 2, seed: 8)
    }
    
    
    return total1
}

func noiseGenerator(a: Int, wavelength: Int, amplitude: Int, seed: Int) -> Int{
    if a >= 0{
        let left = randRange(1, maxVal: Double(amplitude), seed: Int64((a - (a % wavelength)) * wavelength * seed))
        let right = randRange(1, maxVal: Double(amplitude), seed: Int64((wavelength + (a - (a % wavelength))) * wavelength * seed))
        return Int(cosineInterplation(left, b: right, x: Double(a % wavelength) / Double(wavelength)))
    }
    else{
        let left = randRange(1, maxVal: Double(amplitude), seed: Int64((a - (a % wavelength)) * wavelength * seed))
        
        let rightSeed = Int64((-wavelength + (a - (a % wavelength))) * wavelength * seed)
        let right = randRange(1, maxVal: Double(amplitude), seed: rightSeed)
        
        return Int(cosineInterplation(left, b: right, x: abs(Double(a % wavelength)) / Double(wavelength)))
    }
}

func cosineInterplation(a: Double, b: Double, x: Double) -> Double{
    let scaled = x * 3.1415927
    let cosined = (1 - cos(scaled)) * 0.5
    
    return  a * (1 - cosined) + b * cosined
}