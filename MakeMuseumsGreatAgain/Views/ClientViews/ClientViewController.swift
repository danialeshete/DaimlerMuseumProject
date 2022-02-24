//
//  ClientViewController.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import UIKit

protocol ClientPresenterDelegate {
    
}

protocol ClientPresenting {
    var view: ClientViewing? { get set }
    var delegate: ClientPresenterDelegate? { get set }
    
    func viewDidLoad()
}

protocol ClientViewing: AnyObject {
    var presenter: ClientPresenting! { get set }
    
    func show(viewController: UIViewController, animated: Bool)
    func hideViewController()
    func reload()
    func display(points: Int)
}

class ClientViewController: UIViewController {
        
    var presenter: ClientPresenting! {
        didSet {
            presenter.view = self
        }
    }
    
    @IBOutlet var avatarContainerView: UIView!
    private var avatarViewController: AvatarViewing?
    @IBOutlet var avatarWrapperView: UIView!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    private var currentPresentingViewController: UIViewController?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        let avatarPresenter = AvatarPresenter()
        avatarViewController?.presenter = avatarPresenter
        avatarPresenter.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Avatar View Controller" {
            if let avatarViewController = segue.destination as? AvatarViewController {
                self.avatarViewController = avatarViewController
            }
        }
    }
}

extension ClientViewController: StoryboardInitializable { }

extension ClientViewController: ClientViewing {
    func display(points: Int) {
        DispatchQueue.main.async {
            self.highScoreLabel.text = "Highscore: \(points)"
        }
    }
    

    func reload() {
        avatarViewController?.reload()
    }
    
    func hideViewController() {
        if let vc = currentPresentingViewController {
            vc.dismiss(animated: true) {
                self.currentPresentingViewController = nil
            }
        }
    }
    
    func show(viewController: UIViewController, animated: Bool = true) {
        viewController.isModalInPresentation = true
        
        if let vc = currentPresentingViewController, vc.self != viewController.self {
            vc.dismiss(animated: true, completion: {
                self.present(viewController, animated: animated) {
                    self.currentPresentingViewController = viewController
                }
            })
        } else {
            self.present(viewController, animated: animated) {
                self.currentPresentingViewController = viewController
            }
        }
    }
}


class ClientPresenter: ClientPresenting {
    var delegate: ClientPresenterDelegate?
    
    weak var view: ClientViewing?
    
    func viewDidLoad() {
        
    }

}
