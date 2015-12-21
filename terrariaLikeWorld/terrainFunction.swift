//
//  terrainFunction.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func isValidBlock(x: Int, y: Int) -> Int{
    
    let height = terrainFunction(x, seed: 8, range: 1...8)
    let humidity = scaleVal(8...8, y: terrainFunction(x, seed: 6, range: 8...8))
    let temperature = scaleVal(8...8, y: terrainFunction(x, seed: 7, range: 8...8))
    let roughness = scaleVal(6...8, y: terrainFunction(x, seed: 3, range: 6...8))
    
    let scaledHeight = scaleVal(1...8, y: height)
    
    let shouldBeBlock = terrainHolesFunction(x, y: y, seed: 1, range: 1...4)
    
    if y > height{
        if shouldBeBlock >= 0.6 && shouldBeBlock <= 1.0{
            return determineBlock(x, y: y, seed: 9, heightAtX: height, elevation: scaledHeight, humidity: humidity, temperature: temperature, roughness: roughness)
        }
//        if y < 105{
//            return 5
//        }
        
        return 0
    }
    if shouldBeBlock >= roughness * 0.33{
        return determineBlock(x, y: y, seed: 9, heightAtX: height, elevation: scaledHeight, humidity: humidity, temperature: temperature, roughness: roughness)
    }
    return 0
}

func terrainFunction(a: Int, seed: Int, range: Range<Int>) -> Int{
    
    var total1 = 0
    
    for i in range{
        let pt1 = Int(pow(2.0, Double(i)))
        total1 += noiseGenerator1d(a, wavelength: pt1, amplitude: pt1 / 2, seed: seed)
    }
    
    
    return total1
}

func scaleVal(range: Range<Int>, y: Int) -> Double{
    var total = 0
    for i in range{
        total += Int(pow(2.0, Double(i - 1)))
        
    }
    return Double(y) / Double(total)
}

func determineBlock(x: Int, y: Int, seed: Int, heightAtX: Int, elevation: Double, humidity: Double, temperature: Double, roughness: Double) -> Int{
    let blockTypes = determineBiome(elevation, humidity: humidity, temperature: temperature, roughness: roughness)
    
    var probibality: Double = 0.00005 * Double((y - heightAtX) * (y - heightAtX)) + 0.05
    if probibality > 0.95{
        probibality = 0.95
    }
    
    let randVal = rand(Int64(x * y * seed))
    if randVal <= probibality{
        return blockTypes[1]
    }
    return blockTypes[0]
}

func terrainHolesFunction(x: Int, y: Int, seed: Int, range: Range<Int>) -> Double{
    var total1 = 0
    var ampSum = 0
    
    for i in range{
        let pt1 = Int(pow(2.0, Double(i)))
        total1 += noiseGenerator2d(x, y: y, wavelength: pt1, amplitude: pt1 / 2, seed: seed)
        ampSum += pt1 / 2
    }
    
    return Double(total1) / Double(ampSum)
}

func noiseGenerator1d(a: Int, wavelength: Int, amplitude: Int, seed: Int) -> Int{
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

func noiseGenerator2d(x: Int, y: Int, wavelength: Int, amplitude: Int, seed: Int) -> Int{
    let indexA = (x / wavelength) * wavelength
    let indexB = wavelength + (x / wavelength) * wavelength
    let horizontalBlendVal: Double = Double(x - indexA) / Double(wavelength)
    
    let indexC = (y / wavelength) * wavelength
    let indexD = wavelength + (y / wavelength) * wavelength
    let verticalBlendVal: Double = Double(y - indexC) / Double(wavelength)
    
    let top = cosineInterplation(randRange(0, maxVal: Double(amplitude), seed: Int64(indexA * indexC * wavelength * seed)), b: randRange(0, maxVal: Double(amplitude), seed: Int64(indexB * indexC * wavelength * seed)), x: horizontalBlendVal)
    
    let bottom = cosineInterplation(randRange(0, maxVal: Double(amplitude), seed: Int64(indexA * indexD * wavelength * seed)), b: randRange(0, maxVal: Double(amplitude), seed: Int64(indexB * indexD * wavelength * seed)), x: horizontalBlendVal)
    
    return Int(cosineInterplation(top, b: bottom, x: verticalBlendVal))
    
}

func cosineInterplation(a: Double, b: Double, x: Double) -> Double{
    let scaled = x * 3.1415927
    let cosined = (1 - cos(scaled)) * 0.5
    
    return  a * (1 - cosined) + b * cosined
}