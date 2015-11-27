//
//  GameScene.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright (c) 2015 sea_software. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var keys = ["up": false, "down": false, "left": false, "right": false]
    var myCamera: MyCamera = MyCamera()
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.myCamera.position.x = self.frame.midX
        self.myCamera.position.y = self.frame.minY
        self.addChild(myCamera)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if keys["left"] == true{
            self.myCamera.position.x += 5
            self.myCamera.updateYPos(CGPoint(x: self.frame.midX, y: self.frame.midY))
            self.myCamera.endlessTerrain(self.frame.minX, rightBound: self.frame.maxX)
        }
        if keys["right"] == true{
            self.myCamera.position.x -= 5
            self.myCamera.updateYPos(CGPoint(x: self.frame.midX, y: self.frame.midY))
            self.myCamera.endlessTerrain(self.frame.minX, rightBound: self.frame.maxX)
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        let keyCode = theEvent.keyCode
        if(keyCode == 123){
            keys["left"] = true
        }
        if(keyCode == 124){
            keys["right"] = true
        }
        if(keyCode == 125){
            keys["down"] = true
        }
        if(keyCode == 126){
            keys["up"] = true
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        let keyCode = theEvent.keyCode
        if(keyCode == 123){
            keys["left"] = false
        }
        if(keyCode == 124){
            keys["right"] = false
        }
        if(keyCode == 125){
            keys["down"] = false
        }
        if(keyCode == 126){
            keys["up"] = false
        }
    }
    
    
}
