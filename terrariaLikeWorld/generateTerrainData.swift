//
//  generateTerrainData.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func generateTerrainData(leftPos: CGPoint, blockSize: Int) -> [[Int]]{
    var terrainData: [[Int]] = []
    for x in Int(leftPos.y)..<Int(leftPos.y) + blockSize{
        var temp: [Int] = []
        for i in Int(leftPos.x)..<Int(leftPos.x) + blockSize{
            temp.append(isValidBlock(i, y: x))
        }
        terrainData.append(temp)
    }
    
    return terrainData
}