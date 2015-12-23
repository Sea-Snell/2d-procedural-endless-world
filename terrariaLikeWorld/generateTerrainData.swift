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
    
    init(){
        self.memo = [:]
    }
    
    func generateTerrainData(leftPos: CGPoint, blockSize: Int) -> [[Int]]{
        var terrainData: [[Int]] = []
        for x in Int(leftPos.y)..<Int(leftPos.y) + blockSize{
            var temp: [Int] = []
            for i in Int(leftPos.x)..<Int(leftPos.x) + blockSize{
                var block = isValidBlock(i, y: x)
                if isWater(i, y: x, blockType: block) == true{
                    block = 5
                }
                temp.append(block)
            }
            terrainData.append(temp)
        }
    
        return terrainData
    }
    
    func isWater(x: Int, y: Int, blockType: Int, last: String? = nil) -> Bool{
        if self.memo.count > 100000{
            self.memo = [:]
        }
        var val: Bool = false
        if blockType != 0 || y > terrainFunction(x, seed: 8, range: 1...8){
            if blockType == 5{
                val = true
            }
            else{
                val = false
            }
        }
        else if let memoVal = self.memo["\(x) \(y)"]{
            return memoVal
        }
        else{
            val = self.isWater(x, y: y + 1, blockType: isValidBlock(x, y: y + 1), last: "\(x) \(y)")
            if val == false{
                if "\(x - 1) \(y)" != last{
                    val = self.isWater(x - 1, y: y, blockType: isValidBlock(x - 1, y: y), last: "\(x) \(y)")
                }
            }
            if val == false{
                if "\(x + 1) \(y)" != last{
                    val = self.isWater(x + 1, y: y, blockType: isValidBlock(x + 1, y: y), last: "\(x) \(y)")
                }
            }
        }
        self.memo["\(x) \(y)"] = val
        return val
    }
}