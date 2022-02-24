//
//  StarsViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 13.01.22.
//

import UIKit

class StarsViewController: UIViewController {
    
    var confettiView: SwiftConfettiView?
    @IBOutlet weak var starsLabel: UILabel!
    public var stars: Int? {
        didSet {
            if let stars = stars {
                starsText = "Glückwunsch! Du hast \(stars) Sterne gesammelt"
            }
        }
    }
    private var starsText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        self.confettiView = confettiView
        starsLabel.text = starsText
        
        confettiView.startConfetti()
    }
}

extension StarsViewController: StoryboardInitializable { }
