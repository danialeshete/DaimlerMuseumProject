//
//  GameViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 24.11.21.
//

import UIKit

protocol GameViewing: AnyObject {
    var presenter: GamePresenting! { get set }
}

protocol GamePresenting {
    var view: GameViewing? { get set }
    
    func viewDidLoad()
}

class GamePresenter: GamePresenting {
    var view: GameViewing?
    
    func viewDidLoad() {
        
    }
}

class GameViewController: UIViewController {
    
    var presenter: GamePresenting! {
        didSet {
            presenter.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func test(_ sender: Any) {
        view.backgroundColor = .yellow
    }
}

extension GameViewController: StoryboardInitializable { }

extension GameViewController: GameViewing {
    
}
