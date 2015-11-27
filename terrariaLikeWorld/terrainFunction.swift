//
//  terrainFunction.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation


func terrainFunction(a: Int) -> Int{
    let wv1 = Int(sin(Double(a) * 0.1) * 10.0)
    let wv2 = Int(sin(Double(a) * 0.05) * 10.0)
    let wv3 = Int(sin(Double(a) * 0.2) * 10.0)
    let wv4 = Int(sin(Double(a) * 0.4) * 10.0)
    let wv6 = Int(sin(Double(a) * 0.8) * 10.0)
    return ((wv1 + wv2 + wv3 + wv4 + wv6) / 5) + 10
    
}