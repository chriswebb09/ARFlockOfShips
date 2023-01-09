//
//  Ship.swift
//  ARFlock
//
//  Created by Christopher Webb on 1/9/23.
//

import SceneKit
import QuartzCore

class Ship {
    
    var node: SCNNode;
    var velocity: SCNVector3 = SCNVector3(x: Float(1), y: Float(1), z:Float(1))
    var prevDir: SCNVector3 = SCNVector3(x: Float(0), y: Float(1), z:Float(0))
    
    init(newNode: SCNNode) {
        self.node = newNode;
    }
}
