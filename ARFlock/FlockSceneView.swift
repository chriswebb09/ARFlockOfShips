//
//  FlockSceneView.swift
//  ARFlock
//
//  Created by Christopher Webb on 1/9/23.
//

import Foundation
import SceneKit
import ARKit

class FlockSceneView: ARSCNView {
//    override func mouseDown(with theEvent: NSEvent) {
//          /* Called when a mouse click occurs */
//
//          // check what nodes are clicked
//          let p = self.convert(theEvent.locationInWindow, from: nil)
//          let hitResults = self.hitTest(p, options: nil)
//          if hitResults.count > 0 {
//              // check that we clicked on at least one object
//              if hitResults.count > 0 {
//                  // retrieved the first clicked object
//                  let result: AnyObject = hitResults[0]
//
//                  // get its material
//                  let material = result.node!.geometry!.firstMaterial!
//
//                  // highlight it
//                  SCNTransaction.begin()
//                  SCNTransaction.animationDuration = 0.5
//
//                  // on completion - unhighlight
//                  SCNTransaction.completionBlock = {
//                      SCNTransaction.begin()
//                      SCNTransaction.animationDuration = 0.5
//
//                      material.emission.contents = NSColor.black
//
//                      SCNTransaction.commit()
//                  }
//
//                  material.emission.contents = NSColor.red
//
//                  SCNTransaction.commit()
//              }
//          }
//
//          super.mouseDown(with: theEvent)
//    }
}
