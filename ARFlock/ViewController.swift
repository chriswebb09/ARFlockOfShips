//
//  ViewController.swift
//  ARFlock
//
//  Created by Christopher Webb on 1/9/23.
//

import UIKit
import SceneKit
import QuartzCore
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: FlockSceneView!
    
    var ships: [Ship] = [Ship]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
//        // create and add a camera to the scene
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        sceneView.scene.rootNode.addChildNode(cameraNode)
//
//        // place the camera
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 70)
//        cameraNode.camera?.zFar = 100
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 50)
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.darkGray
        sceneView.scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        for _ in 0...100 {
            let shipNode = scene.rootNode.childNode(withName: "ship", recursively: true)!.clone()
            
            let ship = Ship(newNode: shipNode);
            sceneView.scene.rootNode.addChildNode(ship.node)
            ships.append(ship);
            ship.node.position = SCNVector3(x: Float(Int(arc4random_uniform(10)) - 5), y: Float(Int(arc4random_uniform(10)) - 5), z: 0)
            ship.node.scale = SCNVector3(x: Float(1.5), y: Float(1.5), z: Float(1.5))
        }
        
        
        let shipNode = scene.rootNode.childNode(withName: "ship", recursively: true)!.clone()
        shipNode.position = SCNVector3(x: Float(-100), y: Float(-100), z: 0)
        sceneView.scene.rootNode.addChildNode(shipNode)
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = NSValue(scnVector4: SCNVector4(x: Float(0), y: Float(1), z: Float(0), w: Float.pi*2))
        animation.duration = 30000
        animation.repeatCount = MAXFLOAT //repeat forever
        shipNode.addAnimation(animation, forKey: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func degToRad(_ deg: Float) -> Float {
        return deg / 180.0 * Float.pi
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        var percievedCenter = SCNVector3(x: Float(0), y: Float(0), z:Float(0))
        var percievedVelocity = SCNVector3(x: Float(0), y: Float(0), z:Float(0))
        for otherShip in ships {
            percievedCenter = percievedCenter + otherShip.node.position;
            percievedVelocity = percievedVelocity + otherShip.velocity;
        }
        
        for ship in ships {
            var v1 = flyCenterOfMass(ship, percievedCenter)
            var v2 = keepASmallDistance(ship)
            var v3 = matchSpeedWithOtherShips(ship, percievedVelocity)
            var v4 = boundPositions(ship)
            v1 *= (0.01)
            v2 *= (0.01)
            v3 *= (0.01)
            v4 *= (1.0)
            let forward = SCNVector3(x: Float(0), y: Float(0), z: Float(1))
            let velocityNormal = ship.velocity.normalized()
            ship.velocity = ship.velocity + v1 + v2 + v3 + v4;
            limitVelocity(ship);
            let nor = forward.cross(velocityNormal)
            let angle = CGFloat(forward.dot(velocityNormal))
            ship.node.rotation = SCNVector4(x: nor.x, y: nor.y, z: nor.z, w: Float(acos(angle)))
            ship.node.position = ship.node.position + (ship.velocity)
        }
    }
    
    func limitVelocity(_ ship: Ship) {
        let mag = Float(ship.velocity.length())
        let limit = Float(0.5);
        if mag > limit {
            ship.velocity = (ship.velocity/mag) * limit
        }
    }
    
    func flyCenterOfMass(_ ship: Ship, _ percievedCenter: SCNVector3) -> SCNVector3 {
        let averagePercievedCenter = percievedCenter / Float(ships.count - 1);
        return (averagePercievedCenter - ship.node.position)/100;
    }
    
    func keepASmallDistance(_ ship: Ship) -> SCNVector3 {
        var forceAway = SCNVector3(x: Float(0), y: Float(0), z: Float(0))
        
        for otherShip in ships {
            if ship.node != otherShip.node {
                if abs(otherShip.node.position.distance(ship.node.position)) < 5 {
                    forceAway = (forceAway - (otherShip.node.position - ship.node.position))
                }
            }
        }
        return forceAway
    }
    
    func matchSpeedWithOtherShips(_ ship: Ship,  _ percievedVelocity: SCNVector3) -> SCNVector3 {
        let averagePercievedVelocity = percievedVelocity / Float(ships.count - 1);
        return (averagePercievedVelocity - ship.velocity)
    }
    
    func boundPositions(_ ship: Ship) -> SCNVector3 {
        var rebound = SCNVector3(x: Float(0), y: Float(0), z:Float(0))
        let Xmin = -30;
        let Ymin = -30;
        let Zmin = -30;
        let Xmax = 30;
        let Ymax = 30;
        let Zmax = 70;
        if ship.node.position.x < Float(Xmin) {
            rebound.x = 1;
        }
        
        if ship.node.position.x > Float(Xmax) {
            rebound.x = -1;
        }
        
        if ship.node.position.y < Float(Ymin) {
            rebound.y = 1;
        }
        
        if ship.node.position.y > Float(Ymax) {
            rebound.y = -1;
        }
        
        if ship.node.position.z < Float(Zmin) {
            rebound.z = 1;
        }
        
        if ship.node.position.z > Float(Zmax) {
            rebound.z = -1;
        }
        return rebound;
        
    }
    
}
