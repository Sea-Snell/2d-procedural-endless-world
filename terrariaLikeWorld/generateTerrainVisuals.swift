//
//  generateTerrainVisuals.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation
import SpriteKit

class Stack: SKNode{
    var size: Int
    var blockSize: Int
    init(size: Int, blockSize: Int) {
        self.size = size
        self.blockSize = blockSize
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateStack(){
        for i in 0..<self.size{
            let block = SKSpriteNode(imageNamed: "tile")
            block.position.x = self.position.x
            block.position.y = self.position.y + CGFloat(i * self.blockSize)
            block.size.width = CGFloat(self.blockSize)
            block.size.height = CGFloat(self.blockSize)
            self.addChild(block)
        }
    }
}


class Terrain: SKNode{
    var n: Int
    var terrainData: [Int]
    var blockSize: Int
    
    init(n: Int, blockSize: Int, terrainData: [Int]) {
        self.n = n
        self.blockSize = blockSize
        self.terrainData = terrainData
        
        
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func generateTerrain(){
        for i in 0..<self.n{
            let stack = Stack(size: self.terrainData[i], blockSize: self.blockSize)
            stack.generateStack()
            stack.position.x = self.position.x + CGFloat(i * self.blockSize)
            stack.position.y = self.position.y
            self.addChild(stack)
        }
    }
}