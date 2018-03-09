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
    var blockWidth: CGFloat
    var terrain: [[Terrain]]
    var terrainData: [[Block]]
    var start: CGPoint
    var point: CGPoint
    var dataGenerator: GenerateTerrainData
    
    override init() {
        self.start = CGPoint(x: 0, y: 0)
        self.blockSize = 1
        self.blockWidth = 12.5
        self.terrainData = []
        self.terrain = []
        self.point = CGPoint(x: 0, y: 0)
        self.dataGenerator = GenerateTerrainData()
        
        super.init()
        
        self.point = CGPoint(x: self.position.x, y: self.position.y)
        
        for _ in 0..<104{
            self.addBlockColRight(104)
        }
    }
    
    func addBlockColRight(_ colSize: Int){
        var blockX = 0
        
        if self.terrainData.count != 0{
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
            let data = self.dataGenerator.generateTerrainData(blockPos, blockSize: self.blockSize)
            for x in 0..<self.blockSize{
                terrainData[x + (i * self.blockSize)] += data[x]
            }
        }
        
        for i in 0..<colSize{
            let terrainVal = Terrain(blockSize: self.blockSize, blockWidth: self.blockWidth, terrainData: self.splice2dArray(self.blockSize * i..<self.blockSize * (i + 1), range2: self.terrainData[0].count - self.blockSize..<self.terrainData[0].count, items: self.terrainData))
            terrainVal.generateTerrain()
            terrainVal.position.x = self.point.x + (CGFloat(blockX) - self.start.x) * CGFloat(self.blockWidth)
            terrainVal.position.y = self.point.y + CGFloat(i * self.blockSize) * self.blockWidth
            self.addChild(terrainVal)
            
            self.terrain[i].append(terrainVal)
        }
    }
    
    
    func addBlockColLeft(_ colSize: Int){
        if self.terrainData.count != 0{
            self.start.x -= CGFloat(self.blockSize)
            self.point.x -= CGFloat(self.blockSize) * self.blockWidth
        }
        
        let blockX = self.start.x
        
        if self.terrainData.count == 0{
            for _ in 0..<colSize * blockSize{
                self.terrainData.append([])
            }
            for _ in 0..<colSize{
                self.terrain.append([])
            }
        }
        
        for i in 0..<colSize{
            let blockPos = CGPoint(x: CGFloat(blockX), y: self.start.y + CGFloat(i * self.blockSize))
            let data = self.dataGenerator.generateTerrainData(blockPos, blockSize: self.blockSize)
            
            for x in 0..<self.blockSize{
                terrainData[x + (i * self.blockSize)] = data[x] + terrainData[x + (i * self.blockSize)]
            }
        }
        
        for i in 0..<colSize{
            let terrainVal = Terrain(blockSize: self.blockSize, blockWidth: self.blockWidth, terrainData: self.splice2dArray(self.blockSize * i..<self.blockSize * (i + 1), range2: 0..<self.blockSize, items: self.terrainData))
            terrainVal.generateTerrain()
            terrainVal.position.x = self.point.x
            terrainVal.position.y = self.point.y + CGFloat(i * self.blockSize) * self.blockWidth
            self.addChild(terrainVal)
            
            self.terrain[i].insert(terrainVal, at: 0)

        }
    }
    
    func addBlockRowTop(_ rowSize: Int){
        var blockY = 0
        
        if self.terrainData.count != 0{
            blockY = Int(self.start.y) + (self.terrainData.count)
        }
        
        for _ in 0..<blockSize{
            self.terrainData.append([])
        }
        
        self.terrain.append([])
        
        for i in 0..<rowSize{
            let blockPos = CGPoint(x: self.start.x + CGFloat(i * self.blockSize), y: CGFloat(blockY))
            let data = self.dataGenerator.generateTerrainData(blockPos, blockSize: self.blockSize)
            for x in (blockY - Int(self.start.y))..<self.terrainData.count{
                self.terrainData[x] += data[x - (blockY - Int(self.start.y))]
            }
        }
        
        for i in 0..<rowSize{
            let terrainVal = Terrain(blockSize: self.blockSize, blockWidth: self.blockWidth, terrainData: self.splice2dArray(self.terrainData.count - self.blockSize..<self.terrainData.count, range2: i * self.blockSize..<(i + 1) * self.blockSize, items: self.terrainData))
            terrainVal.generateTerrain()
            terrainVal.position.x = self.point.x + CGFloat(i * self.blockSize) * self.blockWidth
            terrainVal.position.y = self.point.y + (CGFloat(blockY) - self.start.y) * CGFloat(self.blockWidth)
            self.addChild(terrainVal)
            
            self.terrain[self.terrain.count - 1].append(terrainVal)
        }
    }
    
    func addBlockRowBottom(_ rowSize: Int){
        if self.terrainData.count != 0{
            self.start.y -= CGFloat(self.blockSize)
            self.point.y -= CGFloat(self.blockSize) * self.blockWidth
        }
        
        let blockY = self.start.y
        
        for _ in 0..<blockSize{
            self.terrainData.insert([], at: 0)
        }
        
        self.terrain.insert([], at: 0)
        
        for i in 0..<rowSize{
            let blockPos = CGPoint(x: self.start.x + CGFloat(i * self.blockSize), y: CGFloat(blockY))
            let data = self.dataGenerator.generateTerrainData(blockPos, blockSize: self.blockSize)
            for x in 0..<self.blockSize{
                self.terrainData[x] += data[x]
            }
        }
        
        for i in 0..<rowSize{
            let terrainVal = Terrain(blockSize: self.blockSize, blockWidth: self.blockWidth, terrainData: self.splice2dArray(0..<self.blockSize, range2: i * self.blockSize..<(i + 1) * self.blockSize, items: self.terrainData))
            terrainVal.generateTerrain()
            terrainVal.position.x = self.point.x + CGFloat(i * self.blockSize) * self.blockWidth
            terrainVal.position.y = self.point.y
            self.addChild(terrainVal)
            
            self.terrain[0].append(terrainVal)
        }
    }
    
    func removeBlockColLeft(){
        let colSize = self.terrain.count
        var deadTerain: [Terrain] = []
        for i in 0..<colSize{
            self.terrainData[i] = Array(self.terrainData[i][self.blockSize..<self.terrainData.count])
            deadTerain.append(self.terrain[i][0])
            self.terrain[i].remove(at: 0)
        }
        
        self.start.x += CGFloat(self.blockSize)
        self.point.x += CGFloat(self.blockSize) * self.blockWidth
        
        self.removeChildren(in: deadTerain)
    }
    
    func removeBlockColRight(){
        let colSize = self.terrain.count
        var deadTerain: [Terrain] = []
        for i in 0..<colSize{
            self.terrainData[i] = Array(self.terrainData[i][0..<self.terrainData.count - self.blockSize])
            deadTerain.append(self.terrain[i][self.terrain.count - 1])
            self.terrain[i].removeLast()
        }
        self.removeChildren(in: deadTerain)
    }
    
    func removeBlockRowBottom(){
        self.terrainData = Array(self.terrainData[self.blockSize..<self.terrainData.count])
        self.removeChildren(in: self.terrain[0])
        self.terrain.remove(at: 0)
        
        self.start.y += CGFloat(self.blockSize)
        self.point.y += CGFloat(self.blockSize) * self.blockWidth
    }
    
    func removeBlockRowTop(){
        self.terrainData = Array(self.terrainData[0..<self.terrainData.count - self.blockSize])
        self.removeChildren(in: self.terrain[self.terrain.count - 1])
        self.terrain.removeLast()
    }
    
    func splice2dArray(_ range1: CountableRange<Int>, range2: CountableRange<Int>, items: [[Block]]) -> [[Block]]{
        var newItems: [[Block]] = []
        for i in range1{
            var temp: [Block] = []
            for x in range2{
                temp.append(items[i][x])
            }
            newItems.append(temp)
        }
        return newItems
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
