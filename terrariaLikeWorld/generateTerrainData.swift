//
//  generateTerrainData.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func generateTerrainData(leftPos: CGPoint, blockSize: Int) -> [[Block]]{
    var terrainData: [[Block]] = []
    for x in Int(leftPos.y)..<Int(leftPos.y) + blockSize{
        var temp: [Block] = []
        for i in Int(leftPos.x)..<Int(leftPos.x) + blockSize{
            let block = Block(x: i, y: x)
            temp.append(block)
        }
        terrainData.append(temp)
    }
    
    return terrainData
}