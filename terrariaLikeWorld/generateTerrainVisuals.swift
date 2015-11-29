//
//  generateTerrainVisuals.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation
import SpriteKit

class Terrain: SKNode{
    var blockSize: Int
    var terrainData: [[Int]]
    var blockWidth: Int
    
    init(blockSize: Int, blockWidth: Int, terrainData: [[Int]]) {
        self.blockSize = blockSize
        self.blockWidth = blockWidth
        self.terrainData = terrainData
        
        
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func generateTerrain(){
        for i in 0..<self.blockSize{
            for x in 0..<self.blockSize{
                if self.terrainData[x][i] == 1{
                    
                    let block = SKSpriteNode(imageNamed: "tile")
                    block.position.x = self.position.x + CGFloat(i * self.blockWidth)
                    block.position.y = self.position.y + CGFloat(x * self.blockWidth)
                    block.size.width = CGFloat(self.blockWidth)
                    block.size.height = CGFloat(self.blockWidth)
                    self.addChild(block)
                }
            }
        }
    }
}