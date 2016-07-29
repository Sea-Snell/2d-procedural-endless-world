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
    var precalculatedTerrain: [Int: Int]
    var precalculatedBlocks: [String: Block]
    
    init(){
        self.memo = [:]
        self.precalculatedTerrain = [:]
        self.precalculatedBlocks = [:]
    }
    
    func generateTerrainData(leftPos: CGPoint, blockSize: Int) -> [[Block]]{
        var terrainData: [[Block]] = []
        for x in Int(leftPos.y)..<Int(leftPos.y) + blockSize{
            var temp: [Block] = []
            for i in Int(leftPos.x)..<Int(leftPos.x) + blockSize{
                let block = self.isValidBlock(i, y: x)
//                if isWater(block) == true{
//                    block = WaterBlock(x: i, y: x)
//                }
                temp.append(block)
            }
            terrainData.append(temp)
        }
    
        return terrainData
    }
    
    func determineBlock(heightAtX: Int, x: Int, y: Int, temperature: Double) -> String{
        var probability = ["soneBlock": 0.0, "dirtBlock": 0.0, "snowBlock": 0.0, "sandBlock": 0.0, "clayBlock": 0.0]
        
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
        
        var dirtProbability = -25 * (temperature - 0.4) * (temperature - 0.4) + 0.8
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
        
        var stoneWeight = -0.001 * Double((y - heightAtX + 30) * (y - heightAtX + 30) * (y - heightAtX + 30)) + 0.1
        if stoneWeight < 0.005{
            stoneWeight = 0.005
        }
        if stoneWeight > 0.995{
            stoneWeight = 0.995
        }
        
        let power = Double(y - heightAtX) + 25.0
        var clayWeight = -0.0003 * power * power * power * power + 1
        
        if clayWeight < 0.00005{
            clayWeight = 0.00005
        }
        
        if clayWeight > 0.995{
            clayWeight = 0.995
        }
        
        let sandFinalProb = sandProbability * sandWeight
        let dirtFinalProb = dirtProbability * dirtWeight
        let snowFinalProb = snowProbability * snowWeight
        let stoneFinalProb = stoneWeight
        let clayFinalProb = clayWeight
        
        
        let sum = (sandFinalProb + snowFinalProb + stoneFinalProb + dirtFinalProb + clayFinalProb)
        
        probability["snowBlock"] = snowFinalProb / sum
        probability["sandBlock"] = sandFinalProb / sum
        probability["dirtBlock"] = dirtFinalProb / sum
        probability["stoneBlock"] = stoneFinalProb / sum
        probability["clayBlock"] = clayFinalProb / sum
        
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
        case "clayBlock":
            return ClayBlock(x: x, y: y)
        default:
            return Block(x: x, y: y, asset: name, visible: false)
        }
    }
    
    
    
    func isValidBlock(x: Int, y: Int) -> Block{
        
        if self.precalculatedBlocks["\(x) \(y)"] != nil{
            return self.precalculatedBlocks["\(x) \(y)"]!
        }
        
        if self.precalculatedBlocks.count > 100000{
            self.precalculatedBlocks = [:]
        }
        
        let height = terrainFunction(x, seed: 8, range: 1...8)
        let temperature = (Double(terrainHolesFunction(x, y: y, seed: 6, range: 6...8)) - Double(y - 125) * 0.005)
        let roughness = scaleVal(6...8, y: Double(terrainFunction(x, seed: 3, range: 6...8)))
        
        //let scaledHeight = scaleVal(1...8, y: Double(height))
        
        let shouldBeBlock = terrainHolesFunction(x, y: y, seed: 1, range: 1...4)
        
        if y > height{
            if shouldBeBlock >= 0.6 && shouldBeBlock <= 1.0{
                let ans = stringToBlockObject(x, y: y, name: determineBlock(height, x: x, y: y, temperature: temperature))
                self.precalculatedBlocks["\(x) \(y)"] = ans
                return ans
            }
//            if isWaterHole(x, y: y, wavelengths: 8...8) == true{
//                let ans = WaterBlock(x: x, y: y)
//                self.precalculatedBlocks["\(x) \(y)"] = ans
//                return ans
//            }
            let ans = stringToBlockObject(x, y: y, name: "")
            self.precalculatedBlocks["\(x) \(y)"] = ans
            return ans
        }
        if shouldBeBlock >= roughness * 0.33{
            let ans = stringToBlockObject(x, y: y, name: determineBlock(height, x: x, y: y, temperature: temperature))
            self.precalculatedBlocks["\(x) \(y)"] = ans
            return ans
        }
        let ans = stringToBlockObject(x, y: y, name: "")
        self.precalculatedBlocks["\(x) \(y)"] = ans
        return ans
    }
    
    func terrainFunction(a: Int, seed: Int, range: Range<Int>) -> Int{
        
        if self.precalculatedTerrain.count > 100000{
            self.precalculatedTerrain = [:]
        }
        
        var total1 = 0
        
        if self.precalculatedTerrain[a] != nil{
            return self.precalculatedTerrain[a]!
        }
        
        for i in range{
            let pt1 = Int(pow(2.0, Double(i)))
            total1 += noiseGenerator1d(a, wavelength: pt1, amplitude: pt1 / 2, seed: seed)
        }
        
        self.precalculatedTerrain[a] = total1
        
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
    
//    func isWaterHole(x: Int, y: Int, wavelengths: Range<Int>) -> Bool{
//        for i in wavelengths{
//            let wave = Int(pow(2.0, Double(i)))
//            let leftX = x - (x % wave)
//            let rightX = leftX + wave
//            let leftLeftX = leftX - wave
//            let rightRightX = rightX + wave
//            
//            let leftXHeight = terrainFunction(leftX, seed: 8, range: 1...8)
//            let leftLeftXHeight = terrainFunction(leftLeftX, seed: 8, range: 1...8)
//            let rightXHeight = terrainFunction(rightX, seed: 8, range: 1...8)
//            let rightRightXHeight = terrainFunction(rightRightX, seed: 8, range: 1...8)
//            
//            if leftLeftXHeight > leftXHeight && rightXHeight > leftXHeight{
//                if randRange(0, maxVal: 1, seed: Int64(leftXHeight * leftX * i * 5)) <= self.calculateWaterProbability((Double(terrainHolesFunction(leftX, y: leftXHeight, seed: 6, range: 6...8)) - Double(leftXHeight - 125) * 0.005)){
//                    let height = randRange(1, maxVal: Double(min(leftLeftXHeight - leftXHeight, rightXHeight - leftXHeight)), seed: Int64(leftXHeight * leftX * 2 * i))
//                    if y - leftXHeight <= Int(height){
//                        return true
//                    }
//                }
//            }
//            
//            if leftXHeight > rightXHeight && rightRightXHeight > rightXHeight{
//                if randRange(0, maxVal: 1, seed: Int64(rightXHeight * rightX * i * 5)) <= self.calculateWaterProbability((Double(terrainHolesFunction(rightX, y: rightXHeight, seed: 6, range: 6...8)) - Double(rightXHeight - 125) * 0.005)){
//                    let height = randRange(1, maxVal: Double(min(leftXHeight - rightXHeight, rightRightXHeight - rightXHeight)), seed: Int64(rightXHeight * rightX * 2 * i))
//                    if y - rightXHeight < Int(height){
//                        return true
//                    }
//                }
//            }
//        }
//        return false
//    }
//    
//    func calculateWaterProbability(temp: Double) -> Double{
//        var prob = -7 * (temp - 0.5) * (temp - 0.5) + 0.7
//        
//        if prob < 0.05{
//            prob = 0.05
//        }
//        
//        return prob
//    }
    
    
//    func isWater(blockType: Block, var visited: [String] = []) -> Bool{
//        let directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
//        if self.memo.count > 100000{
//            self.memo = [:]
//        }
//        
//        if blockType.asset == "waterBlock"{
//            return true
//        }
//        
//        if self.memo["\(blockType.x) \(blockType.y)"] != nil{
//            return self.memo["\(blockType.x) \(blockType.y)"]!
//        }
//        
//        if blockType.y > self.terrainFunction(blockType.x, seed: 8, range: 1...8){
//            return false
//        }
//        
//        if blockType.visible == false{
//            for i in 0..<directions.count{
//                if (visited.contains("\(blockType.x + directions[i][0])  \(blockType.y + directions[i][1])")) == false{
//                    visited.append("\(blockType.x + directions[i][0])  \(blockType.y + directions[i][1])")
//                    let ans = self.isWater(self.isValidBlock(blockType.x + directions[i][0], y: blockType.y + directions[i][1]), visited: visited)
//                    visited.popLast()
//                    if ans == true{
//                        self.memo["\(blockType.x) \(blockType.y)"] = true
//                        return true
//                    }
//                }
//            }
//        }
//        self.memo["\(blockType.x) \(blockType.y)"] = false
//        return false
//    }
}