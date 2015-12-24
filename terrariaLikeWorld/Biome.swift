//
//  Biome.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/23/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Biome{
    var primaryAsset: String
    var secondaryAsset: String
    var liquidAsset: String
    var heightAtX: Int
    var x: Int
    var y: Int
    var visible: Bool
    
    init(x: Int, y: Int, primaryAsset: String, secondaryAsset: String, liquidAsset: String, heightAtX: Int, visible: Bool){
        self.x = x
        self.y = y
        self.primaryAsset = primaryAsset
        self.secondaryAsset = secondaryAsset
        self.liquidAsset = liquidAsset
        self.heightAtX = heightAtX
        self.visible = visible
    }
    
    func determineBlock() -> Block?{
        if visible == false{
            return Block(x: self.x, y: self.y, asset: "", visible: false)
        }
        
        var probibality: Double = 0.00005 * Double((self.y - self.heightAtX) * (self.y - self.heightAtX)) + 0.05
        if probibality > 0.95{
            probibality = 0.95
        }
        
        let randVal = rand(Int64(x * y * 9))
        
        if randVal <= probibality{
            return self.stringToObject(self.secondaryAsset)!
        }
        return self.stringToObject(self.primaryAsset)!
    }
    
    func stringToObject(asset: String) -> Block?{
        switch(asset){
            case "sandBlock":
                return Sand(x: self.x, y: self.y)
            case "snowBlock":
                return Snow(x: self.x, y: self.y)
            case "dirtBlock":
                return Dirt(x: self.x, y: self.y)
            case "stoneBlock":
                return Stone(x: self.x, y: self.y)
            case "waterBlock":
                return Water(x: self.x, y: self.y)
            default:
                return nil
        }
    }
}