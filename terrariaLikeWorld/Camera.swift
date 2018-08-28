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
    
    var blocks: [SKSpriteNode]
    var blockWidth: CGFloat
    var rectDims: (CGFloat, CGFloat)
    var gridDims: (Int, Int)
    var lastGridPos: (CGFloat, CGFloat)?
    var lastBlockWidth: CGFloat?
    var dataGenerator: GenerateTerrainData
    
    override init(){
        self.blocks = []
        self.blockWidth = 0.0
        self.rectDims = (0.0, 0.0)
        self.lastGridPos = nil
        self.lastBlockWidth = nil
        self.gridDims = (0, 0)
        self.dataGenerator = GenerateTerrainData()
        
        super.init()
    }
    
    func setUp(blockWidth: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat) {
        self.blockWidth = blockWidth
        self.gridDims = (Int(screenWidth / self.blockWidth) + 2, Int(screenHeight / self.blockWidth) + 2)
        self.rectDims = (CGFloat(self.gridDims.0) * self.blockWidth, CGFloat(self.gridDims.1) * self.blockWidth)
        
        if self.blocks.count > (self.gridDims.0 * self.gridDims.1){
            for _ in 0..<(self.blocks.count - (self.gridDims.0 * self.gridDims.1)){
                self.blocks[self.blocks.count - 1].removeFromParent()
                self.blocks.removeLast(1)
            }
        }
        
        if self.gridDims.0 * self.gridDims.1 > self.blocks.count{
            for _ in 0..<((self.gridDims.0 * self.gridDims.1) - self.blocks.count){
                let tempBlock = SKSpriteNode(imageNamed: "stoneBlock")
                self.addChild(tempBlock)
                self.blocks.append(tempBlock)
            }
        }
        
        let blockData = self.dataGenerator.generateTerrainData(x: 0, y: 0)
        for i in 0..<self.blocks.count{
            self.blocks[i].isHidden = !(blockData.visible!)
            if blockData.visible == true{
                self.blocks[i].texture = SKTexture(imageNamed: blockData.asset!)
            }
            self.blocks[i].anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.blocks[i].position = CGPoint(x: 0.0, y: 0.0)
            self.blocks[i].size = CGSize(width: self.blockWidth, height: self.blockWidth)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        var isFilledGrid: [GridPos: Bool] = [:]
        let rectCornerPos: (CGFloat, CGFloat) = getLeftCornerPos()
        let gridCornerPos: (CGFloat, CGFloat) = getLeftGridPos(leftCornerPos: rectCornerPos)
        
        if self.lastGridPos == nil || self.lastGridPos?.0 != gridCornerPos.0 || self.lastGridPos?.1 != gridCornerPos.1 || self.lastBlockWidth == nil || self.lastBlockWidth != self.blockWidth{
            for i in 0..<self.gridDims.0{
                for x in 0..<self.gridDims.1{
                    isFilledGrid[GridPos(x: gridCornerPos.0 + CGFloat(i) * self.blockWidth, y: gridCornerPos.1 + CGFloat(x) * self.blockWidth)] = false
                }
            }
        
            var needsPlacement: [SKSpriteNode] = []
            for i in 0..<self.blocks.count{
                if isFilledGrid[GridPos(x: self.blocks[i].position.x, y: self.blocks[i].position.y)] == false && !(self.blocks[i].position.x < rectCornerPos.0 || self.blocks[i].position.y < rectCornerPos.1 || self.blocks[i].position.x >= rectCornerPos.0 + self.rectDims.0 || self.blocks[i].position.y >= rectCornerPos.1 + self.rectDims.1){
                    isFilledGrid[GridPos(x: self.blocks[i].position.x, y: self.blocks[i].position.y)] = true
                }
                else{
                    needsPlacement.append(self.blocks[i])
                }
            }
        
            var currentIdx: Int = 0
            for (key, value) in isFilledGrid{
                if value == false{
                    let blockData = self.dataGenerator.generateTerrainData(x: Int(key.x / self.blockWidth), y: Int(key.y / self.blockWidth))
                    needsPlacement[currentIdx].position = CGPoint(x: key.x, y: key.y)
                    needsPlacement[currentIdx].isHidden = !(blockData.visible!)
                    if blockData.visible == true{
                        needsPlacement[currentIdx].texture = SKTexture(imageNamed: blockData.asset!)
                    }
                    currentIdx += 1
                }
            }
            self.lastGridPos = gridCornerPos
            self.lastBlockWidth = self.blockWidth
        }
    }
    
    func getLeftCornerPos() -> (CGFloat, CGFloat){
        return (-self.position.x - self.blockWidth, -self.position.y - self.blockWidth)
    }
    
    func getLeftGridPos(leftCornerPos: (CGFloat, CGFloat)) -> (CGFloat, CGFloat){
        var gridCornerPos: (CGFloat, CGFloat) = (0.0, 0.0)
        var tempVal = Int(leftCornerPos.0 / self.blockWidth)
        
        if CGFloat(tempVal) * self.blockWidth != leftCornerPos.0 && leftCornerPos.0 > 0.0{
            gridCornerPos.0 = CGFloat(tempVal + 1) * self.blockWidth
        }
        else{
            gridCornerPos.0 = CGFloat(tempVal) * self.blockWidth
        }
        
        tempVal = Int(leftCornerPos.1 / self.blockWidth)
        if CGFloat(tempVal) * self.blockWidth != leftCornerPos.1 && leftCornerPos.1 > 0.0{
            gridCornerPos.1 = CGFloat(tempVal + 1) * self.blockWidth
        }
        else{
            gridCornerPos.1 = CGFloat(tempVal) * self.blockWidth
        }
        return gridCornerPos
    }
    
    func goToGround(centerPos: CGPoint){
        let currentPos = Int((centerPos.x + getLeftCornerPos().0) / CGFloat(self.blockWidth))
        let currentHeight = self.dataGenerator.getGroundHeight(x: currentPos)
        let newY = centerPos.y - CGFloat(currentHeight) * self.blockWidth
        self.run(SKAction.moveTo(y: newY, duration: 0.5))
    }
}

struct GridPos: Hashable{
    var x: CGFloat
    var y: CGFloat
}
