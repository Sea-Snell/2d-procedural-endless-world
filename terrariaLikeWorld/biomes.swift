//
//  biomes.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/20/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

func determineBiome(elevation: Double, humidity: Double, temperature: Double, roughness: Double) -> String{
    var best = 10.0
    var biome: [String: Any] = [:]
    let biomes: [[String: Any]] = [["elevation": 1.0, "humidity": 1.0, "temperature": 0.5, "roughness": 1.0, "name": "mountains"], ["elevation": 1.0, "humidity": 0.5, "temperature": 1.0, "roughness": 0.5, "name": "hills"], ["elevation": 0.5, "humidity": 0.0, "temperature": 1.0, "roughness": 0.0, "name": "desert"], ["elevation": 0.5, "humidity": 0.0, "temperature": 0.0, "roughness": 0.5, "name": "tundra"]]
    
    for i in biomes{
        let a = abs((i["elevation"] as! Double) - elevation)
        let b = abs((i["humidity"]as! Double) - humidity)
        let c = abs((i["temperature"] as! Double) - temperature)
        let d = abs((i["roughness"] as! Double) - roughness)
        let diff = a + b + c + d
        if diff < best{
            best = diff
            biome = i
        }
    }
    
    return String(biome["name"]!)
}

func stringToBlockObject(x: Int, y: Int, heightAtX: Int, name: String = "", visible: Bool = false) -> Block{
    var biome: Biome? = nil
    switch(name){
        case "desert":
            biome =  Desert(x: x, y: y, heightAtX: heightAtX, visible: visible)
            return (biome?.determineBlock())!
        case "mountains":
            biome =  Mountains(x: x, y: y, heightAtX: heightAtX, visible: visible)
            return (biome?.determineBlock())!
        case "hills":
            biome =  Hills(x: x, y: y, heightAtX: heightAtX, visible: visible)
            return (biome?.determineBlock())!
        case "tundra":
            biome =  Tundra(x: x, y: y, heightAtX: heightAtX, visible: visible)
            return (biome?.determineBlock())!
        default:
            return Block(x: x, y: y, asset: "", visible: false)
    }
}