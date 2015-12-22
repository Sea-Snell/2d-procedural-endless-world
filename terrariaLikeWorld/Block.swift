//
//  Block.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/21/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation
class Block{
    var x: Int
    var y: Int
    var hidden: Bool
    var height: Int
    var humidity: Double
    var temperature: Double
    var roughness: Double
    var scaledHeight: Double
    var biome: Biome?
    
    init(x: Int, y: Int){
        self.x = x
        self.y = y
        
        self.height = 0
        self.humidity = 0
        self.temperature = 0
        self.roughness = 0
        self.scaledHeight = 0
        
        self.hidden = false
        self.biome = nil
        
        self.height = self.terrainFunction(self.x, seed: 8, range: 1...8)
        self.humidity = self.scaleVal(8...8, yVal: self.terrainFunction(self.x, seed: 6, range: 8...8))
        self.temperature = self.scaleVal(8...8, yVal: self.terrainFunction(self.x, seed: 7, range: 8...8))
        self.roughness = self.scaleVal(6...8, yVal: self.terrainFunction(self.x, seed: 3, range: 6...8))
        self.scaledHeight = self.scaleVal(1...8, yVal: height)
        
        self.hidden = self.isValidBlock()
        self.biome = self.determineBiome()
    }
    
    func isValidBlock() -> Bool{
        
        let shouldBeBlock = terrainHolesFunction(1, range: 1...4)
        
        if self.y > self.height{
            if shouldBeBlock >= 0.6 && shouldBeBlock <= 1.0{
                return false
            }
            return true
        }
        if shouldBeBlock >= self.roughness * 0.33{
            return false
        }
        return true
    }
    
    func terrainFunction(a: Int, seed: Int, range: Range<Int>) -> Int{
        
        var total1 = 0
        
        for i in range{
            let pt1 = Int(pow(2.0, Double(i)))
            total1 += noiseGenerator1d(pt1, amplitude: pt1 / 2, seed: seed)
        }
        
        
        return total1
    }
    
    func scaleVal(range: Range<Int>, yVal: Int) -> Double{
        var total = 0
        for i in range{
            total += Int(pow(2.0, Double(i - 1)))
            
        }
        return Double(yVal) / Double(total)
    }
    
    func terrainHolesFunction(seed: Int, range: Range<Int>) -> Double{
        var total1 = 0
        var ampSum = 0
        
        for i in range{
            let pt1 = Int(pow(2.0, Double(i)))
            total1 += noiseGenerator2d(pt1, amplitude: pt1 / 2, seed: seed)
            ampSum += pt1 / 2
        }
        
        return Double(total1) / Double(ampSum)
    }
    
    func noiseGenerator1d(wavelength: Int, amplitude: Int, seed: Int) -> Int{
        if self.x >= 0{
            let left = randRange(1, maxVal: Double(amplitude), seed: Int64((self.x - (self.x % wavelength)) * wavelength * seed))
            let right = randRange(1, maxVal: Double(amplitude), seed: Int64((wavelength + (self.x - (self.x % wavelength))) * wavelength * seed))
            return Int(cosineInterplation(left, b: right, xVal: Double(self.x % wavelength) / Double(wavelength)))
        }
        else{
            let left = randRange(1, maxVal: Double(amplitude), seed: Int64((self.x - (self.x % wavelength)) * wavelength * seed))
            
            let rightSeed = Int64((-wavelength + (self.x - (self.x % wavelength))) * wavelength * seed)
            let right = randRange(1, maxVal: Double(amplitude), seed: rightSeed)
            
            return Int(cosineInterplation(left, b: right, xVal: abs(Double(self.x % wavelength)) / Double(wavelength)))
        }
    }
    
    func noiseGenerator2d(wavelength: Int, amplitude: Int, seed: Int) -> Int{
        let indexA = (self.x / wavelength) * wavelength
        let indexB = wavelength + (self.x / wavelength) * wavelength
        let horizontalBlendVal: Double = Double(self.x - indexA) / Double(wavelength)
        
        let indexC = (self.y / wavelength) * wavelength
        let indexD = wavelength + (self.y / wavelength) * wavelength
        let verticalBlendVal: Double = Double(y - indexC) / Double(wavelength)
        
        let top = cosineInterplation(randRange(0, maxVal: Double(amplitude), seed: Int64(indexA * indexC * wavelength * seed)), b: randRange(0, maxVal: Double(amplitude), seed: Int64(indexB * indexC * wavelength * seed)), xVal: horizontalBlendVal)
        
        let bottom = cosineInterplation(randRange(0, maxVal: Double(amplitude), seed: Int64(indexA * indexD * wavelength * seed)), b: randRange(0, maxVal: Double(amplitude), seed: Int64(indexB * indexD * wavelength * seed)), xVal: horizontalBlendVal)
        
        return Int(cosineInterplation(top, b: bottom, xVal: verticalBlendVal))
        
    }
    
    func cosineInterplation(a: Double, b: Double, xVal: Double) -> Double{
        let scaled = xVal * 3.1415927
        let cosined = (1 - cos(scaled)) * 0.5
        
        return  a * (1 - cosined) + b * cosined
    }
    
    func determineBiome() -> Biome{
        var best = 10.0
        var biome: [String: Double]? = nil
        let biomes = [["mainAsset": 1, "secondaryAsset": 1, "elevation": 1.0, "humidity": 1.0, "temperature": 0.5, "roughness": 1.0], ["mainAsset": 2, "secondaryAsset": 1, "elevation": 1.0, "humidity": 0.5, "temperature": 1.0, "roughness": 0.5], ["mainAsset": 4, "secondaryAsset": 1, "elevation": 0.5, "humidity": 0.0, "temperature": 1.0, "roughness": 0.0], ["mainAsset": 3, "secondaryAsset": 1, "elevation": 0.5, "humidity": 0.0, "temperature": 0.0, "roughness": 0.5]]
        let assets = [1: "stoneBlock", 2: "dirtBlock", 3: "snowBlock", 4: "sandBlock"]
        
        for i in biomes{
            let elevationDiff = abs(i["elevation"]! - self.scaledHeight)
            let humidityDiff = abs(i["humidity"]! - self.humidity)
            let temperatureDiff = abs(i["temperature"]! - self.temperature)
            let roughnessDiff = abs(i["roughness"]! - self.roughness)
            let diff = elevationDiff + humidityDiff + temperatureDiff + roughnessDiff
            if diff < best{
                best = diff
                biome = i
            }
        }
        
        return Biome(mainAsset: assets[Int(biome!["mainAsset"]!)]!, secondaryAsset: assets[Int(biome!["secondaryAsset"]!)]!, elevationScaled: self.scaledHeight, realElevation: self.height, humidity: self.humidity, temperature: self.temperature, roughness: self.roughness, x: self.x, y: self.y, hidden: self.hidden)
    }
}