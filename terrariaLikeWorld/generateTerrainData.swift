//
//  generateTerrainData.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class GenerateTerrainData{
    //var memo: [String: Bool]
    
    init(){
        //self.memo = [:]
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
    
    func determineBlock(heightAtX: Int, x: Int, y: Int, temperature: Double) -> String{
        var probability = ["soneBlock": 0.0, "dirtBlock": 0.0, "snowBlock": 0.0, "sandBlock": 0.0]
        
        var snowProbability = -30 * (temperature - 0.333) * (temperature - 0.333) * (temperature - 0.333)
        if snowProbability < 0{
            snowProbability = 0
        }
        if snowProbability > 1{
            snowProbability = 1
        }
        
        var sandProbability = 100 * (temperature - 0.4) * (temperature - 0.4) * (temperature - 0.4) * (temperature - 0.4) * (temperature - 0.4)
        if sandProbability < 0{
            sandProbability = 0
        }
        if sandProbability > 1{
            sandProbability = 1
        }
        
        var dirtProbability = -25 * (temperature - 0.5) * (temperature - 0.5) + 0.8
        if dirtProbability < 0{
            dirtProbability = 0
        }
        if dirtProbability > 1{
            dirtProbability = 1
        }
        
        var snowWeight = 0.00002 * Double((y - heightAtX + 30) * (y - heightAtX + 30) * (y - heightAtX + 30)) + 0.5
        if snowWeight < 0.005{
            snowWeight = 0.005
        }
        if snowWeight > 0.995{
            snowWeight = 0.995
        }
        
        var sandWeight = 0.0005 * Double((y - heightAtX + 10) * (y - heightAtX + 10) * (y - heightAtX + 10)) + 1.0
        if sandWeight < 0.005{
            sandWeight = 0.005
        }
        if sandWeight > 0.995{
            sandWeight = 0.995
        }
        
        var dirtWeight = 0.0000001 * Double((y - heightAtX + 20) * (y - heightAtX + 20) * (y - heightAtX + 20) * (y - heightAtX + 20) * (y - heightAtX + 20)) + 0.6
        if dirtWeight < 0.005{
            dirtWeight = 0.005
        }
        if dirtWeight > 0.995{
            dirtWeight = 0.995
        }
        
        var stoneWeight = -0.001 * Double((y - heightAtX + 10) * (y - heightAtX + 10) * (y - heightAtX + 10)) + 0.1
        if stoneWeight < 0.005{
            stoneWeight = 0.005
        }
        if stoneWeight > 0.995{
            stoneWeight = 0.995
        }
        
        let sandFinalProb = sandProbability * sandWeight
        let dirtFinalProb = dirtProbability * dirtWeight
        let snowFinalProb = snowProbability * snowWeight
        let stoneFinalProb = stoneWeight
        
        
//        var stoneProbability = 0.0002 * Double((y - heightAtX) * (y - heightAtX)) + 0.02
//        if stoneProbability < 0{
//            stoneProbability = 0
//        }
//        if stoneProbability > 1{
//            stoneProbability = 1
//        }
        
        
        
        
        probability["snowBlock"] = snowFinalProb / (sandFinalProb + snowFinalProb + stoneFinalProb + dirtFinalProb)
        probability["sandBlock"] = sandFinalProb / (sandFinalProb + snowFinalProb + stoneFinalProb + dirtFinalProb)
        probability["dirtBlock"] = dirtFinalProb / (sandFinalProb + snowFinalProb + stoneFinalProb + dirtFinalProb)
        probability["stoneBlock"] = stoneFinalProb / (sandFinalProb + snowFinalProb + stoneFinalProb + dirtFinalProb)
        
        let randVal = randRange(0, maxVal: 1, seed: Int64(x * y * 4))
        var total = 0.0
        
        for i in probability.keys{
            if randVal > total && randVal <= total + probability[i]!{
                return i
            }
            total += probability[i]!
        }
        return ""
    }
    
    func stringToBlockObject(x: Int, y: Int, name: String) -> Block{
        switch(name){
        case "sandBlock":
            return SandBlock(x: x, y: y)
        case "dirtBlock":
            return DirtBlock(x: x, y: y)
        case "stoneBlock":
            return StoneBlock(x: x, y: y)
        case "snowBlock":
            return SnowBlock(x: x, y: y)
        default:
            return Block(x: x, y: y, asset: name, visible: false)
        }
    }
    
    
    
    func isValidBlock(x: Int, y: Int) -> Block{
        
        let height = terrainFunction(x, seed: 8, range: 1...8)
        let temperature = (Double(terrainHolesFunction(x, y: y, seed: 6, range: 6...8)) - Double(y - 125) * 0.005)
        let roughness = scaleVal(6...8, y: Double(terrainFunction(x, seed: 3, range: 6...8)))
        
        //let scaledHeight = scaleVal(1...8, y: Double(height))
        
        let shouldBeBlock = terrainHolesFunction(x, y: y, seed: 1, range: 1...4)
        
        if y > height{
            if shouldBeBlock >= 0.6 && shouldBeBlock <= 1.0{
                return stringToBlockObject(x, y: y, name: determineBlock(height, x: x, y: y, temperature: temperature))
            }
            return stringToBlockObject(x, y: y, name: "")
        }
        if shouldBeBlock >= roughness * 0.33{
            return stringToBlockObject(x, y: y, name: determineBlock(height, x: x, y: y, temperature: temperature))
        }
        return stringToBlockObject(x, y: y, name: "")
    }
    
    func terrainFunction(a: Int, seed: Int, range: Range<Int>) -> Int{
        
        var total1 = 0
        
        for i in range{
            let pt1 = Int(pow(2.0, Double(i)))
            total1 += noiseGenerator1d(a, wavelength: pt1, amplitude: pt1 / 2, seed: seed)
        }
        
        
        return total1
    }
    
    func scaleVal(range: Range<Int>, y: Double) -> Double{
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