//
//  terrainFunction.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation


//func terrainFunction(a: Int) -> Int{
////    let wv1 = Int(sin(Double(a) * 0.1) * 10.0)
////    let wv2 = Int(sin(Double(a) * 0.05) * 10.0)
////    let wv3 = Int(sin(Double(a) * 0.2) * 10.0)
////    let wv4 = Int(sin(Double(a) * 0.4) * 10.0)
////    let wv6 = Int(sin(Double(a) * 0.8) * 10.0)
////    return ((wv1 + wv2 + wv3 + wv4 + wv6) / 5) + 10
//    
//    
//    let wv1 = Int(sin(Double(a) * 0.1) * 10.0)
//    let wv2 = Int(sin(Double(a) * 2.0) * 2.0)
//    let wv3 = Int(sin(Double(a) * 0.025) * 40.0)
//    return ((wv1 + wv2 + wv3)) + 52
//}

func terrainFunction(var a: Int) -> Int{
    let randNums = RandNums()
    var sinFunctions = 0
    var amplitudeCounter = 0
    var iterCount = 0
    
    a = abs(a)
    
    if randRange(0, maxVal: 1000, seed: randNums.globalSeed * a) <= 30{
        randNums.newWaveLengthRange(a)
    }
    
    for i in 0..<4{
        if randRange(1, maxVal: 15, seed: randNums.globalSeed * i) > 5{
            let result = randNums.getASinedValue(a, counter: i)
            sinFunctions += result.0
            amplitudeCounter += result.1
            iterCount += 1
        }
    }
    return sinFunctions + amplitudeCounter
    
}

class RandNums{
    var lowWaveLength: Double
    var highWaveLength: Double
    var globalSeed: Int
    
    init(){
        self.globalSeed = 816
        self.lowWaveLength = 0
        self.highWaveLength = 0
        self.newWaveLengthRange(0)
    }
    
    func newWaveLengthRange(var a: Int){
        if a == 0{
            a = 1
        }
        
        self.lowWaveLength = randRange(0.0, maxVal: 1.0, seed: self.globalSeed * a)
        self.highWaveLength = randRange(self.lowWaveLength, maxVal: 1.0, seed: self.globalSeed * a * 2)
    }
    
    func getASinedValue(var a: Int, var counter: Int) -> (Int, Int){
        if a == 0{
            a = 1
        }
        if counter == 0{
            counter = 1
        }
        let amplitude = Int(randRange(1, maxVal: (self.highWaveLength - self.lowWaveLength) * 5, seed: self.globalSeed + a * counter))
        let value = Int(sin(Double(a) * randRange(self.lowWaveLength, maxVal: self.highWaveLength, seed: self.globalSeed * a * counter)) * Double(amplitude))
        return (value, amplitude)
    }
}