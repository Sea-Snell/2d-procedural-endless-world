//
//  Water.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/23/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Water: Block{
    init(x: Int, y: Int){
        super.init(x: x, y: y, asset: "waterBlock", visible: true)
    }
}