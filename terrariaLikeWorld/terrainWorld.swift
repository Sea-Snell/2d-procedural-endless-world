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
    var terrain: [[Terrain]]
    var terrainData: [[Int]]
    var start: CGPoint
    var point: CGPoint
    
    override init() {
        self.start = CGPoint(x: 0, y: 0)
        self.blockSize = 1
        self.blockWidth = 50
        self.terrainData = []
        self.terrain = []
        self.point = CGPoint(x: 0, y: 0)
        
        super.init()
        
        self.point = CGPoint(x: self.position.x, y: self.position.y)
        for _ in 0..<26{
            self.addBlockColRight(26)
        }
    }
    
    func addBlockColRight(colSize: Int){
        var blockX = 0
        
        if self.terrainData != []{
            blockX = Int(self.start.x) + (self.terrainData[0].count)
        }
        else{
            for _ in 0..<colSize * blockSize{
                self.terrainData.append([])
            }
            
            for _ in 0..<colSize{
                self.terrain.append([])
            }
        }
        
        for i in 0..<colSize{
            let blockPos = CGPoint(x: CGFloat(blockX), y: self.start.y + CGFloat(i * self.blockSize))
            let data = generateTerrainData(blockPos, blockSize: self.blockSize)
            
            for x in 0..<self.blockSize{
                self.terrainData[x + (i * self.blockSize)] += data[x]
            }
        }
        
        
        for i in 0..<colSize{
            let terrainVal = Terrain(blockSize: self.blockSize, blockWidth: self.blockWidth, terrainData: self.array2dSplice(self.terrainData, range1: i * self.blockSize..<(i + 1) * self.blockSize, range2: self.terrainData[0].count - self.blockSize..<self.terrainData[0].count))
            terrainVal.generateTerrain()
            terrainVal.position.x = self.point.x + (CGFloat(blockX) - self.start.x) * CGFloat(self.blockWidth)
            terrainVal.position.y = self.point.y + CGFloat(i * self.blockSize * self.blockWidth)
            self.addChild(terrainVal)
            
            self.terrain[i].append(terrainVal)
        }
    }
    
    
    func addBlockColLeft(colSize: Int){
        if self.terrainData != []{
            self.start.x -= CGFloat(self.blockSize)
            self.point.x -= CGFloat(self.blockSize * self.blockWidth)
        }
        
        let blockX = self.start.x
        
        if self.terrainData == []{
            for _ in 0..<colSize * blockSize{
                self.terrainData.append([])
            }
            for _ in 0..<colSize{
                self.terrain.append([])
            }
        }
        for i in 0..<colSize{
            let blockPos = CGPoint(x: CGFloat(blockX), y: self.start.y + CGFloat(i * self.blockSize))
            let data = generateTerrainData(blockPos, blockSize: self.blockSize)
        
            for x in 0..<self.blockSize{
                terrainData[x + (i * self.blockSize)] = data[x] + terrainData[x + (i * self.blockSize)]
            }
        }
        
        
        for i in 0..<colSize{
            
            let terrainVal = Terrain(blockSize: self.blockSize, blockWidth: self.blockWidth, terrainData: self.array2dSplice(self.terrainData, range1: i * self.blockSize..<(i + 1) * self.blockSize, range2: 0..<self.blockSize))
            terrainVal.generateTerrain()
            terrainVal.position.x = self.point.x
            terrainVal.position.y = self.point.y + CGFloat(i * self.blockSize * self.blockWidth)
            self.addChild(terrainVal)
            
            self.terrain[i].insert(terrainVal, atIndex: 0)

        }
    }
    
    func addBlockRowTop(rowSize: Int){
        var blockY = 0
        
        if self.terrainData != []{
            blockY = Int(self.start.y) + (self.terrainData.count)
        }
        
        for _ in 0..<blockSize{
            self.terrainData.append([])
        }
        self.terrain.append([])
        
        
        for i in 0..<rowSize{
            let blockPos = CGPoint(x: self.start.x + CGFloat(i * self.blockSize), y: CGFloat(blockY))
            let data = generateTerrainData(blockPos, blockSize: self.blockSize)
            
            for x in (blockY - Int(self.start.y))..<self.terrainData.count{
                self.terrainData[x] += data[x - (blockY - Int(self.start.y))]
            }
        }
        
        
        for i in 0..<rowSize{
            let terrainVal = Terrain(blockSize: self.blockSize, blockWidth: self.blockWidth, terrainData: self.array2dSplice(self.terrainData, range1: self.terrainData.count - self.blockSize..<self.terrainData.count, range2: i * self.blockSize..<(i + 1) * self.blockSize))
            
            terrainVal.generateTerrain()
            terrainVal.position.x = self.point.x + CGFloat(i * self.blockSize * self.blockWidth)
            terrainVal.position.y = self.point.y + (CGFloat(blockY) - self.start.y) * CGFloat(self.blockWidth)
            self.addChild(terrainVal)
            
            self.terrain[self.terrain.count - 1].append(terrainVal)
        }
    }
    
    func addBlockRowBottom(rowSize: Int){
        if self.terrainData != []{
            self.start.y -= CGFloat(self.blockSize)
            self.point.y -= CGFloat(self.blockSize * self.blockWidth)
        }
        
        let blockY = self.start.y
        
        for _ in 0..<blockSize{
            self.terrainData.insert([], atIndex: 0)
        }
        
        self.terrain.insert([], atIndex: 0)
        
        for i in 0..<rowSize{
            let blockPos = CGPoint(x: self.start.x + CGFloat(i * self.blockSize), y: CGFloat(blockY))
            let data = generateTerrainData(blockPos, blockSize: self.blockSize)
            
            for x in 0..<self.blockSize{
                self.terrainData[x] += data[x]
            }
        }
        
        for i in 0..<rowSize{
            let terrainVal = Terrain(blockSize: self.blockSize, blockWidth: self.blockWidth, terrainData: self.array2dSplice(self.terrainData, range1: 0..<self.blockSize, range2: i * self.blockSize..<(i + 1) * self.blockSize))
            terrainVal.generateTerrain()
            terrainVal.position.x = self.point.x + CGFloat(i * self.blockSize * self.blockWidth)
            terrainVal.position.y = self.point.y
            self.addChild(terrainVal)
            
            self.terrain[0].append(terrainVal)
        }
        
        self.findWater()
    }
    
    func removeBlockColLeft(){
        let colSize = self.terrain.count
        var deadTerain: [Terrain] = []
        for i in 0..<colSize{
            self.terrainData[i] = Array(self.terrainData[i][self.blockSize..<self.terrainData.count])
            deadTerain.append(self.terrain[i][0])
            self.terrain[i].removeAtIndex(0)
        }
        
        self.start.x += CGFloat(self.blockSize)
        self.point.x += CGFloat(self.blockSize * self.blockWidth)
        
        self.removeChildrenInArray(deadTerain)
    }
    
    func removeBlockColRight(){
        let colSize = self.terrain.count
        var deadTerain: [Terrain] = []
        for i in 0..<colSize{
            self.terrainData[i] = Array(self.terrainData[i][0..<self.terrainData.count - self.blockSize])
            deadTerain.append(self.terrain[i][self.terrain.count - 1])
            self.terrain[i].removeLast()
        }
        self.removeChildrenInArray(deadTerain)
    }
    
    func removeBlockRowBottom(){
        self.terrainData = Array(self.terrainData[self.blockSize..<self.terrainData.count])
        self.removeChildrenInArray(self.terrain[0])
        self.terrain.removeAtIndex(0)
        
        self.start.y += CGFloat(self.blockSize)
        self.point.y += CGFloat(self.blockSize * self.blockWidth)
    }
    
    func removeBlockRowTop(){
        self.terrainData = Array(self.terrainData[0..<self.terrainData.count - self.blockSize])
        self.removeChildrenInArray(self.terrain[self.terrain.count - 1])
        self.terrain.removeLast()
    }
    
    func findWater(){
        for i in 0..<self.terrainData.count{
            for x in 0..<self.terrainData[i].count{
                if self.terrainData[i][x] == 5{
                    self.processWater([i, x])
                }
            }
        }
    }
    
    func processWater(pos: [Int]){
        let moves = [[-1, 0], [0, -1], [0, 1]]
        if pos[0] + moves[0][0] >= 0 && pos[0] + moves[0][0] < self.terrainData.count && pos[1] + moves[0][1] >= 0 && pos[1] + moves[0][1] < self.terrainData[0].count && self.terrainData[pos[0] + moves[0][0]][pos[1] + moves[0][1]] == 0{
            self.terrainData[pos[0] + moves[0][0]][pos[1] + moves[0][1]] = 5
            self.processWater([pos[0] + moves[0][0], pos[1] + moves[0][1]])
        }
        else{
            for i in 1..<moves.count{
                if pos[0] + moves[i][0] >= 0 && pos[0] + moves[i][0] < self.terrainData.count && pos[1] + moves[i][1] >= 0 && pos[1] + moves[i][1] < self.terrainData[0].count && self.terrainData[pos[0] + moves[i][0]][pos[1] + moves[i][1]] == 0{
                    self.terrainData[pos[0] + moves[i][0]][pos[1] + moves[i][1]] = 5
                    self.processWater([pos[0] + moves[i][0], pos[1] + moves[i][1]])
                }
            }
        }
    }
    
    func array2dSplice(array: [[Int]], range1: Range<Int>, range2: Range<Int>) -> [[Int]]{
        var newArray: [[Int]] = []
        for i in range1{
            newArray.append([])
            for x in range2{
                newArray[newArray.count - 1].append(array[i][x])
            }
        }
        return newArray
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}