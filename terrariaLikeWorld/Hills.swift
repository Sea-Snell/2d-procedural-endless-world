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
}