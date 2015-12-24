//
//  Sand.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/24/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class Sand: Block{
    init(x: Int, y: Int){
        super.init(x: x, y: y, asset: "sandBlock", visible: true)
    }
}