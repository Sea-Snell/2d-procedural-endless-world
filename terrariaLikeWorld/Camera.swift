//
//  Camera.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation
import SpriteKit

class MyCamera: SKNode{
    
    var terrainWorld: TerrainWorld
    var lowPoint: CGFloat
    
    override init() {
        self.terrainWorld = TerrainWorld()
        self.lowPoint = 0
        
        super.init()
        
        self.terrainWorld.position.x = self.position.x
        self.terrainWorld.position.y = self.position.y
        self.addChild(self.terrainWorld)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateYPos(centerPos: CGPoint){
        let currentPos = Int((centerPos.x - self.position.x) / CGFloat(self.terrainWorld.blockWidth))
        if currentPos >= self.terrainWorld.start && currentPos < self.terrainWorld.terrainData.count + self.terrainWorld.start{
            let currentHeight = self.terrainWorld.terrainData[currentPos - self.terrainWorld.start]
            let newY = centerPos.y - CGFloat(currentHeight * self.terrainWorld.blockWidth)
            let moveY = SKAction.moveToY(newY, duration: 0.5)
            self.runAction(moveY)
        }
    }
    
    func endlessTerrain(leftBound: CGFloat, rightBound: CGFloat){
        if self.terrainWorld.terrain.count > 0{
            let isOutLeftBound = self.position.x + (self.terrainWorld.terrain[0].position.x + CGFloat(self.terrainWorld.blockWidth * self.terrainWorld.blockSize)) < leftBound
            let isOutRightBound = self.position.x + self.terrainWorld.terrain[self.terrainWorld.terrain.count - 1].position.x > rightBound
        
            if isOutLeftBound{
                self.terrainWorld.removeBlockLeft()
                self.terrainWorld.addBlockRight()
            }
        
            if isOutRightBound{
                self.terrainWorld.removeBlockRight()
                self.terrainWorld.addBlockLeft()
            }
        }
    }
    
    
}