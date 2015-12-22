//
//  Water.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/21/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Water: RealBlock{
    
    init(x: Int, y: Int){
        super.init(x: x, y: y, type: "waterBlock")
    }
    
    override func update(){
        if (self.leftConnection?.biome?.realBlock?.type) == ""{
            self.leftConnection?.biome?.realBlock = Water(x: self.x, y: self.y)
            self.leftConnection?.hidden = false
            self.leftConnection?.biome?.hidden = false
        }
        if (self.rightConnection?.biome?.realBlock?.type) == ""{
            self.rightConnection?.biome?.realBlock = Water(x: self.x, y: self.y)
            self.rightConnection?.hidden = false
            self.rightConnection?.biome?.hidden = false
        }
        if (self.downConnection?.biome?.realBlock?.type) == ""{
            self.downConnection?.biome?.realBlock = Water(x: self.x, y: self.y)
            self.downConnection?.hidden = false
            self.downConnection?.biome?.hidden = false
        }
    }
}