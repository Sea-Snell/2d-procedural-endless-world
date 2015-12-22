//
//  biomes.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/20/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Biome{
    var mainAsset: String
    var secondaryAsset: String
    var x: Int
    var y: Int
    var hidden: Bool
    var humidity: Double
    var temperature: Double
    var roughness: Double
    var elevationScaled: Double
    var realElevation: Int
    var realBlock: RealBlock?
    
    init(mainAsset: String, secondaryAsset: String, elevationScaled: Double, realElevation: Int, humidity: Double, temperature: Double, roughness: Double, x: Int, y: Int, hidden: Bool){
        self.x = x
        self.y = y
        self.hidden = hidden
        self.mainAsset = mainAsset
        self.secondaryAsset = secondaryAsset
        self.humidity = humidity
        self.temperature = temperature
        self.elevationScaled = elevationScaled
        self.realElevation = realElevation
        self.roughness = roughness
        self.realBlock = nil
        self.realBlock = self.determineBlock(9, heightAtX: self.realElevation)
    }
    
    func determineBlock(seed: Int, heightAtX: Int) -> RealBlock{
        if self.hidden == true{
            if self.y > self.realElevation && self.y < 105{
                return Water(x: self.x, y: self.y)
            }
            return RealBlock(x: self.x, y: self.y, type: "")
        }

        var probibality: Double = 0.00005 * Double((self.y - heightAtX) * (self.y - heightAtX)) + 0.05
        if probibality > 0.95{
            probibality = 0.95
        }

        let randVal = rand(Int64(self.x * self.y * seed))
        if randVal <= probibality{
            return RealBlock(x: self.x, y: self.y, type: self.secondaryAsset)
        }
        return RealBlock(x: self.x, y: self.y, type: self.mainAsset)
    }
}