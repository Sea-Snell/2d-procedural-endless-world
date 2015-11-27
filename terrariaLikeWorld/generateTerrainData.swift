//
//  generateTerrainData.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func generateTerrainData(leftPos: Int, n: Int) -> [Int]{
    var terrainData: [Int] = []
    for i in leftPos..<leftPos + n{
        terrainData.append(terrainFunction(i))
    }
    return terrainData
}