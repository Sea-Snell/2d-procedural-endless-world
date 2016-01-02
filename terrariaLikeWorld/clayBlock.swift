//
//  clayBlock.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 1/2/16.
//  Copyright © 2016 sea_software. All rights reserved.
//

import Foundation

class ClayBlock: Block{
    init(x: Int, y: Int){
        super.init(x: x, y: y, asset: "clayBlock", visible: true)
    }
}