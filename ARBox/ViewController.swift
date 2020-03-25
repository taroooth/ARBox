//
//  ViewController.swift
//  ARBox
//
//  Created by 岡田龍太朗 on 2019/08/30.
//  Copyright © 2019 岡田龍太朗. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration, options: [])

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let box = SCNScene(named: "art.scnassets/box.scn")!
        let boxNode = box.rootNode.childNodes.first!
        boxNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        let infrontCamera = SCNVector3Make(0, 0, -0.3)
        
        guard let cameraNode = sceneView.pointOfView else {
            return
        }
        let pointInWorld = cameraNode.convertPosition(infrontCamera, to: nil)
        
        var screenPosition = sceneView.projectPoint(pointInWorld)
        
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }
        
        screenPosition.x = Float(location.x)
        screenPosition.y = Float(location.y)
        
        let finalPosition = sceneView.unprojectPoint(screenPosition)
        
        boxNode.position = finalPosition
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func addBox(hitResult: ARHitTestResult) {
        let box = SCNScene(named: "art.scnassets/box.scn")!
        let boxNode = box.rootNode.childNodes.first!

        // タップした位置より20cm上から落下させる
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.20, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(boxNode)
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
}
