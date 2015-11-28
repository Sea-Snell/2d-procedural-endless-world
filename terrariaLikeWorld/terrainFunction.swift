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
    
    var total1 = 0
    var total2 = 0
    var total3 = 0
    
    for i in 4...8{
        let pt1 = Int(pow(2.0, Double(i)))
        total1 += noiseGenerator(a, wavelength: pt1, amplitude: pt1 / 2, seed: 8)
    }
    
    for i in 1...6{
        let pt1 = Int(pow(2.0, Double(i)))
        total2 += noiseGenerator(a, wavelength: pt1, amplitude: pt1 / 2, seed: 7)
    }
    
    for i in 6...8{
        let pt1 = Int(pow(2.0, Double(i)))
        total3 += noiseGenerator(a, wavelength: pt1, amplitude: pt1 / 2, seed: 4)
    }
    
    let avg = Double(total3) / 224.0
    
    return Int(Double(total1) * avg + Double(total2) * (1.0 - avg))
}

func noiseGenerator(a: Int, wavelength: Int, amplitude: Int, seed: Int) -> Int{
    let left = randRange(1, maxVal: Double(amplitude), seed: Int64((a - (a % wavelength)) * wavelength * seed))
    let right = randRange(1, maxVal: Double(amplitude), seed: Int64((wavelength + (a - (a % wavelength))) * wavelength * seed))
    return Int(cosineInterplation(left, b: right, x: Double(a % wavelength) / Double(wavelength)))
}

func cosineInterplation(a: Double, b: Double, x: Double) -> Double{
    let scaled = x * 3.1415927
    let cosined = (1 - cos(scaled)) * 0.5
    
    return  a * (1 - cosined) + b * cosined
}