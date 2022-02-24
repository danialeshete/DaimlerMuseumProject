//
//  ARRealityKitViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 26.11.21.
//

import UIKit
import RealityKit

class ARRealityKitViewController: UIViewController {

    @IBOutlet weak var scene: ARView!
    //var anchor: Engine.EngineModel!
    //var anchor:
    var anchor1: Labels.Motor1!
    var anchor2: Labels.Motor2!
    var anchor3: Labels.Motor3!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nur zum testen! Try Block entfernen
        anchor1 = try! Labels.loadMotor1()
        anchor2 = try! Labels.loadMotor2()
        anchor3 = try! Labels.loadMotor3()

        
        scene.scene.anchors.append(anchor1)
        scene.scene.anchors.append(anchor2)
        scene.scene.anchors.append(anchor3)

        
    }
}

extension ARRealityKitViewController: StoryboardInitializable { }
