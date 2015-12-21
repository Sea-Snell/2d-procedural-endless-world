//
//  biomes.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/20/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Biome{
    var mainAsset: Int
    var secondaryAsset: Int
    var elevation: Double
    var humidity: Double
    var temperature: Double
    var roughness: Double
    var name: String
    
    init(mainAsset: Int, secondaryAsset: Int, elevation: Double, humidity: Double, temperature: Double, roughness: Double, name: String){
        self.mainAsset = mainAsset
        self.secondaryAsset = secondaryAsset
        self.elevation = elevation
        self.humidity = humidity
        self.temperature = temperature
        self.roughness = roughness
        self.name = name
    }
}

func determineBiome(elevation: Double, humidity: Double, temperature: Double, roughness: Double) -> [Int]{
    var best = 10.0
    var biome: Biome? = nil
    let biomes = [Biome(mainAsset: 1, secondaryAsset: 1, elevation: 1.0, humidity: 1.0, temperature: 0.5, roughness: 1.0, name: "mountains"), Biome(mainAsset: 2, secondaryAsset: 1, elevation: 1.0, humidity: 0.5, temperature: 1.0, roughness: 0.5, name: "hills"), Biome(mainAsset: 4, secondaryAsset: 1, elevation: 0.5, humidity: 0.0, temperature: 1.0, roughness: 0.0, name: "desert"), Biome(mainAsset: 3, secondaryAsset: 1, elevation: 0.5, humidity: 0.0, temperature: 0.0, roughness: 0.5, name: "tundra")]
    
    for i in biomes{
        let diff = abs(i.elevation - elevation) + abs(i.humidity - humidity) + abs(i.temperature - temperature) + abs(i.roughness - roughness)
        if diff < best{
            best = diff
            biome = i
        }
    }
    
    return [biome!.mainAsset, biome!.secondaryAsset]
}