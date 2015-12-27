//
//  Tundra.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/23/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Tundra: Biome{
    init(x: Int, y: Int, heightAtX: Int, visible: Bool){
        super.init(x: x, y: y, primaryAsset: "snowBlock", secondaryAsset: "stoneBlock", liquidAsset: "waterBlock", heightAtX: heightAtX, visible: visible)
    }
    
    override func determineBlock() -> Block?{
        if visible == false{
            return Block(x: self.x, y: self.y, asset: "", visible: false)
        }
        
        var probibality: Double = 0.0005 * Double((self.y - self.heightAtX) * (self.y - self.heightAtX)) + 0.005
        if probibality > 0.9991{
            probibality = 0.9991
        }
        
        let randVal = rand(Int64(x * y * 9))
        
        if randVal <= probibality{
            return self.stringToObject(self.secondaryAsset)!
        }
        return self.stringToObject(self.primaryAsset)!
    }
}