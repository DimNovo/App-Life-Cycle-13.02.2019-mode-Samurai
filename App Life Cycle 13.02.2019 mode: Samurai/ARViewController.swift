//
//  ARViewController.swift
//  App Life Cycle 13.02.2019 mode: Samurai
//
//  Created by Dmitry Novosyolov on 13/02/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import ARKit

class ARViewController: UIViewController {
    
    // MARK: - ... Create Scene & Label
    let sceneView = ARSCNView()
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 75))
    
    // MARK: - ... ARViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the scene to the view
        label.center = CGPoint(x: 160, y: 284)
        label.textAlignment = NSTextAlignment.center
        label.text = "Searching in Progress..."
        view = sceneView
        self.view.addSubview(label)
        sceneView.delegate = self
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = images
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.pause()
    }
}
// MARK: - ... ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARImageAnchor else { return }
        
        let imageNode = getImage(for: anchor)
        node.addChildNode(imageNode)
    }
    // MARK: - ... Custom Methods
    func getImage(for anchor: ARImageAnchor) -> SCNNode {
        
        let image = anchor.referenceImage
        let size = image.physicalSize
        
        let plane = SCNPlane(width: size.width , height: size.height)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "200ILShek")
        
        let node = SCNNode(geometry: plane)
        node.eulerAngles.x = -.pi / 2
        node.opacity = 0.75
        
        DispatchQueue.main.async {
            self.label.textColor = UIColor.green
            self.label.text = "Successfully Detected!"
        }
        
        return node
    }
}
