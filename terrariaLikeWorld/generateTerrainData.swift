//
//  generateTerrainData.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class GenerateTerrainData{
    var memo: [String: Bool]
    var desert: Desert
    var mountain: Mountains
    var hill: Hills
    var tundra: Tundra
    
    init(){
        self.desert = Desert(x: 0, y: 0, heightAtX: 0, visible: false)
        self.mountain = Mountains(x: 0, y: 0, heightAtX: 0, visible: false)
        self.hill = Hills(x: 0, y: 0, heightAtX: 0, visible: false)
        self.tundra = Tundra(x: 0, y: 0, heightAtX: 0, visible: false)
        self.memo = [:]
        
    }
    
    func generateTerrainData(leftPos: CGPoint, blockSize: Int) -> [[Block]]{
        var terrainData: [[Block]] = []
        for x in Int(leftPos.y)..<Int(leftPos.y) + blockSize{
            var temp: [Block] = []
            for i in Int(leftPos.x)..<Int(leftPos.x) + blockSize{
                let block = self.isValidBlock(i, y: x)
                //if isWater(i, y: x, blockType: block) == true{
                //    block = 5
                //}
                temp.append(block)
            }
            terrainData.append(temp)
        }
    
        return terrainData
    }
    
    func determineBiome(elevation: Double, humidity: Double, temperature: Double, roughness: Double) -> String{
        var best = 10.0
        var biome: [String: Any] = [:]
        let biomes: [[String: Any]] = [["elevation": 1.0, "humidity": 1.0, "temperature": 0.5, "roughness": 1.0, "name": "mountains"], ["elevation": 1.0, "humidity": 0.5, "temperature": 1.0, "roughness": 0.5, "name": "hills"], ["elevation": 0.5, "humidity": 0.0, "temperature": 1.0, "roughness": 0.0, "name": "desert"], ["elevation": 0.5, "humidity": 0.0, "temperature": 0.0, "roughness": 0.5, "name": "tundra"]]
        
        for i in biomes{
            let a = abs((i["elevation"] as! Double) - elevation)
            let b = abs((i["humidity"]as! Double) - humidity)
            let c = abs((i["temperature"] as! Double) - temperature)
            let d = abs((i["roughness"] as! Double) - roughness)
            let diff = a + b + c + d
            if diff < best{
                best = diff
                biome = i
            }
        }
        
        return String(biome["name"]!)
    }
    
    func stringToBlockObject(x: Int, y: Int, heightAtX: Int, name: String = "", visible: Bool = false) -> Block{
        switch(name){
        case "desert":
            desert.x = x
            desert.y = y
            desert.visible = visible
            desert.heightAtX = heightAtX
            return (desert.determineBlock())!
        case "mountains":
            mountain.x = x
            mountain.y = y
            mountain.visible = visible
            mountain.heightAtX = heightAtX
            return (mountain.determineBlock())!
        case "hills":
            hill.x = x
            hill.y = y
            hill.visible = visible
            hill.heightAtX = heightAtX
            return (hill.determineBlock())!
        case "tundra":
            tundra.x = x
            tundra.y = y
            tundra.visible = visible
            tundra.heightAtX = heightAtX
            return (tundra.determineBlock())!
        default:
            return Block(x: x, y: y, asset: "", visible: false)
        }
    }
    
    
    
    func isValidBlock(x: Int, y: Int) -> Block{
        
        let height = terrainFunction(x, seed: 8, range: 1...8)
        let humidity = scaleVal(8...8, y: terrainFunction(x, seed: 6, range: 8...8))
        let temperature = scaleVal(8...8, y: terrainFunction(x, seed: 7, range: 8...8))
        let roughness = scaleVal(6...8, y: terrainFunction(x, seed: 3, range: 6...8))
        
        let scaledHeight = scaleVal(1...8, y: height)
        
        let shouldBeBlock = terrainHolesFunction(x, y: y, seed: 1, range: 1...4)
        
        if y > height{
            if shouldBeBlock >= 0.6 && shouldBeBlock <= 1.0{
                return stringToBlockObject(x, y: y, heightAtX: height, name: determineBiome(scaledHeight, humidity: humidity, temperature: temperature, roughness: roughness), visible: true)
            }
            return stringToBlockObject(x, y: y, heightAtX: height)
        }
        if shouldBeBlock >= roughness * 0.33{
            return stringToBlockObject(x, y: y, heightAtX: height, name: determineBiome(scaledHeight, humidity: humidity, temperature: temperature, roughness: roughness), visible: true)
        }
        return stringToBlockObject(x, y: y, heightAtX: height)
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
    
    
//    func isWater(x: Int, y: Int, blockType: Int, last: String? = nil) -> Bool{
//        if self.memo.count > 100000{
//            self.memo = [:]
//        }
//        var val: Bool = false
//        if blockType != 0 || y > terrainFunction(x, seed: 8, range: 1...8){
//            if blockType == 5{
//                val = true
//            }
//            else{
//                val = false
//            }
//        }
//        else if let memoVal = self.memo["\(x) \(y)"]{
//            return memoVal
//        }
//        else{
//            val = self.isWater(x, y: y + 1, blockType: isValidBlock(x, y: y + 1), last: "\(x) \(y)")
//            if val == false{
//                if "\(x - 1) \(y)" != last{
//                    val = self.isWater(x - 1, y: y, blockType: isValidBlock(x - 1, y: y), last: "\(x) \(y)")
//                }
//            }
//            if val == false{
//                if "\(x + 1) \(y)" != last{
//                    val = self.isWater(x + 1, y: y, blockType: isValidBlock(x + 1, y: y), last: "\(x) \(y)")
//                }
//            }
//        }
//        self.memo["\(x) \(y)"] = val
//        return val
//    }
}