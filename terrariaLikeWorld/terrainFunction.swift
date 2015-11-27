//
//  terrainFunction.swift
//  terrariaLikeWorld
//
//  Created by Charlie Snell on 11/26/15.
//  Copyright © 2015 sea_software. All rights reserved.
//

import Foundation

let randTerrain = RandTerrain()

func terrainFunction(var a: Int) -> Int{
    a = abs(a)
    
    randTerrain.randomNumberGenerator.seed = a
    
    if a == 0{
        randTerrain.randomNumberGenerator.seed = 1
        randTerrain.randomNumberGenerator.rand()
        randTerrain.newWaveLengthRange()
        randTerrain.newWaveLengthAmplitudeVals(10)
    }
    
    return randTerrain.getASinedValue(a)
    
}

class RandTerrain{
    var lowWaveLength: Double
    var highWaveLength: Double
    var globalSeed: Int
    var waveLengths: [Double]
    var amplitudes: [Double]
    var amplitudeSum: Double
    var randomNumberGenerator: RandomNumberGenerator
    
    init(){
        self.globalSeed = 816
        self.lowWaveLength = 0
        self.highWaveLength = 0
        self.waveLengths = []
        self.amplitudes = []
        self.amplitudeSum = 0
        self.randomNumberGenerator = RandomNumberGenerator(seed: self.globalSeed)
    }
    
    func newWaveLengthRange(){
        self.lowWaveLength = randomNumberGenerator.randRange(0.1, maxVal: 0.5)
        self.highWaveLength = randomNumberGenerator.randRange(self.lowWaveLength, maxVal: 0.5)
    }
    
    func newWaveLengthAmplitudeVals(size: Int){
        waveLengths = []
        amplitudes = []
        
        for _ in 0..<size{
            waveLengths.append(randomNumberGenerator.randRange(self.lowWaveLength, maxVal: self.highWaveLength))
            amplitudes.append(3)
        }
        
        for i in amplitudes{
            self.amplitudeSum += i
        }
    }
    
    func getASinedValue(a: Int) -> Int{
        var total = 0
        for i in 0..<waveLengths.count{
            total += Int(sin(Double(a) * waveLengths[i]) * amplitudes[i])
        }
        return (total) + (Int(amplitudeSum + 1))
    }
}