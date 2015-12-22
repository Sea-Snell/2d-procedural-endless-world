//
//  RealBlock.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 12/21/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

class RealBlock{
    var x: Int
    var y: Int
    var type: String
    var upConnection: Block?
    var downConnection: Block?
    var leftConnection: Block?
    var rightConnection: Block?
    
    init(x: Int, y: Int, type: String){
        self.x = x
        self.y = y
        self.type = type
        self.upConnection = nil
        self.downConnection = nil
        self.leftConnection = nil
        self.rightConnection = nil
    }
    
    func update(){
        
    }
}