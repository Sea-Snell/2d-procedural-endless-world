//
//  terrainWorld.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation
import SpriteKit

class TerrainWorld: SKNode{
    var blockSize: Int
    var blockWidth: Int
    var terrain: [Terrain]
    var terrainData: [Int]
    var start: Int
    
    override init() {
        self.start = 0
        self.blockSize = 1
        self.blockWidth = 50
        self.terrainData = []
        self.terrain = []
        
        super.init()
        
        for _ in 0..<30{
            self.addBlockRight()
            self.addBlockLeft()
        }
    }
    
    func addBlockRight(){
        let startIdx = (terrain.count * self.blockSize) + self.start
        
        let terrainBlockData = generateTerrainData(startIdx, n: self.blockSize)
        let terrainBlock = Terrain(n: self.blockSize, blockSize: self.blockWidth, terrainData: terrainBlockData)
        terrainBlock.generateTerrain()
        terrainBlock.position.x = self.position.x + CGFloat(CGFloat(startIdx) * (CGFloat(self.blockWidth)))
        terrainBlock.position.y = self.position.y
        self.addChild(terrainBlock)
        
        self.terrain.append(terrainBlock)
        self.terrainData += terrainBlockData
    }
    
    func addBlockLeft(){
        let startIdx = self.start - self.blockSize
        self.start = startIdx
        
        let terrainBlockData = generateTerrainData(startIdx, n: self.blockSize)
        let terrainBlock = Terrain(n: self.blockSize, blockSize: self.blockWidth, terrainData: terrainBlockData)
        terrainBlock.generateTerrain()
        terrainBlock.position.x = self.position.x + CGFloat(CGFloat(startIdx) * (CGFloat(self.blockWidth)))
        terrainBlock.position.y = self.position.y
        self.addChild(terrainBlock)
        
        self.terrain.insert(terrainBlock, atIndex: 0)
        self.terrainData = terrainBlockData + terrainData
    }
    
    func removeBlockLeft(){
        self.removeChildrenInArray([self.terrain[0]])
        self.terrain.removeAtIndex(0)
        self.terrainData = Array(self.terrainData[self.blockSize..<self.terrainData.count])
        self.start += self.blockSize
    }
    
    func removeBlockRight(){
        self.removeChildrenInArray([self.terrain[self.terrain.count - 1]])
        self.terrain.removeAtIndex(self.terrain.count - 1)
        self.terrainData = Array(self.terrainData[0..<self.terrainData.count - self.blockSize])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}