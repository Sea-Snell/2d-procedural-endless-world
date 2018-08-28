//
//  generateTerrainData.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//




import Foundation

class GenerateTerrainData{
    
    var memo: [GridPoint: Block]
    var randomNums: RandomNumber
    init(){
        self.memo = Dictionary<GridPoint, Block>(minimumCapacity: 100000)
        self.randomNums = RandomNumber()
    }
    
    func generateTerrainData(x: Int, y: Int) -> Block{
        let gridPoint = GridPoint(x: x, y: y)
        if let block = self.memo[gridPoint]{
            return block
        }
        
        let height = getGroundHeight(x: x)
        let temperature = getTemp(x: x, y: y)
        let caveStrength = getCaveStrength(x: x, y: y)
        let caveProb = getCaveProb(x: x, y: y)
        let cloudProb = getCloudProb(x: x, y: y)
        
        var block = Block()
        block.x = x
        block.y = y
        block.visible = false
        block.asset = ""
        
        if y > height{
            if cloudProb >= 0.6 && cloudProb <= 1.0{
                block.visible = true
                block.asset = "cloudBlock"
            }
        }
        else{
            if caveProb >= caveStrength * 0.33{
                block.visible = true
                block.asset = determineBlock(heightAtX: height, x: x, y: y, temperature: temperature)
            }
        }
        return insertMemo(gridPoint: gridPoint, block: block)
    }
    
    func getGroundHeight(x: Int) -> Int{
        return Int(224.0 * terrainFunction(a: x, seed: 8, range: 1...8))
    }
    
    func getTemp(x: Int, y: Int) -> Double{
        return terrainHolesFunction(x: x, y: y, seed: 6, range: 6...8) - Double(y - 125) * 0.005
    }
    
    func getCaveStrength(x: Int, y: Int) -> Double{
        return terrainHolesFunction(x: x, y: y, seed: 3, range: 6...8)
    }
    
    func getCaveProb(x: Int, y: Int) -> Double{
        return terrainHolesFunction(x: x, y: y, seed: 1, range: 1...4)
    }
    
    func getCloudProb(x: Int, y: Int) -> Double{
        return terrainHolesFunction(x: x, y: y, seed: 2, range: 2...5) + min((Double(y) - 225.0) * 0.001, 0.0)
    }
    
//    func getTree(x: Int, groundHeight: Int){
//        let treeProab = scaleVal(range: 6...8, y: Double(terrainFunction(a: x, seed: 5, range: 6...8)))
//        let randVal = randRange(minVal: 0, maxVal: 1, seed: Int64(x * 5))
//
//        if randVal < treeProab{
//            let height = randRange(minVal: 5.0, maxVal: 30.0, seed: Int64(x * 6))
//
//        }
//    }
    
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
        
        let keyList = ["snowBlock", "sandBlock", "dirtBlock", "stoneBlock", "clayBlock"]
        self.randomNums.seed = Int64(x * y * 4)
        let randVal = self.randomNums.rand()
        var total = 0.0
        if randVal == 0.0{
            return keyList[0]
        }
        for i in 0..<keyList.count{
            if randVal > total && randVal <= total + probability[keyList[i]]!{
                return keyList[i]
            }
            total += probability[keyList[i]]!
        }
        return ""
    }
    
    func terrainFunction(a: Int, seed: Int, range: CountableClosedRange<Int>) -> Double{
        var total1 = 0
        for i in range{
            let pt1 = Int(pow(2.0, Double(i)))
            total1 += noiseGenerator1d(a: a, wavelength: pt1, amplitude: pt1 / 2, seed: seed)
        }
        return Double(total1) / (pow(2.0, Double(range.upperBound)) - pow(2.0, Double(range.lowerBound - 1)))
    }
    
    func terrainHolesFunction(x: Int, y: Int, seed: Int, range: CountableClosedRange<Int>) -> Double{
        var total1 = 0
        for i in range{
            let pt1 = Int(pow(2.0, Double(i)))
            total1 += noiseGenerator2d(x: x, y: y, wavelength: pt1, amplitude: pt1 / 2, seed: seed)
        }
        return Double(total1) / (pow(2.0, Double(range.upperBound)) - pow(2.0, Double(range.lowerBound - 1)))
    }
    
    func noiseGenerator1d(a: Int, wavelength: Int, amplitude: Int, seed: Int) -> Int{
        if a >= 0{
            self.randomNums.seed = Int64((a - (a % wavelength)) * wavelength * seed)
            let left = self.randomNums.rand(minVal: 1.0, maxVal: Double(amplitude))
            self.randomNums.seed = Int64((wavelength + (a - (a % wavelength))) * wavelength * seed)
            let right = self.randomNums.rand(minVal: 1.0, maxVal: Double(amplitude))
            
            return Int(cosineInterplation(a: left, b: right, x: Double(a % wavelength) / Double(wavelength)))
        }
        else{
            self.randomNums.seed = Int64((a - (a % wavelength)) * wavelength * seed)
            let left = self.randomNums.rand(minVal: 1.0, maxVal: Double(amplitude))
            self.randomNums.seed = Int64((-wavelength + (a - (a % wavelength))) * wavelength * seed)
            let right = self.randomNums.rand(minVal: 1.0, maxVal: Double(amplitude))
            
            return Int(cosineInterplation(a: left, b: right, x: abs(Double(a % wavelength)) / Double(wavelength)))
        }
    }
    
    func noiseGenerator2d(x: Int, y: Int, wavelength: Int, amplitude: Int, seed: Int) -> Int{
        let indexA = (x / wavelength) * wavelength
        let indexB = wavelength + (x / wavelength) * wavelength
        let horizontalBlendVal: Double = Double(x - indexA) / Double(wavelength)
        
        let indexC = (y / wavelength) * wavelength
        let indexD = wavelength + (y / wavelength) * wavelength
        let verticalBlendVal: Double = Double(y - indexC) / Double(wavelength)
        
        self.randomNums.seed = Int64(indexA * indexC * wavelength * seed)
        let tempA1 = self.randomNums.rand(minVal: 0.0, maxVal: Double(amplitude))
        self.randomNums.seed = Int64(indexB * indexC * wavelength * seed)
        let tempB1 = self.randomNums.rand(minVal: 0.0, maxVal: Double(amplitude))
        let top = cosineInterplation(a: tempA1, b: tempB1, x: horizontalBlendVal)
        
        self.randomNums.seed = Int64(indexA * indexD * wavelength * seed)
        let tempA2 = self.randomNums.rand(minVal: 0.0, maxVal: Double(amplitude))
        self.randomNums.seed = Int64(indexB * indexD * wavelength * seed)
        let tempB2 = self.randomNums.rand(minVal: 0.0, maxVal: Double(amplitude))
        let bottom = cosineInterplation(a: tempA2, b: tempB2, x: horizontalBlendVal)
        
        return Int(cosineInterplation(a: top, b: bottom, x: verticalBlendVal))
        
    }
    
    func cosineInterplation(a: Double, b: Double, x: Double) -> Double{
        let scaled = x * 3.1415927
        let cosined = (1 - cos(scaled)) * 0.5
        
        return  a * (1 - cosined) + b * cosined
    }
    
    func insertMemo(gridPoint: GridPoint, block: Block) -> Block{
        if self.memo.count == self.memo.capacity{
            self.memo.removeAll(keepingCapacity: true)
        }
        self.memo[gridPoint] = block
        return block
    }
}

class Block{
    var asset: String?
    var x: Int?
    var y: Int?
    var visible: Bool?
    
    init(){
        self.x = nil
        self.y = nil
        self.asset = nil
        self.visible = nil
    }
}

//class Tree{
//    var x: Int
//    var topY: Int
//
//    init(x: Int, topY: Int){
//        self.x = x
//        self.topY = topY
//    }
//}

struct GridPoint: Hashable{
    var x: Int
    var y: Int
}
