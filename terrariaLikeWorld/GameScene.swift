//
//  GameScene.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright (c) 2015 sea_software. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var keys = ["up": false, "down": false, "left": false, "right": false, "space": false]
    var myCamera: MyCamera = MyCamera()
//    var playerPlaceHolder = SKSpriteNode(imageNamed: "circle")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
//        self.playerPlaceHolder.position.x = self.frame.midX
//        self.playerPlaceHolder.position.y = self.frame.midY
//        self.playerPlaceHolder.anchorPoint.x = 0.5
//        self.playerPlaceHolder.anchorPoint.y = 0.5
//        self.playerPlaceHolder.size.width = 50.0
//        self.playerPlaceHolder.size.height = 50.0
//        self.addChild(self.playerPlaceHolder)
        
        self.myCamera.position.x = self.frame.minX
        self.myCamera.position.y = self.frame.minY
        self.addChild(myCamera)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if keys["left"] == true{
            self.myCamera.position.x += 20
        }
        if keys["right"] == true{
            self.myCamera.position.x -= 20
        }
        if keys["up"] == true{
            self.myCamera.position.y -= 20
        }
        if keys["down"] == true{
            self.myCamera.position.y += 20
        }
        if keys["space"] == true{
            myCamera.updateYPos(CGPoint(x: self.frame.midX, y: self.frame.midY))
        }
        self.myCamera.endlessTerrain(self.frame.minX - 200, rightBound: self.frame.maxX + 200, topBound: self.frame.maxY + 500, bottomBound: self.frame.minY - 500)
    }
    
    override func keyDown(theEvent: NSEvent) {
        let keyCode = theEvent.keyCode
        if (keyCode == 49){
            keys["space"] = true
        }
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
        if (keyCode == 49){
            keys["space"] = false
        }
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
