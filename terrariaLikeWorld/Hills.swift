//
//  Hills.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/23/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Hills: Biome{
    init(x: Int, y: Int, heightAtX: Int, visible: Bool){
        super.init(x: x, y: y, primaryAsset: "dirtBlock", secondaryAsset: "stoneBlock", liquidAsset: "waterBlock", heightAtX: heightAtX, visible: visible)
    }
    
    override func determineBlock() -> Block?{
        if visible == false{
            return Block(x: self.x, y: self.y, asset: "", visible: false)
        }
        
        let basePoint: Double = 0.00005 * Double(self.heightAtX * self.heightAtX) + 0.05
        var probibility: Double = 0.00005 * Double((self.y - self.heightAtX) * (self.y - self.heightAtX)) + basePoint
        if probibility > 0.95{
            probibility = 0.95
        }
        
        let randVal = rand(Int64(x * y * 9))
        
        if randVal <= probibility{
            return self.stringToObject(self.secondaryAsset)!
        }
        return self.stringToObject(self.primaryAsset)!
    }
}