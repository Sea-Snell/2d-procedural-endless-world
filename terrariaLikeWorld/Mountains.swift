//
//  Mountains.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/23/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Mountains: Biome{
    init(x: Int, y: Int, heightAtX: Int, visible: Bool){
        super.init(x: x, y: y, primaryAsset: "stoneBlock", secondaryAsset: "stoneBlock", liquidAsset: "waterBlock", heightAtX: heightAtX, visible: visible)
    }
}