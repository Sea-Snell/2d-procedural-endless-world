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
        if CGFloat(currentPos) >= self.terrainWorld.start.x && CGFloat(currentPos) < CGFloat(self.terrainWorld.terrainData.count) + self.terrainWorld.start.x{
            let currentHeight = terrainFunction(currentPos)
            let newY = centerPos.y - CGFloat(currentHeight * self.terrainWorld.blockWidth)
            self.position.y = newY
            //let moveY = SKAction.moveToY(newY, duration: 0.5)
            //self.runAction(moveY)
        }
    }
    
    func endlessTerrain(leftBound: CGFloat, rightBound: CGFloat, topBound: CGFloat, bottomBound: CGFloat){
        if self.terrainWorld.terrain.count > 0{
            let isOutLeftBound = self.position.x + (self.terrainWorld.terrain[0][0].position.x + CGFloat(self.terrainWorld.blockWidth * self.terrainWorld.blockSize)) < leftBound
            let isOutRightBound = self.position.x + self.terrainWorld.terrain[0][self.terrainWorld.terrain[0].count - 1].position.x > rightBound
            let isOutTopBound = self.position.y + (self.terrainWorld.terrain[self.terrainWorld.terrain.count - 1][0].position.y + CGFloat(self.terrainWorld.blockWidth * self.terrainWorld.blockSize)) > topBound
            let isOutBottomBound = self.position.y + self.terrainWorld.terrain[0][0].position.y < bottomBound
        
            if isOutLeftBound{
                self.terrainWorld.removeBlockColLeft()
                self.terrainWorld.addBlockColRight(26)
            }
        
            if isOutRightBound{
                self.terrainWorld.removeBlockColRight()
                self.terrainWorld.addBlockColLeft(26)
            }
            
            if isOutTopBound{
                self.terrainWorld.removeBlockRowTop()
                self.terrainWorld.addBlockRowBottom(26)
            }
            
            if isOutBottomBound{
                self.terrainWorld.removeBlockRowBottom()
                self.terrainWorld.addBlockRowTop(26)
            }
        }
    }
    
    
}