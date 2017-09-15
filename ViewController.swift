//
//  ViewController.swift
//  ARDimensionDoor
//
//  Created by 薛飞龙 on 2017/9/15.
//  Copyright © 2017年 薛飞龙. All rights reserved.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/portal.scn")!
        //
        //        // Set the scene to the view
        sceneView.scene = scene
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
    
    //    检测平面
    //    當我检测到锚点的时候掉用这个方法
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //        锚点⚓️ ＶＳ 节点
        if anchor is ARPlaneAnchor {
            //            锚点可以是任何的形态，因为我们现在要检测水平面，所以我们会把锚点放在我们检测到的水平面上
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            //            extent: 检测平面的宽和高
            //            锚点的大小 ＝ 我所检测到的水平面大小
            let planeNode = SCNNode() //先不要急着把几何放进去
            //            节点到底在哪里？ 节点就在 锚点的平面中心位置
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            planeNode.geometry = plane // 因为我不知道 会检测到怎样的水平面
            node.addChildNode(planeNode)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        是否第一次点击（是否第一次接触）
        if let touch = touches.first {
            //            在 2d 的屏幕上 点击的位置
            let touchLocation = touch.location(in: sceneView)
            //            在 2d 屏幕上所点击的位置，转换成手机屏幕里面的 3d 坐标
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            // existingPlaneUsingExtent: 我只在检测到的平面范围上点击 才有作用
            //            点击結果是否是他的第一次
            if let hitResult = results.first {
                
                
                let boxScene = SCNScene(named: "art.scnassets/portal.scn")!
                
                if let boxNode = boxScene.rootNode.childNode(withName: "portal", recursively: true) {
                    
                    
                    boxNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + 0.05, z: hitResult.worldTransform.columns.3.z)
                    
                    sceneView.scene.rootNode.addChildNode(boxNode)
                }
            }
        }
    }
}

