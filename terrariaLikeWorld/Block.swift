//
//  Block.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/23/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Block{
    var asset: String
    var x: Int
    var y: Int
    var visible: Bool
    
    init(x: Int, y: Int, asset: String, visible: Bool){
        self.x = x
        self.y = y
        self.asset = asset
        self.visible = visible
    }
}