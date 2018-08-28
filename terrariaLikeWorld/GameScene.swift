//
//  GameScene.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright (c) 2015 sea_software. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var keys = ["up": false, "down": false, "left": false, "right": false, "space": false, "+": false, "-": false]
    var myCamera: MyCamera = MyCamera()
    
    override func didMove(to view: SKView) {
        self.myCamera.position.x = self.frame.minX
        self.myCamera.position.y = self.frame.minY
        self.addChild(myCamera)
        self.myCamera.setUp(blockWidth: 30.0, screenWidth: self.frame.size.width, screenHeight: self.frame.size.height)
        self.myCamera.update()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if keys["left"] == true{
            self.myCamera.position.x += 10
        }
        if keys["right"] == true{
            self.myCamera.position.x -= 10
        }
        if keys["up"] == true{
            self.myCamera.position.y -= 10
        }
        if keys["down"] == true{
            self.myCamera.position.y += 10
        }
        if keys["space"] == true{
            myCamera.goToGround(centerPos: CGPoint(x: self.frame.midX, y: self.frame.midY))
        }
        if keys["+"] == true{
            let percentChange = 0.5 * (1.0 - (self.myCamera.blockWidth / (self.myCamera.blockWidth + 1.0)))
            self.myCamera.position.x += percentChange * self.myCamera.rectDims.0
            self.myCamera.position.y += percentChange * self.myCamera.rectDims.1
            self.myCamera.setUp(blockWidth: self.myCamera.blockWidth + 1.0, screenWidth: self.frame.size.width, screenHeight: self.frame.size.height)
        }
        if keys["-"] == true{
            let percentChange = 0.5 * (1.0 - ((self.myCamera.blockWidth - 1.0) / self.myCamera.blockWidth))
            self.myCamera.position.x -= percentChange * self.myCamera.rectDims.0
            self.myCamera.position.y -= percentChange * self.myCamera.rectDims.1
            self.myCamera.setUp(blockWidth: self.myCamera.blockWidth - 1.0, screenWidth: self.frame.size.width, screenHeight: self.frame.size.height)
        }
        self.myCamera.update()
    }
    
    override func keyDown(with theEvent: NSEvent) {
        let keyCode = theEvent.keyCode
        if(keyCode == 49){
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
        if(keyCode == 27){
            keys["-"] = true
        }
        if(keyCode == 24){
            keys["+"] = true
        }
    }
    
    override func keyUp(with theEvent: NSEvent) {
        let keyCode = theEvent.keyCode
        if(keyCode == 49){
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
        if(keyCode == 27){
            keys["-"] = false
        }
        if(keyCode == 24){
            keys["+"] = false
        }
    }
    
    
}
